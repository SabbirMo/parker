class SubscriptionPlan {
  final int id;
  final String name;
  final double price;
  final String currency;
  final String interval;
  final String intervalDisplay;
  final String stripePriceId;
  final String description;
  final List<String> features;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.interval,
    required this.intervalDisplay,
    required this.stripePriceId,
    required this.description,
    required this.features,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      interval: json['interval'] as String,
      intervalDisplay: json['interval_display'] as String,
      stripePriceId: json['stripe_price_id'] as String,
      description: json['description'] as String,
      features: (json['features'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'currency': currency,
      'interval': interval,
      'interval_display': intervalDisplay,
      'stripe_price_id': stripePriceId,
      'description': description,
      'features': features,
    };
  }
}
