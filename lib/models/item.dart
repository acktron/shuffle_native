import 'location.dart';

Map<String, double> parseLocation(String location) {
  final regex = RegExp(r'POINT \(([-\d.]+) ([-\d.]+)\)');
  final match = regex.firstMatch(location);

  if (match != null) {
    final longitude = double.parse(match.group(1)!);
    final latitude = double.parse(match.group(2)!);

    return {'latitude': latitude, 'longitude': longitude};
  } else {
    throw FormatException('Invalid location format');
  }
}

class Item {
  final int id; // If you expect an ID from Django
  // final String owner; // or maybe an object or id, depending on your use case
  final String name;
  final String description;
  final String? conditionNotes;
  final String? category; // can also be an int if it's an ID
  final String pricePerDay;
  final String depositAmount;
  final String image; // path or URL
  final bool isAvailable;
  final Location? location;
  final String? owner_name;

  Item({
    required this.id,
    // required this.owner,
    required this.name,
    required this.description,
    this.conditionNotes,
    this.category,
    required this.pricePerDay,
    required this.depositAmount,
    required this.image,
    required this.isAvailable,
    this.location,
    required this.owner_name,
  });

  factory Item.fromJson(Map<String, dynamic> data) {
    // Parse the location string if it exists
    final locationString = data['location'] as String?;
    Map<String, double>? parsedLocation;
    if (locationString != null) {
      parsedLocation = parseLocation(locationString);
    }

    return Item(
      id: int.parse(data['id'].toString()), // Ensure id is parsed as an int
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      conditionNotes: data['condition_notes'],
      category: data['category'],
      pricePerDay: data['price_per_day'] ?? '0',
      depositAmount: data['deposit_amount'] ?? '0',
      image: data['image'] ?? '',
      isAvailable: data['is_available'] ?? false,
      location: parsedLocation != null
          ? Location('Point', [
              parsedLocation['longitude']!,
              parsedLocation['latitude']!,
            ])
          : null,
      owner_name: data['owner_name'] ?? '',
    );
  }
}
