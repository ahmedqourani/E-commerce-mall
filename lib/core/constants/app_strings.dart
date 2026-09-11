/// Every user-facing string that the app supplies itself.
///
/// The catalogue behind this app is a **general, multi-category marketplace**:
/// the same endpoint returns beauty, furniture, groceries, laptops, phones,
/// tablets, watches, shirts, dresses, shoes, bags, jewellery, sunglasses,
/// sports gear, motorcycles and vehicles. So no string in this file may name a
/// single vertical, and no screen may imply one.
///
/// The rule for anything added here: if the wording would read as wrong when
/// the API happens to return a car instead of a carton of milk, it belongs to
/// the API response, not to this file. Category names, brands, product titles
/// and descriptions all come from the server and are never hardcoded.
class AppStrings {
  const AppStrings._();

  // ---------------------------------------------------------------- brand ---

  /// Shown next to the wordmark glyph. Deliberately a place, not a product.
  static const String brandName = 'MALL';
  static const String brandTagline = 'Everything in one place';

  // ----------------------------------------------------------------- home ---

  static const String homeGreeting = 'Welcome Back!';
  static const String homeSubtitle = 'Explore the Mall';

  static const String searchHint = 'Search products, stores, or categories...';

  static const String browseCategories = 'Browse Categories';
  static const String categoryAll = 'All';

  /// Section titles. Each one is backed by a field the API actually returns —
  /// see `HomeSections` for how each list is derived.
  static const String specialOffers = 'Special Offers';
  static const String featured = 'Featured';
  static const String newArrivals = 'New Arrivals';
  static const String stores = 'Stores';
  static const String exploreAll = 'Explore All';

  static const String seeAll = 'See all';
  static const String clearFilters = 'Clear';

  /// `%d` style placeholders are avoided so callers stay readable.
  static String resultsFor(int count, String query) =>
      '$count ${count == 1 ? 'result' : 'results'} for "$query"';
  static String itemCount(int count) =>
      '$count ${count == 1 ? 'item' : 'items'}';

  // -------------------------------------------------------------- product ---

  static const String description = 'Description';
  static const String specifications = 'Specifications';
  static const String quantity = 'Quantity';
  static const String total = 'Total';
  static const String addToCart = 'Add To Cart';

  static const String category = 'Category';
  static const String brand = 'Brand';
  static const String store = 'Store';
  static const String availability = 'Availability';
  static const String sku = 'SKU';
  static const String weight = 'Weight';
  static const String dimensions = 'Dimensions';
  static const String warranty = 'Warranty';
  static const String shipping = 'Shipping';
  static const String returnPolicy = 'Returns';
  static const String minimumOrder = 'Minimum order';

  static const String addedToCart = 'Added to cart successfully!';
  static const String addToCartFailed = 'Could not add this item to your cart';

  // ----------------------------------------------------------------- cart ---

  static const String cartTitle = 'My Cart';
  static const String checkout = 'Checkout';
  static const String remove = 'Remove';

  // ------------------------------------------------------------ favourites ---

  static const String favorites = 'Favorites';

  /// The bottom bar's label for the same screen — short, because five fixed
  /// tabs leave each one about 72dp on a narrow phone.
  static const String favorite = 'Favorite';

  static const String addToFavorites = 'Add to favourites';
  static const String removeFromFavorites = 'Remove from favourites';

  // ------------------------------------------------------------- checkout ---

  static const String orderSummary = 'Order Summary';
  static const String subtotal = 'Subtotal';
  static const String taxes = 'Taxes';
  static const String shippingFee = 'Shipping';
  static const String estimatedDelivery = 'Estimated delivery';
  static const String paymentMethods = 'Payment methods';
  static const String cashOnDelivery = 'Cash on Delivery';
  static const String debitCard = 'Debit card';
  static const String saveCard = 'Save card details for future payments';
  static const String payNow = 'Pay Now';
  static const String close = 'Close';
  static const String paymentSuccess = 'Success';
  static const String paymentSuccessBody = 'Your payment was successful';
  static const String paymentReceiptBody =
      'A receipt for this purchase has been sent to your email';

  // --------------------------------------------------------------- orders ---

  static const String orderHistory = 'Order History';

  /// The bottom bar's label for the same screen. Five fixed tabs leave each one
  /// about 80dp, which "Order History" wraps out of — the screen keeps its full
  /// title, the tab uses the short form.
  static const String orders = 'Orders';
  static const String reorder = 'Re Order';
  static const String retry = 'Retry';
  static const String reorderSuccess = 'Items added to your cart';

  // ----------------------------------------------------------------- auth ---

  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle =
      'Discover everything you need in one place';
  static const String registerTitle = 'Create Account';
  static const String registerSubtitle =
      'Join the mall and discover more';

  // --------------------------------------------------------- empty states ---

  static const String noProductsTitle = 'No products found';
  static const String noProductsBody = 'Try a different search or category';

  static const String noResultsTitle = 'Nothing matched your search';
  static const String noResultsBody = 'Check the spelling or try a broader term';

  static const String emptyCartTitle = 'Your cart is empty';
  static const String emptyCartBody = 'Browse the mall and add something you like';

  static const String noFavoritesTitle = 'No favourites yet';
  static const String noFavoritesBody =
      'Tap the heart on a product to keep it here';

  static const String noOrdersTitle = 'No orders yet';
  static const String noOrdersBody = 'Your purchases will show up here';

  static const String noCategoriesTitle = 'No categories available';

  // --------------------------------------------------------------- errors ---

  static const String loadProductsFailed = 'Failed to load products';
  static const String loadCategoriesFailed = 'Failed to load categories';
  static const String loadOrdersFailed = 'Failed to load orders';
  static const String loadCartFailed = 'Failed to load your cart';
  static const String reorderFailed = 'Failed to re-order';
}
