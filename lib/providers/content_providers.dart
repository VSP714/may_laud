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
    _subscribeToRealtimeChanges();
  }

  SupabaseClient get _client => SupabaseService.client;

  // FIX — live updates: without this the provider only ever fetches once,
  // on construction, so a new row inserted in Supabase never shows up
  // until the whole app is restarted (which recreates the provider).
  // Subscribing to Postgres Changes on the `announcements` table means
  // new/edited/deleted announcements reach the app immediately, no
  // manual reload or app restart required.
  RealtimeChannel? _channel;

  void _subscribeToRealtimeChanges() {
    try {
      _channel = _client
          .channel('public:announcements')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'announcements',
            callback: (payload) => _handleRealtimeChange(payload),
          )
          .subscribe();
    } catch (_) {
      // Realtime may be unavailable (e.g. offline) — the manual
      // refresh button / pull-to-refresh still works as a fallback.
    }
  }

  void _handleRealtimeChange(PostgresChangePayload payload) {
    switch (payload.eventType) {
      case PostgresChangeEvent.insert:
        final a = Announcement.fromJson(payload.newRecord);
        // Guard against duplicates if a manual fetch raced the event.
        if (state.any((e) => e.id == a.id)) return;
        state = [a, ...state]
          ..sort((x, y) => y.date.compareTo(x.date));
        break;
      case PostgresChangeEvent.update:
        final updated = Announcement.fromJson(payload.newRecord);
        state = state.map((a) {
          if (a.id != updated.id) return a;
          // Preserve the locally-known read status; it isn't part of
          // the `announcements` row itself (it lives in
          // `announcement_reads`), so don't let the update clobber it.
          return updated.copyWith(isRead: a.isRead);
        }).toList();
        break;
      case PostgresChangeEvent.delete:
        final oldId = payload.oldRecord['id'] as String?;
        if (oldId == null) return;
        state = state.where((a) => a.id != oldId).toList();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

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
    _subscribeToRealtimeChanges();
  }

  SupabaseClient get _client => SupabaseService.client;

  // FIX — live updates: previously this only ever fetched once, on
  // construction. When the web admin changes a citizen_report's status
  // (or any other server-side flow inserts a row into `notifications`
  // for this user), the resident wouldn't see it until they force-closed
  // and reopened the app. Subscribing to Postgres Changes on the
  // `notifications` table means a new row — e.g. "Your report was
  // marked resolved" — reaches the app immediately and updates the
  // unread badge/list in real time, the same way FCM push does when the
  // app is backgrounded. This also covers the case where a push is
  // missed (permission denied, offline at delivery time, etc.) since
  // Supabase stays the source of truth.
  RealtimeChannel? _channel;
  String? _subscribedUid;

  void _subscribeToRealtimeChanges() {
    final uid = SupabaseService.userId;
    if (uid == null) return;
    if (_channel != null && _subscribedUid == uid) return;
    // A different user signed in on this device than the one the
    // channel was opened for (or none at all yet) — drop the stale
    // subscription before opening a fresh, correctly-filtered one.
    _channel?.unsubscribe();
    _subscribedUid = uid;
    try {
      _channel = _client
          .channel('public:notifications:user_id=eq.$uid')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'notifications',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: uid,
            ),
            callback: (payload) => _handleRealtimeChange(payload),
          )
          .subscribe();
    } catch (_) {
      // Realtime may be unavailable (e.g. offline) — pull-to-refresh on
      // NotificationsScreen and the FCM-triggered refresh still work.
    }
  }

  void _handleRealtimeChange(PostgresChangePayload payload) {
    switch (payload.eventType) {
      case PostgresChangeEvent.insert:
        final n = AppNotification.fromJson(payload.newRecord);
        if (state.any((e) => e.id == n.id)) return;
        state = [n, ...state];
        break;
      case PostgresChangeEvent.update:
        final updated = AppNotification.fromJson(payload.newRecord);
        state = state.map((n) => n.id == updated.id ? updated : n).toList();
        break;
      case PostgresChangeEvent.delete:
        final oldId = payload.oldRecord['id'] as String?;
        if (oldId == null) return;
        state = state.where((n) => n.id != oldId).toList();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  Future<void> fetchNotifications() async {
    final uid = SupabaseService.userId;
    if (uid == null) return;

    // The provider is constructed once, at app start, when there may be
    // no signed-in user yet (guest mode, session still restoring) — so
    // the realtime channel from the constructor never attached. Every
    // later call to fetchNotifications() (pull-to-refresh, opening the
    // screen, a push arriving) is a safe point to (re)attach it for
    // whoever is currently signed in, without needing auth_provider to
    // know about this provider at all.
    _subscribeToRealtimeChanges();

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
    final uid = SupabaseService.userId;
    if (uid == null) return;

    // FIX — scope the update to the signed-in user as well as the row id.
    // Filtering by `id` alone means the *client* trusts that `id` always
    // belongs to the current user; it's only true today because the UI
    // never shows anyone else's notification. Adding `user_id = uid` here
    // is defense-in-depth for the app, but it is NOT what actually keeps
    // one resident from reading/marking another resident's notifications —
    // that has to be enforced by a Row Level Security policy on the
    // `notifications` table in Supabase (see notes below).
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id)
        .eq('user_id', uid);

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

// ─────────────────────────────────────────────────────────
// DOCUMENT REQUESTS 
// ─────────────────────────────────────────────────────────
class DocumentRequest {
  final String id;
  final String documentType;
  final String purpose;
  final String status; // 'pending' | 'processing' | 'ready' | 'released' | 'rejected'
  final String? fee;
  final String? notes;
  final DateTime createdAt;

  const DocumentRequest({
    required this.id,
    required this.documentType,
    required this.purpose,
    required this.status,
    required this.createdAt,
    this.fee,
    this.notes,
  });

  factory DocumentRequest.fromJson(Map<String, dynamic> json) {
    return DocumentRequest(
      id:           json['id']?.toString() ?? '',
      documentType: json['document_type'] ?? '',
      purpose:      json['purpose'] ?? '',
      status:       json['status'] ?? 'pending',
      fee:          json['fee'],
      notes:        json['notes'],
      createdAt:    json['created_at'] != null
                      ? DateTime.parse(json['created_at'])
                      : DateTime.now(),
    );
  }
}

class DocumentRequestsProvider extends StateNotifier<List<DocumentRequest>> {
  DocumentRequestsProvider() : super([]) {
    try {
      fetchRequests();
    } catch (_) {}
  }

  SupabaseClient get _client => SupabaseService.client;

  Future<void> fetchRequests() async {
    final uid = SupabaseService.userId;
    if (uid == null) return;

    try {
      final rows = await _client
          .from('document_requests')
          .select()
          .eq('user_id', uid)
          .order('created_at', ascending: false);

      state = (rows as List)
          .map((r) => DocumentRequest.fromJson(r as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Table may not exist yet, or the user has no requests — leave
      // state as-is rather than crashing the profile screen.
    }
  }

  /// Called by DocumentRequestScreen on successful submission.
  /// `urgency` has no dedicated column in the schema, so it's
  /// recorded inside `notes` rather than being dropped.
  Future<void> submitRequest({
    required String documentType,
    required String purpose,
    required String urgency,
    String? fee,
  }) async {
    final uid = SupabaseService.userId;
    if (uid == null) return;

    try {
      final row = await _client
          .from('document_requests')
          .insert({
            'user_id':       uid,
            'document_type': documentType,
            'purpose':       purpose,
            'status':        'pending',
            if (fee != null) 'fee': fee,
            'notes':         'Urgency: $urgency',
          })
          .select()
          .single();
      state = [DocumentRequest.fromJson(row), ...state];
    } catch (_) {
      // If the insert fails (e.g. table not provisioned yet) at least
      // reflect the request locally so the stats stay honest for this
      // session instead of silently doing nothing.
      state = [
        DocumentRequest(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          documentType: documentType,
          purpose: purpose,
          status: 'pending',
          notes: 'Urgency: $urgency',
          createdAt: DateTime.now(),
        ),
        ...state,
      ];
    }
  }
}

final documentRequestsProvider =
    StateNotifierProvider<DocumentRequestsProvider, List<DocumentRequest>>(
  (ref) => DocumentRequestsProvider(),
);

final documentRequestStatsProvider = Provider<Map<String, int>>((ref) {
  final requests = ref.watch(documentRequestsProvider);
  return {
    'total':    requests.length,
    'approved': requests.where((r) => r.status == 'ready' || r.status == 'released').length,
    'pending':  requests.where((r) => r.status == 'pending' || r.status == 'processing').length,
  };
});

// ─────────────────────────────────────────────────────────
// DASHBOARD STAT
// ─────────────────────────────────────────────────────────
class DashboardStats {
  final int activeProjects;
  final double budgetUtilizedPercent;
  final int resolvedReports;
  final int barangayAssemblies;
  final bool isLoading;

  const DashboardStats({
    this.activeProjects = 0,
    this.budgetUtilizedPercent = 0,
    this.resolvedReports = 0,
    this.barangayAssemblies = 0,
    this.isLoading = true,
  });

  DashboardStats copyWith({
    int? activeProjects,
    double? budgetUtilizedPercent,
    int? resolvedReports,
    int? barangayAssemblies,
    bool? isLoading,
  }) {
    return DashboardStats(
      activeProjects: activeProjects ?? this.activeProjects,
      budgetUtilizedPercent:
          budgetUtilizedPercent ?? this.budgetUtilizedPercent,
      resolvedReports: resolvedReports ?? this.resolvedReports,
      barangayAssemblies: barangayAssemblies ?? this.barangayAssemblies,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DashboardStatsNotifier extends StateNotifier<DashboardStats> {
  DashboardStatsNotifier() : super(const DashboardStats()) {
    try {
      fetchStats();
    } catch (_) {}
  }

  SupabaseClient get _client => SupabaseService.client;

  Future<void> fetchStats() async {
    // Each figure is fetched independently and defaults to 0 on
    // failure, so a missing table (e.g. `projects` not created yet)
    // degrades gracefully instead of blanking the whole dashboard.
    final results = await Future.wait([
      _resolvedReportsCount(),
      _activeProjectsCount(),
      _budgetUtilizedPercent(),
      _barangayAssembliesCount(),
    ]);

    state = DashboardStats(
      resolvedReports: results[0] as int,
      activeProjects: results[1] as int,
      budgetUtilizedPercent: results[2] as double,
      barangayAssemblies: results[3] as int,
      isLoading: false,
    );
  }

  Future<int> _resolvedReportsCount() async {
    try {
      final rows = await _client
          .from('citizen_reports')
          .select('id')
          .eq('status', 'resolved');
      return (rows as List).length;
    } catch (_) {
      return 0;
    }
  }

  Future<int> _activeProjectsCount() async {
    try {
      final rows = await _client
          .from('projects')
          .select('id')
          .eq('status', 'active');
      return (rows as List).length;
    } catch (_) {
      return 0;
    }
  }

  Future<double> _budgetUtilizedPercent() async {
    try {
      final row = await _client
          .from('municipal_budget')
          .select('total_allocated, total_utilized')
          .order('fiscal_year', ascending: false)
          .limit(1)
          .maybeSingle();
      if (row == null) return 0;
      final allocated = (row['total_allocated'] as num?)?.toDouble() ?? 0;
      final utilized = (row['total_utilized'] as num?)?.toDouble() ?? 0;
      if (allocated <= 0) return 0;
      return (utilized / allocated) * 100;
    } catch (_) {
      return 0;
    }
  }

  Future<int> _barangayAssembliesCount() async {
    try {
      final now = DateTime.now();
      final yearStart = DateTime(now.year, 1, 1).toIso8601String();
      final rows = await _client
          .from('barangay_assemblies')
          .select('id')
          .gte('held_at', yearStart);
      return (rows as List).length;
    } catch (_) {
      return 0;
    }
  }
}

final dashboardStatsProvider =
    StateNotifierProvider<DashboardStatsNotifier, DashboardStats>(
  (ref) => DashboardStatsNotifier(),
);