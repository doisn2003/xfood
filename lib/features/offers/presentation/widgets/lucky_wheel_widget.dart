import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/offers/presentation/bloc/offers_cubit.dart';
import 'package:xfood/features/shared/models/voucher_model.dart';

class LuckyWheelDialog extends StatefulWidget {
  const LuckyWheelDialog({super.key});

  @override
  State<LuckyWheelDialog> createState() => _LuckyWheelDialogState();
}

class _LuckyWheelDialogState extends State<LuckyWheelDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isSpinning = false;
  bool _hasResult = false;
  int _resultIndex = -1;
  final Random _random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // 8 sectors: 4 winning + 4 losing
  late List<_WheelSector> _sectors;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _buildSectors();
  }

  void _buildSectors() {
    final offersState = context.read<OffersCubit>().state;
    List<VoucherModel> vouchers = [];
    if (offersState is OffersLoaded) {
      vouchers = offersState.vouchers.where((v) => !v.isUsed).take(4).toList();
    }

    // Cute color palette
    const winColors = [
      Color(0xFFFFB7B2), // Pastel Pink
      Color(0xFFFFDAC1), // Pastel Peach
      Color(0xFFE2F0CB), // Pastel Mint
      Color(0xFFB5EAD7), // Pastel Green
      Color(0xFFC7CEEA), // Pastel Purple
    ];
    const loseColors = [
      Color(0xFFF0F0F0),
      Color(0xFFE0E0E0),
    ];

    _sectors = [];
    
    // We want 8 sectors total. 
    // 4 Wins (vouchers), 4 Loses (2 "Hụt rồi", 2 "Chúc bạn may mắn lần sau")
    
    // 1. Add 4 Winning Sectors
    for (int i = 0; i < 4; i++) {
      VoucherModel v;
      if (i < vouchers.length) {
        v = vouchers[i];
      } else {
        v = VoucherModel(
          id: 'v_bonus_$i',
          code: 'GIFT${_random.nextInt(99)}',
          description: 'Voucher tặng thêm 10k',
          discountAmount: 10000,
        );
      }
      _sectors.add(_WheelSector(
        label: '${v.code}\n${v.discountAmount ~/ 1000}k',
        voucher: v,
        color: winColors[i % winColors.length],
      ));
    }

    // 2. Add 4 Losing Sectors
    _sectors.insert(1, _WheelSector(
      label: 'Hụt rồi',
      voucher: null,
      color: loseColors[0],
    ));
    _sectors.insert(3, _WheelSector(
      label: 'Chúc bạn\nmay mắn\nlần sau',
      voucher: null,
      color: loseColors[1],
    ));
    _sectors.insert(5, _WheelSector(
      label: 'Hụt rồi',
      voucher: null,
      color: loseColors[0],
    ));
    _sectors.insert(7, _WheelSector(
      label: 'Chúc bạn\nmay mắn\nlần sau',
      voucher: null,
      color: loseColors[1],
    ));
  }

  Future<void> _playSound(String url) async {
    try {
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  void _spin() {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
      _hasResult = false;
    });

    // Play spin sound
    _playSound('https://assets.mixkit.co/active_storage/sfx/2013/2013-preview.mp3');

    // Random result (weighted: 50% win, 50% lose since it's 4/4)
    _resultIndex = _random.nextInt(_sectors.length);

    // Calculate target angle
    final sectorAngle = 2 * pi / _sectors.length;
    final targetAngle = (2 * pi * 6) + // 6 full spins
        (2 * pi - (_resultIndex * sectorAngle + sectorAngle / 2));

    _animation = Tween<double>(begin: 0, end: targetAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.reset();
    _controller.forward().then((_) {
      if (!mounted) return;
      
      final wonSector = _sectors[_resultIndex];
      if (wonSector.voucher != null) {
        // Win sound
        _playSound('https://assets.mixkit.co/active_storage/sfx/1435/1435-preview.mp3');
        
        final newVoucher = VoucherModel(
          id: 'v_reward_${DateTime.now().millisecondsSinceEpoch}',
          code: 'LUCKY${_random.nextInt(999)}',
          description: 'Giảm ${wonSector.voucher!.discountAmount ~/ 1000}k từ Vòng quay!',
          discountAmount: wonSector.voucher!.discountAmount,
        );
        context.read<OffersCubit>().addRewardVoucher(newVoucher);
      } else {
        // Lose sound
        _playSound('https://assets.mixkit.co/active_storage/sfx/131/131-preview.mp3');
      }

      setState(() {
        _isSpinning = false;
        _hasResult = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Vòng Quay May Mắn',
                  style: AppTypography.h2.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                Text(
                  '🎰 Thử vận may đêm nay! 🎰',
                  style: AppTypography.bodySecondary,
                ),
                const SizedBox(height: 24),

                // Wheel Container
                SizedBox(
                  width: 260,
                  height: 260,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: 260,
                      height: 260,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // The wheel
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _animation.value,
                                child: CustomPaint(
                                  size: const Size(260, 260),
                                  painter: _WheelPainter(sectors: _sectors),
                                ),
                              );
                            },
                          ),
                          // Pointer (top triangle) - Neon Gold
                          Positioned(
                            top: -10,
                            child: CustomPaint(
                              size: const Size(36, 24),
                              painter: _PointerPainter(color: const Color(0xFFFFD700)),
                            ),
                          ),
                          // Center button
                          GestureDetector(
                            onTap: _spin,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF85FF), Color(0xFFE972EA)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF85FF).withValues(alpha: 0.6),
                                    blurRadius: 25,
                                    spreadRadius: 2,
                                  ),
                                ],
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: Center(
                                child: Text(
                                  _isSpinning ? '...' : 'QUAY',
                                  style: AppTypography.button.copyWith(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Result
                if (_hasResult) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _sectors[_resultIndex].voucher != null
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _sectors[_resultIndex].voucher != null ? '🎉 Chúc mừng!' : '😴',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _sectors[_resultIndex].voucher != null
                              ? 'Bạn nhận được Voucher giảm ${_sectors[_resultIndex].voucher!.discountAmount ~/ 1000}k!'
                              : 'Huhu, hụt mất rồi. Quay lại sau nhé!',
                          style: AppTypography.subtitle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Text(
                        _sectors[_resultIndex].voucher != null ? 'Nhận Voucher' : 'Đóng',
                        style: AppTypography.button,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Close button
          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(CupertinoIcons.xmark, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WheelSector {
  final String label;
  final VoucherModel? voucher;
  final Color color;

  _WheelSector({required this.label, this.voucher, required this.color});
}

class _WheelPainter extends CustomPainter {
  final List<_WheelSector> sectors;

  _WheelPainter({required this.sectors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Bán kính được trừ đi 5px để tạo khoảng đệm cho viền (stroke) không bị cắt
    final radius = (size.width / 2) - 5;
    final sectorAngle = 2 * pi / sectors.length;

    for (int i = 0; i < sectors.length; i++) {
      final paint = Paint()
        ..color = sectors[i].color
        ..style = PaintingStyle.fill;

      final startAngle = i * sectorAngle - pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sectorAngle,
        true,
        paint,
      );

      // Divider line
      final dividerPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      final dx = center.dx + radius * cos(startAngle);
      final dy = center.dy + radius * sin(startAngle);
      canvas.drawLine(center, Offset(dx, dy), dividerPaint);

      // Text label with wrapping support
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(startAngle + sectorAngle / 2);
      
      final textSpan = TextSpan(
        text: sectors[i].label,
        style: TextStyle(
          color: sectors[i].voucher != null ? const Color(0xFF5D4037) : const Color(0xFF757575),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          height: 1.1,
        ),
      );
      
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout(maxWidth: radius * 0.6);
      // Paint text at a distance from center
      textPainter.paint(
        canvas,
        Offset(radius * 0.35, -textPainter.height / 2),
      );
      canvas.restore();
    }

    // Outer rim - Beautiful Gold
    final rimPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    
    // Vẽ viền vàng (Vòng tròn viền sẽ nằm trọn vẹn bên trong canvas)
    canvas.drawCircle(center, radius, rimPaint);
    
    // Decorative dots on the rim
    final dotPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 16; i++) {
      final angle = i * (2 * pi / 16);
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(dx, dy), 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PointerPainter extends CustomPainter {
  final Color color;
  _PointerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);

    // Glow shadow
    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path, shadowPaint);
    
    // Border for definition
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
