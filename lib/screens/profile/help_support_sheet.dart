import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../home/home.dart';

const _faqs = [
  (
    q: 'How do I request a barangay document?',
    a: 'Go to the + button on Home, select "Document Request", fill in the form, and submit. You will receive a reference number to track your request.',
  ),
  (
    q: 'How do I report a community issue?',
    a: 'Tap the + button, choose "Citizen Report", describe the issue, attach photos if needed, and submit. Reports are reviewed within 3–5 business days.',
  ),
  (
    q: 'What do I do during a flood alert?',
    a: 'Go to Flood Alert from the + button to see current risk levels and nearest evacuation centers. Follow local authority instructions.',
  ),
  (
    q: 'How do I contact emergency hotlines?',
    a: 'Tap the + button and select "Milaor Hotlines". Tap any contact to call them directly from your phone.',
  ),
  (
    q: 'How do I update my profile information?',
    a: 'Go to Profile → Edit Profile. Update your name, phone, or address and tap Save Changes.',
  ),
];

class HelpSupportSheet extends StatelessWidget {
  const HelpSupportSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _cs = _theme.colorScheme;
    final _titleColor = _isDark ? _cs.onSurface : HomeColors.deepAnchor;
    final _accentColor = _isDark ? _cs.primary : HomeColors.heritagePurple;
        return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      builder: (ctx, scrollCtrl) => Padding(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            _buildHandle(),
            SizedBox(height: 20.h),
            Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: _titleColor,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Frequently asked questions',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF9E9E9E),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.separated(
                controller: scrollCtrl,
                itemCount: _faqs.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (ctx, i) => _FaqTile(
                  question: _faqs[i].q,
                  answer: _faqs[i].a,
                  titleColor: _titleColor,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            _buildContactCard(
              titleColor: _titleColor,
              accentColor: _accentColor,
            ),
          ],
        ),
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

  Widget _buildContactCard(
      {required Color titleColor, required Color accentColor}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: HomeColors.heritagePurple.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.support_agent_outlined,
            color: accentColor,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need more help?',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                Text(
                  'Contact the Barangay Hall directly.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF9E9E9E),
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

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;
  final Color titleColor;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 4.w),
        childrenPadding:
            EdgeInsets.only(left: 4.w, right: 4.w, bottom: 12.h),
        title: Text(
          question,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        iconColor: HomeColors.heritagePurple,
        collapsedIconColor: const Color(0xFF9E9E9E),
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF616161),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper to show this sheet from anywhere
Future<void> showHelpSupportSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (_) => const HelpSupportSheet(),
  );
}