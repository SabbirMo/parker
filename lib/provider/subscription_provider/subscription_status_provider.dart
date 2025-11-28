import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:parker_touch/model/subscription_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionStatusProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  // Subscription plans
  List<SubscriptionPlan> plans = [];
  bool plansLoaded = false;

  // Subscription status data
  bool isPaid = false;
  bool? isTrialing; // Nullable because API returns null
  bool isPaused = false;
  bool canAddMonitor = false;
  String planName = '';
  String? currentPeriodEndsAt;
  String? trialEndsAt; // Nullable
  int daysLeft = 0;
  String status = '';
  bool requiresPayment = false;

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
        // Check if response is HTML (error page from backend)
        if (response.body.trim().startsWith('<!DOCTYPE') ||
            response.body.trim().startsWith('<html')) {
          debugPrint('ERROR: Subscription API returned HTML error page');
          debugPrint('Backend error - API endpoint issue or model error');
          errorMessage = 'Subscription service unavailable';
          // Set default values to allow app to continue
          isPaid = false;
          isTrialing = null;
          isPaused = false;
          canAddMonitor = false;
          planName = 'Unknown';
          status = 'Unknown';
          daysLeft = 0;
          requiresPayment = false;
          notifyListeners();
          return false;
        }

        try {
          final data = jsonDecode(response.body);

          // Update subscription status with safe defaults matching new API response
          isPaid = data['is_paid'] ?? false;
          isTrialing = data['is_trialing']; // Can be null
          isPaused = data['is_paused'] ?? false;
          canAddMonitor = data['can_add_monitor'] ?? false;
          planName = data['plan_name'] ?? 'Free';
          currentPeriodEndsAt = data['current_period_ends_at'];
          trialEndsAt = data['trial_ends_at'];
          daysLeft = data['days_left'] ?? 0;
          status = data['status'] ?? 'Unknown';
          requiresPayment = data['requires_payment'] ?? false;

          debugPrint('Subscription Status:');
          debugPrint('Plan: $planName');
          debugPrint('Status: $status');
          debugPrint('Is Paid: $isPaid');
          debugPrint('Is Trialing: $isTrialing');
          debugPrint('Is Paused: $isPaused');
          debugPrint('Days Left: $daysLeft');
          debugPrint('Can Add Monitor: $canAddMonitor');
          debugPrint('Requires Payment: $requiresPayment');

          notifyListeners();
          return true;
        } catch (parseError) {
          debugPrint('Error parsing subscription response: $parseError');
          errorMessage = 'Invalid subscription data';
          notifyListeners();
          return false;
        }
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
  /// planId should be "1" for monthly or "2" for yearly
  Future<String?> createCheckout(String planId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      debugPrint('Creating checkout with plan_id: $planId');
      debugPrint('Using token: ${token.substring(0, 20)}...');

      final response = await http.post(
        Uri.parse('$baseUrl/api/subscription/create-checkout/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'plan_id': planId}),
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      isLoading = false;
      notifyListeners();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response is HTML (error page)
        if (response.body.trim().startsWith('<!DOCTYPE') ||
            response.body.trim().startsWith('<html')) {
          debugPrint('ERROR: Checkout API returned HTML error page');
          errorMessage = 'Checkout service unavailable';
          return null;
        }

        try {
          final data = jsonDecode(response.body);
          final checkoutUrl = data['checkout_url'] as String?;

          if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
            debugPrint('Checkout created successfully');
            debugPrint('Checkout URL: $checkoutUrl');
            return checkoutUrl;
          } else {
            debugPrint('No checkout URL in response');
            errorMessage = 'Invalid checkout response';
            return null;
          }
        } catch (parseError) {
          debugPrint('Error parsing checkout response: $parseError');
          errorMessage = 'Invalid response format';
          return null;
        }
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

  /// Fetches available subscription plans from the API
  Future<bool> fetchPlans() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/api/subscription/plans/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      isLoading = false;

      if (response.statusCode == 200) {
        // Check if response is HTML (error page)
        if (response.body.trim().startsWith('<!DOCTYPE') ||
            response.body.trim().startsWith('<html')) {
          debugPrint('ERROR: Plans API returned HTML error page');
          errorMessage = 'Plans service unavailable';
          notifyListeners();
          return false;
        }

        try {
          final data = jsonDecode(response.body);
          final plansList = data['plans'] as List<dynamic>;

          plans = plansList
              .map((planJson) => SubscriptionPlan.fromJson(planJson))
              .toList();

          plansLoaded = true;

          debugPrint('Fetched ${plans.length} subscription plans');
          for (var plan in plans) {
            debugPrint('Plan: ${plan.name} - \$${plan.price}/${plan.interval}');
          }

          notifyListeners();
          return true;
        } catch (parseError) {
          debugPrint('Error parsing plans response: $parseError');
          errorMessage = 'Invalid plans data';
          notifyListeners();
          return false;
        }
      } else {
        debugPrint('Failed to fetch plans: ${response.body}');
        errorMessage = 'Failed to fetch subscription plans';
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Error fetching plans: $e');
      isLoading = false;
      errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
}
