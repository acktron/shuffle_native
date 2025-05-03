class CreatePaymentResponse {
  final String orderId;
  final String razorpayKey;
  final int amount;
  final String currency;

  CreatePaymentResponse({
    required this.orderId,
    required this.razorpayKey,
    required this.amount,
    required this.currency,
  });

  factory CreatePaymentResponse.fromJson(Map<String, dynamic> json) {
    return CreatePaymentResponse(
      orderId: json['order_id'],
      razorpayKey: json['razorpay_key'],
      amount: json['amount'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'razorpay_key': razorpayKey,
      'amount': amount,
      'currency': currency,
    };
  }
}