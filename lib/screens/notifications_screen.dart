
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Water Interruption Notice',
      message:
          'Water supply will be interrupted tomorrow from 8 AM to 4 PM for maintenance.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'alert',
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Document Request Approved',
      message:
          'Your Barangay Clearance request has been approved. You can now claim it at the barangay hall.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: 'update',
      isRead: true,
    ),
    NotificationItem(
      id: '3',
      title: 'Community Town Hall',
      message:
          'Join the community town hall meeting this Saturday at 3 PM at the barangay hall.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: 'event',
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Flood Alert Update',
      message:
          'Bicol River water level is rising. Residents near the river are advised to prepare.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      type: 'alert',
      isRead: false,
    ),
    NotificationItem(
      id: '5',
      title: 'Tax Payment Reminder',
      message:
          'Last day for real property tax payment is on December 15, 2024.',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      type: 'reminder',
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      title: 'Vaccination Schedule',
      message:
          'Free flu vaccination for seniors will be available next week at the health center.',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      type: 'health',
      isRead: true,
    ),
  ];

  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    final scaffoldBg = isDark ? cs.background : const Color(0xFFFEF7FF);
    final appBarBg = isDark ? cs.surface : Colors.white;
    final statsBg = isDark ? cs.surface : Colors.white;
    final accentPurple = isDark ? cs.primary : const Color(0xFF4C229C);
    final accentPurple2 = isDark ? cs.primary : const Color(0xFF643EB5);

    final filteredNotifications = _notifications.where((notification) {
      if (_filter == 'unread') return !notification.isRead;
      if (_filter == 'alerts') return notification.type == 'alert';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: accentPurple,
          ),
        ),
        backgroundColor: appBarBg,
        elevation: 0,
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _filter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Notifications'),
              ),
              const PopupMenuItem(
                value: 'unread',
                child: Text('Unread Only'),
              ),
              const PopupMenuItem(
                value: 'alerts',
                child: Text('Alerts Only'),
              ),
            ],
            icon: Icon(
              Icons.filter_list,
              size: 28.sp,
              color: accentPurple,
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            color: statsBg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_notifications.where((n) => !n.isRead).length} Unread',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: accentPurple,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      for (var notification in _notifications) {
                        notification.isRead = true;
                      }
                    });
                  },
                  child: Text(
                    'Mark All as Read',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: accentPurple2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: filteredNotifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 64.sp,
                          color: cs.onSurface.withOpacity(0.4),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No notifications',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _filter == 'unread'
                              ? 'You have no unread notifications'
                              : _filter == 'alerts'
                                  ? 'No alert notifications'
                                  : 'All notifications are cleared',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: cs.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: isDark
                          ? cs.onSurface.withOpacity(0.1)
                          : Colors.grey[200],
                    ),
                    itemBuilder: (context, index) {
                      final notification = filteredNotifications[index];
                      return _buildNotificationItem(notification, isDark, cs);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
      NotificationItem notification, bool isDark, ColorScheme cs) {
    IconData icon;
    Color iconColor;

    switch (notification.type) {
      case 'alert':
        icon = Icons.warning;
        iconColor = const Color(0xFFF44336);
        break;
      case 'event':
        icon = Icons.event;
        iconColor = const Color(0xFF2196F3);
        break;
      case 'health':
        icon = Icons.medical_services;
        iconColor = const Color(0xFF4CAF50);
        break;
      case 'reminder':
        icon = Icons.notifications;
        iconColor = const Color(0xFFFF9800);
        break;
      default:
        icon = Icons.info;
        iconColor = isDark ? cs.primary : const Color(0xFF4C229C);
    }

    final timeAgo = _getTimeAgo(notification.timestamp);

    // Dark mode: use surface/surface variant instead of white/light purple
    final readBg = isDark ? cs.surface : Colors.white;
    final unreadBg = isDark ? cs.surface.withOpacity(0.7) : const Color(0xFFF5F0F8);
    final unreadBgDark = isDark ? cs.primary.withOpacity(0.08) : const Color(0xFFF5F0F8);
    final titleColor = isDark ? cs.onSurface : const Color(0xFF333333);
    final bodyColor = isDark ? cs.onSurface.withOpacity(0.65) : const Color(0xFF666666);
    final timeColor = isDark ? cs.onSurface.withOpacity(0.45) : const Color(0xFF999999);
    final dotColor = isDark ? cs.primary : const Color(0xFF4C229C);

    return InkWell(
      onTap: () {
        setState(() {
          notification.isRead = true;
        });
        _showNotificationDetails(notification);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        color: notification.isRead ? readBg : unreadBgDark,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22.sp,
                color: iconColor,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: bodyColor,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: timeColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
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
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _showNotificationDetails(NotificationItem notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.h),
            Text(
              'Received: ${_getTimeAgo(notification.timestamp)}',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });
}