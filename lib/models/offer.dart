
class Offer {
  final String id;
  final String title;
  final String description;

  Offer({required this.id, required this.title, required this.description});

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
    );
  }
}
