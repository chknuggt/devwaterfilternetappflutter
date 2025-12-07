import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralGray50,
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                floating: false,
                pinned: false,
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.neutralGray900,
                automaticallyImplyLeading: false,
                title: Text(
                  'Cart (${cart.itemCount})',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                actions: [
                  if (cart.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        _showClearCartDialog(context, cart);
                      },
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Clear Cart',
                    ),
                ],
              ),

              // Cart Content
              if (cart.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: AppTheme.neutralGray400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your Cart is Empty',
                          style: AppTextStyles.sectionHeader,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add some water filtration products to get started!',
                          style: TextStyle(
                            color: AppTheme.neutralGray600,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          text: 'Start Shopping',
                          onPressed: () {},
                          icon: Icons.store,
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: AppSizing.paddingMedium),
                      ...cart.items.map((cartItem) => Container(
                        margin: const EdgeInsets.fromLTRB(
                          AppSizing.paddingLarge,
                          0,
                          AppSizing.paddingLarge,
                          AppSizing.paddingMedium,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neutralGray300.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizing.paddingLarge),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                                  color: AppTheme.neutralGray50,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
                                  child: cartItem.product.imageUrl.isNotEmpty
                                      ? Image.network(
                                          cartItem.product.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.water_drop_outlined,
                                              size: AppSizing.iconLarge,
                                              color: AppTheme.neutralGray400,
                                            );
                                          },
                                        )
                                      : const Icon(
                                          Icons.water_drop_outlined,
                                          size: AppSizing.iconLarge,
                                          color: AppTheme.neutralGray400,
                                        ),
                                ),
                              ),
                              const SizedBox(width: AppSizing.paddingMedium),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.product.name,
                                      style: AppTextStyles.productTitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '€${cartItem.product.price.toStringAsFixed(2)} each',
                                      style: AppTextStyles.productDescription,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.neutralGray100,
                                            borderRadius: BorderRadius.circular(AppSizing.radiusSmall),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                onTap: () => cart.decreaseQuantity(cartItem.product.id),
                                                child: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 16,
                                                    color: AppTheme.neutralGray700,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                '${cartItem.quantity}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.neutralGray900,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => cart.increaseQuantity(cartItem.product.id),
                                                child: Container(
                                                  padding: const EdgeInsets.all(8),
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 16,
                                                    color: AppTheme.neutralGray700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '€${cartItem.totalPrice.toStringAsFixed(2)}',
                                          style: AppTextStyles.priceText.copyWith(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => cart.removeFromCart(cartItem.product.id),
                                icon: const Icon(
                                  Icons.close,
                                  size: 20,
                                  color: AppTheme.neutralGray500,
                                ),
                                tooltip: 'Remove item',
                              ),
                            ],
                          ),
                        ),
                      )).toList(),
                      const SizedBox(height: AppSizing.paddingXLarge),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isEmpty) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.all(AppSizing.paddingLarge),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neutralGray200,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total (${cart.itemCount} items)',
                        style: AppTextStyles.productTitle.copyWith(fontSize: 16),
                      ),
                      Text(
                        '€${cart.totalAmount.toStringAsFixed(2)}',
                        style: AppTextStyles.priceText.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizing.paddingMedium),
                  PrimaryButton(
                    text: 'Proceed to Checkout',
                    fullWidth: true,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Checkout - Coming Soon'),
                          backgroundColor: AppTheme.primaryTeal,
                        ),
                      );
                    },
                    icon: Icons.payment,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Clear Cart',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            text: 'Clear',
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cart cleared'),
                  backgroundColor: AppTheme.neutralGray700,
                ),
              );
            },
            size: ButtonSize.small,
            variant: ButtonVariant.secondary,
          ),
        ],
      ),
    );
  }
}
