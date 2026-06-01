import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home/home.dart';
import '../providers/auth_provider.dart';
import '../providers/app_providers.dart';
import '../core/local_storage.dart';

// Profile sub-screens
import 'profile/quick_settings_sheet.dart';
import 'profile/change_photo_sheet.dart';
import 'profile/edit_profile_sheet.dart';
import 'profile/change_password_sheet.dart';
import 'profile/privacy_security_sheet.dart';
import 'profile/notification_preferences_sheet.dart';
import 'profile/help_support_sheet.dart';
import 'profile/about_milaud_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final Map<String, int> _docStats = {
    'total': 12,
    'approved': 8,
    'pending': 3,
  };

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    // ← FIX: read theme colors from context so they respond to dark mode
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Adaptive background: light lavender in light mode, true dark in dark mode
    final scaffoldBg = isDark ? colorScheme.background : HomeColors.warmHearth;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(isDark: isDark, colorScheme: colorScheme),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 12.h),
                  _buildProfileHeaderCard(user),
                  SizedBox(height: 20.h),
                  _buildStatsRow(isDark: isDark, colorScheme: colorScheme),
                  SizedBox(height: 20.h),
                  _buildPersonalInfoCard(user, isDark: isDark, colorScheme: colorScheme),
                  SizedBox(height: 20.h),
                  _buildAccountActionsCard(user, isDark: isDark, colorScheme: colorScheme),
                  SizedBox(height: 20.h),
                  _buildAppSettingsCard(isDark: isDark, colorScheme: colorScheme),
                  SizedBox(height: 24.h),
                  _buildLogoutButton(),
                  SizedBox(height: 40.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── APP BAR ───────────────────────────────────────────
  Widget _buildAppBar({required bool isDark, required ColorScheme colorScheme}) {
    // ← FIX: was hardcoded HomeColors.warmHearth always
    final bgColor = isDark ? colorScheme.surface : HomeColors.warmHearth;
    final titleColor = isDark ? colorScheme.onSurface : HomeColors.deepAnchor;
    final iconColor = HomeColors.heritagePurple;

    return SliverAppBar(
      pinned: true,
      floating: false,
      automaticallyImplyLeading: false,
      backgroundColor: bgColor,
      elevation: 0,
      centerTitle: false,
      title: Text(
        'My Profile',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: titleColor,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => showQuickSettingsSheet(context),
          icon: Icon(
            Icons.settings_outlined,
            size: 22.sp,
            color: iconColor,
          ),
        ),
        SizedBox(width: 4.w),
      ],
    );
  }

  // ─── PROFILE HEADER CARD ───────────────────────────────
  // Gradient card — intentionally keeps the purple gradient in both modes
  Widget _buildProfileHeaderCard(User? user) {
    final name = user?.name ?? 'Resident';
    final memberYear = user?.createdAt?.year.toString() ?? '2022';

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [HomeColors.deepAnchor, HomeColors.heritagePurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: HomeColors.heritagePurple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 45.r,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  backgroundImage: user?.profileImage != null
                      ? NetworkImage(user!.profileImage!)
                      : null,
                  child: user?.profileImage == null
                      ? Icon(Icons.person, size: 48.sp, color: Colors.white)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () => showChangePhotoSheet(context),
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 16.sp,
                      color: HomeColors.heritagePurple,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email_outlined, size: 15.sp, color: Colors.white70),
                SizedBox(width: 6.w),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Member since $memberYear',
            style: TextStyle(fontSize: 13.sp, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  // ─── STATS ROW ─────────────────────────────────────────
  Widget _buildStatsRow({required bool isDark, required ColorScheme colorScheme}) {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.description_outlined,
          value: '${_docStats['total'] ?? 0}',
          label: 'Total\nRequests',
          color: HomeColors.heritagePurple,
          isDark: isDark,
          colorScheme: colorScheme,
        ),
        SizedBox(width: 12.w),
        _buildStatCard(
          icon: Icons.check_circle_outline,
          value: '${_docStats['approved'] ?? 0}',
          label: 'Approved',
          color: const Color(0xFF2E7D32),
          isDark: isDark,
          colorScheme: colorScheme,
        ),
        SizedBox(width: 12.w),
        _buildStatCard(
          icon: Icons.hourglass_bottom_outlined,
          value: '${_docStats['pending'] ?? 0}',
          label: 'Pending',
          color: const Color(0xFFE65100),
          isDark: isDark,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    // ← FIX: was hardcoded Colors.white
    final cardColor = isDark ? colorScheme.surface : Colors.white;
    final valueColor = isDark ? colorScheme.onSurface : HomeColors.deepAnchor;
    final labelColor = isDark ? colorScheme.onSurface.withOpacity(0.6) : const Color(0xFF757575);

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
              child: Icon(icon, size: 22.sp, color: color),
            ),
            SizedBox(height: 10.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: labelColor,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── PERSONAL INFO CARD ────────────────────────────────
  Widget _buildPersonalInfoCard(User? user, {required bool isDark, required ColorScheme colorScheme}) {
    return _buildCard(
      title: 'Personal Information',
      isDark: isDark,
      colorScheme: colorScheme,
      trailing: TextButton.icon(
        onPressed: () async {
          if (_isEditing) {
            setState(() => _isEditing = false);
          } else {
            final saved = await showEditProfileSheet(context, user);
            if (saved == true && mounted) {
              setState(() => _isEditing = false);
            }
          }
        },
        icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined, size: 18.sp),
        label: Text(
          _isEditing ? 'Cancel' : 'Edit',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
      ),
      children: [
        _buildInfoRow(Icons.person_outline, 'Full Name', user?.name ?? '—', isDark: isDark, colorScheme: colorScheme),
        _buildInfoRow(Icons.email_outlined, 'Email', user?.email ?? '—', isDark: isDark, colorScheme: colorScheme),
        _buildInfoRow(Icons.phone_outlined, 'Phone', user?.phone ?? '—', isDark: isDark, colorScheme: colorScheme),
        _buildInfoRow(Icons.location_on_outlined, 'Address', user?.address ?? '—', isDark: isDark, colorScheme: colorScheme),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {required bool isDark, required ColorScheme colorScheme}) {
    // ← FIX: was hardcoded HomeColors.deepAnchor for value text
    final iconBg = isDark
        ? const Color(0xFF4C229C).withOpacity(0.15)
        : HomeColors.heritagePurple.withOpacity(0.08);
    final iconColor = HomeColors.heritagePurple;
    final labelColor = isDark ? colorScheme.onSurface.withOpacity(0.5) : const Color(0xFF9E9E9E);
    final valueColor = isDark ? colorScheme.onSurface : HomeColors.deepAnchor;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 20.sp, color: iconColor),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: valueColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── ACCOUNT ACTIONS CARD ──────────────────────────────
  Widget _buildAccountActionsCard(User? user, {required bool isDark, required ColorScheme colorScheme}) {
    return _buildCard(
      title: 'Account',
      isDark: isDark,
      colorScheme: colorScheme,
      children: [
        _buildActionTile(
          icon: Icons.edit_outlined,
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          onTap: () => showEditProfileSheet(context, user),
          isDark: isDark,
          colorScheme: colorScheme,
        ),
        _buildActionTile(
          icon: Icons.lock_outline,
          title: 'Change Password',
          subtitle: 'Secure your account with a new password',
          onTap: () => showChangePasswordSheet(context),
          isDark: isDark,
          colorScheme: colorScheme,
        ),
        _buildActionTile(
          icon: Icons.security_outlined,
          title: 'Privacy & Security',
          subtitle: 'Manage your data and account security',
          onTap: () => showPrivacySecuritySheet(context),
          isDark: isDark,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  // ─── APP SETTINGS CARD ─────────────────────────────────
  Widget _buildAppSettingsCard({required bool isDark, required ColorScheme colorScheme}) {
    final settings = ref.watch(appSettingsProvider);
    final iconColor = HomeColors.heritagePurple;
    final iconBg = isDark
        ? const Color(0xFF4C229C).withOpacity(0.15)
        : HomeColors.heritagePurple.withOpacity(0.07);
    final titleColor = isDark ? colorScheme.onSurface : HomeColors.deepAnchor;
    final subtitleColor = isDark ? colorScheme.onSurface.withOpacity(0.5) : const Color(0xFF9E9E9E);

    return _buildCard(
      title: 'App Settings',
      isDark: isDark,
      colorScheme: colorScheme,
      children: [
        _buildActionTile(
          icon: Icons.notifications_outlined,
          title: 'Notification Preferences',
          subtitle: 'Manage alerts and push notifications',
          onTap: () => showNotificationPreferencesSheet(context),
          isDark: isDark,
          colorScheme: colorScheme,
        ),

        // Dark mode inline toggle
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
          child: Row(
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  settings.isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  size: 22.sp,
                  color: iconColor,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      settings.isDarkMode ? 'Dark theme active' : 'Light theme active',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: subtitleColor,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: settings.isDarkMode,
                activeColor: HomeColors.heritagePurple,
                onChanged: (val) async {
                  ref.read(appSettingsProvider.notifier).toggleDarkMode();
                  await LocalStorage.setDarkMode(val);
                },
              ),
            ],
          ),
        ),

        _buildActionTile(
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'FAQs, guides, and contact support',
          onTap: () => showHelpSupportSheet(context),
          isDark: isDark,
          colorScheme: colorScheme,
        ),
        _buildActionTile(
          icon: Icons.info_outline,
          title: 'About Milaud',
          subtitle: 'App version, terms, and privacy policy',
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'v1.0.0',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
            ),
          ),
          onTap: () => showAboutMilaudSheet(context),
          isDark: isDark,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    required ColorScheme colorScheme,
    Widget? trailing,
  }) {
    // ← FIX: was all hardcoded HomeColors
    final iconBg = isDark
        ? const Color(0xFF4C229C).withOpacity(0.15)
        : HomeColors.heritagePurple.withOpacity(0.07);
    final iconColor = HomeColors.heritagePurple;
    final titleColor = isDark ? colorScheme.onSurface : HomeColors.deepAnchor;
    final subtitleColor = isDark ? colorScheme.onSurface.withOpacity(0.5) : const Color(0xFF9E9E9E);
    final chevronColor = isDark ? colorScheme.onSurface.withOpacity(0.3) : const Color(0xFFBDBDBD);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 22.sp, color: iconColor),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.sp,
                  color: chevronColor,
                ),
          ],
        ),
      ),
    );
  }

  // ─── CARD WRAPPER ──────────────────────────────────────
  // ← FIX: renamed from _buildWhiteCard, now theme-aware
  Widget _buildCard({
    required String title,
    required List<Widget> children,
    required bool isDark,
    required ColorScheme colorScheme,
    Widget? trailing,
  }) {
    // ← FIX: was always Colors.white
    final cardColor = isDark ? colorScheme.surface : Colors.white;
    final titleColor = isDark ? colorScheme.onSurface : HomeColors.deepAnchor;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  letterSpacing: -0.3,
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  // ─── LOGOUT BUTTON ─────────────────────────────────────
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton.icon(
        onPressed: _showLogoutConfirmation,
        icon: Icon(Icons.logout_rounded, size: 20.sp),
        label: Text(
          'Logout',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFD32F2F),
          side: const BorderSide(color: Color(0xFFEF9A9A), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF3D1515)
              : const Color(0xFFFFF5F5),
        ),
      ),
    );
  }

  // ─── LOGOUT DIALOG ─────────────────────────────────────
  void _showLogoutConfirmation() {
    final userName = ref.read(authProvider).user?.name ?? 'user';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Confirm Logout',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out, $userName? '
          "You'll need to sign in again to access your account.",
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF616161),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF757575),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authProvider.notifier).logout();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            ),
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}