class Address {
  int? user;
  String fullName;
  String phoneNumber;
  String streetAddress;
  String city;
  String state;
  String postalCode;
  String country;
  bool isDefault;
  DateTime? createdAt;

  Address({
    this.user,
    required this.fullName,
    required this.phoneNumber,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.isDefault,
    this.createdAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      user: json['user'],
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

  Map<String, dynamic> toJson() {
    return {
      // 'user': user,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'street_address': streetAddress,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'is_default': isDefault,
      // 'created_at': createdAt!.toIso8601String(),
    };
  }
}
