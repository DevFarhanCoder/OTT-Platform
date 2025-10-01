import '../models/subscription.dart';

class SubscriptionService {
  static const String _baseUrl = 'https://api.emmarott.com';

  // Mock subscription data
  final List<Subscription> _mockSubscriptions = [
    Subscription(
      id: '1',
      name: 'Basic Plan',
      description: 'Access to standard content with ads',
      price: 9.99,
      durationInDays: 30,
      features: [
        'Standard Definition (SD) streaming',
        'Limited content library',
        'Watch on 1 device',
        'Ad-supported viewing',
        'Cancel anytime'
      ],
      isPopular: false,
      type: SubscriptionType.basic,
    ),
    Subscription(
      id: '2',
      name: 'Premium Plan',
      description: 'Full access to all content in HD/4K',
      price: 19.99,
      originalPrice: 24.99,
      durationInDays: 30,
      features: [
        'High Definition (HD) & 4K streaming',
        'Full content library access',
        'Watch on up to 4 devices',
        'Ad-free experience',
        'Download for offline viewing',
        'Premium exclusive content',
        'Multiple audio tracks',
        'All subtitles available',
        'Cancel anytime'
      ],
      isPopular: true,
      discountText: '20% OFF',
      type: SubscriptionType.premium,
    ),
    Subscription(
      id: '3',
      name: 'VIP Plan',
      description: 'Ultimate entertainment experience',
      price: 39.99,
      originalPrice: 49.99,
      durationInDays: 30,
      features: [
        'Ultra High Definition (4K) streaming',
        'Complete content library',
        'Watch on unlimited devices',
        'Ad-free premium experience',
        'Download unlimited content',
        'VIP exclusive premieres',
        'Early access to new releases',
        'Multiple audio & subtitle options',
        'Priority customer support',
        'Live streaming events',
        'Behind-the-scenes content',
        'Cancel anytime'
      ],
      isPopular: false,
      discountText: '20% OFF',
      type: SubscriptionType.vip,
    ),
    Subscription(
      id: '4',
      name: 'Annual Premium',
      description: 'Premium plan with annual savings',
      price: 199.99,
      originalPrice: 239.88,
      durationInDays: 365,
      features: [
        'High Definition (HD) & 4K streaming',
        'Full content library access',
        'Watch on up to 4 devices',
        'Ad-free experience',
        'Download for offline viewing',
        'Premium exclusive content',
        'Multiple audio tracks',
        'All subtitles available',
        'Save 2 months compared to monthly',
        'Cancel anytime'
      ],
      isPopular: true,
      discountText: 'Save 17%',
      type: SubscriptionType.premium,
    ),
  ];

  Future<List<Subscription>> getAvailableSubscriptions() async {
    await Future.delayed(const Duration(seconds: 1));
    return List.from(_mockSubscriptions);
  }

  Future<UserSubscription?> getCurrentUserSubscription() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock current subscription - return null for free user
    // Uncomment below to simulate an active subscription
    /*
    return UserSubscription(
      id: 'user_sub_1',
      userId: '1',
      subscriptionId: '2',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 15)),
      isActive: true,
      paymentMethod: 'Credit Card',
      transactionId: 'txn_123456789',
      subscription: _mockSubscriptions[1], // Premium plan
    );
    */
    
    return null; // Free user
  }

  Future<UserSubscription?> purchaseSubscription(
    String subscriptionId, 
    String paymentMethod,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      final subscription = _mockSubscriptions.firstWhere(
        (sub) => sub.id == subscriptionId,
      );
      
      // Mock successful purchase
      final userSubscription = UserSubscription(
        id: 'user_sub_${DateTime.now().millisecondsSinceEpoch}',
        userId: '1', // Mock user ID
        subscriptionId: subscriptionId,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: subscription.durationInDays)),
        isActive: true,
        paymentMethod: paymentMethod,
        transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
        subscription: subscription,
      );
      
      return userSubscription;
    } catch (e) {
      return null;
    }
  }

  Future<bool> cancelSubscription() async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock successful cancellation
    return true;
  }

  Future<List<Map<String, dynamic>>> getPaymentHistory() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock payment history
    return [
      {
        'id': 'payment_1',
        'amount': 19.99,
        'date': DateTime.now().subtract(const Duration(days: 30)),
        'subscription': 'Premium Plan',
        'status': 'Completed',
        'payment_method': 'Credit Card',
      },
      {
        'id': 'payment_2',
        'amount': 19.99,
        'date': DateTime.now().subtract(const Duration(days: 60)),
        'subscription': 'Premium Plan',
        'status': 'Completed',
        'payment_method': 'Credit Card',
      },
    ];
  }

  Future<bool> updatePaymentMethod(String paymentMethod, Map<String, String> details) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock successful update
    return true;
  }

  Future<bool> applyPromoCode(String promoCode) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock promo code validation
    final validCodes = ['SAVE20', 'WELCOME10', 'PREMIUM50'];
    return validCodes.contains(promoCode.toUpperCase());
  }

  Future<double> calculateDiscountedPrice(String subscriptionId, String? promoCode) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      final subscription = _mockSubscriptions.firstWhere(
        (sub) => sub.id == subscriptionId,
      );
      
      double price = subscription.price;
      
      if (promoCode != null) {
        switch (promoCode.toUpperCase()) {
          case 'SAVE20':
            price *= 0.8; // 20% off
            break;
          case 'WELCOME10':
            price *= 0.9; // 10% off
            break;
          case 'PREMIUM50':
            price *= 0.5; // 50% off
            break;
        }
      }
      
      return price;
    } catch (e) {
      throw Exception('Invalid subscription ID');
    }
  }
}