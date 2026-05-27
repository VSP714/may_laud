import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home.dart';
import '../app_features/announcement/announcements_list_screen.dart';
import '../app_features/report/citizen_report_screen.dart';
import '../app_features/flood_alert/flood_alert_screen.dart';
import '../app_features/emergency/hotlines_screen.dart';
import '../app_features/document/document_request_screen.dart';
import '../notifications_screen.dart';
import '../profile_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  // ─── SCREENS ──────────────────────────────────────────
  late final List<Widget> _screens = [
    const HomeScreen(),
    const AnnouncementsListScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  // ─── QUICK-SERVICE DEFINITIONS ────────────────────────
  static final List<_QuickService> _services = [
    _QuickService(Icons.report_problem_rounded, 'Citizen Report',
        'Report issues or concerns', CitizenReportScreen()),
    _QuickService(Icons.warning_rounded, 'Flood Alert',
        'Disaster alerts & updates', FloodAlertScreen()),
    _QuickService(Icons.phone_rounded, 'Milaor Hotlines', 'Emergency contacts',
        HotlinesScreen()),
    _QuickService(Icons.description_rounded, 'Document Request',
        'Barangay clearance, permits', DocumentRequestScreen()),
  ];

  // ─── HANDLERS ─────────────────────────────────────────
  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  void _openService(BuildContext context, _QuickService service) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => service.screen),
    );
  }

  // ──────────────────────────────────────────────────────
  // BUILD
  // ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.warmHearth,

      // ─── BODY ─────────────────────────────────────
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // ─── FAB ──────────────────────────────────────
      floatingActionButton: Container(
        width: 72.w,
        height: 72.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: HomeColors.fabGradient,
          boxShadow: [
            BoxShadow(
              color: HomeColors.heritagePurple.withValues(alpha: .35),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () => _showQuickServices(context),
          child: Icon(Icons.miscellaneous_services,
              color: Colors.white, size: 34.sp),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ─── BOTTOM NAV ───────────────────────────────
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── PROFESSIONAL BOTTOM NAV (notch for FAB) ──────────
  Widget _buildBottomNav() {
    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: HomeColors.heritagePurple.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, 'Home', 0),
              _navItem(Icons.campaign_outlined, 'Announcements', 1),
              SizedBox(width: 44.w), // gap for FAB
              _navItem(Icons.notifications_outlined, 'Notifications', 2),
              _navItem(Icons.person_outline_rounded, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  // ─── PROFESSIONAL NAV ITEM ─────────────────────────────
  Widget _navItem(IconData icon, String label, int index) {
    final bool active = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => _onItemTapped(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          // FIX overflow: removed vertical padding
          // FIX overflow: removed top margin
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Active indicator pill
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: EdgeInsets.only(bottom: active ? 2.h : 0),
                width: active ? 32.w : 0,
                height: 3.h,
                decoration: BoxDecoration(
                  color: HomeColors.heritagePurple,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              Icon(
                icon,
                size: active ? 23.sp : 21.sp,
                color: active
                    ? HomeColors.heritagePurple
                    : const Color(0xFFBDBDBD),
              ),
              SizedBox(height: 2.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active
                      ? HomeColors.heritagePurple
                      : const Color(0xFFBDBDBD),
                  letterSpacing: active ? 0.2 : 0,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── QUICK SERVICES BOTTOM SHEET ──────────────────────
  void _showQuickServices(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 36.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: HomeColors.heritagePurple.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.miscellaneous_services_rounded,
                      size: 22.sp, color: HomeColors.heritagePurple),
                ),
                SizedBox(width: 14.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Public Services',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: HomeColors.deepAnchor,
                      ),
                    ),
                    Text(
                      'Choose a service below',
                      style: TextStyle(
                          fontSize: 13.sp, color: HomeColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14.h,
              crossAxisSpacing: 14.w,
              childAspectRatio: 1.05,
              children: _services.map((s) => _serviceTile(context, s)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceTile(BuildContext context, _QuickService service) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () => _openService(context, service),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: HomeColors.warmHearth,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: HomeColors.heritagePurple.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: HomeColors.heritagePurple.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(service.icon,
                  size: 28.sp, color: HomeColors.heritagePurple),
            ),
            SizedBox(height: 12.h),
            Text(
              service.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: HomeColors.deepAnchor,
                height: 1.2,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              service.subtitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                height: 1.2,
                color: HomeColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lightweight model for a quick-service entry.
class _QuickService {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget screen;

  const _QuickService(this.icon, this.title, this.subtitle, this.screen);
}
