import 'location.dart';

class Item {
  final int id; // If you expect an ID from Django
  final String owner; // or maybe an object or id, depending on your use case
  final String name;
  final String description;
  final String? conditionNotes;
  final String? category; // can also be an int if it's an ID
  final String pricePerDay;
  final String depositAmount;
  final String image; // path or URL
  final bool isAvailable;
  final Location? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? owner_name;

  Item({
    required this.id,
    required this.owner,
    required this.name,
    required this.description,
    this.conditionNotes,
    this.category,
    required this.pricePerDay,
    required this.depositAmount,
    required this.image,
    required this.isAvailable,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.owner_name,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      owner: json['owner'],
      name: json['name'],
      description: json['description'],
      conditionNotes: json['conditionNotes'],
      category: json['category'],
      pricePerDay: json['pricePerDay'],
      depositAmount: json['depositAmount'],
      image: json['image'],
      isAvailable: json['isAvailable'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      owner_name: json['owner_name'],
    );
  }
}
