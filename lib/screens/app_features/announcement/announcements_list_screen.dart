import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../home/home.dart';
import '../../../providers/content_providers.dart';

class AnnouncementsListScreen extends ConsumerStatefulWidget {
  const AnnouncementsListScreen({super.key});

  @override
  ConsumerState<AnnouncementsListScreen> createState() =>
      _AnnouncementsListScreenState();
}

class _AnnouncementsListScreenState
    extends ConsumerState<AnnouncementsListScreen> {

  final List<String> _categories = [
    'All',
    'Public Notice',
    'Traffic Advisory',
    'Health',
    'Government',
    'Event',
    'Public Service',
    'Disaster Preparedness',
    'Business',
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _showImportantOnly = false;

  List<Announcement> _filtered(List<Announcement> all) {
    var list = all;
    if (_selectedCategory != 'All') {
      list = list.where((a) => a.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((a) =>
              a.title.toLowerCase().contains(q) ||
              a.description.toLowerCase().contains(q))
          .toList();
    }
    if (_showImportantOnly) {
      list = list.where((a) => a.isImportant).toList();
    }
    return list;
  }

  void _markAsRead(String id) {
    ref.read(announcementsProvider.notifier).markAsRead(id);
  }

  void _viewDetails(Announcement announcement) {
    _markAsRead(announcement.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnnouncementDetailScreen(announcement: announcement),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final announcements = ref.watch(announcementsProvider);
    final filtered = _filtered(announcements);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    final scaffoldBg = isDark ? cs.background : const Color(0xFFF5F0F8);
    final accentPurple = isDark ? cs.primary : const Color(0xFF4C229C);
    final titleColor = isDark ? cs.onBackground : const Color(0xFF311B6B);
    final searchFill = isDark ? cs.surface : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Icon(Icons.campaign, size: 30.sp, color: accentPurple),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Announcements',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => ref
                        .read(announcementsProvider.notifier)
                        .fetchAnnouncements(),
                    icon: Icon(Icons.refresh, size: 26.sp, color: accentPurple),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ),
            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: TextStyle(color: cs.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search announcements...',
                  prefixIcon: Icon(Icons.search, size: 24.sp),
                  filled: true,
                  fillColor: searchFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                ),
              ),
            ),
            // Category chips
            SizedBox(
              height: 60.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: _categories.length,
                itemBuilder: (_, i) {
                  final cat = _categories[i];
                  final selected = _selectedCategory == cat;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                      selectedColor: accentPurple,
                      backgroundColor: isDark ? cs.surface : null,
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        color: selected
                            ? Colors.white
                            : (isDark ? cs.onSurface : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Important filter + count
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Important Only'),
                    selected: _showImportantOnly,
                    onSelected: (_) =>
                        setState(() => _showImportantOnly = !_showImportantOnly),
                    avatar: Icon(Icons.priority_high,
                        size: 18.sp,
                        color: _showImportantOnly ? Colors.white : Colors.red),
                    selectedColor: Colors.red.shade700,
                    backgroundColor: isDark ? cs.surface : null,
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: _showImportantOnly
                          ? Colors.white
                          : (isDark ? cs.onSurface : Colors.black),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '${filtered.length} announcement${filtered.length == 1 ? '' : 's'}',
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark
                            ? cs.onSurface.withOpacity(0.6)
                            : Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            // List
            Expanded(
              child: announcements.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.campaign_outlined,
                              size: 56.sp,
                              color: accentPurple.withOpacity(0.3)),
                          SizedBox(height: 16.h),
                          Text(
                            'No announcements yet',
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: isDark
                                    ? cs.onSurface.withOpacity(0.5)
                                    : Colors.grey.shade500),
                          ),
                        ],
                      ),
                    )
                  : filtered.isEmpty
                      ? Center(
                          child: Text(
                            'No results for your filters.',
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: isDark
                                    ? cs.onSurface.withOpacity(0.5)
                                    : Colors.grey.shade500),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) =>
                              _buildCard(filtered[i], isDark, cs),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Announcement a, bool isDark, ColorScheme cs) {
    final accentPurple = isDark ? cs.primary : const Color(0xFF4C229C);
    final categoryBg = isDark ? cs.primary.withOpacity(0.15) : const Color(0xFFEADCFB);
    final titleColor = isDark ? cs.onSurface : const Color(0xFF2E2438);
    final bodyColor = isDark ? cs.onSurface.withOpacity(0.65) : const Color(0xFF6F6878);

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      color: isDark ? cs.surface : null,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r)),
      child: InkWell(
        onTap: () => _viewDetails(a),
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)),
              child: Stack(
                children: [
                  a.imageUrl != null && a.imageUrl!.isNotEmpty
                      ? Image.network(
                          a.imageUrl!,
                          height: 180.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _imageFallback(a, isDark, cs),
                        )
                      : _imageFallback(a, isDark, cs),
                  if (a.isImportant)
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.priority_high,
                                size: 14.sp, color: Colors.white),
                            SizedBox(width: 4.w),
                            Text('IMPORTANT',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: categoryBg,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          a.category,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: accentPurple),
                        ),
                      ),
                      if (!a.isRead)
                        Container(
                          width: 10.w,
                          height: 10.h,
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    a.title,
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: titleColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    a.description,
                    style: TextStyle(
                        fontSize: 14.sp, color: bodyColor, height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 16.sp, color: bodyColor),
                      SizedBox(width: 6.w),
                      Text(
                        a.formattedDate,
                        style: TextStyle(fontSize: 14.sp, color: bodyColor),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.bookmark_border,
                            size: 20.sp, color: bodyColor),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.share_outlined,
                            size: 20.sp, color: bodyColor),
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

  Widget _imageFallback(Announcement a, bool isDark, ColorScheme cs) {
    final fallbackBg = isDark ? cs.primary.withOpacity(0.12) : const Color(0xFFEADCFB);
    final fallbackIcon = isDark ? cs.primary.withOpacity(0.4) : const Color(0xFF4C229C).withOpacity(0.4);
    return Container(
      height: 180.h,
      width: double.infinity,
      color: fallbackBg,
      child: Center(
        child: Icon(
          a.isImportant ? Icons.priority_high : Icons.campaign_outlined,
          size: 48.sp,
          color: fallbackIcon,
        ),
      ),
    );
  }
}

// ── Detail screen ─────────────────────────────────────────────────────────────
class AnnouncementDetailScreen extends StatelessWidget {
  final Announcement announcement;
  const AnnouncementDetailScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    final scaffoldBg = isDark ? cs.background : HomeColors.warmHearth;
    final accentPurple = isDark ? cs.primary : const Color(0xFF4C229C);
    final categoryBg = isDark ? cs.primary.withOpacity(0.15) : const Color(0xFFEADCFB);
    final imageFallbackBg = isDark ? cs.surface : const Color(0xFFEADCFB);
    final backBtnBg = isDark ? cs.surface.withOpacity(0.9) : Colors.white.withOpacity(0.9);
    final titleColor = isDark ? cs.onSurface : const Color(0xFF2E2438);
    final metaColor = isDark ? cs.onSurface.withOpacity(0.55) : const Color(0xFF6F6878);
    final bodyColor = isDark ? cs.onSurface.withOpacity(0.85) : const Color(0xFF3D3549);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                announcement.imageUrl != null &&
                        announcement.imageUrl!.isNotEmpty
                    ? Image.network(
                        announcement.imageUrl!,
                        height: 260.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 260.h,
                          color: imageFallbackBg,
                        ),
                      )
                    : Container(
                        height: 260.h,
                        color: imageFallbackBg,
                      ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: CircleAvatar(
                      backgroundColor: backBtnBg,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: accentPurple),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (announcement.isImportant)
                    Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.priority_high,
                              size: 14.sp, color: Colors.white),
                          SizedBox(width: 4.w),
                          Text('IMPORTANT',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: categoryBg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      announcement.category,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: accentPurple),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    announcement.title,
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: titleColor),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 16.sp, color: metaColor),
                      SizedBox(width: 6.w),
                      Text(
                        announcement.formattedDate,
                        style: TextStyle(fontSize: 13.sp, color: metaColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    announcement.description,
                    style: TextStyle(
                        fontSize: 15.sp, color: bodyColor, height: 1.7),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
