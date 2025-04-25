import 'package:shuffle_native/models/item.dart';

class Booking {
  final int id;
  final int renter;
  final Item item;
  final String start_date;
  final String end_date;
  final String total_price;
  final String status;
  final String pickup_photo;
  final String return_photo;

  Booking({
    required this.id,
    required this.renter,
    required this.item,
    required this.start_date,
    required this.end_date,
    required this.total_price,
    required this.status,
    required this.pickup_photo,
    required this.return_photo,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      renter: json['renter'],
      item: Item.fromJson(json['item']),
      start_date: json['start_date'],
      end_date: json['end_date'],
      total_price: json['total_price'],
      status: json['status'],
      pickup_photo: json['pickup_photo'] ?? '',
      return_photo: json['return_photo'] ?? '',
    );
  }
}