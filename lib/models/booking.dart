class Booking {
  final int id;
  final int renter;
  final int item;
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
}