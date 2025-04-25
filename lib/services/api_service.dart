import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shuffle_native/models/booking.dart';
import 'package:shuffle_native/models/item.dart';
import 'package:shuffle_native/models/location.dart';
import 'api_client.dart';

class ApiService {
  final Dio _dio = ApiClient.instance;

  // Future<Response> listNewItem({
  //   required String name,
  //   required String description,
  //   String? condition_notes,
  //   required int price_per_day,
  //   required int deposit_amount,
  //   required Location location,
  // }) async {
  //   return await _dio.post(
  //     '/api/rentals/items/',
  //     data: {
  //       'name': name,
  //       'description': description,
  //       'condition_notes': condition_notes,
  //       'price_per_day': price_per_day,
  //       'deposit_amount': deposit_amount,
  //       'location': location,
  //     },
  //   );
  // }

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
        pricePerDay: data['price_per_day'],
        depositAmount: data['deposit_amount'],
        image: data['image'],
        isAvailable: data['is_available'],
        location:
            data['location'] != null
                ? Location(
                  data['location']['type'],
                  List<double>.from(data['location']['coordinates']),
                )
                : null,
        owner_name: data['owner_name'],
        createdAt: DateTime.parse(data['created_at']),
        updatedAt: DateTime.parse(data['updated_at']),
      );
    } else {
      throw Exception('Failed to fetch item with ID: $id');
    }
  }

  Future<List<Item>> getItems(Location? location, int radius) async {
    // Build the query parameters dynamically based on whether location is null
    final queryParameters =
        location != null
            ? '?latitude=${location.coordinates[1]}&longitude=${location.coordinates[0]}&radius=$radius'
            : '';

    final response = await _dio.get('/api/rentals/items/$queryParameters');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      print('Got Data from API');

      // Map the API response to a list of Item objects
      return data.map((item) {
        // Parse the location string
        final locationString = item['location'] as String?;
        Map<String, double>? parsedLocation;
        if (locationString != null) {
          parsedLocation = _parseLocation(locationString);
        }

        return Item(
          id: item['id'] ?? 0,
          owner: item['owner'] ?? '',
          name: item['name'] ?? '',
          description: item['description'] ?? '',
          conditionNotes: item['condition_notes'],
          category: item['category'],
          pricePerDay: item['price_per_day'] ?? 0,
          depositAmount: item['deposit_amount'] ?? 0,
          image: item['image'] ?? '',
          isAvailable: item['is_available'] ?? false,
          location:
              parsedLocation != null
                  ? Location('Point', [
                    parsedLocation['longitude']!,
                    parsedLocation['latitude']!,
                  ])
                  : null,
          owner_name: item['owner_name'] ?? '',
          createdAt:
              DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now(),
          updatedAt:
              DateTime.tryParse(item['updated_at'] ?? '') ?? DateTime.now(),
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch items');
    }
  }

  Future<Response> deleteItem(String id) async {
    return await _dio.delete('/api/rentals/items/$id');
  }

  // Helper function to parse the location string
  Map<String, double> _parseLocation(String location) {
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

  Future<bool> bookItem(int id, DateTime startDate, DateTime endDate) async {
    print('Booking item with ID: $id from $startDate to $endDate');
    final response = await _dio.post(
      '/api/rentals/bookings/$id/',
      data: {
        'start_date': startDate.toIso8601String(), // Convert to ISO 8601 string
        'end_date': endDate.toIso8601String(), // Convert to ISO 8601 string
      },
    );
    return response.statusCode == 201;
  }

  Future<bool> listNewItem({
    required String name,
    required String description,
    String? conditionNotes,
    required String pricePerDay,
    required String depositAmount,
    required Location location,
    required File? image, // Assuming you want to upload an image file
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'description': description,
      'condition_notes': conditionNotes,
      'price_per_day': pricePerDay,
      'deposit_amount': depositAmount,
      'location': location.toJson(), // Adjust this if needed
      'image': await MultipartFile.fromFile(
        image!.path,
        filename: image.path.split('/').last,
      ),
    });

    print('Listing new item with data: $formData');

    return _dio
        .post('/api/rentals/items/', data: formData)
        .then((response) {
          print('Response status code: ${response.statusCode}');
          return response.statusCode == 201; // 201 Created
        })
        .catchError((error) {
          print('Error listing new item: $error');
          return false;
        });
  }

  Future<List<Booking>> getItemPendingBookings() async {
    final response = await _dio.get('/api/rentals/booking/requests/');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      print('Got Data from API');

      // Map the API response to a list of Booking objects
      return data.map((booking) {
        return Booking.fromJson(booking);
      }).toList();
    } else {
      throw Exception('Failed to fetch pending bookings');
    }
  }
}
