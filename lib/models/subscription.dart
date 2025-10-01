class Subscription {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationInDays;
  final List<String> features;
  final bool isPopular;
  final String? discountText;
  final double? originalPrice;
  final SubscriptionType type;

  Subscription({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationInDays,
    required this.features,
    this.isPopular = false,
    this.discountText,
    this.originalPrice,
    required this.type,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      durationInDays: json['duration_in_days'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
      isPopular: json['is_popular'] ?? false,
      discountText: json['discount_text'],
      originalPrice: json['original_price']?.toDouble(),
      type: SubscriptionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => SubscriptionType.premium,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration_in_days': durationInDays,
      'features': features,
      'is_popular': isPopular,
      'discount_text': discountText,
      'original_price': originalPrice,
      'type': type.toString().split('.').last,
    };
  }

  String get formattedPrice {
    return '\$${price.toStringAsFixed(2)}';
  }

  String get durationText {
    if (durationInDays == 1) return '1 Day';
    if (durationInDays == 7) return '1 Week';
    if (durationInDays == 30) return '1 Month';
    if (durationInDays == 90) return '3 Months';
    if (durationInDays == 365) return '1 Year';
    return '$durationInDays Days';
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  double get discountPercentage {
    if (!hasDiscount) return 0.0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }
}

enum SubscriptionType {
  free,
  basic,
  premium,
  vip
}

class UserSubscription {
  final String id;
  final String userId;
  final String subscriptionId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final String paymentMethod;
  final String transactionId;
  final Subscription subscription;

  UserSubscription({
    required this.id,
    required this.userId,
    required this.subscriptionId,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.paymentMethod,
    required this.transactionId,
    required this.subscription,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      subscriptionId: json['subscription_id'] ?? '',
      startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? false,
      paymentMethod: json['payment_method'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      subscription: Subscription.fromJson(json['subscription'] ?? {}),
    );
  }

  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isValidSubscription => isActive && !isExpired;
  
  int get daysRemaining {
    if (isExpired) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }
}