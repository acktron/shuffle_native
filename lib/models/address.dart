class Address {
  int userId;
  String fullName;
  String phoneNumber;
  String streetAddress;
  String city;
  String state;
  String postalCode;
  String country;
  bool isDefault;
  DateTime createdAt;

  Address({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.isDefault,
    required this.createdAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      userId: json['user_id'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      streetAddress: json['street_address'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postal_code'],
      country: json['country'],
      isDefault: json['is_default'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
