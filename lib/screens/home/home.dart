import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:may_laud/providers/auth_provider.dart';
import '../app_features/flood_alert/flood_alert_screen.dart';

// ===== MUNICIPAL BRAND PALETTE (same as before) =====
class HomeColors {
  static const Color heritagePurple = Color(0xFF4C229C);
  static const Color riverFlow = Color(0xFF643EB5);
  static const Color deepAnchor = Color(0xFF24005B);
  static const Color warmHearth = Color(0xFFF8F5FF);
  static const Color cardWhite = Colors.white;

  static const Color successGreen = Color(0xFF16A34A);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color infoBlue = Color(0xFF3B82F6);
  static const Color dangerRed = Color(0xFFEF4444);
  static const Color textMuted = Color(0xFF9CA3AF);

  static const LinearGradient fabGradient = LinearGradient(
    colors: [riverFlow, heritagePurple],
  );
  static const LinearGradient avatarGradient = LinearGradient(
    colors: [riverFlow, heritagePurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepAnchor, heritagePurple],
  );
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  int _feedbackRating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  bool _feedbackSubmitted = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 10 != _isScrolled) {
        setState(() => _isScrolled = _scrollController.position.pixels > 10);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Get auth state – user name comes from here
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final userName = user?.name ?? 'Resident';
    final isGuest = authState.isGuest;

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 18.h,
        bottom: 130.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(userName, isGuest),
          SizedBox(height: 24.h),
          _buildDashboardStats(),
          SizedBox(height: 28.h),
          _buildFloodStatusBanner(context),
          SizedBox(height: 28.h),
          _buildCitizenFeedback(context),
          SizedBox(height: 28.h),
          _buildSectionLabel('Announcements', 'Latest news from the LGU'),
          SizedBox(height: 16.h),
          _buildAnnouncementFeed(),
          SizedBox(height: 8.h),
          _buildViewAllButton(),
        ],
      ),
    );
  }

  // ─── HEADER (now receives user name) ───────────────────
  Widget _buildHeader(String userName, bool isGuest) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: HomeColors.avatarGradient,
                boxShadow: [
                  BoxShadow(
                    color: HomeColors.heritagePurple.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(Icons.person, color: Colors.white, size: 28.sp),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Good ${_timeOfDay()}!',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: HomeColors.textMuted,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: HomeColors.warmHearth,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: HomeColors.heritagePurple.withOpacity(0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified,
                                size: 12.sp, color: HomeColors.heritagePurple),
                            SizedBox(width: 4.w),
                            Text(
                              isGuest ? 'Guest Mode' : 'LGU Milaor',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: HomeColors.heritagePurple,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // ✅ Dynamic user name
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: HomeColors.deepAnchor,
                      height: 1.15,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14.sp, color: HomeColors.riverFlow),
                      SizedBox(width: 3.w),
                      Text(
                        'Milaor, Camarines Sur',
                        style: TextStyle(
                            fontSize: 12.sp, color: HomeColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to notifications
              },
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: HomeColors.warmHearth,
                  border: Border.all(
                    color: HomeColors.riverFlow.withOpacity(0.1),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(Icons.notifications_outlined,
                          size: 22.sp, color: HomeColors.heritagePurple),
                    ),
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: Container(
                        width: 9.w,
                        height: 9.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: HomeColors.dangerRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: HomeColors.warmHearth,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 16.sp, color: HomeColors.heritagePurple),
              SizedBox(width: 8.w),
              Text(
                _todayDate(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: HomeColors.heritagePurple,
                ),
              ),
              const Spacer(),
              Icon(Icons.cloud_outlined,
                  size: 16.sp, color: HomeColors.textMuted),
              SizedBox(width: 6.w),
              Text(
                '32°C  •  Partly Cloudy',
                style: TextStyle(fontSize: 12.sp, color: HomeColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper: get time of day for greeting
  String _timeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 18) return 'Afternoon';
    return 'Evening';
  }


  // ─── DASHBOARD STATS ──────────────────────────────────
  Widget _buildDashboardStats() {
    return Row(
      children: [
        _statCard(
          icon: Icons.engineering_rounded,
          label: 'Active\nProjects',
          value: '12',
          color: HomeColors.heritagePurple,
          bgColor: HomeColors.heritagePurple.withOpacity(0.08),
        ),
        SizedBox(width: 12.w),
        _statCard(
          icon: Icons.account_balance_wallet_rounded,
          label: 'Budget\nUtilized',
          value: '78%',
          color: HomeColors.successGreen,
          bgColor: HomeColors.successGreen.withOpacity(0.08),
        ),
        SizedBox(width: 12.w),
        _statCard(
          icon: Icons.feedback_rounded,
          label: 'Resolved\nReports',
          value: '243',
          color: HomeColors.infoBlue,
          bgColor: HomeColors.infoBlue.withOpacity(0.08),
        ),
        SizedBox(width: 12.w),
        _statCard(
          icon: Icons.groups_rounded,
          label: 'Barangay\nAssemblies',
          value: '18',
          color: HomeColors.warningAmber,
          bgColor: HomeColors.warningAmber.withOpacity(0.08),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: HomeColors.cardWhite,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 20.sp, color: color),
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: HomeColors.deepAnchor,
                height: 1,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: HomeColors.textMuted,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SECTION LABEL ────────────────────────────────────
  Widget _buildSectionLabel(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: HomeColors.deepAnchor,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13.sp, color: HomeColors.textMuted),
        ),
      ],
    );
  }

  // ─── FLOOD STATUS BANNER ──────────────────────────────
  Widget _buildFloodStatusBanner(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FloodAlertScreen()),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [HomeColors.successGreen, const Color(0xFF15803D)],
          ),
          boxShadow: [
            BoxShadow(
              color: HomeColors.successGreen.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(Icons.water_drop_rounded,
                  size: 28.sp, color: Colors.white),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bicol River Status',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Normal Water Level',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Safely within limits • All routes clear • Updated 14m ago',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 18.sp, color: Colors.white.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }

  // ─── CITIZEN FEEDBACK ─────────────────────────────────
  Widget _buildCitizenFeedback(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: HomeColors.cardWhite,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.rate_review_rounded,
                  size: 22.sp, color: HomeColors.heritagePurple),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  'Your Voice, Our Action',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: HomeColors.deepAnchor,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: HomeColors.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Voice of the People',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: HomeColors.successGreen,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Rating: "Kamusta an serbisyo?"
          Text(
            'How is the LGU service?',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: HomeColors.deepAnchor,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return GestureDetector(
                onTap: _feedbackSubmitted
                    ? null
                    : () => setState(() => _feedbackRating = i + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Icon(
                    i < _feedbackRating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 36.sp,
                    color: i < _feedbackRating
                        ? HomeColors.warningAmber
                        : Colors.grey.shade300,
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 4.h),
          Center(
            child: Text(
              _feedbackRating == 0
                  ? 'Tap the stars to rate'
                  : _ratingLabel(_feedbackRating),
              style: TextStyle(
                fontSize: 12.sp,
                color: _feedbackRating > 0
                    ? HomeColors.heritagePurple
                    : HomeColors.textMuted,
                fontWeight:
                    _feedbackRating > 0 ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          if (_feedbackRating > 0 && !_feedbackSubmitted) ...[
            SizedBox(height: 14.h),
            TextField(
              controller: _feedbackController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Any other suggestions? Write here...',
                hintStyle:
                    TextStyle(fontSize: 12.sp, color: HomeColors.textMuted),
                filled: true,
                fillColor: HomeColors.warmHearth,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                      color: HomeColors.heritagePurple.withOpacity(0.3)),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _feedbackSubmitted = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Thank you for your feedback! Long live Milaor!'),
                      backgroundColor: HomeColors.successGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HomeColors.heritagePurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Submit Feedback',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
          if (_feedbackSubmitted) ...[
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: HomeColors.successGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 22.sp, color: HomeColors.successGreen),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Thank you! Your feedback has been received. Together we serve for Milaor!',
                      style: TextStyle(
                        fontSize: 12.sp,
                        height: 1.4,
                        color: HomeColors.successGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _ratingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Needs improvement';
      case 2:
        return 'Could be better';
      case 3:
        return 'Okay, decent service';
      case 4:
        return 'Good service!';
      case 5:
        return 'Excellent! Keep it up!';
      default:
        return '';
    }
  }

  // ─── ANNOUNCEMENT FEED ────────────────────────────────
  Widget _buildAnnouncementFeed() {
    return Column(
      children: [
        _buildAnnouncementCard(
          category: 'PUBLIC ADVISORY',
          accentColor: HomeColors.infoBlue,
          icon: Icons.campaign_rounded,
          title: 'Barangay Vaccination Drive — Q4 2024',
          excerpt:
              'Starting Monday, LGU health teams will visit San Roque, Capucnasan, and Del Rosario for the scheduled vaccination drive.',
          date: '2 hours ago',
          isUnread: true,
          imageAsset: 'assets/images/home_screen/Vaccine.png',
        ),
        SizedBox(height: 16.h),
        _buildAnnouncementCard(
          category: 'INFRASTRUCTURE',
          accentColor: HomeColors.warningAmber,
          icon: Icons.construction_rounded,
          title: 'Road Rehabilitation: Cabugao–Dalipay',
          excerpt:
              'Road concreting project begins next week. Expect minor traffic rerouting in the area. Estimated completion: 45 days.',
          date: 'Yesterday',
          isUnread: false,
          imageAsset: 'assets/images/home_screen/Road_Announcement.png',
        ),
        SizedBox(height: 16.h),
        _buildAnnouncementCard(
          category: 'COMMUNITY',
          accentColor: HomeColors.successGreen,
          icon: Icons.groups_rounded,
          title: 'Town Hall Meeting: Participatory Budgeting',
          excerpt:
              'Join the Municipal Hall forum on participatory budgeting for FY 2025. All 20 barangays are encouraged to send representatives.',
          date: '2 days ago',
          isUnread: false,
          imageAsset: 'assets/images/home_screen/Community_Townhall.png',
        ),
      ],
    );
  }

  /// ─── PROFESSIONAL ANNOUNCEMENT CARD (Vertical Layout) ───
  Widget _buildAnnouncementCard({
    required String category,
    required Color accentColor,
    required IconData icon,
    required String title,
    required String excerpt,
    required String date,
    required bool isUnread,
    required String imageAsset,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigate to announcement detail
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: HomeColors.cardWhite,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color(0xFFDEE2E6)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Image with Gradient Overlay & Category Badge ──
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              child: Stack(
                children: [
                  SizedBox(
                    height: 170.h,
                    width: double.infinity,
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accentColor.withOpacity(0.7),
                              accentColor.withOpacity(0.35),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(icon,
                              size: 48.sp,
                              color: Colors.white.withOpacity(0.9)),
                        ),
                      ),
                    ),
                  ),
                  // Gradient overlay for better text readability
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF000000).withOpacity(0.15),
                            const Color(0xFF000000).withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Category badge + Unread dot
                  Positioned(
                    left: 12.w,
                    bottom: 12.h,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 13.sp, color: Colors.white),
                          SizedBox(width: 5.w),
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Unread indicator
                  if (isUnread)
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: HomeColors.infoBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: HomeColors.infoBlue.withOpacity(0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // ── Content Body ──
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: HomeColors.deepAnchor,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Excerpt
                  Text(
                    excerpt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.5,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  // Footer: date + action
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 14.sp, color: const Color(0xFF9CA3AF)),
                      SizedBox(width: 5.w),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Read More',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: accentColor,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(Icons.arrow_forward_rounded,
                                size: 14.sp, color: accentColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── VIEW ALL BUTTON ──────────────────────────────────
  Widget _buildViewAllButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to full announcements list
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: HomeColors.warmHearth,
          borderRadius: BorderRadius.circular(14.r),
          border:
              Border.all(color: HomeColors.heritagePurple.withOpacity(0.12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined,
                size: 18.sp, color: HomeColors.heritagePurple),
            SizedBox(width: 8.w),
            Text(
              'View All Announcements',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: HomeColors.heritagePurple,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14.sp, color: HomeColors.heritagePurple),
          ],
        ),
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────
  String _todayDate() {
    final now = DateTime.now();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}
