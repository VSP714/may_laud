// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:may_laud/providers/content_providers.dart';
import 'package:may_laud/services/mock_data_service.dart';

/// Service for announcements
class AnnouncementService {
  final Ref ref;

  AnnouncementService(this.ref);

  /// Fetch announcements (mock implementation)
  Future<List<Announcement>> fetchAnnouncements() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final mockData = MockDataService.generateAnnouncements(10);
    return mockData.map((data) => Announcement.fromJson(data)).toList();
  }

  /// Mark announcement as read
  Future<void> markAsRead(String announcementId) async {
    ref.read(announcementsProvider.notifier).markAsRead(announcementId);
  }

  /// Mark all announcements as read
  Future<void> markAllAsRead() async {
    ref.read(announcementsProvider.notifier).markAllAsRead();
  }

  /// Submit new announcement (admin function)
  Future<void> submitAnnouncement({
    required String title,
    required String description,
    required String category,
    String? imageUrl,
    bool isImportant = false,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final newAnnouncement = Announcement(
      id: 'ann_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      category: category,
      date: DateTime.now(),
      imageUrl: imageUrl,
      isImportant: isImportant,
    );

    ref.read(announcementsProvider.notifier).addAnnouncement(newAnnouncement);
  }
}

/// Service for notifications
class NotificationService {
  final Ref ref;

  NotificationService(this.ref);

  /// Fetch notifications (mock implementation)
  Future<List<AppNotification>> fetchNotifications() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final mockData = MockDataService.generateNotifications(15);
    return mockData.map((data) => AppNotification.fromJson(data)).toList();
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    ref.read(notificationsProvider.notifier).markAsRead(notificationId);
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    ref.read(notificationsProvider.notifier).markAllAsRead();
  }

  /// Send test notification
  Future<void> sendTestNotification() async {
    final testNotification = AppNotification(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Test Notification',
      message:
          'This is a test notification sent at ${DateTime.now().toString()}',
      timestamp: DateTime.now(),
      type: 'system',
    );

    ref.read(notificationsProvider.notifier).addNotification(testNotification);
  }
}

/// Service for emergency hotlines
class HotlineService {
  /// Fetch all hotlines
  Future<List<Map<String, dynamic>>> fetchHotlines() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockDataService.generateHotlines();
  }

  /// Call hotline (mock)
  Future<void> callHotline(String number) async {
    // In a real app, this would use url_launcher to make a phone call
    print('Calling hotline: $number');
    await Future.delayed(const Duration(seconds: 1));
  }
}

/// Service for document requests
class DocumentService {
  /// Fetch available document types
  Future<List<Map<String, dynamic>>> fetchDocumentTypes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockDataService.generateDocumentTypes();
  }

  /// Submit document request
  Future<Map<String, dynamic>> submitDocumentRequest({
    required String documentTypeId,
    required String purpose,
    required Map<String, dynamic> userInfo,
    List<String>? attachments,
  }) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    final requestId =
        'DOC-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch}';

    return {
      'requestId': requestId,
      'status': 'pending',
      'submittedAt': DateTime.now().toIso8601String(),
      'estimatedCompletion':
          DateTime.now().add(const Duration(days: 2)).toIso8601String(),
      'documentTypeId': documentTypeId,
      'purpose': purpose,
      'message':
          'Your document request has been submitted successfully. You will be notified when it\'s ready for pickup.',
    };
  }

  /// Check request status
  Future<Map<String, dynamic>> checkRequestStatus(String requestId) async {
    await Future.delayed(const Duration(seconds: 1));

    final statuses = [
      'pending',
      'processing',
      'ready',
      'completed',
      'rejected'
    ];
    final randomStatus = statuses[DateTime.now().millisecond % statuses.length];

    return {
      'requestId': requestId,
      'status': randomStatus,
      'lastUpdated': DateTime.now().toIso8601String(),
      'message': _getStatusMessage(randomStatus),
    };
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'pending':
        return 'Your request is awaiting review by the barangay office.';
      case 'processing':
        return 'Your document is being processed. Expected completion: 1-2 business days.';
      case 'ready':
        return 'Your document is ready for pickup at the barangay hall.';
      case 'completed':
        return 'Document has been picked up and request is closed.';
      case 'rejected':
        return 'Request was rejected. Please check requirements and resubmit.';
      default:
        return 'Status unknown.';
    }
  }
}

/// Service for flood alerts
class FloodAlertService {
  /// Get current flood alert status
  Future<Map<String, dynamic>> getCurrentAlert() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockDataService.generateFloodAlert();
  }

  /// Get flood alert history
  Future<List<Map<String, dynamic>>> getAlertHistory() async {
    await Future.delayed(const Duration(seconds: 1));

    final List<Map<String, dynamic>> history = [];
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final alert = MockDataService.generateFloodAlert();
      alert['date'] = date.toIso8601String();
      alert['isActive'] = false; // Past alerts are not active
      history.add(alert);
    }

    return history;
  }

  /// Subscribe to flood alerts
  Future<void> subscribeToAlerts(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    print('User $userId subscribed to flood alerts');
  }
}

/// Service for citizen reports
class CitizenReportService {
  /// Fetch report categories
  Future<List<Map<String, dynamic>>> fetchReportCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockDataService.generateReportCategories();
  }

  /// Submit citizen report
  Future<Map<String, dynamic>> submitReport({
    required String categoryId,
    required String subcategory,
    required String description,
    required String location,
    List<String>? photos,
    String? contactInfo,
  }) async {
    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    final reportId =
        'CR-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch}';

    return {
      'reportId': reportId,
      'status': 'received',
      'submittedAt': DateTime.now().toIso8601String(),
      'categoryId': categoryId,
      'subcategory': subcategory,
      'assignedTo': 'Barangay Office',
      'estimatedResolution': '3-5 business days',
      'message':
          'Thank you for your report. It has been received and will be reviewed by the appropriate department.',
    };
  }

  /// Check report status
  Future<Map<String, dynamic>> checkReportStatus(String reportId) async {
    await Future.delayed(const Duration(seconds: 1));

    final statuses = [
      'received',
      'assigned',
      'in_progress',
      'resolved',
      'closed'
    ];
    final randomStatus = statuses[DateTime.now().millisecond % statuses.length];

    return {
      'reportId': reportId,
      'status': randomStatus,
      'lastUpdated': DateTime.now().toIso8601String(),
      'message': _getReportStatusMessage(randomStatus),
    };
  }

  String _getReportStatusMessage(String status) {
    switch (status) {
      case 'received':
        return 'Report has been received and is awaiting assignment.';
      case 'assigned':
        return 'Report has been assigned to a department for action.';
      case 'in_progress':
        return 'Department is currently working on resolving the issue.';
      case 'resolved':
        return 'The reported issue has been resolved.';
      case 'closed':
        return 'Report has been closed after resolution.';
      default:
        return 'Status unknown.';
    }
  }
}

/// Provider for services
final announcementServiceProvider = Provider((ref) => AnnouncementService(ref));
final notificationServiceProvider = Provider((ref) => NotificationService(ref));
final hotlineServiceProvider = Provider((ref) => HotlineService());
final documentServiceProvider = Provider((ref) => DocumentService());
final floodAlertServiceProvider = Provider((ref) => FloodAlertService());
final citizenReportServiceProvider = Provider((ref) => CitizenReportService());
