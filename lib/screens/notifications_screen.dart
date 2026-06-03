import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:may_laud/theme/app_colors.dart';

// _kPurple / _kPurple2 removed — use AppColors.heritagePurple / AppColors.riverFlow

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(id:'1', title:'Water Interruption Notice', message:'Water supply will be interrupted tomorrow from 8 AM to 4 PM for maintenance.', timestamp:DateTime.now().subtract(const Duration(hours:2)), type:'alert', isRead:false),
    NotificationItem(id:'2', title:'Document Request Approved', message:'Your Barangay Clearance request has been approved. You can now claim it at the barangay hall.', timestamp:DateTime.now().subtract(const Duration(days:1)), type:'update', isRead:true),
    NotificationItem(id:'3', title:'Community Town Hall', message:'Join the community town hall meeting this Saturday at 3 PM at the barangay hall.', timestamp:DateTime.now().subtract(const Duration(days:2)), type:'event', isRead:true),
    NotificationItem(id:'4', title:'Flood Alert Update', message:'Bicol River water level is rising. Residents near the river are advised to prepare.', timestamp:DateTime.now().subtract(const Duration(days:3)), type:'alert', isRead:false),
    NotificationItem(id:'5', title:'Tax Payment Reminder', message:'Last day for real property tax payment is on December 15, 2024.', timestamp:DateTime.now().subtract(const Duration(days:4)), type:'reminder', isRead:true),
    NotificationItem(id:'6', title:'Vaccination Schedule', message:'Free flu vaccination for seniors will be available next week at the health center.', timestamp:DateTime.now().subtract(const Duration(days:5)), type:'health', isRead:true),
  ];

  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final filtered = _notifications.where((n) {
      if (_filter == 'unread') return !n.isRead;
      if (_filter == 'alerts') return n.type == 'alert';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colors.surface,
        elevation: 0,
        title: Text('Notifications', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: colors.textPrimary)),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => setState(() => _filter = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'all',    child: Text('All Notifications')),
              PopupMenuItem(value: 'unread', child: Text('Unread Only')),
              PopupMenuItem(value: 'alerts', child: Text('Alerts Only')),
            ],
            icon: Icon(Icons.filter_list, size: 28.sp, color: AppColors.heritagePurple),
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          color: colors.surface,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${_notifications.where((n) => !n.isRead).length} Unread',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.heritagePurple)),
            TextButton(
              onPressed: () => setState(() { for (var n in _notifications) n.isRead = true; }),
              child: Text('Mark All as Read', style: TextStyle(fontSize: 14.sp, color: AppColors.riverFlow, fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: filtered.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.notifications_none, size: 64.sp, color: colors.iconMuted),
                  SizedBox(height: 16.h),
                  Text('No notifications', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: colors.textSecondary)),
                  SizedBox(height: 8.h),
                  Text(_filter == 'unread' ? 'You have no unread notifications' : _filter == 'alerts' ? 'No alert notifications' : 'All notifications are cleared',
                      style: TextStyle(fontSize: 14.sp, color: colors.textMuted)),
                ]))
              : ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: colors.divider),
                  itemBuilder: (_, i) => _buildItem(filtered[i], colors),
                ),
        ),
      ]),
    );
  }

  Widget _buildItem(NotificationItem n, AppColorScheme colors) {
    final (icon, iconColor) = switch (n.type) {
      'alert'    => (Icons.warning,          AppColors.error),
      'event'    => (Icons.event,            AppColors.infoAlt),
      'health'   => (Icons.medical_services, AppColors.success),
      'reminder' => (Icons.notifications,    AppColors.warning),
      _          => (Icons.info,             AppColors.heritagePurple),
    };

    return InkWell(
      onTap: () { setState(() => n.isRead = true); _showDetails(n); },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        color: n.isRead ? colors.surface : AppColors.heritagePurple.withValues(alpha: .06),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 44.w, height: 44.w,
            decoration: BoxDecoration(color: iconColor.withOpacity(.1), shape: BoxShape.circle),
            child: Icon(icon, size: 22.sp, color: iconColor),
          ),
          SizedBox(width: 16.w),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text(n.title,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: colors.textPrimary),
                  maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (!n.isRead)
                Container(width: 10.w, height: 10.w, decoration: const BoxDecoration(color: AppColors.heritagePurple, shape: BoxShape.circle)),
            ]),
            SizedBox(height: 4.h),
            Text(n.message, style: TextStyle(fontSize: 14.sp, color: colors.textSecondary, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
            SizedBox(height: 8.h),
            Text(_timeAgo(n.timestamp), style: TextStyle(fontSize: 12.sp, color: colors.textMuted)),
          ])),
        ]),
      ),
    );
  }

  String _timeAgo(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'Just now';
    if (d.inHours < 1)   return '${d.inMinutes}m ago';
    if (d.inDays < 1)    return '${d.inHours}h ago';
    if (d.inDays < 7)    return '${d.inDays}d ago';
    return '${t.day}/${t.month}/${t.year}';
  }

  void _showDetails(NotificationItem n) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(n.title),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(n.message, style: const TextStyle(fontSize: 16)),
        SizedBox(height: 16.h),
        Text('Received: ${_timeAgo(n.timestamp)}', style: TextStyle(fontSize: 14.sp, color: AppColors.neutralGray500)),
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
    ));
  }
}

class NotificationItem {
  final String id, title, message, type; final DateTime timestamp; bool isRead;
  NotificationItem({required this.id, required this.title, required this.message, required this.timestamp, required this.type, required this.isRead});
}