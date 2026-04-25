import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/features/shared/models/product_model.dart';
import 'package:xfood/features/shared/models/shop_model.dart';
import 'package:xfood/features/shared/models/voucher_model.dart';
import 'package:xfood/features/shared/repositories/product_repository.dart';
import 'package:xfood/features/shared/repositories/shop_repository.dart';
import 'package:xfood/features/shared/repositories/voucher_repository.dart';

part 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final VoucherRepository _voucherRepository;
  final ProductRepository _productRepository;
  final ShopRepository _shopRepository;

  OffersCubit({
    required VoucherRepository voucherRepository,
    required ProductRepository productRepository,
    required ShopRepository shopRepository,
  })  : _voucherRepository = voucherRepository,
        _productRepository = productRepository,
        _shopRepository = shopRepository,
        super(OffersInitial());

  Future<void> loadOffers() async {
    emit(OffersLoading());
    try {
      final vouchers = await _voucherRepository.getAllVouchers();
      final products = await _productRepository.getAllProducts();
      final shops = await _shopRepository.getPopularShops();

      emit(OffersLoaded(
        vouchers: vouchers,
        products: products,
        shops: shops,
      ));
    } catch (e) {
      emit(OffersError(message: e.toString()));
    }
  }

  Future<void> useVoucher(String voucherId) async {
    final currentState = state;
    if (currentState is OffersLoaded) {
      await _voucherRepository.markAsUsed(voucherId);
      final updatedVouchers = currentState.vouchers.map((v) {
        if (v.id == voucherId) return v.copyWith(isUsed: true);
        return v;
      }).toList();
      emit(currentState.copyWith(vouchers: updatedVouchers));
    }
  }

  Future<void> addRewardVoucher(VoucherModel voucher) async {
    final currentState = state;
    if (currentState is OffersLoaded) {
      await _voucherRepository.addVoucher(voucher);
      final updatedVouchers = List<VoucherModel>.from(currentState.vouchers)..add(voucher);
      emit(currentState.copyWith(vouchers: updatedVouchers));
    }
  }
}
