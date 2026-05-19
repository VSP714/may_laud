import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:may_laud/providers/content_providers.dart';

void main() {
  group('Announcement Model Tests', () {
    test('Announcement.fromJson should parse valid JSON', () {
      // Arrange
      final json = {
        'id': 'announcement-123',
        'title': 'Town Hall Meeting',
        'description': 'Monthly town hall meeting for all residents',
        'category': 'Government',
        'date': '2024-03-15T14:30:00.000Z',
        'imageUrl': 'https://example.com/image.jpg',
        'isImportant': true,
        'isRead': false,
      };

      // Act
      final announcement = Announcement.fromJson(json);

      // Assert
      expect(announcement.id, 'announcement-123');
      expect(announcement.title, 'Town Hall Meeting');
      expect(announcement.description,
          'Monthly town hall meeting for all residents');
      expect(announcement.category, 'Government');
      expect(announcement.date, DateTime.utc(2024, 3, 15, 14, 30));
      expect(announcement.imageUrl, 'https://example.com/image.jpg');
      expect(announcement.isImportant, true);
      expect(announcement.isRead, false);
    });

    test('Announcement.toJson should serialize correctly', () {
      // Arrange
      final announcement = Announcement(
        id: 'announcement-123',
        title: 'Town Hall Meeting',
        description: 'Monthly town hall meeting for all residents',
        category: 'Government',
        date: DateTime.utc(2024, 3, 15, 14, 30),
        imageUrl: 'https://example.com/image.jpg',
        isImportant: true,
        isRead: false,
      );

      // Act
      final json = announcement.toJson();

      // Assert
      expect(json['id'], 'announcement-123');
      expect(json['title'], 'Town Hall Meeting');
      expect(
          json['description'], 'Monthly town hall meeting for all residents');
      expect(json['category'], 'Government');
      expect(json['date'], '2024-03-15T14:30:00.000Z');
      expect(json['imageUrl'], 'https://example.com/image.jpg');
      expect(json['isImportant'], true);
      expect(json['isRead'], false);
    });

    test('formattedDate should return correct format', () {
      // Arrange
      final announcement = Announcement(
        id: 'test',
        title: 'Test',
        description: 'Test',
        category: 'Test',
        date: DateTime.utc(2024, 3, 15, 14, 30),
      );

      // Act
      final formatted = announcement.formattedDate;

      // Assert
      expect(formatted, contains('Mar 15, 2024'));
      expect(formatted,
          contains('02:30 PM')); // UTC+8 conversion depends on locale
    });

    test('copyWith should create new instance with updated values', () {
      // Arrange
      final original = Announcement(
        id: 'original',
        title: 'Original Title',
        description: 'Original Description',
        category: 'General',
        date: DateTime.utc(2024, 1, 1),
        isImportant: false,
        isRead: false,
      );

      // Act
      final updated = original.copyWith(
        title: 'Updated Title',
        isImportant: true,
        isRead: true,
      );

      // Assert
      expect(updated.id, 'original');
      expect(updated.title, 'Updated Title');
      expect(updated.description, 'Original Description');
      expect(updated.category, 'General');
      expect(updated.date, DateTime.utc(2024, 1, 1));
      expect(updated.isImportant, true);
      expect(updated.isRead, true);
    });
  });

  group('AppNotification Model Tests', () {
    test('AppNotification.fromJson should parse valid JSON', () {
      // Arrange
      final json = {
        'id': 'notification-123',
        'title': 'New Announcement',
        'message': 'A new town hall meeting has been scheduled',
        'timestamp': '2024-03-15T10:00:00.000Z',
        'type': 'announcement',
        'isRead': false,
        'data': {'announcementId': 'announcement-123'},
      };

      // Act
      final notification = AppNotification.fromJson(json);

      // Assert
      expect(notification.id, 'notification-123');
      expect(notification.title, 'New Announcement');
      expect(
          notification.message, 'A new town hall meeting has been scheduled');
      expect(notification.timestamp, DateTime.utc(2024, 3, 15, 10, 0));
      expect(notification.type, 'announcement');
      expect(notification.isRead, false);
      expect(notification.data?['announcementId'], 'announcement-123');
    });

    // Note: AppNotification doesn't have toJson method in the current implementation
    // test('AppNotification.toJson should serialize correctly', () { ... });

    test('formattedTime should return correct format', () {
      // Arrange
      final notification = AppNotification(
        id: 'test',
        title: 'Test',
        message: 'Test',
        timestamp: DateTime.utc(2024, 3, 15, 10, 0),
        type: 'announcement',
      );

      // Act
      final formatted = notification.formattedTime;

      // Assert
      expect(formatted, contains('10:00 AM')); // Time format depends on locale
    });

    // Note: AppNotification doesn't have copyWith method in the current implementation
    // test('copyWith should create new instance with updated values', () { ... });
  });

  group('Content Providers Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('announcementsProvider should have initial announcements', () {
      final announcements = container.read(announcementsProvider);
      expect(announcements, isNotEmpty);
      expect(announcements.length, greaterThan(0));
    });

    test('notificationsProvider should have initial notifications', () {
      final notifications = container.read(notificationsProvider);
      expect(notifications, isNotEmpty);
      expect(notifications.length, greaterThan(0));
    });

    test('unreadNotificationsCountProvider should count unread notifications',
        () {
      final count = container.read(unreadNotificationsCountProvider);
      expect(count, greaterThanOrEqualTo(0));
      expect(count,
          lessThanOrEqualTo(container.read(notificationsProvider).length));
    });

    test('importantAnnouncementsProvider should filter important announcements',
        () {
      final importantAnnouncements =
          container.read(importantAnnouncementsProvider);

      // All announcements in the list should have isImportant = true
      for (final announcement in importantAnnouncements) {
        expect(announcement.isImportant, true);
      }
    });

    test('markAnnouncementAsRead should update announcement', () {
      final notifier = container.read(announcementsProvider.notifier);
      final initialAnnouncements = container.read(announcementsProvider);

      if (initialAnnouncements.isNotEmpty) {
        final firstAnnouncement = initialAnnouncements.first;
        expect(firstAnnouncement.isRead, false);

        notifier.markAsRead(firstAnnouncement.id);

        final updatedAnnouncements = container.read(announcementsProvider);
        final updatedAnnouncement = updatedAnnouncements.firstWhere(
          (a) => a.id == firstAnnouncement.id,
        );
        expect(updatedAnnouncement.isRead, true);
      }
    });

    test('markNotificationAsRead should update notification', () {
      final notifier = container.read(notificationsProvider.notifier);
      final initialNotifications = container.read(notificationsProvider);

      if (initialNotifications.isNotEmpty) {
        final firstNotification = initialNotifications.first;
        expect(firstNotification.isRead, false);

        notifier.markAsRead(firstNotification.id);

        final updatedNotifications = container.read(notificationsProvider);
        final updatedNotification = updatedNotifications.firstWhere(
          (n) => n.id == firstNotification.id,
        );
        expect(updatedNotification.isRead, true);
      }
    });

    test('addAnnouncement should increase announcements count', () {
      final notifier = container.read(announcementsProvider.notifier);
      final initialCount = container.read(announcementsProvider).length;

      final newAnnouncement = Announcement(
        id: 'test-new-announcement',
        title: 'Test Announcement',
        description: 'Test Description',
        category: 'Test',
        date: DateTime.now(),
      );

      notifier.addAnnouncement(newAnnouncement);

      final updatedCount = container.read(announcementsProvider).length;
      expect(updatedCount, initialCount + 1);
    });

    test('addNotification should increase notifications count', () {
      final notifier = container.read(notificationsProvider.notifier);
      final initialCount = container.read(notificationsProvider).length;

      final newNotification = AppNotification(
        id: 'test-new-notification',
        title: 'Test Notification',
        message: 'Test Message',
        timestamp: DateTime.now(),
        type: 'test',
      );

      notifier.addNotification(newNotification);

      final updatedCount = container.read(notificationsProvider).length;
      expect(updatedCount, initialCount + 1);
    });
  });
}
