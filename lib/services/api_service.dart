import 'package:dio/dio.dart';
import 'package:shuffle_native/models/item.dart';
import 'package:shuffle_native/models/location.dart';
import 'api_client.dart';

class ApiService {
  final Dio _dio = ApiClient.instance;

  Future<Response> listNewItem({
    required String name,
    required String description,
    String? condition_notes,
    required int price_per_day,
    required int deposit_amount,
    required Location location,
  }) async {
    return await _dio.post(
      '/api/rentals/items/',
      data: {
        'name': name,
        'description': description,
        'condition_notes': condition_notes,
        'price_per_day': price_per_day,
        'deposit_amount': deposit_amount,
        'location': location,
      },
    );
  }

  Future<Item> getItemById(String id) async {
    final response = await _dio.get('/api/rentals/items/$id');
    if (response.statusCode == 200) {
      final data = response.data;

      // Map the API response to the Item class
      return Item(
        id: data['id'],
        owner: data['owner'],
        name: data['name'],
        description: data['description'],
        conditionNotes: data['condition_notes'],
        category: data['category'],
        pricePerDay: (data['price_per_day'] as num).toDouble(),
        depositAmount: (data['deposit_amount'] as num).toDouble(),
        image: data['image'],
        isAvailable: data['is_available'],
        location: data['location'] != null
            ? Location(
                data['location']['type'],
                List<double>.from(data['location']['coordinates']),
              )
            : null,
        createdAt: DateTime.parse(data['created_at']),
        updatedAt: DateTime.parse(data['updated_at']),
      );
    } else {
      throw Exception('Failed to fetch item with ID: $id');
    }
  }

  Future<List<Item>> getItems(Location? location, int radius) async {
    // Build the query parameters dynamically based on whether location is null
    final queryParameters = location != null
        ? '?latitude=${location.coordinates[1]}&longitude=${location.coordinates[0]}&radius=$radius'
        : '';

    final response = await _dio.get('/api/rentals/items/$queryParameters');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;

      // Map the API response to a list of Item objects
      return data.map((item) {
        return Item(
          id: item['id'] ?? 0,
          owner: item['owner'] ?? '',
          name: item['name'] ?? '',
          description: item['description'] ?? '',
          conditionNotes: item['condition_notes'],
          category: item['category'],
          pricePerDay: (item['price_per_day'] as num?)?.toDouble() ?? 0.0,
          depositAmount: (item['deposit_amount'] as num?)?.toDouble() ?? 0.0,
          image: item['image'] ?? '',
          isAvailable: item['is_available'] ?? false,
          location: item['location'] != null
              ? Location(
                  item['location']['type'] ?? '',
                  List<double>.from(item['location']['coordinates']),
                )
              : null,
          createdAt: DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now(),
          updatedAt: DateTime.tryParse(item['updated_at'] ?? '') ?? DateTime.now(),
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch items');
    }
  }

  Future<Response> deleteItem(String id) async {
    return await _dio.delete('/api/rentals/items/$id');
  }
  
}
