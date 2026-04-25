import 'package:xfood/data_sources/env.dart';
import 'package:xfood/data_sources/mock_server/mock_database.dart';
import 'package:xfood/features/shared/models/voucher_model.dart';

class VoucherRepository {
  Future<List<VoucherModel>> getAllVouchers() async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    return MockDatabase.instance.vouchers;
  }

  Future<List<VoucherModel>> getAvailableVouchers() async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    return MockDatabase.instance.vouchers.where((v) => !v.isUsed).toList();
  }

  Future<void> markAsUsed(String voucherId) async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    MockDatabase.instance.useVoucher(voucherId);
  }

  Future<void> addVoucher(VoucherModel voucher) async {
    await Future.delayed(const Duration(milliseconds: Env.mockDelayMs));
    MockDatabase.instance.addVoucher(voucher);
  }
}
