import 'package:flutter/foundation.dart';
import '../models/subscription.dart';
import '../services/subscription_service.dart';

class SubscriptionProvider with ChangeNotifier {
  final SubscriptionService _subscriptionService = SubscriptionService();
  
  List<Subscription> _availableSubscriptions = [];
  UserSubscription? _currentUserSubscription;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Subscription> get availableSubscriptions => _availableSubscriptions;
  UserSubscription? get currentUserSubscription => _currentUserSubscription;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  bool get hasActiveSubscription => 
      _currentUserSubscription?.isValidSubscription ?? false;
  
  bool get isPremiumUser => 
      hasActiveSubscription && 
      (_currentUserSubscription?.subscription.type == SubscriptionType.premium ||
       _currentUserSubscription?.subscription.type == SubscriptionType.vip);

  Future<void> loadAvailableSubscriptions() async {
    _setLoading(true);
    _clearError();
    
    try {
      _availableSubscriptions = await _subscriptionService.getAvailableSubscriptions();
    } catch (e) {
      _setError('Failed to load subscriptions: ${e.toString()}');
    }
    
    _setLoading(false);
  }

  Future<void> loadCurrentSubscription() async {
    _setLoading(true);
    _clearError();
    
    try {
      _currentUserSubscription = await _subscriptionService.getCurrentUserSubscription();
    } catch (e) {
      _setError('Failed to load current subscription: ${e.toString()}');
    }
    
    _setLoading(false);
  }

  Future<bool> purchaseSubscription(String subscriptionId, String paymentMethod) async {
    _setLoading(true);
    _clearError();
    
    try {
      final userSubscription = await _subscriptionService.purchaseSubscription(
        subscriptionId, 
        paymentMethod,
      );
      
      if (userSubscription != null) {
        _currentUserSubscription = userSubscription;
        _setLoading(false);
        return true;
      } else {
        _setError('Subscription purchase failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Subscription purchase failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> cancelSubscription() async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _subscriptionService.cancelSubscription();
      if (success) {
        // Keep the subscription data but mark as inactive
        if (_currentUserSubscription != null) {
          _currentUserSubscription = UserSubscription(
            id: _currentUserSubscription!.id,
            userId: _currentUserSubscription!.userId,
            subscriptionId: _currentUserSubscription!.subscriptionId,
            startDate: _currentUserSubscription!.startDate,
            endDate: _currentUserSubscription!.endDate,
            isActive: false,
            paymentMethod: _currentUserSubscription!.paymentMethod,
            transactionId: _currentUserSubscription!.transactionId,
            subscription: _currentUserSubscription!.subscription,
          );
        }
        _setLoading(false);
        return true;
      } else {
        _setError('Subscription cancellation failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Subscription cancellation failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> renewSubscription() async {
    if (_currentUserSubscription == null) return false;
    
    return await purchaseSubscription(
      _currentUserSubscription!.subscriptionId,
      _currentUserSubscription!.paymentMethod,
    );
  }

  bool canAccessPremiumContent() {
    return hasActiveSubscription && isPremiumUser;
  }

  bool canAccessContent(bool isPremiumContent) {
    if (!isPremiumContent) return true;
    return canAccessPremiumContent();
  }

  String getSubscriptionStatus() {
    if (_currentUserSubscription == null) {
      return 'No active subscription';
    }
    
    if (_currentUserSubscription!.isExpired) {
      return 'Subscription expired';
    }
    
    if (!_currentUserSubscription!.isActive) {
      return 'Subscription cancelled';
    }
    
    final daysRemaining = _currentUserSubscription!.daysRemaining;
    if (daysRemaining <= 0) {
      return 'Expires today';
    } else if (daysRemaining == 1) {
      return 'Expires tomorrow';
    } else if (daysRemaining <= 7) {
      return 'Expires in $daysRemaining days';
    } else {
      return 'Active subscription';
    }
  }

  List<Subscription> getRecommendedSubscriptions() {
    final recommended = <Subscription>[];
    
    // Add popular subscription first
    final popular = _availableSubscriptions.where((s) => s.isPopular).toList();
    recommended.addAll(popular);
    
    // Add others sorted by price
    final others = _availableSubscriptions.where((s) => !s.isPopular).toList()
      ..sort((a, b) => a.price.compareTo(b.price));
    recommended.addAll(others);
    
    return recommended;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}