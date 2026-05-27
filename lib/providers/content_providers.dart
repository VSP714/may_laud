import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:may_laud/services/supabase_service.dart';

class Announcement {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final String? imageUrl;
  final bool isImportant;
  final bool isRead; // FIX #1 — immutable (was mutable `bool isRead`)

  const Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    this.imageUrl,
    this.isImportant = false,
    this.isRead = false,
  });

  String get formattedDate =>
      DateFormat('MMM dd, yyyy • hh:mm a').format(date);

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id:          json['id'] ?? '',
      title:       json['title'] ?? '',
      description: json['description'] ?? '',
      category:    json['category'] ?? 'General',
      date:        json['created_at'] != null
                     ? DateTime.parse(json['created_at'])
                     : DateTime.now(),
      imageUrl:    json['image_url'],
      isImportant: json['is_important'] ?? false,
      isRead:      json['is_read'] ?? false,
    );
  }

  Announcement copyWith({bool? isRead}) {
    return Announcement(
      id:          id,
      title:       title,
      description: description,
      category:    category,
      date:        date,
      imageUrl:    imageUrl,
      isImportant: isImportant,
      isRead:      isRead ?? this.isRead,
    );
  }
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type;
  final bool isRead; // FIX #1 — immutable (was mutable `bool isRead`)
  final Map<String, dynamic>? data;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.data,
  });

  String get formattedTime {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours   < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays    < 1) return '${diff.inHours}h ago';
    if (diff.inDays    < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM dd').format(timestamp);
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id:        json['id'] ?? '',
      title:     json['title'] ?? '',
      message:   json['message'] ?? '',
      timestamp: json['created_at'] != null
                   ? DateTime.parse(json['created_at'])
                   : DateTime.now(),
      type:      json['type'] ?? 'system',
      isRead:    json['is_read'] ?? false,
      data:      json['data'],
    );
  }

  // FIX #8 — add missing copyWith
  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id:        id,
      title:     title,
      message:   message,
      timestamp: timestamp,
      type:      type,
      isRead:    isRead ?? this.isRead,
      data:      data,
    );
  }
}

class AnnouncementsProvider extends StateNotifier<List<Announcement>> {
  AnnouncementsProvider() : super([]) {
    try {
      fetchAnnouncements();
    } catch (_) {}
  }

  SupabaseClient get _client => SupabaseService.client;

  Future<void> fetchAnnouncements() async {
    try {
      final uid = SupabaseService.userId;

      final rows = await _client
          .from('announcements')
          .select()
          .order('created_at', ascending: false);

      Set<String> readIds = {};
      if (uid != null) {
        final reads = await _client
            .from('announcement_reads')
            .select('announcement_id')
            .eq('user_id', uid);
        readIds = {for (final r in reads) r['announcement_id'] as String};
      }

      state = (rows as List).map((row) {
        final a = Announcement.fromJson(row as Map<String, dynamic>);
        return a.copyWith(isRead: readIds.contains(a.id));
      }).toList();
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    final uid = SupabaseService.userId;
    if (uid == null) return;

    await _client.from('announcement_reads').upsert({
      'user_id':         uid,
      'announcement_id': id,
    });

    // FIX #1 — use copyWith instead of mutating isRead directly
    state = state.map((a) => a.id == id ? a.copyWith(isRead: true) : a).toList();
  }

  Future<void> markAllAsRead() async {
    final uid = SupabaseService.userId;
    if (uid == null) return;

    final unread = state.where((a) => !a.isRead).toList();
    for (final a in unread) {
      await _client.from('announcement_reads').upsert({
        'user_id':         uid,
        'announcement_id': a.id,
      });
    }

    // FIX #1 — use copyWith instead of mutating
    state = state.map((a) => a.copyWith(isRead: true)).toList();
  }

  void addAnnouncement(Announcement a) => state = [a, ...state];
  void deleteAnnouncement(String id) =>
      state = state.where((a) => a.id != id).toList();
}

class NotificationsProvider extends StateNotifier<List<AppNotification>> {
  NotificationsProvider() : super([]) {
    try {
      fetchNotifications();
    } catch (_) {}
  }

  SupabaseClient get _client => SupabaseService.client;

  Future<void> fetchNotifications() async {
    final uid = SupabaseService.userId;
    if (uid == null) return;

    try {
      final rows = await _client
          .from('notifications')
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false);

      state = (rows as List)
          .map((r) => AppNotification.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id);

    // FIX #1 — use copyWith instead of mutating n.isRead directly
    state = state.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList();
  }

  Future<void> markAllAsRead() async {
    final uid = SupabaseService.userId;
    if (uid == null) return;

    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', uid);

    // FIX #1 — use copyWith instead of mutating
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  void addNotification(AppNotification n) => state = [n, ...state];
  void deleteNotification(String id) =>
      state = state.where((n) => n.id != id).toList();
  int get unreadCount => state.where((n) => !n.isRead).length;
}

final announcementsProvider =
    StateNotifierProvider<AnnouncementsProvider, List<Announcement>>(
  (ref) => AnnouncementsProvider(),
);

final notificationsProvider =
    StateNotifierProvider<NotificationsProvider, List<AppNotification>>(
  (ref) => NotificationsProvider(),
);

final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((n) => !n.isRead).length;
});

final importantAnnouncementsProvider = Provider<List<Announcement>>((ref) {
  return ref.watch(announcementsProvider).where((a) => a.isImportant).toList();
});
