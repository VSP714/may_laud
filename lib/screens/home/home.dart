import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:may_laud/providers/auth_provider.dart';
import 'package:may_laud/providers/content_providers.dart';
import '../app_features/announcement/announcements_list_screen.dart';
import '../app_features/flood_alert/flood_alert_screen.dart';

// ===== MUNICIPAL BRAND PALETTE =====
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
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final userName = user?.name ?? 'Resident';
    final isGuest = authState.isGuest;

    // ← FIX: read theme so all helpers below can use it
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Gradient header — intentionally keeps purple gradient in both modes
        SliverAppBar(
          expandedHeight: 210.h,
          pinned: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: HomeColors.deepAnchor,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [HomeColors.deepAnchor, HomeColors.heritagePurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52.w,
                            height: 52.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Icon(Icons.person_rounded,
                                size: 28.sp, color: Colors.white),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Good ${_timeOfDay()}, ${isGuest ? 'Guest' : userName.split(' ').first}!',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  isGuest ? 'Guest Mode' : userName,
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(Icons.notifications_outlined,
                                      size: 22.sp, color: Colors.white),
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
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14.sp, color: Colors.white60),
                          SizedBox(width: 4.w),
                          Text(
                            'Milaor, Camarines Sur',
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.white60),
                          ),
                          const Spacer(),
                          Icon(Icons.cloud_outlined,
                              size: 14.sp, color: Colors.white60),
                          SizedBox(width: 4.w),
                          Text(
                            '32°C  •  Partly Cloudy',
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.white60),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 24.h,
            bottom: 130.h,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildDashboardStats(isDark: isDark, cs: cs),
              SizedBox(height: 28.h),
              _buildFloodStatusBanner(context),
              SizedBox(height: 28.h),
              _buildCitizenFeedback(context, isDark: isDark, cs: cs),
              SizedBox(height: 28.h),
              _buildSectionLabel('Announcements', 'Latest news from the LGU',
                  isDark: isDark, cs: cs),
              SizedBox(height: 16.h),
              _buildAnnouncementFeed(isDark: isDark, cs: cs),
              if (ref.watch(announcementsProvider).isNotEmpty) ...[
                SizedBox(height: 8.h),
                _buildViewAllButton(isDark: isDark, cs: cs),
              ],
            ]),
          ),
        ),
      ],
    );
  }

  String _timeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 18) return 'Afternoon';
    return 'Evening';
  }

  // ─── DASHBOARD STATS ──────────────────────────────────
  Widget _buildDashboardStats({required bool isDark, required ColorScheme cs}) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : HomeColors.cardWhite;
    final valueColor = isDark ? Colors.white : HomeColors.deepAnchor;
    final labelColor = isDark ? Colors.white60 : HomeColors.textMuted;
    final borderColor = isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFDEE2E6);

    return Row(
      children: [
        _statCard(
          icon: Icons.engineering_rounded,
          label: 'Active\nProjects',
          value: '12',
          color: HomeColors.heritagePurple,
          bgColor: HomeColors.heritagePurple.withValues(alpha: 0.08),
          cardColor: cardColor,
          valueColor: valueColor,
          labelColor: labelColor,
          borderColor: borderColor,
        ),
        SizedBox(width: 12.w),
        _statCard(
          icon: Icons.account_balance_wallet_rounded,
          label: 'Budget\nUtilized',
          value: '78%',
          color: HomeColors.successGreen,
          bgColor: HomeColors.successGreen.withValues(alpha: 0.08),
          cardColor: cardColor,
          valueColor: valueColor,
          labelColor: labelColor,
          borderColor: borderColor,
        ),
        SizedBox(width: 12.w),
        _statCard(
          icon: Icons.feedback_rounded,
          label: 'Resolved\nReports',
          value: '243',
          color: HomeColors.infoBlue,
          bgColor: HomeColors.infoBlue.withValues(alpha: 0.08),
          cardColor: cardColor,
          valueColor: valueColor,
          labelColor: labelColor,
          borderColor: borderColor,
        ),
        SizedBox(width: 12.w),
        _statCard(
          icon: Icons.groups_rounded,
          label: 'Barangay\nAssemblies',
          value: '18',
          color: HomeColors.warningAmber,
          bgColor: HomeColors.warningAmber.withValues(alpha: 0.08),
          cardColor: cardColor,
          valueColor: valueColor,
          labelColor: labelColor,
          borderColor: borderColor,
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
    required Color cardColor,
    required Color valueColor,
    required Color labelColor,
    required Color borderColor,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: cardColor, // ← FIX
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
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
                color: valueColor, // ← FIX
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
                color: labelColor, // ← FIX
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SECTION LABEL ────────────────────────────────────
  Widget _buildSectionLabel(String title, String subtitle,
      {required bool isDark, required ColorScheme cs}) {
    // ← FIX: was hardcoded HomeColors
    final titleColor = isDark ? Colors.white : HomeColors.deepAnchor;
    final subtitleColor = isDark ? Colors.white60 : HomeColors.textMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13.sp, color: subtitleColor),
        ),
      ],
    );
  }

  // ─── FLOOD STATUS BANNER ─────────────────────────────
  // Intentionally keeps green gradient — no change needed
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [HomeColors.successGreen, Color(0xFF15803D)],
          ),
          boxShadow: [
            BoxShadow(
              color: HomeColors.successGreen.withValues(alpha: 0.25),
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
                color: Colors.white.withValues(alpha: 0.2),
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
                      color: Colors.white.withValues(alpha: 0.8),
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
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 18.sp, color: Colors.white.withValues(alpha: 0.7)),
          ],
        ),
      ),
    );
  }

  // ─── CITIZEN FEEDBACK ─────────────────────────────────
  Widget _buildCitizenFeedback(BuildContext context,
      {required bool isDark, required ColorScheme cs}) {
    // ← FIX: was hardcoded Colors.white / HomeColors throughout
    final cardColor = isDark ? const Color(0xFF1E1E2E) : HomeColors.cardWhite;
    final borderColor = isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFDEE2E6);
    final titleColor = isDark ? Colors.white : HomeColors.deepAnchor;
    final inputFill = isDark ? const Color(0xFF2A2A3A) : HomeColors.warmHearth;
    final inputBorder = isDark
        ? HomeColors.heritagePurple.withOpacity(0.5)
        : HomeColors.heritagePurple.withValues(alpha: 0.3);
    final starEmpty = isDark ? Colors.white24 : Colors.grey.shade300;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                    color: titleColor,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: HomeColors.successGreen.withValues(alpha: 0.1),
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
          Text(
            'How is the LGU service?',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: titleColor,
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
                        : starEmpty,
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
              style: TextStyle(color: isDark ? cs.onSurface : null),
              decoration: InputDecoration(
                hintText: 'Any other suggestions? Write here...',
                hintStyle:
                    TextStyle(fontSize: 12.sp, color: HomeColors.textMuted),
                filled: true,
                fillColor: inputFill,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: inputBorder),
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
                color: HomeColors.successGreen.withValues(alpha: 0.08),
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
      case 1: return 'Needs improvement';
      case 2: return 'Could be better';
      case 3: return 'Okay, decent service';
      case 4: return 'Good service!';
      case 5: return 'Excellent! Keep it up!';
      default: return '';
    }
  }

  // ─── ANNOUNCEMENT FEED ────────────────────────────────
  Widget _buildAnnouncementFeed({required bool isDark, required ColorScheme cs}) {
    final announcements = ref.watch(announcementsProvider);

    if (announcements.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Text(
            'No announcements yet.',
            style: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.white60 : HomeColors.textMuted),
          ),
        ),
      );
    }

    final preview = announcements.take(3).toList();

    return Column(
      children: [
        for (int i = 0; i < preview.length; i++) ...[
          if (i > 0) SizedBox(height: 16.h),
          _buildAnnouncementCard(
            category: preview[i].category.toUpperCase(),
            accentColor: preview[i].isImportant
                ? HomeColors.dangerRed
                : HomeColors.heritagePurple,
            icon: preview[i].isImportant
                ? Icons.priority_high_rounded
                : Icons.campaign_rounded,
            title: preview[i].title,
            excerpt: preview[i].description,
            date: preview[i].formattedDate,
            isUnread: !preview[i].isRead,
            imageUrl: preview[i].imageUrl,
            isDark: isDark,
            cs: cs,
            onTap: () {
              ref.read(announcementsProvider.notifier).markAsRead(preview[i].id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      AnnouncementDetailScreen(announcement: preview[i]),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildAnnouncementCard({
    required String category,
    required Color accentColor,
    required IconData icon,
    required String title,
    required String excerpt,
    required String date,
    required bool isUnread,
    required bool isDark,
    required ColorScheme cs,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    // ← FIX: card/text colors were all hardcoded
    final cardColor = isDark ? const Color(0xFF1E1E2E) : HomeColors.cardWhite;
    final borderColor = isDark ? Colors.white.withOpacity(0.10) : const Color(0xFFDEE2E6);
    final titleColor = isDark ? Colors.white : HomeColors.deepAnchor;
    final excerptColor = isDark ? Colors.white60 : const Color(0xFF6B7280);
    final dateColor = isDark ? Colors.white38 : const Color(0xFF9CA3AF);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              child: Stack(
                children: [
                  SizedBox(
                    height: 170.h,
                    width: double.infinity,
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _cardFallback(accentColor, icon),
                          )
                        : _cardFallback(accentColor, icon),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF000000).withValues(alpha: 0.15),
                            const Color(0xFF000000).withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12.w,
                    bottom: 12.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.4),
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
                              color: HomeColors.infoBlue.withValues(alpha: 0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: titleColor, // ← FIX
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    excerpt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.5,
                      color: excerptColor, // ← FIX
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 14.sp, color: dateColor),
                      SizedBox(width: 5.w),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: dateColor, // ← FIX
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.08),
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

  Widget _cardFallback(Color accentColor, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.7),
            accentColor.withValues(alpha: 0.35),
          ],
        ),
      ),
      child: Center(
        child: Icon(icon,
            size: 48.sp, color: Colors.white.withValues(alpha: 0.9)),
      ),
    );
  }

  // ─── VIEW ALL BUTTON ──────────────────────────────────
  Widget _buildViewAllButton({required bool isDark, required ColorScheme cs}) {
    // ← FIX: was hardcoded HomeColors.warmHearth bg
    final bg = isDark ? const Color(0xFF1E1E2E) : HomeColors.warmHearth;
    final border = isDark
        ? HomeColors.heritagePurple.withOpacity(0.4)
        : HomeColors.heritagePurple.withValues(alpha: 0.12);
    final fgColor = isDark ? const Color(0xFF9B72E8) : HomeColors.heritagePurple;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AnnouncementsListScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 18.sp, color: fgColor),
            SizedBox(width: 8.w),
            Text(
              'View All Announcements',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: fgColor,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: fgColor),
          ],
        ),
      ),
    );
  }

  String _todayDate() {
    final now = DateTime.now();
    const months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December',
    ];
    const days = [
      'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday',
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}