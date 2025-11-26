import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionStatusProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  // Subscription status data
  bool isTrialing = false;
  int trialDaysLeft = 0;
  bool isPaid = false;
  bool canAddMonitor = false;
  String planName = '';
  bool showSubscriptionBanner = false;
  bool requiresSubscription = false;

  /// Fetches subscription status from the API
  Future<bool> getSubscriptionStatus() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/api/subscription/status/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Update subscription status
        isTrialing = data['is_trialing'] ?? false;
        trialDaysLeft = data['trial_days_left'] ?? 0;
        isPaid = data['is_paid'] ?? false;
        canAddMonitor = data['can_add_monitor'] ?? false;
        planName = data['plan_name'] ?? '';
        showSubscriptionBanner = data['show_subscription_banner'] ?? false;
        requiresSubscription = data['requires_subscription'] ?? false;

        debugPrint('Subscription Status:');
        debugPrint('Plan: $planName');
        debugPrint('Is Trialing: $isTrialing');
        debugPrint('Trial Days Left: $trialDaysLeft');
        debugPrint('Is Paid: $isPaid');
        debugPrint('Can Add Monitor: $canAddMonitor');

        notifyListeners();
        return true;
      } else {
        debugPrint('Failed to fetch subscription status: ${response.body}');
        errorMessage = 'Failed to fetch subscription status';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Error fetching subscription status: $e');
      isLoading = false;
      errorMessage = 'An error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  //create checkout

  /// Creates a checkout session for subscription
  /// Returns the checkout URL if successful, null otherwise
  Future<String?> createCheckout(String planType) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      debugPrint('Creating checkout with plan type: $planType');
      debugPrint('Using token: ${token.substring(0, 20)}...');

      final response = await http.post(
        Uri.parse('$baseUrl/api/subscription/create-checkout/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'plan_type': planType}),
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final checkoutUrl = data['checkout_url'] as String?;

        debugPrint('Checkout created successfully');
        debugPrint('Checkout URL: $checkoutUrl');

        return checkoutUrl;
      } else {
        // Try to parse error message from response
        try {
          final errorData = jsonDecode(response.body);
          errorMessage =
              errorData['error'] ??
              errorData['detail'] ??
              'Failed to create checkout';
        } catch (e) {
          errorMessage = 'Failed to create checkout: ${response.statusCode}';
        }
        debugPrint('Failed to create checkout: ${response.body}');
        notifyListeners();
        return null;
      }
    } catch (e) {
      debugPrint('Error creating checkout: $e');
      isLoading = false;
      errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }
}
