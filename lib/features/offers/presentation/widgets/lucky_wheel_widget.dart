import 'dart:math';
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

  // 8 sectors: 6 vouchers + 2 "may mắn lần sau"
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
      vouchers = offersState.vouchers.where((v) => !v.isUsed).take(6).toList();
    }

    _sectors = [];
    // Fill with vouchers (up to 6)
    for (int i = 0; i < 6; i++) {
      if (i < vouchers.length) {
        _sectors.add(_WheelSector(
          label: vouchers[i].code,
          voucher: vouchers[i],
          color: i.isEven ? AppColors.primary : AppColors.tertiary,
        ));
      } else {
        _sectors.add(_WheelSector(
          label: 'BONUS',
          voucher: VoucherModel(
            id: 'v_bonus_$i',
            code: 'BONUS${_random.nextInt(99)}',
            description: 'Voucher bí ẩn 15k',
            discountAmount: 15000,
          ),
          color: i.isEven ? AppColors.primary : AppColors.tertiary,
        ));
      }
    }
    // Add 2 "may mắn lần sau" slots
    _sectors.insert(2, _WheelSector(
      label: 'Hụt rồi', // Shortened from user's request because it's a wheel sector
      voucher: null,
      color: AppColors.surfaceContainerHighest,
    ));
    _sectors.insert(6, _WheelSector(
      label: 'Hụt rồi',
      voucher: null,
      color: AppColors.surfaceContainerHighest,
    ));
  }

  void _spin() {
    if (_isSpinning) return;
    setState(() {
      _isSpinning = true;
      _hasResult = false;
    });

    // Random result (weighted: 70% voucher, 30% nothing)
    final rand = _random.nextDouble();
    if (rand < 0.7) {
      // Win a voucher — pick a voucher slot
      final voucherSlots = <int>[];
      for (int i = 0; i < _sectors.length; i++) {
        if (_sectors[i].voucher != null) voucherSlots.add(i);
      }
      _resultIndex = voucherSlots[_random.nextInt(voucherSlots.length)];
    } else {
      // "May mắn lần sau"
      final emptySlots = <int>[];
      for (int i = 0; i < _sectors.length; i++) {
        if (_sectors[i].voucher == null) emptySlots.add(i);
      }
      _resultIndex = emptySlots[_random.nextInt(emptySlots.length)];
    }

    // Calculate target angle so the pointer lands on _resultIndex
    final sectorAngle = 2 * pi / _sectors.length;
    final targetAngle = (2 * pi * 5) + // 5 full spins
        (2 * pi - (_resultIndex * sectorAngle + sectorAngle / 2));

    _animation = Tween<double>(begin: 0, end: targetAngle).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.reset();
    _controller.forward().then((_) {
      if (!mounted) return;
      setState(() {
        _isSpinning = false;
        _hasResult = true;
      });

      // If won a voucher, add it
      final wonSector = _sectors[_resultIndex];
      if (wonSector.voucher != null) {
        final newVoucher = VoucherModel(
          id: 'v_reward_${DateTime.now().millisecondsSinceEpoch}',
          code: 'LUCKY${_random.nextInt(999)}',
          description: 'Giảm ${wonSector.voucher!.discountAmount ~/ 1000}k từ Vòng quay!',
          discountAmount: wonSector.voucher!.discountAmount,
        );
        context.read<OffersCubit>().addRewardVoucher(newVoucher);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      insetPadding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Vòng Quay May Mắn 🎰',
                  style: AppTypography.h2.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Thử vận may đêm nay!',
                  style: AppTypography.bodySecondary,
                ),
                const SizedBox(height: 24),

                // Wheel
                SizedBox(
                  width: 280,
                  height: 280,
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
                              size: const Size(280, 280),
                              painter: _WheelPainter(sectors: _sectors),
                            ),
                          );
                        },
                      ),
                      // Pointer (top triangle)
                      Positioned(
                        top: -6,
                        child: CustomPaint(
                          size: const Size(30, 20),
                          painter: _PointerPainter(),
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
                              colors: [AppColors.primary, AppColors.primaryContainer],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.5),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _isSpinning ? '...' : 'QUAY',
                              style: AppTypography.button.copyWith(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                              : 'Chúc bạn may mắn lần sau!',
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
    final radius = size.width / 2;
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
        ..color = AppColors.backgroundDark
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      final dx = center.dx + radius * cos(startAngle);
      final dy = center.dy + radius * sin(startAngle);
      canvas.drawLine(center, Offset(dx, dy), dividerPaint);

      // Text label
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(startAngle + sectorAngle / 2);
      final textPainter = TextPainter(
        text: TextSpan(
          text: sectors[i].label,
          style: TextStyle(
            color: sectors[i].voucher != null ? AppColors.textDark : Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(radius * 0.45, -textPainter.height / 2),
      );
      canvas.restore();
    }

    // Outer ring
    final ringPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);

    // Glow shadow
    final shadowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(path, shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
