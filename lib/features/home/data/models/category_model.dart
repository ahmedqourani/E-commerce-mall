/// One category of the marketplace, exactly as the API defines it.
///
/// Categories are never hardcoded in this app — the whole list comes from
/// `/products/categories`, so whatever verticals the catalogue carries are the
/// verticals the user sees.
class CategoryModel {
  final String slug;
  final String name;
  final String url;

  const CategoryModel({
    required this.slug,
    required this.name,
    required this.url,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final slug = '${json['slug'] ?? ''}';
    final name = '${json['name'] ?? ''}';
    return CategoryModel(
      slug: slug,
      // Fall back to a humanised slug so a category missing its display name
      // still shows something readable rather than an empty chip.
      name: name.isNotEmpty ? name : _humanize(slug),
      url: '${json['url'] ?? ''}',
    );
  }

  /// The category endpoint has returned both objects and bare slug strings
  /// across API versions; accept either rather than crashing the home screen.
  factory CategoryModel.fromAny(Object? value) {
    if (value is Map<String, dynamic>) return CategoryModel.fromJson(value);
    final slug = '$value'.trim();
    return CategoryModel(slug: slug, name: _humanize(slug), url: '');
  }

  static String _humanize(String slug) => slug
      .split(RegExp(r'[-_\s]+'))
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');
}
