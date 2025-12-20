
class Place {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final String? city;
  final String? description;
  final List<String> images;
  final double rating;
  final int ratingCount;
  final int? priceRange;
  final double? price;
  final List<String> features;
  final bool isActive;
  final bool isVerified;
  final int viewCount;

  Place({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.city,
    this.description,
    required this.images,
    required this.rating,
    required this.ratingCount,
    this.priceRange,
    this.price,
    required this.features,
    required this.isActive,
    required this.isVerified,
    required this.viewCount,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      city: json['city'],
      description: json['description'],
      images: List<String>.from(json['images'] ?? []),
      rating: (json['rating'] as num).toDouble(),
      ratingCount: json['ratingCount'] as int,
      priceRange: json['priceRange'] as int?,
      price: (json['price'] as num?)?.toDouble(),
      features: List<String>.from(json['features'] ?? []),
      isActive: json['isActive'],
      isVerified: json['isVerified'],
      viewCount: json['viewCount'] as int,
    );
  }
}
