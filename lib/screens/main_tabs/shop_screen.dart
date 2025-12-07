import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/category_model.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../utils/empty_state_widget.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<CategoryModel> categories = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? selectedCategory;

  final List<String> categoryFilters = [
    'Water Filters',
    'Reverse Osmosis',
    'Water Coolers',
    'Water Softener',
  ];

  @override
  void initState() {
    super.initState();
    categories = CategoryModel.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutralGray50,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: false,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.neutralGray900,
            title: const Text(
              'Shop',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.tune),
                tooltip: 'Filters',
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(
                  AppSizing.paddingLarge,
                  0,
                  AppSizing.paddingLarge,
                  AppSizing.paddingSmall,
                ),
                child: _buildSearchField(),
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: _buildFilterChips(),
            ),
          ),

          // Categories Section
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: AppSizing.paddingLarge),
                const SectionHeader(
                  title: 'Shop by Category',
                  subtitle: 'Find the perfect water solution for your needs',
                  actionText: 'View All',
                ),
                const SizedBox(height: AppSizing.paddingMedium),
                _buildCategoriesGrid(),
                const SizedBox(height: AppSizing.paddingLarge),
                _buildQuickCategoryActions(),
              ],
            ),
          ),

          // Products Section (Empty State)
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: AppSizing.paddingXLarge),
                const SectionHeader(
                  title: 'All Products',
                  subtitle: 'Complete range of water filtration solutions',
                ),
                const SizedBox(height: AppSizing.paddingMedium),
              ],
            ),
          ),

          // Empty State for Products
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateWidget(
              icon: Icons.inventory_2_outlined,
              title: 'Products Coming Soon',
              message: 'Our product catalog will be available once connected to the database.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.neutralGray100,
        borderRadius: BorderRadius.circular(AppSizing.radiusMedium),
        border: Border.all(color: AppTheme.neutralGray200),
      ),
      child: TextField(
        controller: _searchController,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Search water filters, parts...',
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.neutralGray500,
              ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.neutralGray500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizing.paddingLarge,
            vertical: AppSizing.paddingMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizing.paddingLarge,
        vertical: AppSizing.paddingMedium,
      ),
      child: Row(
        children: categoryFilters.map((filter) {
          final isSelected = selectedCategory == filter;
          return Padding(
            padding: const EdgeInsets.only(right: AppSizing.paddingSmall),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = selected ? filter : null;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppTheme.primaryTeal.withOpacity(0.12),
              checkmarkColor: AppTheme.primaryTeal,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryTeal : AppTheme.neutralGray700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontFamily: 'Poppins',
              ),
              side: BorderSide(
                color: isSelected ? AppTheme.primaryTeal : AppTheme.neutralGray300,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizing.paddingLarge),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          mainAxisSpacing: AppSizing.paddingMedium,
          crossAxisSpacing: AppSizing.paddingMedium,
        ),
        itemCount: categories.length > 6 ? 6 : categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${category.name} - Coming Soon'),
                  backgroundColor: AppTheme.primaryTeal,
                ),
              );
            },
            child: Container(
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
                padding: const EdgeInsets.all(AppSizing.paddingMedium),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: category.boxColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          category.iconPath,
                          width: 26,
                          height: 26,
                          colorFilter: ColorFilter.mode(
                            category.boxColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizing.paddingSmall),
                    Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.neutralGray900,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickCategoryActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizing.paddingLarge),
      padding: const EdgeInsets.all(AppSizing.paddingLarge),
      decoration: BoxDecoration(
        color: AppTheme.primaryTeal.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSizing.radiusLarge),
        border: Border.all(
          color: AppTheme.primaryTeal.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.filter_list,
            color: AppTheme.primaryTeal,
            size: AppSizing.iconLarge,
          ),
          const SizedBox(width: AppSizing.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need Help Finding Products?',
                  style: AppTextStyles.productTitle.copyWith(
                    color: AppTheme.primaryTeal,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Use our smart filters to find exactly what you need',
                  style: AppTextStyles.productDescription.copyWith(
                    fontSize: 13,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
          PrimaryButton(
            text: 'Browse',
            size: ButtonSize.small,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
