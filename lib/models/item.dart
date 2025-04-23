import 'location.dart';

class Item {
  final int id; // If you expect an ID from Django
  final String owner; // or maybe an object or id, depending on your use case
  final String name;
  final String description;
  final String? conditionNotes;
  final String? category; // can also be an int if it's an ID
  final double pricePerDay;
  final double depositAmount;
  final String image; // path or URL
  final bool isAvailable;
  final Location? location;
  final DateTime createdAt;
  final DateTime updatedAt;

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
  });
}

class RentItem {
  final String price, title, location, imageAsset;

  const RentItem({
    required this.price,
    required this.title,
    required this.location,
    required this.imageAsset,
  });
}
