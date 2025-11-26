import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parker_touch/core/base_url/base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final bool isRead;
  final NotificationType type;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.imageUrl,
    this.data,
    this.isRead = false,
    this.type = NotificationType.info,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    String? imageUrl,
    Map<String, dynamic>? data,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    final data = message.data;
    NotificationType type = NotificationType.info;

    // Determine notification type based on data
    if (data.containsKey('type')) {
      if (data['type'] == 'missed') {
        type = NotificationType.missed;
      } else if (data['type'] == 'taken') {
        type = NotificationType.taken;
      } else if (data['type'] == 'reminder') {
        type = NotificationType.reminder;
      }
    }

    return NotificationModel(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? '',
      timestamp: DateTime.now(),
      imageUrl:
          message.notification?.android?.imageUrl ??
          message.notification?.apple?.imageUrl,
      data: data,
      type: type,
    );
  }

  // Factory method to create NotificationModel from backend JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    NotificationType type = NotificationType.info;

    // Determine notification type
    if (json.containsKey('type')) {
      if (json['type'] == 'missed') {
        type = NotificationType.missed;
      } else if (json['type'] == 'taken') {
        type = NotificationType.taken;
      } else if (json['type'] == 'reminder') {
        type = NotificationType.reminder;
      }
    }

    return NotificationModel(
      id:
          json['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? json['message'] ?? 'Notification',
      body: json['body'] ?? json['description'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'])
                : DateTime.now()),
      isRead: json['is_read'] ?? false,
      type: type,
      data: json,
    );
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  String getFormattedTime() {
    final hour = timestamp.hour > 12
        ? timestamp.hour - 12
        : (timestamp.hour == 0 ? 12 : timestamp.hour);
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')} $period';
  }
}

enum NotificationType { missed, taken, reminder, info }

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _backendUnreadCount = 0;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get backendUnreadCount => _backendUnreadCount;

  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  int get unreadCount => unreadNotifications.length;

  // Fetch notifications from backend
  Future<void> fetchNotifications() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        debugPrint('No access token found. User not logged in.');
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/monitor/notifications/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      _isLoading = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _backendUnreadCount = data['unread_count'] ?? 0;

        final List<dynamic> notificationsList = data['notifications'] ?? [];

        // Convert backend notifications to NotificationModel
        final backendNotifications = notificationsList
            .map((json) => NotificationModel.fromJson(json))
            .toList();

        // Merge with existing Firebase notifications (avoid duplicates)
        final existingIds = _notifications.map((n) => n.id).toSet();
        final newNotifications = backendNotifications
            .where((n) => !existingIds.contains(n.id))
            .toList();

        _notifications.addAll(newNotifications);

        // Sort by timestamp (newest first)
        _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        debugPrint(
          'Fetched ${notificationsList.length} notifications from backend',
        );
        notifyListeners();
      } else {
        _errorMessage = 'Failed to fetch notifications: ${response.statusCode}';
        debugPrint(_errorMessage);
        debugPrint('Response: ${response.body}');
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error fetching notifications: $e';
      debugPrint(_errorMessage);
      notifyListeners();
    }
  }

  void addNotification(NotificationModel notification) {
    // Check if notification already exists
    if (!_notifications.any((n) => n.id == notification.id)) {
      _notifications.insert(0, notification);
      notifyListeners();
    }
  }

  void addNotificationFromRemoteMessage(RemoteMessage message) {
    final notification = NotificationModel.fromRemoteMessage(message);
    addNotification(notification);
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  void clearReadNotifications() {
    _notifications.removeWhere((n) => n.isRead);
    notifyListeners();
  }
}
