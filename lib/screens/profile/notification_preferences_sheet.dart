import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/app_providers.dart';
import '../home/home.dart';

class NotificationPreferencesSheet extends ConsumerWidget {
  const NotificationPreferencesSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _cs = _theme.colorScheme;
    final _titleColor = _isDark ? _cs.onSurface : HomeColors.deepAnchor;
    final _accentColor = _isDark ? _cs.primary : HomeColors.heritagePurple;
        return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(),
          SizedBox(height: 20.h),
          Text(
            'Notification Preferences',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: _titleColor,
            ),
          ),
          SizedBox(height: 20.h),

          // Master toggle
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Icon(
              Icons.notifications_outlined,
              color: _accentColor,
            ),
            title: Text(
              'All Notifications',
              style:
                  TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              settings.notificationsEnabled ? 'On' : 'Off',
              style: TextStyle(fontSize: 13.sp),
            ),
            value: settings.notificationsEnabled,
            activeColor: _accentColor,
            onChanged: (_) =>
                ref.read(appSettingsProvider.notifier).toggleNotifications(),
          ),

          Divider(height: 8.h),

          // Per-category rows (local state only — extend with Supabase prefs later)
          _NotifSubTile(
            title: 'Flood Alerts',
            icon: Icons.water_outlined,
            subtitle: 'Critical disaster warnings',
            defaultVal: true,
          ),
          _NotifSubTile(
            title: 'Announcements',
            icon: Icons.campaign_outlined,
            subtitle: 'Barangay news and updates',
            defaultVal: true,
          ),
          _NotifSubTile(
            title: 'Document Updates',
            icon: Icons.description_outlined,
            subtitle: 'Request status changes',
            defaultVal: true,
          ),
          _NotifSubTile(
            title: 'General',
            icon: Icons.info_outline,
            subtitle: 'App updates and reminders',
            defaultVal: false,
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

/// Individual sub-toggle row with its own local state
class _NotifSubTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final bool defaultVal;

  const _NotifSubTile({
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.defaultVal,
  });

  @override
  State<_NotifSubTile> createState() => _NotifSubTileState();
}

class _NotifSubTileState extends State<_NotifSubTile> {
  late bool _val;

  @override
  void initState() {
    super.initState();
    _val = widget.defaultVal;
  }

  @override
  Widget build(BuildContext context) {
    final _accentColor = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).colorScheme.primary
        : HomeColors.heritagePurple;

    return SwitchListTile(
      contentPadding: EdgeInsets.only(left: 8.w),
      secondary: Icon(widget.icon,
          size: 20.sp, color: const Color(0xFF9E9E9E)),
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
      subtitle:
          Text(widget.subtitle, style: TextStyle(fontSize: 12.sp)),
      value: _val,
      activeColor: _accentColor,
      onChanged: (v) => setState(() => _val = v),
    );
  }
}

/// Helper to show this sheet from anywhere
Future<void> showNotificationPreferencesSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (_) => const NotificationPreferencesSheet(),
  );
}