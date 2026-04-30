import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xfood/core/theme/app_colors.dart';
import 'package:xfood/core/theme/app_typography.dart';
import 'package:xfood/features/shared/models/product_model.dart';
import 'package:xfood/features/shop_dashboard/presentation/bloc/shop_cubit.dart';
import 'package:xfood/core/utils/currency_formatter.dart';

class ShopProductsTab extends StatelessWidget {
  const ShopProductsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thực đơn'),
        centerTitle: true,
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showProductDialog(context),
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ShopCubit, ShopState>(
          builder: (context, state) {
            if (state.status == ShopStatus.loading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            final products = state.products;
            if (products.isEmpty) {
              return const Center(child: Text('Chưa có sản phẩm nào'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _ProductCard(product: products[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: product.imageUrl.startsWith('http')
                ? Image.network(
                    product.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: Colors.grey, child: const Icon(Icons.fastfood, color: Colors.white)),
                  )
                : Image.asset(
                    product.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 80, height: 80, color: Colors.grey, child: const Icon(Icons.fastfood, color: Colors.white)),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTypography.h3, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(product.description, style: AppTypography.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(CurrencyFormatter.format(product.price), style: AppTypography.body.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Switch(
                value: product.isAvailable,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  context.read<ShopCubit>().toggleProductAvailability(product.id, val);
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => _showProductDialog(context, product: product),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.edit, color: AppColors.textSecondary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 0),
                  InkWell(
                    onTap: () => context.read<ShopCubit>().deleteProduct(product.id),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.delete, color: AppColors.error, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showProductDialog(BuildContext context, {ProductModel? product}) {
  final isEditing = product != null;
  final nameController = TextEditingController(text: product?.name);
  final descController = TextEditingController(text: product?.description);
  final priceController = TextEditingController(text: product?.price.toString());
  final imageController = TextEditingController(text: product?.imageUrl);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surfaceContainerHigh,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEditing ? 'Chỉnh sửa món ăn' : 'Thêm món ăn mới', style: AppTypography.h2),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên món ăn', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Mô tả', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Giá tiền (VNĐ)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'URL Hình ảnh', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final price = int.tryParse(priceController.text) ?? 0;
                  if (nameController.text.isEmpty || price <= 0 || imageController.text.isEmpty) return;

                  if (isEditing) {
                    final updatedProduct = product!.copyWith(
                      name: nameController.text,
                      description: descController.text,
                      price: price,
                      imageUrl: imageController.text,
                    );
                    context.read<ShopCubit>().updateProduct(updatedProduct);
                  } else {
                    final newProduct = ProductModel(
                      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                      shopId: 's_6', // Current mock shop ID
                      categoryId: 'c_1', // Default category
                      name: nameController.text,
                      description: descController.text,
                      imageUrl: imageController.text,
                      price: price,
                    );
                    context.read<ShopCubit>().addProduct(newProduct);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(isEditing ? 'Cập nhật' : 'Thêm món', style: AppTypography.h3.copyWith(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  },
);
}
