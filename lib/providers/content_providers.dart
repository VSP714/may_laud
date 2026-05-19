import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Announcement model
class Announcement {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final String? imageUrl;
  final bool isImportant;
  final bool isRead;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.imageUrl,
    this.isImportant = false,
    this.isRead = false,
  });

  String get formattedDate {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      imageUrl: json['imageUrl'],
      isImportant: json['isImportant'] ?? false,
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'date': date.toIso8601String(),
      'imageUrl': imageUrl,
      'isImportant': isImportant,
      'isRead': isRead,
    };
  }

  Announcement copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? date,
    String? imageUrl,
    bool? isImportant,
    bool? isRead,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      isImportant: isImportant ?? this.isImportant,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// Notification model
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // 'announcement', 'alert', 'reminder', 'system'
  final bool isRead;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.data,
  });

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(timestamp);
    }
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      type: json['type'] ?? 'system',
      isRead: json['isRead'] ?? false,
      data: json['data'],
    );
  }
}

/// Announcements provider
class AnnouncementsProvider extends StateNotifier<List<Announcement>> {
  AnnouncementsProvider() : super(_mockAnnouncements);

  static final List<Announcement> _mockAnnouncements = [
    Announcement(
      id: '1',
      title: 'Community Townhall Meeting',
      description:
          'Join us for the monthly community townhall meeting at the Milaor Municipal Hall. Discuss local issues and upcoming projects.',
      category: 'Community',
      date: DateTime.now().subtract(const Duration(days: 1)),
      imageUrl: 'assets/images/home_screen/Community_Townhall.png',
      isImportant: true,
    ),
    Announcement(
      id: '2',
      title: 'Road Closure: San Jose Street',
      description:
          'San Jose Street will be closed for road repairs from April 25-30. Please use alternate routes.',
      category: 'Infrastructure',
      date: DateTime.now().subtract(const Duration(days: 2)),
      imageUrl: 'assets/images/home_screen/Road_Announcement.png',
    ),
    Announcement(
      id: '3',
      title: 'Free Vaccination Drive',
      description:
          'Free flu vaccination drive at Milaor Health Center from April 28-30. All residents are encouraged to participate.',
      category: 'Health',
      date: DateTime.now().subtract(const Duration(days: 3)),
      imageUrl: 'assets/images/home_screen/Vacine _Announcement.png',
      isImportant: true,
    ),
    Announcement(
      id: '4',
      title: 'Water Interruption Schedule',
      description:
          'Water supply will be interrupted on April 26, 9 AM to 5 PM for pipeline maintenance.',
      category: 'Utilities',
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Announcement(
      id: '5',
      title: 'New Business Permit Process',
      description:
          'Streamlined business permit application process now available online through the Milaud app.',
      category: 'Government',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Announcement(
      id: '6',
      title: 'Cultural Festival 2024',
      description:
          'Milaor Cultural Festival returns this May 15-20. Join us for traditional dances, food, and music.',
      category: 'Events',
      date: DateTime.now().subtract(const Duration(days: 6)),
      imageUrl: 'assets/images/home_screen/Greetings.png',
    ),
  ];

  void markAsRead(String id) {
    state = state.map((announcement) {
      if (announcement.id == id) {
        return announcement.copyWith(isRead: true);
      }
      return announcement;
    }).toList();
  }

  void markAllAsRead() {
    state = state
        .map((announcement) => announcement.copyWith(isRead: true))
        .toList();
  }

  void addAnnouncement(Announcement announcement) {
    state = [announcement, ...state];
  }

  void deleteAnnouncement(String id) {
    state = state.where((announcement) => announcement.id != id).toList();
  }

  List<Announcement> get importantAnnouncements {
    return state.where((a) => a.isImportant).toList();
  }

  List<Announcement> get unreadAnnouncements {
    return state.where((a) => !a.isRead).toList();
  }
}

/// Notifications provider
class NotificationsProvider extends StateNotifier<List<AppNotification>> {
  NotificationsProvider() : super(_mockNotifications);

  static final List<AppNotification> _mockNotifications = [
    AppNotification(
      id: '1',
      title: 'New Announcement',
      message: 'Community Townhall Meeting has been scheduled',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      type: 'announcement',
    ),
    AppNotification(
      id: '2',
      title: 'Flood Alert',
      message: 'Heavy rainfall expected in Milaor area. Stay safe.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'alert',
      isRead: true,
    ),
    AppNotification(
      id: '3',
      title: 'Document Ready',
      message: 'Your Barangay Clearance is ready for pickup',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: 'reminder',
    ),
    AppNotification(
      id: '4',
      title: 'Report Submitted',
      message: 'Your citizen report #CR-2024-001 has been received',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: 'system',
      isRead: true,
    ),
    AppNotification(
      id: '5',
      title: 'Welcome to Milaud',
      message:
          'Thank you for joining Milaud! Explore features to stay connected.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: 'system',
      isRead: true,
    ),
  ];

  void markAsRead(String id) {
    state = state.map((notification) {
      if (notification.id == id) {
        return AppNotification(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          timestamp: notification.timestamp,
          type: notification.type,
          isRead: true,
          data: notification.data,
        );
      }
      return notification;
    }).toList();
  }

  void markAllAsRead() {
    state = state
        .map((notification) => AppNotification(
              id: notification.id,
              title: notification.title,
              message: notification.message,
              timestamp: notification.timestamp,
              type: notification.type,
              isRead: true,
              data: notification.data,
            ))
        .toList();
  }

  void addNotification(AppNotification notification) {
    state = [notification, ...state];
  }

  void deleteNotification(String id) {
    state = state.where((notification) => notification.id != id).toList();
  }

  int get unreadCount {
    return state.where((n) => !n.isRead).length;
  }
}

/// Provider instances
final announcementsProvider =
    StateNotifierProvider<AnnouncementsProvider, List<Announcement>>(
  (ref) => AnnouncementsProvider(),
);

final notificationsProvider =
    StateNotifierProvider<NotificationsProvider, List<AppNotification>>(
  (ref) => NotificationsProvider(),
);

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});

final importantAnnouncementsProvider = Provider<List<Announcement>>((ref) {
  final announcements = ref.watch(announcementsProvider);
  return announcements.where((a) => a.isImportant).toList();
});
