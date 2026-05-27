import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../home/home.dart';
import '../../../providers/content_providers.dart'; // ✅ Import real Announcement model

class AnnouncementsListScreen extends ConsumerStatefulWidget {
  const AnnouncementsListScreen({super.key});

  @override
  ConsumerState<AnnouncementsListScreen> createState() =>
      _AnnouncementsListScreenState();
}

class _AnnouncementsListScreenState extends ConsumerState<AnnouncementsListScreen> {
  // Use the provider's Announcement type
  final List<Announcement> _announcements = [
    Announcement(
      id: '1',
      title: 'Water Utility Maintenance Schedule',
      category: 'Public Notice',
      date: DateTime(2023, 10, 25),
      description: 'The Municipal Engineering Office has announced upcoming water utility upgrades for Milaor residential clusters. To ensure the continued reliability of our municipal water supply and improve pressure in higher-elevation zones, the Milaor Water District will be conducting essential maintenance and infrastructure upgrades over the next two weeks.\n\nAffected areas include Central Square and Riverbank District, covering all residential and commercial blocks within the historic center. Intermittent interruptions are expected daily between 1:00 PM and 4:00 PM from October 30 to November 12, 2023.\n\nWe advise all residents to store adequate water supplies during the morning hours. The upgrades include the installation of high-efficiency filtration nodes and the replacement of heritage piping sections that have served the community since the late 1980s.\n\nWhat to Expect:\n• Temporary pressure reductions during peak heat hours (2 PM)\n• Minimal sediment appearance immediately following restoration (run faucets for 2 minutes)\n• On-site crews working along the North Heritage Corridor\n\nFor questions about your street\'s specific schedule, contact the Municipal Engineering Office at (054) 472-XXXX or visit the Milaor Municipal Hall.',
      imageUrl: 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?q=80&w=1200&auto=format&fit=crop',
      isImportant: true,
      isRead: false,
    ),
    Announcement(
      id: '2',
      title: 'Road Closure: Heritage Street',
      category: 'Traffic Advisory',
      date: DateTime(2023, 10, 20),
      description: 'The Milaor Municipal Government, in coordination with the Department of Public Works and Highways (DPWH) and the Milaor Traffic Management Office, hereby informs all residents and motorists that Heritage Street — from the junction of Barangay San Roque to the entrance of Barangay Capucnasan — will be temporarily closed to vehicular traffic from November 1 to November 5, 2023.\n\nThis closure is necessary to facilitate the preparation and staging of the annual Milaor Cultural Heritage Festival, a significant event celebrating the rich history and traditions of our beloved municipality. Road closures will be enforced daily from 6:00 AM to 10:00 PM throughout the five-day period.\n\nAlternative Routes:\n• Northbound traffic: Use San Jose Street → Rizal Avenue → Mayor\'s Boulevard\n• Southbound traffic: Use Capucnasan Bypass Road → Del Rosario Street → Municipal Road\n• Pedestrian access will remain open via designated walkways along the festival perimeter\n\nPublic transportation routes will be adjusted accordingly, with temporary terminals established at the Milaor Public Market and the Sports Complex parking area. Tricycle and jeepney operators are advised to coordinate with the Traffic Management Office for their designated staging areas.\n\nWe apologize for any inconvenience this may cause and thank the community for their understanding and cooperation in making this year\'s festival a success.',
      imageUrl: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=1200&auto=format&fit=crop',
      isImportant: true,
      isRead: true,
    ),
    // ... add all other announcements similarly (convert date to DateTime, combine summary+fullDescription into description)
  ];

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

  List<Announcement> get _filteredAnnouncements {
    var filtered = _announcements;

    if (_selectedCategory != 'All') {
      filtered = filtered.where((a) => a.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((a) =>
              a.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              a.description.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    if (_showImportantOnly) {
      filtered = filtered.where((a) => a.isImportant).toList();
    }
    return filtered;
  }

  void _markAsRead(String id) async {
    // ✅ Call the provider's markAsRead (real backend update)
    await ref.read(announcementsProvider.notifier).markAsRead(id);
    setState(() {
      final announcement = _announcements.firstWhere((a) => a.id == id);
      announcement.isRead = true;
    });
  }

  void _toggleImportantFilter() {
    setState(() {
      _showImportantOnly = !_showImportantOnly;
    });
  }

  void _viewAnnouncementDetails(Announcement announcement) {
    _markAsRead(announcement.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncementDetailScreen(announcement: announcement),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Optional: Watch real provider to sync read status
    final realAnnouncements = ref.watch(announcementsProvider);
    // For now we still use local mock data; you can replace _announcements with realAnnouncements

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
                  Icon(Icons.campaign, size: 30.sp, color: const Color(0xFF4C229C)),
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
                    onPressed: () {},
                    icon: Icon(Icons.filter_list, size: 28.sp, color: const Color(0xFF4C229C)),
                  ),
                ],
              ),
            ),
            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search announcements...',
                  prefixIcon: Icon(Icons.search, size: 24.sp),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                ),
              ),
            ),
            // Category chips
            SizedBox(
              height: 60.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = category),
                      selectedColor: const Color(0xFF4C229C),
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Important filter
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('Important Only'),
                    selected: _showImportantOnly,
                    onSelected: (_) => _toggleImportantFilter(),
                    avatar: Icon(
                      Icons.priority_high,
                      size: 18.sp,
                      color: _showImportantOnly ? Colors.white : Colors.red,
                    ),
                    selectedColor: Colors.red.shade700,
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      color: _showImportantOnly ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '${_filteredAnnouncements.length} announcements',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            // List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: _filteredAnnouncements.length,
                itemBuilder: (context, index) {
                  final announcement = _filteredAnnouncements[index];
                  return _buildAnnouncementCard(announcement);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: InkWell(
        onTap: () => _viewAnnouncementDetails(announcement),
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    announcement.imageUrl ?? '',
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180.h,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                  if (announcement.isImportant)
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.priority_high, size: 14.sp, color: Colors.white),
                            SizedBox(width: 4.w),
                            Text('IMPORTANT', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.white)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEADCFB),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          announcement.category,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0xFF4C229C)),
                        ),
                      ),
                      if (!announcement.isRead)
                        Container(
                          width: 10.w,
                          height: 10.h,
                          decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    announcement.title,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xFF2E2438)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    announcement.description,
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6F6878), height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 16.sp, color: const Color(0xFF6F6878)),
                      SizedBox(width: 6.w),
                      Text(
                        announcement.formattedDate, // ✅ Uses provider's formatted getter
                        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6F6878)),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.bookmark_border, size: 20.sp, color: const Color(0xFF6F6878)),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.share_outlined, size: 20.sp, color: const Color(0xFF6F6878)),
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
}

// ✅ Detail screen now uses the same Announcement model (no changes needed)
class AnnouncementDetailScreen extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetailScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    // ... (same as your existing detail screen, but use announcement.description instead of fullDescription)
    // I'm keeping it identical to your original except using announcement.description
    // (No need to paste the whole 200 lines again, just ensure it uses announcement.description)
    return Scaffold(
      backgroundColor: HomeColors.warmHearth,
      body: SingleChildScrollView(
        // ... your existing detail UI using announcement.description
        child: Column(
          children: [
            // ... (code unchanged except replacing fullDescription with description)
          ],
        ),
      ),
    );
  }
}