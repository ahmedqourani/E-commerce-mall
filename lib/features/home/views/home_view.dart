import 'package:e_commerce_mall/core/constants/app_strings.dart';
import 'package:e_commerce_mall/core/network/api_error.dart';
import 'package:e_commerce_mall/core/theme/app_color_tokens.dart';
import 'package:e_commerce_mall/features/home/data/home_sections.dart';
import 'package:e_commerce_mall/features/home/data/models/category_model.dart';
import 'package:e_commerce_mall/features/home/data/models/product_model.dart';
import 'package:e_commerce_mall/features/home/data/repositories/home_repo.dart';
import 'package:e_commerce_mall/features/home/widgets/category_chips.dart';
import 'package:e_commerce_mall/features/home/widgets/product_card.dart';
import 'package:e_commerce_mall/features/home/widgets/search_field.dart';
import 'package:e_commerce_mall/features/home/widgets/store_strip.dart';
import 'package:e_commerce_mall/features/home/widgets/user_header.dart';
import 'package:e_commerce_mall/features/product/views/product_details_view.dart';
import 'package:e_commerce_mall/shared/empty_state.dart';
import 'package:e_commerce_mall/shared/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// The mall's front door.
///
/// Nothing on this screen is tied to a kind of product. The category strip is
/// the API's own category list, the rails are derived from fields the API
/// returns ([HomeSections]), and a section that has no data behind it is not
/// rendered at all. Whichever verticals the catalogue carries — beauty,
/// laptops, dresses, motorcycles — are the verticals that appear here.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeRepo homeRepo = HomeRepo();
  final TextEditingController searchController = TextEditingController();

  /// Everything currently in scope: the whole catalogue, or one category's
  /// products once a category chip is selected.
  List<ProductModel> products = [];
  List<CategoryModel> categories = [];

  /// `null` means the "All" chip — the entire catalogue.
  String? selectedCategorySlug;

  /// A store (the API's `brand`) narrowing the grid, or `null`.
  String? selectedStore;

  String searchQuery = '';

  bool isLoadingProducts = false;
  bool isLoadingCategories = false;

  /// Set when the catalogue could not be loaded at all, so the screen can offer
  /// a retry instead of an empty grid that looks like an empty catalogue.
  String? productsError;

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // --- data ------------------------------------------------------------------

  /// The real category list. Failure here is not fatal: the catalogue still
  /// renders, just without the filter strip.
  Future<void> loadCategories() async {
    setState(() => isLoadingCategories = true);
    try {
      final result = await homeRepo.getCategories();
      if (!mounted) return;
      setState(() => categories = result);
    } catch (_) {
      // Deliberately silent — a missing filter strip is a degraded screen, not
      // a broken one, and the products request reports its own failure.
    } finally {
      if (mounted) setState(() => isLoadingCategories = false);
    }
  }

  /// Loads the catalogue, or one category of it when [selectedCategorySlug] is
  /// set. The narrowing is done by the server, which is the only thing that
  /// knows which products belong to a category.
  Future<void> loadProducts() async {
    setState(() {
      isLoadingProducts = true;
      productsError = null;
    });

    final slug = selectedCategorySlug;
    try {
      final result = slug == null
          ? await homeRepo.getProducts()
          : await homeRepo.getProductsByCategory(slug);

      if (!mounted) return;
      // Ignore a response whose category was superseded by a later tap.
      if (slug != selectedCategorySlug) return;
      setState(() => products = result);
    } catch (e) {
      if (!mounted) return;
      final message = e is ApiError ? e.message : AppStrings.loadProductsFailed;
      setState(() => productsError = message);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.error,
          behavior: SnackBarBehavior.floating,
          content: Text(
            message,
            style: TextStyle(color: context.colors.onError),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoadingProducts = false);
    }
  }

  Future<void> refresh() async {
    await Future.wait([
      loadCategories(),
      loadProducts(),
    ]);
  }

  // --- filters ---------------------------------------------------------------

  void onSearchChanged(String value) {
    setState(() => searchQuery = value);
  }

  void onCategorySelected(String? slug) {
    if (slug == selectedCategorySlug) return;
    searchController.clear();
    setState(() {
      selectedCategorySlug = slug;
      selectedStore = null;
      searchQuery = '';
      products = [];
    });
    loadProducts();
  }

  void onStoreSelected(String? store) {
    setState(() => selectedStore = store);
  }

  void clearFilters() {
    final hadCategory = selectedCategorySlug != null;
    searchController.clear();
    setState(() {
      searchQuery = '';
      selectedStore = null;
      selectedCategorySlug = null;
      if (hadCategory) products = [];
    });
    if (hadCategory) loadProducts();
  }

  /// What the grid shows: the in-scope products, narrowed by the store filter
  /// and then by the search term.
  List<ProductModel> get visibleProducts {
    var result = products;
    final store = selectedStore;
    if (store != null) {
      result = result.where((p) => p.storeName == store).toList();
    }
    return HomeSections.search(result, searchQuery);
  }

  bool get isSearching => searchQuery.trim().isNotEmpty;

  bool get hasFilters =>
      isSearching || selectedStore != null || selectedCategorySlug != null;

  /// The rails only make sense while browsing; a search or a store filter means
  /// the user is looking for something specific, so the grid takes over.
  bool get isBrowsing => !isSearching && selectedStore == null;

  String get gridTitle {
    if (isSearching) {
      return AppStrings.resultsFor(visibleProducts.length, searchQuery.trim());
    }
    if (selectedStore != null) return selectedStore!;
    final slug = selectedCategorySlug;
    if (slug != null) {
      return categories
              .firstWhere(
                (c) => c.slug == slug,
                orElse: () => CategoryModel(slug: slug, name: slug, url: ''),
              )
              .name;
    }
    return AppStrings.exploreAll;
  }

  void openProduct(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductDetailsView(product: product)),
    );
  }

  // --- ui --------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final showFullScreenLoader = isLoadingProducts && products.isEmpty;
    final showLoadFailure =
        productsError != null && products.isEmpty && !isLoadingProducts;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        color: context.colors.primary,
        backgroundColor: context.colors.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              const SliverToBoxAdapter(child: UserHeader()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverToBoxAdapter(
                child: SearchField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 22)),

              if (categories.isNotEmpty || isLoadingCategories) ...[
                const SliverToBoxAdapter(
                  child: SectionHeader(title: AppStrings.browseCategories),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: CategoryChips(
                    categories: categories,
                    selectedSlug: selectedCategorySlug,
                    onSelected: onCategorySelected,
                    isLoading: isLoadingCategories,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 26)),
              ],

              if (showFullScreenLoader)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (showLoadFailure)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: Icons.cloud_off_rounded,
                    title: AppStrings.loadProductsFailed,
                    message: productsError,
                    actionLabel: AppStrings.retry,
                    onAction: loadProducts,
                  ),
                )
              else ...[
                if (isBrowsing) ..._browsingSlivers(),
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: gridTitle,
                    actionLabel: hasFilters ? AppStrings.clearFilters : null,
                    onAction: hasFilters ? clearFilters : null,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                if (visibleProducts.isEmpty)
                  SliverToBoxAdapter(
                    child: EmptyState(
                      icon: isSearching
                          ? Icons.search_off_rounded
                          : Icons.inventory_2_outlined,
                      title: isSearching
                          ? AppStrings.noResultsTitle
                          : AppStrings.noProductsTitle,
                      message: isSearching
                          ? AppStrings.noResultsBody
                          : AppStrings.noProductsBody,
                      actionLabel: hasFilters ? AppStrings.clearFilters : null,
                      onAction: hasFilters ? clearFilters : null,
                    ),
                  )
                else
                  SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childCount: visibleProducts.length,
                    itemBuilder: (context, index) {
                      final product = visibleProducts[index];
                      return ProductGridCard(
                        product: product,
                        onTap: () => openProduct(product),
                      );
                    },
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// The merchandising rails. Each is omitted entirely when the catalogue holds
  /// no data for it, rather than being padded out with unrelated products.
  List<Widget> _browsingSlivers() {
    final stores = HomeSections.stores(products);
    final offers = HomeSections.specialOffers(products);
    final featured = HomeSections.featured(products);
    final arrivals = HomeSections.newArrivals(products);

    return [
      if (stores.isNotEmpty) ...[
        const SliverToBoxAdapter(
          child: SectionHeader(title: AppStrings.stores),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: StoreStrip(
            stores: stores,
            selectedStore: selectedStore,
            onSelected: onStoreSelected,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 26)),
      ],
      ..._rail(AppStrings.specialOffers, offers),
      ..._rail(AppStrings.featured, featured),
      ..._rail(AppStrings.newArrivals, arrivals),
    ];
  }

  List<Widget> _rail(String title, List<ProductModel> items) {
    if (items.isEmpty) return const [];
    return [
      SliverToBoxAdapter(child: SectionHeader(title: title)),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),
      SliverToBoxAdapter(
        child: _ProductRail(items: items, onTap: openProduct),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 26)),
    ];
  }
}

/// Horizontally scrolling row of products.
///
/// Sized by its tallest card via [IntrinsicHeight] rather than a magic height,
/// so a long product name or a large system font scale cannot clip it.
class _ProductRail extends StatelessWidget {
  const _ProductRail({required this.items, required this.onTap});

  final List<ProductModel> items;
  final ValueChanged<ProductModel> onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              ProductRailCard(
                product: items[i],
                onTap: () => onTap(items[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
