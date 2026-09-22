class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double discountPrice;
  final double discountPercent;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final List<String> sizes;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.discountPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.description,
    this.sizes = const [],
    this.inStock = true,
  });
}
