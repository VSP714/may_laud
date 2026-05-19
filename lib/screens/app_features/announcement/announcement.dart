import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ===================== ANNOUNCEMENT DETAIL SCREEN =====================
class AnnouncementFeedScreen extends StatelessWidget {
  const AnnouncementFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF8F9FA);
    const primary = Color(0xFF0056A3);
    const cardBg = Colors.white;
    const lightBg = Color(0xFFE8F0FE);
    const textDark = Color(0xFF212529);
    const textMuted = Color(0xFF6C757D);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Announcement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              child: SizedBox(
                width: double.infinity,
                height: 240.h,
                child: Image.network(
                  'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?q=80&w=1200&auto=format&fit=crop',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 240.h,
                    color: const Color(0xFFE9ECEF),
                    child:
                        const Icon(Icons.campaign, size: 48, color: textMuted),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -24.h),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: const Text(
                        'PUBLIC NOTICE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    const Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 14, color: textMuted),
                        SizedBox(width: 6),
                        Text('Published Oct 25, 2023',
                            style: TextStyle(fontSize: 13, color: textMuted)),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    const Text(
                      'New Water Utility Maintenance Schedule',
                      style: TextStyle(
                        fontSize: 26,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      height: 1,
                      color: const Color(0xFFDEE2E6),
                    ),
                    SizedBox(height: 16.h),
                    const Text(
                      'The Municipal Engineering Office has announced the upcoming water utility upgrade cycle for the Milaor residential clusters. To ensure the continued reliability of our municipal water supply and improve pressure in higher-elevation zones, the Milaor Water District will be conducting essential maintenance and infrastructure upgrades over the next two weeks.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.8,
                        color: textMuted,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _infoBox(
                      icon: Icons.access_time,
                      title: 'TIMEFRAME',
                      content: 'Oct 30 — Nov 12, 2023',
                      subtitle:
                          'Intermittent interruptions daily between 1:00 PM and 4:00 PM.',
                      primary: primary,
                      lightBg: lightBg,
                      textDark: textDark,
                      textMuted: textMuted,
                    ),
                    SizedBox(height: 14.h),
                    _infoBox(
                      icon: Icons.location_on_outlined,
                      title: 'AFFECTED AREAS',
                      content: 'Central Square & Riverbank District',
                      subtitle:
                          'All residential and commercial blocks within the historic center.',
                      primary: primary,
                      lightBg: lightBg,
                      textDark: textDark,
                      textMuted: textMuted,
                    ),
                    SizedBox(height: 20.h),
                    const Text(
                      'We advise all residents to store adequate water supplies during the morning hours. The upgrades include the installation of high-efficiency filtration nodes and the replacement of heritage piping sections that have served the community since the late 1980s.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.8,
                        color: textMuted,
                      ),
                    ),
                    SizedBox(height: 22.h),
                    const Text(
                      'What to Expect',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: textDark,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...[
                      'Temporary pressure reductions during peak heat hours (2 PM).',
                      'Minimal sediment appearance immediately following restoration (run faucets for 2 minutes).',
                      'On-site crews working along the North Heritage Corridor.'
                    ].map((item) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 3.h),
                                child: const Icon(Icons.check_circle_outline,
                                    size: 18, color: primary),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.6,
                                      color: textMuted),
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: lightBg,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Community Support',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: textDark),
                          ),
                          SizedBox(height: 8.h),
                          const Text(
                            "Have specific questions about your street's schedule? Connect with the Civic Concierge team.",
                            style: TextStyle(height: 1.7, color: textMuted),
                          ),
                          SizedBox(height: 16.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text('Contact Engineering Office',
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.print_outlined, size: 18.sp),
                      label: const Text('Print'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        side: const BorderSide(color: primary),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.info_outline, size: 18.sp),
                      label: const Text('Report Issue'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  static Widget _infoBox({
    required IconData icon,
    required String title,
    required String content,
    required String subtitle,
    required Color primary,
    required Color lightBg,
    required Color textDark,
    required Color textMuted,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: lightBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(left: BorderSide(color: primary, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: primary),
              SizedBox(width: 8.w),
              Text(title,
                  style: TextStyle(
                      fontSize: 11, letterSpacing: 1, color: textMuted)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(content,
              style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: textDark)),
          SizedBox(height: 8.h),
          Text(subtitle,
              style: TextStyle(height: 1.6, fontSize: 13.sp, color: textMuted)),
        ],
      ),
    );
  }
}
