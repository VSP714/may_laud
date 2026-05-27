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

  // Filters applied on top of the live Supabase data
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
    // Single source of truth — live from Supabase via provider
    final announcements = ref.watch(announcementsProvider);
    final filtered = _filtered(announcements);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Icon(Icons.campaign,
                      size: 30.sp, color: const Color(0xFF4C229C)),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Announcements',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF311B6B),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => ref
                        .read(announcementsProvider.notifier)
                        .fetchAnnouncements(),
                    icon: Icon(Icons.refresh,
                        size: 26.sp, color: const Color(0xFF4C229C)),
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
                decoration: InputDecoration(
                  hintText: 'Search announcements...',
                  prefixIcon: Icon(Icons.search, size: 24.sp),
                  filled: true,
                  fillColor: Colors.white,
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
                      selectedColor: const Color(0xFF4C229C),
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        color: selected ? Colors.white : Colors.black,
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
                        color:
                            _showImportantOnly ? Colors.white : Colors.red),
                    selectedColor: Colors.red.shade700,
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: _showImportantOnly ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '${filtered.length} announcement${filtered.length == 1 ? '' : 's'}',
                    style: TextStyle(
                        fontSize: 14.sp, color: Colors.grey.shade600),
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
                              color: const Color(0xFF4C229C)
                                  .withValues(alpha: 0.3)),
                          SizedBox(height: 16.h),
                          Text(
                            'No announcements yet',
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey.shade500),
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
                                color: Colors.grey.shade500),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) =>
                              _buildCard(filtered[i]),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Announcement a) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
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
                              _imageFallback(a),
                        )
                      : _imageFallback(a),
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
                          color: const Color(0xFFEADCFB),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          a.category,
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4C229C)),
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
                        color: const Color(0xFF2E2438)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    a.description,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF6F6878),
                        height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 16.sp, color: const Color(0xFF6F6878)),
                      SizedBox(width: 6.w),
                      Text(
                        a.formattedDate,
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF6F6878)),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.bookmark_border,
                            size: 20.sp,
                            color: const Color(0xFF6F6878)),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.share_outlined,
                            size: 20.sp,
                            color: const Color(0xFF6F6878)),
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

  Widget _imageFallback(Announcement a) {
    return Container(
      height: 180.h,
      width: double.infinity,
      color: const Color(0xFFEADCFB),
      child: Center(
        child: Icon(
          a.isImportant ? Icons.priority_high : Icons.campaign_outlined,
          size: 48.sp,
          color: const Color(0xFF4C229C).withValues(alpha: 0.4),
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
    return Scaffold(
      backgroundColor: HomeColors.warmHearth,
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
                          color: const Color(0xFFEADCFB),
                        ),
                      )
                    : Container(
                        height: 260.h,
                        color: const Color(0xFFEADCFB),
                      ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: CircleAvatar(
                      backgroundColor:
                          Colors.white.withValues(alpha: 0.9),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Color(0xFF4C229C)),
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
                      color: const Color(0xFFEADCFB),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      announcement.category,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4C229C)),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    announcement.title,
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E2438)),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 16.sp, color: const Color(0xFF6F6878)),
                      SizedBox(width: 6.w),
                      Text(
                        announcement.formattedDate,
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF6F6878)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    announcement.description,
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xFF3D3549),
                        height: 1.7),
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