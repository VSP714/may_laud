import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:may_laud/providers/content_providers.dart';
import 'package:may_laud/services/supabase_service.dart';

class AnnouncementService {
  final Ref ref;
  AnnouncementService(this.ref);

  Future<List<Announcement>> fetchAnnouncements() async {
    await ref.read(announcementsProvider.notifier).fetchAnnouncements();
    return ref.read(announcementsProvider);
  }

  Future<void> markAsRead(String id) async =>
      ref.read(announcementsProvider.notifier).markAsRead(id);

  Future<void> markAllAsRead() async =>
      ref.read(announcementsProvider.notifier).markAllAsRead();

  Future<void> submitAnnouncement({
    required String title,
    required String description,
    required String category,
    String? imageUrl,
    bool isImportant = false,
  }) async {
    await SupabaseService.client.from('announcements').insert({
      'title':        title,
      'description':  description,
      'category':     category,
      'image_url':    imageUrl,
      'is_important': isImportant,
    });
    await fetchAnnouncements();
  }
}

class NotificationService {
  final Ref ref;
  NotificationService(this.ref);

  Future<List<AppNotification>> fetchNotifications() async {
    await ref.read(notificationsProvider.notifier).fetchNotifications();
    return ref.read(notificationsProvider);
  }

  Future<void> markAsRead(String id) async =>
      ref.read(notificationsProvider.notifier).markAsRead(id);

  Future<void> markAllAsRead() async =>
      ref.read(notificationsProvider.notifier).markAllAsRead();

  Future<void> sendNotification({
    required String title,
    required String message,
    required String type,
    String? targetUserId,
  }) async {
    final uid = targetUserId ?? SupabaseService.userId;
    if (uid == null) return;

    await SupabaseService.client.from('notifications').insert({
      'user_id': uid,
      'title':   title,
      'message': message,
      'type':    type,
    });
    await fetchNotifications();
  }
}

class HotlineService {
  Future<List<Map<String, dynamic>>> fetchHotlines() async {
    final rows = await SupabaseService.client
        .from('hotlines')
        .select()
        .eq('is_active', true)
        .order('name');
    return List<Map<String, dynamic>>.from(rows as List);
  }
}

class DocumentService {
  Future<List<Map<String, dynamic>>> fetchDocumentTypes() async {
    return [
      {
        'id': '1', 'name': 'Barangay Clearance',
        'description': 'Certificate of residency and good moral character',
        'processingTime': '1-2 days', 'fee': '₱50.00',
        'requirements': ['Valid ID', 'Proof of residency'],
      },
      {
        'id': '2', 'name': 'Business Permit',
        'description': 'License to operate a business in Milaor',
        'processingTime': '3-5 days', 'fee': '₱500.00 - ₱5,000.00',
        'requirements': ['DTI/SEC registration', 'Proof of business address'],
      },
      {
        'id': '3', 'name': 'Certificate of Indigency',
        'description': 'Proof of low-income status',
        'processingTime': '1 day', 'fee': '₱20.00',
        'requirements': ['Valid ID', 'Proof of income'],
      },
      {
        'id': '4', 'name': 'Police Clearance',
        'description': 'Certificate of no criminal record',
        'processingTime': '2-3 days', 'fee': '₱100.00',
        'requirements': ['Valid ID', '2x2 photo', 'Barangay clearance'],
      },
      {
        'id': '5', 'name': 'Building Permit',
        'description': 'Authorization for construction projects',
        'processingTime': '7-14 days', 'fee': 'Based on project cost',
        'requirements': ['Land title', 'Building plans'],
      },
    ];
  }

  Future<Map<String, dynamic>> submitDocumentRequest({
    required String documentTypeId,
    required String purpose,
    required Map<String, dynamic> userInfo,
    List<String>? attachments,
  }) async {
    final uid = SupabaseService.userId;
    if (uid == null) throw Exception('Not logged in');

    final types = await fetchDocumentTypes();
    final docType = types.firstWhere(
      (t) => t['id'] == documentTypeId,
      orElse: () => {'name': 'Document', 'fee': '—'},
    );

    final row = await SupabaseService.client
        .from('document_requests')
        .insert({
          'user_id':       uid,
          'document_type': docType['name'],
          'purpose':       purpose,
          'fee':           docType['fee'],
        })
        .select()
        .single();

    return {
      'requestId':    row['id'],
      'status':       row['status'],
      'submittedAt':  row['created_at'],
      'documentType': row['document_type'],
      'message':      'Your request has been submitted. You will be notified when it\'s ready.',
    };
  }

  Future<Map<String, dynamic>> checkRequestStatus(String requestId) async {
    final row = await SupabaseService.client
        .from('document_requests')
        .select()
        .eq('id', requestId)
        .single();

    return {
      'requestId':   row['id'],
      'status':      row['status'],
      'lastUpdated': row['created_at'],
      'message':     _statusMessage(row['status'] as String),
    };
  }

  String _statusMessage(String status) {
    const map = {
      'pending':    'Your request is awaiting review.',
      'processing': 'Your document is being processed.',
      'ready':      'Your document is ready for pickup.',
      'completed':  'Document has been picked up.',
      'rejected':   'Request was rejected. Please resubmit.',
    };
    return map[status] ?? 'Status unknown.';
  }
}

class FloodAlertService {
  Future<Map<String, dynamic>> getCurrentAlert() async {
    final rows = await SupabaseService.client
        .from('flood_alerts')
        .select()
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .limit(1);

    if ((rows as List).isEmpty) {
      return {
        'level': 'Low', 'affectedAreas': <String>[],
        'waterLevel': '—', 'advice': 'No active alerts.',
        'isActive': false,
      };
    }

    final row = rows.first as Map<String, dynamic>;
    return {
      'level':         row['level'],
      'affectedAreas': List<String>.from(row['affected_areas'] ?? []),
      'waterLevel':    row['water_level'] ?? '—',
      'advice':        row['advice'] ?? '',
      'isActive':      row['is_active'],
      'updateTime':    row['created_at'],
    };
  }
}

class CitizenReportService {
  Future<List<Map<String, dynamic>>> fetchReportCategories() async {
    return [
      {'id': '1', 'name': 'Infrastructure', 'icon': '🚧',
       'subcategories': ['Road Damage', 'Bridge Issues', 'Street Light', 'Drainage Problems']},
      {'id': '2', 'name': 'Sanitation', 'icon': '🗑️',
       'subcategories': ['Garbage Collection', 'Illegal Dumping', 'Public Toilets']},
      {'id': '3', 'name': 'Public Safety', 'icon': '👮',
       'subcategories': ['Criminal Activity', 'Traffic Violations', 'Fire Hazards']},
      {'id': '4', 'name': 'Environment', 'icon': '🌳',
       'subcategories': ['Tree Maintenance', 'Flooding', 'Pollution']},
      {'id': '5', 'name': 'Utilities', 'icon': '⚡',
       'subcategories': ['Water Supply', 'Power Outage', 'Internet Issues']},
      {'id': '6', 'name': 'Others', 'icon': '📋',
       'subcategories': ['General Complaint', 'Suggestion', 'Other Concerns']},
    ];
  }

  Future<Map<String, dynamic>> submitReport({
    required String categoryId,
    required String subcategory,
    required String description,
    required String location,
    List<File>? photoFiles,
    String? contactInfo,
  }) async {
    final uid = SupabaseService.userId;
    if (uid == null) throw Exception('Not logged in');

    final photoUrls = <String>[];
    if (photoFiles != null) {
      for (int i = 0; i < photoFiles.length; i++) {
        final path = '$uid/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        await SupabaseService.client.storage
            .from('report-photos')
            .upload(path, photoFiles[i]);
        final url = SupabaseService.client.storage
            .from('report-photos')
            .getPublicUrl(path);
        photoUrls.add(url);
      }
    }

    final categories = await fetchReportCategories();
    final cat = categories.firstWhere(
      (c) => c['id'] == categoryId,
      orElse: () => {'name': 'Other'},
    );

    final row = await SupabaseService.client
        .from('citizen_reports')
        .insert({
          'user_id':     uid,
          'category':    cat['name'],
          'subcategory': subcategory,
          'description': description,
          'location':    location,
          'photo_urls':  photoUrls,
          'contact':     contactInfo,
        })
        .select()
        .single();

    return {
      'reportId':            row['id'],
      'status':              'received',
      'submittedAt':         row['created_at'],
      'estimatedResolution': '3-5 business days',
      'message':             'Thank you! Your report has been received.',
    };
  }

  Future<Map<String, dynamic>> checkReportStatus(String reportId) async {
    final row = await SupabaseService.client
        .from('citizen_reports')
        .select()
        .eq('id', reportId)
        .single();

    return {
      'reportId':    row['id'],
      'status':      row['status'],
      'lastUpdated': row['updated_at'],
      'message':     _statusMessage(row['status'] as String),
    };
  }

  String _statusMessage(String status) {
    const map = {
      'received':    'Report received, awaiting assignment.',
      'assigned':    'Assigned to a department for action.',
      'in_progress': 'Department is currently working on this.',
      'resolved':    'The issue has been resolved.',
      'closed':      'Report closed after resolution.',
    };
    return map[status] ?? 'Status unknown.';
  }
}

final announcementServiceProvider = Provider((ref) => AnnouncementService(ref));
final notificationServiceProvider  = Provider((ref) => NotificationService(ref));
final hotlineServiceProvider       = Provider((_)   => HotlineService());
final documentServiceProvider      = Provider((_)   => DocumentService());
final floodAlertServiceProvider    = Provider((_)   => FloodAlertService());
final citizenReportServiceProvider = Provider((_)   => CitizenReportService());