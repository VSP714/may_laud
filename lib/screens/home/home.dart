import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_features/flood_alert/flood_alert_screen.dart';

// ===== BRAND PALETTE (shared across home screens) =====
class HomeColors {
  static const Color heritagePurple = Color(0xFF4C229C);
  static const Color riverFlow = Color(0xFF643EB5);
  static const Color deepAnchor = Color(0xFF24005B);
  static const Color warmHearth = Color(0xFFF8F5FF);
  static const Color cardWhite = Colors.white;

  static const LinearGradient fabGradient = LinearGradient(
    colors: [riverFlow, heritagePurple],
  );

  static const LinearGradient avatarGradient = LinearGradient(
    colors: [riverFlow, heritagePurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Pure content widget — no Scaffold, no bottom nav, no FAB.
/// Those live in [MainApp] to avoid duplication.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 22.w,
        right: 22.w,
        top: 18.h,
        bottom: 130.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 28.h),
          _buildWelcomeCard(),
          SizedBox(height: 28.h),
          _buildFloodCard(context),
          SizedBox(height: 34.h),
          _buildAnnouncementSection(context),
          SizedBox(height: 24.h),
          _buildAnnouncementList(),
        ],
      ),
    );
  }

  // ─── HEADER ───────────────────────────────────────────
  static Widget _buildHeader() {
    return Row(
      children: [
        // Avatar
        Container(
          width: 64.w,
          height: 64.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: HomeColors.avatarGradient,
            boxShadow: [
              BoxShadow(
                color: Color(0x4D4C229C),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.person, color: Colors.white, size: 32.sp),
          ),
        ),
        SizedBox(width: 16.w),
        // Name / Location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Juan Dela Cruz',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: HomeColors.deepAnchor,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 14.sp, color: HomeColors.riverFlow),
                  SizedBox(width: 4.w),
                  Text(
                    'Milaor, Camarines Sur',
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Notification bell
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: HomeColors.warmHearth,
            border: Border.all(
              color: HomeColors.riverFlow.withOpacity(0.1),
            ),
          ),
          child: Center(
            child: Icon(Icons.notifications_none,
                size: 22.sp, color: HomeColors.heritagePurple),
          ),
        ),
      ],
    );
  }

  // ─── WELCOME CARD ─────────────────────────────────────
  static Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HomeColors.heritagePurple,
            HomeColors.deepAnchor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: HomeColors.heritagePurple.withOpacity(.18),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),
          Text(
            'WELCOME BACK',
            style: TextStyle(
              color: Colors.white70,
              letterSpacing: 4,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Magandang araw,\nJuan!',
            style: TextStyle(
              color: Colors.white,
              height: 1.1,
              fontWeight: FontWeight.w300,
              fontSize: 42.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Your gateway to efficient local government\nservices and community updates in Milaor.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 17.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ─── FLOOD CARD ───────────────────────────────────────
  static Widget _buildFloodCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32.r),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FloodAlertScreen()),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: HomeColors.cardWhite,
          borderRadius: BorderRadius.circular(32.r),
          border: Border.all(color: HomeColors.riverFlow.withOpacity(.10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Row(
                children: [
                  Container(
                    width: 58.w,
                    height: 58.w,
                    decoration: BoxDecoration(
                      color: HomeColors.riverFlow.withOpacity(.08),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Icon(Icons.waves_rounded,
                        color: HomeColors.heritagePurple, size: 30.sp),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bicol River\nMonitoring',
                          style: TextStyle(
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w700,
                            color: HomeColors.deepAnchor,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Updated 14 mins ago',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: HomeColors.riverFlow.withOpacity(.10),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'NORMAL\nSTATUS',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: HomeColors.heritagePurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: HomeColors.riverFlow.withOpacity(.08)),
            Padding(
              padding: EdgeInsets.all(28.w),
              child: Column(
                children: [
                  Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HomeColors.riverFlow.withOpacity(.08),
                    ),
                    child: Icon(Icons.check_circle,
                        color: HomeColors.heritagePurple, size: 64.sp),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'No Immediate Threat',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w700,
                      color: HomeColors.deepAnchor,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Water levels are currently within safe\nlimits. All evacuation routes remain open.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17.sp, height: 1.6, color: Colors.grey),
                  ),
                  SizedBox(height: 22.h),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View Flood Map →',
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w700,
                        color: HomeColors.heritagePurple,
                      ),
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

  // ─── ANNOUNCEMENT HEADER ──────────────────────────────
  Widget _buildAnnouncementSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Announcements',
          style: TextStyle(
            fontSize: 34.sp,
            fontWeight: FontWeight.w700,
            color: HomeColors.deepAnchor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Keep up with the latest events in Milaor',
          style: TextStyle(fontSize: 17.sp, color: Colors.grey),
        ),
      ],
    );
  }

  // ─── ANNOUNCEMENT CARDS ───────────────────────────────
  static Widget _buildAnnouncementList() {
    return SizedBox(
      height: 390.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _announcementCard(),
          SizedBox(width: 18.w),
          _announcementCard(),
        ],
      ),
    );
  }

  static Widget _announcementCard() {
    return Container(
      width: 330.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            child: Image.asset(
              "assets/images/vaccine.jpg",
              height: 210.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HEALTH & WELLNESS',
                  style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: HomeColors.heritagePurple,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  'Barangay Vaccination Drive\nSchedule - Q4 2024',
                  style: TextStyle(
                    fontSize: 24.sp,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    color: HomeColors.deepAnchor,
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Starting Monday, teams will visit San Roque and Capucnasan.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    height: 1.5,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
