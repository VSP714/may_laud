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
              color: HomeColors.heritagePurple.withOpacity(.35),
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

  // ─── HOME-STYLE BOTTOM NAV (with notch for FAB) ───────
  Widget _buildBottomNav() {
    return Container(
      height: 110.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, 'Home', 0),
              _navItem(Icons.campaign_outlined, 'Announcements', 1),
              SizedBox(width: 40.w), // gap for FAB
              _navItem(Icons.notifications_outlined, 'Notifications', 2),
              _navItem(Icons.person_outline_rounded, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  // ─── NAV ITEM (icon + label) ──────────────────────────
  Widget _navItem(IconData icon, String label, int index) {
    final bool active = _selectedIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () => _onItemTapped(index),
      splashColor: HomeColors.heritagePurple.withOpacity(0.08),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: active
              ? HomeColors.heritagePurple.withOpacity(0.08)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.all(active ? 6.w : 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? HomeColors.heritagePurple.withOpacity(0.12)
                    : Colors.transparent,
              ),
              child: Icon(
                icon,
                size: active ? 26.sp : 24.sp,
                color: active
                    ? HomeColors.heritagePurple
                    : const Color(0xFF9E9E9E),
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: active ? 12.sp : 11.sp,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: active
                    ? HomeColors.heritagePurple
                    : const Color(0xFF9E9E9E),
              ),
              child: Text(label),
            ),
          ],
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
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(34.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            SizedBox(height: 28.h),
            Text(
              'Quick Services',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: HomeColors.deepAnchor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Choose from the following services:',
              style: TextStyle(fontSize: 15.sp, color: Colors.grey),
            ),
            SizedBox(height: 28.h),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 18.h,
              crossAxisSpacing: 18.w,
              childAspectRatio: 1.15,
              children: _services.map((s) => _serviceTile(context, s)).toList(),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _serviceTile(BuildContext context, _QuickService service) {
    return InkWell(
      borderRadius: BorderRadius.circular(28.r),
      onTap: () => _openService(context, service),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: LinearGradient(
            colors: [
              HomeColors.riverFlow.withOpacity(.12),
              HomeColors.heritagePurple.withOpacity(.08),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70.w,
              height: 70.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: HomeColors.heritagePurple,
              ),
              child: Icon(service.icon, color: Colors.white, size: 34.sp),
            ),
            SizedBox(height: 18.h),
            Text(
              service.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: HomeColors.deepAnchor,
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
