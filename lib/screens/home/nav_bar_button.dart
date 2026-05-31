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

  late final List<Widget> _screens = [
    const HomeScreen(),
    const AnnouncementsListScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

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

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  void _openService(BuildContext context, _QuickService service) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => service.screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final scaffoldBg = isDark ? cs.background : HomeColors.warmHearth;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
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
      bottomNavigationBar: _buildBottomNav(isDark: isDark, cs: cs),
    );
  }

  Widget _buildBottomNav({required bool isDark, required ColorScheme cs}) {
    final navBg = isDark ? cs.surface : Colors.white;
    final shadowColor = isDark
        ? HomeColors.heritagePurple.withOpacity(0.12)
        : HomeColors.heritagePurple.withValues(alpha: 0.06);

    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        color: navBg,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
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
              _navItem(Icons.home_rounded, 'Home', 0, isDark: isDark, cs: cs),
              _navItem(Icons.campaign_outlined, 'Announcements', 1,
                  isDark: isDark, cs: cs),
              SizedBox(width: 44.w),
              _navItem(Icons.notifications_outlined, 'Notifications', 2,
                  isDark: isDark, cs: cs),
              _navItem(Icons.person_outline_rounded, 'Profile', 3,
                  isDark: isDark, cs: cs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index,
      {required bool isDark, required ColorScheme cs}) {
    final bool active = _selectedIndex == index;
    final inactiveColor =
        isDark ? cs.onSurface.withOpacity(0.35) : const Color(0xFFBDBDBD);

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => _onItemTapped(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                color: active ? HomeColors.heritagePurple : inactiveColor,
              ),
              SizedBox(height: 2.h),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight:
                      active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? HomeColors.heritagePurple : inactiveColor,
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

  void _showQuickServices(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final sheetBg = isDark ? cs.surface : Colors.white;
    final tileBg = isDark ? cs.background : HomeColors.warmHearth;
    final titleColor = isDark ? cs.onSurface : HomeColors.deepAnchor;
    final subtitleColor =
        isDark ? cs.onSurface.withOpacity(0.5) : HomeColors.textMuted;
    final iconBg = isDark
        ? HomeColors.heritagePurple.withOpacity(0.18)
        : HomeColors.heritagePurple.withValues(alpha: 0.08);
    final tileIconBg = isDark ? cs.background : Colors.white;
    final dragHandle =
        isDark ? Colors.white24 : Colors.grey.shade300;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 36.h),
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: dragHandle,
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
                    color: iconBg,
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
                        color: titleColor,
                      ),
                    ),
                    Text(
                      'Choose a service below',
                      style: TextStyle(
                          fontSize: 13.sp, color: subtitleColor),
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
              children: _services
                  .map((s) => _serviceTile(context, s,
                      tileBg: tileBg,
                      tileIconBg: tileIconBg,
                      titleColor: titleColor,
                      subtitleColor: subtitleColor))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceTile(
    BuildContext context,
    _QuickService service, {
    required Color tileBg,
    required Color tileIconBg,
    required Color titleColor,
    required Color subtitleColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () => _openService(context, service),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: tileBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: HomeColors.heritagePurple.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: tileIconBg,
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
                color: titleColor,
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
                color: subtitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickService {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget screen;

  const _QuickService(this.icon, this.title, this.subtitle, this.screen);
}