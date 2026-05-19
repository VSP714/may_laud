import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../home/home.dart';

class AnnouncementsListScreen extends StatefulWidget {
  const AnnouncementsListScreen({super.key});

  @override
  State<AnnouncementsListScreen> createState() =>
      _AnnouncementsListScreenState();
}

class _AnnouncementsListScreenState extends State<AnnouncementsListScreen> {
  final List<Announcement> _announcements = [
    Announcement(
      id: '1',
      title: 'Water Utility Maintenance Schedule',
      category: 'Public Notice',
      date: 'Oct 25, 2023',
      summary:
          'The Municipal Engineering Office has announced upcoming water utility upgrades for Milaor residential clusters.',
      fullDescription:
          'The Municipal Engineering Office has announced the upcoming water utility upgrade cycle for the Milaor residential clusters. To ensure the continued reliability of our municipal water supply and improve pressure in higher-elevation zones, the Milaor Water District will be conducting essential maintenance and infrastructure upgrades over the next two weeks.\n\nAffected areas include Central Square and Riverbank District, covering all residential and commercial blocks within the historic center. Intermittent interruptions are expected daily between 1:00 PM and 4:00 PM from October 30 to November 12, 2023.\n\nWe advise all residents to store adequate water supplies during the morning hours. The upgrades include the installation of high-efficiency filtration nodes and the replacement of heritage piping sections that have served the community since the late 1980s.\n\nWhat to Expect:\n• Temporary pressure reductions during peak heat hours (2 PM)\n• Minimal sediment appearance immediately following restoration (run faucets for 2 minutes)\n• On-site crews working along the North Heritage Corridor\n\nFor questions about your street\'s specific schedule, contact the Municipal Engineering Office at (054) 472-XXXX or visit the Milaor Municipal Hall.',
      imageUrl:
          'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?q=80&w=1200&auto=format&fit=crop',
      isImportant: true,
      isRead: false,
    ),
    Announcement(
      id: '2',
      title: 'Road Closure: Heritage Street',
      category: 'Traffic Advisory',
      date: 'Oct 20, 2023',
      summary:
          'Heritage Street will be closed for cultural festival preparations from Nov 1-5.',
      fullDescription:
          'The Milaor Municipal Government, in coordination with the Department of Public Works and Highways (DPWH) and the Milaor Traffic Management Office, hereby informs all residents and motorists that Heritage Street — from the junction of Barangay San Roque to the entrance of Barangay Capucnasan — will be temporarily closed to vehicular traffic from November 1 to November 5, 2023.\n\nThis closure is necessary to facilitate the preparation and staging of the annual Milaor Cultural Heritage Festival, a significant event celebrating the rich history and traditions of our beloved municipality. Road closures will be enforced daily from 6:00 AM to 10:00 PM throughout the five-day period.\n\nAlternative Routes:\n• Northbound traffic: Use San Jose Street → Rizal Avenue → Mayor\'s Boulevard\n• Southbound traffic: Use Capucnasan Bypass Road → Del Rosario Street → Municipal Road\n• Pedestrian access will remain open via designated walkways along the festival perimeter\n\nPublic transportation routes will be adjusted accordingly, with temporary terminals established at the Milaor Public Market and the Sports Complex parking area. Tricycle and jeepney operators are advised to coordinate with the Traffic Management Office for their designated staging areas.\n\nWe apologize for any inconvenience this may cause and thank the community for their understanding and cooperation in making this year\'s festival a success.',
      imageUrl:
          'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=1200&auto=format&fit=crop',
      isImportant: true,
      isRead: true,
    ),
    Announcement(
      id: '3',
      title: 'Free Vaccination Drive',
      category: 'Health',
      date: 'Oct 18, 2023',
      summary:
          'Free flu vaccination drive at the Municipal Health Center this Saturday.',
      fullDescription:
          'The Milaor Municipal Health Office, in partnership with the Department of Health (DOH) Region V, is pleased to announce a FREE community vaccination drive this coming Saturday, October 21, 2023, at the Milaor Municipal Health Center from 8:00 AM to 4:00 PM.\n\nAvailable Vaccines:\n• Influenza (Flu) Vaccine — for all ages 6 months and above\n• Pneumococcal Vaccine — for senior citizens (60 years old and above)\n• Tetanus-Diphtheria (Td) Booster — for adults and adolescents\n• HPV Vaccine — for females aged 9-26 years old (limited supply, first-come, first-served)\n\nWhat to Bring:\n• Valid ID with proof of Milaor residency\n• Vaccination card or baby book (for children)\n• Senior Citizen ID or OSCA ID (for senior citizens)\n\nWalk-ins are welcome, but pre-registration is encouraged through your respective Barangay Health Center to minimize waiting time. Medical professionals will be on-site to conduct brief health screenings prior to vaccination.\n\nLight refreshments will be provided, and free health counseling services will also be available throughout the day. Protecting our community starts with each one of us — magpabakuna para sa ligtas na Milaor!',
      imageUrl:
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?q=80&w=1200&auto=format&fit=crop',
      isImportant: false,
      isRead: true,
    ),
    Announcement(
      id: '4',
      title: 'Tax Payment Extension',
      category: 'Government',
      date: 'Oct 15, 2023',
      summary: 'Deadline for property tax payments extended to November 30.',
      fullDescription:
          'The Office of the Municipal Treasurer, by authority of the Municipal Mayor and in accordance with Municipal Ordinance No. 2023-045, hereby informs all property owners in Milaor that the deadline for the payment of Real Property Tax (RPT) for the calendar year 2023 has been extended from October 31 to November 30, 2023.\n\nThis extension is granted in consideration of the recent economic challenges faced by our community, including the impact of Typhoon Karding and the ongoing recovery efforts in several barangays. The extension applies to:\n\n• Basic Real Property Tax (Land and Improvements)\n• Special Education Fund (SEF) Tax\n• Barangay Share of Real Property Tax\n\nPayment Options:\n• In-person at the Municipal Treasurer\'s Office, Milaor Municipal Hall (Monday-Friday, 8:00 AM - 5:00 PM)\n• Through authorized payment centers: Palawan Pawnshop, MLhuillier, and Cebuana Lhuillier branches within Milaor\n• Online via the Land Bank of the Philippines Link.BizPortal (visit www.landbank.com for instructions)\n\nImportant Notes:\n• A 10% discount on the basic tax still applies for those who can pay on or before the original October 31 deadline\n• Payments made from November 1-30 will be at the full assessed amount without penalty\n• A 2% monthly surcharge will be applied for payments made after November 30\n\nFor inquiries regarding your property assessment or tax computation, please contact the Municipal Assessor\'s Office at (054) 472-XXXX or email assessor@milaor.gov.ph.',
      imageUrl:
          'https://images.unsplash.com/photo-1554224155-6726b3ff858f?q=80&w=1200&auto=format&fit=crop',
      isImportant: false,
      isRead: false,
    ),
    Announcement(
      id: '5',
      title: 'Community Town Hall Meeting',
      category: 'Event',
      date: 'Oct 12, 2023',
      summary:
          'Monthly town hall meeting to discuss community projects and concerns.',
      fullDescription:
          'The Milaor Municipal Council, in partnership with the Liga ng mga Barangay, invites all residents to the Monthly Community Town Hall Meeting on Saturday, October 28, 2023, from 1:00 PM to 5:00 PM at the Milaor Sports Complex Covered Court.\n\nThis month\'s town hall will focus on the following agenda items:\n\n1. Progress Report on the Milaor River Flood Control Project — Presentation by the Municipal Engineering Office on the status of the river embankment reinforcement in Barangays San Roque, Capucnasan, and Del Rosario.\n\n2. 2024 Budget Consultation — The Municipal Budget Office will present the proposed budget allocation for the upcoming fiscal year. Residents are encouraged to share their input on priority projects and community needs.\n\n3. Barangay Development Updates — Each Barangay Captain will provide a brief report on ongoing and completed projects in their respective areas.\n\n4. Open Forum — An opportunity for residents to raise concerns, ask questions, and propose initiatives directly to municipal officials and department heads.\n\n5. Community Recognition — Honoring outstanding Milaoreños who have contributed significantly to local development and community service.\n\nRefreshments will be served after the program. Transportation assistance is available for senior citizens and persons with disabilities — please coordinate with your Barangay Hall at least two days before the event.\n\nYour voice matters in building a better Milaor. Kita-kits sa Town Hall!',
      imageUrl:
          'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?q=80&w=1200&auto=format&fit=crop',
      isImportant: false,
      isRead: true,
    ),
    Announcement(
      id: '6',
      title: 'Garbage Collection Schedule Change',
      category: 'Public Service',
      date: 'Oct 10, 2023',
      summary: 'New garbage collection schedule effective November 1.',
      fullDescription:
          'The Milaor Municipal Environment and Natural Resources Office (MENRO), in compliance with Republic Act No. 9003 (Ecological Solid Waste Management Act of 2000), announces the implementation of a revised garbage collection schedule effective November 1, 2023.\n\nNew Collection Schedule by Barangay:\n\nMonday & Thursday:\n• Barangay San Roque (Poblacion area)\n• Barangay Capucnasan\n• Barangay Del Rosario\n\nTuesday & Friday:\n• Barangay San Antonio\n• Barangay San Jose\n• Barangay San Vicente\n\nWednesday & Saturday:\n• Barangay Mayaopayawan\n• Barangay San Miguel\n• Barangay San Rafael\n\nImportant Guidelines:\n• Please place garbage in properly sealed bags or containers at your designated collection point before 6:00 AM on collection days\n• Segregate waste according to the following categories: Biodegradable (nabubulok), Non-Biodegradable (di-nabubulok), and Recyclables (maaaring i-recycle)\n• Hazardous waste (batteries, paint, chemicals) must be brought to the designated drop-off point at the Municipal MRF (Materials Recovery Facility)\n• Bulky items and construction debris require special collection — schedule pickup by calling the MENRO hotline\n\nThe municipality has also launched a Barangay Cleanliness Competition with cash prizes for the cleanest barangay each quarter. For violations, complaints, or special collection requests, contact MENRO at (054) 472-XXXX or visit the Municipal Hall, 2nd Floor, MENRO Office.',
      imageUrl:
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?q=80&w=1200&auto=format&fit=crop',
      isImportant: false,
      isRead: false,
    ),
    Announcement(
      id: '7',
      title: 'Flood Preparedness Workshop',
      category: 'Disaster Preparedness',
      date: 'Oct 8, 2023',
      summary: 'Free workshop on flood preparedness and emergency response.',
      fullDescription:
          'The Milaor Municipal Disaster Risk Reduction and Management Office (MDRRMO), in collaboration with the Office of Civil Defense (OCD) Region V and the Philippine Red Cross Camarines Sur Chapter, will conduct a FREE Community Flood Preparedness Workshop on Saturday, October 14, 2023, from 8:00 AM to 4:00 PM at the Milaor Evacuation Center.\n\nWorkshop Topics:\n\n1. Understanding Flood Risks in Milaor — Learn about flood-prone areas, the Bicol River Basin flood patterns, and early warning systems specific to our municipality.\n\n2. Family Emergency Planning — Create your household\'s disaster preparedness plan, including communication strategies, evacuation routes, and emergency supply kits.\n\n3. First Aid and Basic Life Support — Hands-on training on CPR, wound management, and water-related emergency response by certified Red Cross instructors.\n\n4. Emergency Kit Assembly — Demonstration and distribution of basic "Go Bags" — participants will learn what to pack and how to maintain emergency supplies.\n\n5. Community Early Warning System — Training on the Milaor Alert System, including SMS alerts, barangay sirens, and the Milaud mobile app flood monitoring feature.\n\nWho Should Attend:\n• Barangay officials and tanods\n• School disaster risk reduction coordinators\n• Community volunteers and youth leaders\n• All concerned residents of flood-prone areas\n\nLunch and workshop materials will be provided. Certificates of participation will be issued by the MDRRMO. Pre-register at your Barangay Hall or through the Milaud app. Sa tamang kaalaman, ligtas ang bawat Milaoreño!',
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200&auto=format&fit=crop',
      isImportant: true,
      isRead: false,
    ),
    Announcement(
      id: '8',
      title: 'Business Permit Renewal',
      category: 'Business',
      date: 'Oct 5, 2023',
      summary: 'Renew your business permits online through the Milaud portal.',
      fullDescription:
          'The Business Permits and Licensing Office (BPLO) of Milaor announces the opening of the Business Permit Renewal period for the calendar year 2024. All business owners operating within the municipality are required to renew their permits from January 2 to January 20, 2024.\n\nWhat\'s New This Year:\n\n• ONLINE RENEWAL — For the first time, business permit renewals can now be processed through the new Milaud e-Services Portal! This streamlines the process and reduces waiting time at the Municipal Hall.\n\n• ONE-STOP SHOP — From January 2-20, a One-Stop Business Renewal Center will operate at the Milaor Sports Complex Lobby, consolidating all required offices (BPLO, Treasurer\'s Office, Fire Department, Sanitary Office, and Zoning Office) in one location.\n\nRequirements for Renewal:\n• Duly accomplished application form (available at BPLO or downloadable from the Milaud portal)\n• Previous year\'s Business Permit (original copy)\n• Updated Community Tax Certificate (Cedula)\n• Barangay Clearance (from the barangay where the business is located)\n• Fire Safety Inspection Certificate (for establishments with building area over 50 sqm)\n• Sanitary Permit (for food-related and health service businesses)\n• Latest audited financial statements (for corporations and partnerships)\n\nEarly Bird Incentive:\n• Renew by January 10 and receive a 10% discount on regulatory fees!\n• Businesses with complete requirements processed online will receive a FREE one-year subscription to the Milaud Business Directory.\n\nPenalties:\n• A 25% surcharge on the business tax plus 2% monthly interest will be imposed for late renewals.\n• Businesses operating without a valid permit may face closure orders.\n\nFor assistance, visit the BPLO at the Milaor Municipal Hall, Ground Floor, or call (054) 472-XXXX. You may also email bplo@milaor.gov.ph.',
      imageUrl:
          'https://images.unsplash.com/photo-1556761175-b413da4baf72?q=80&w=1200&auto=format&fit=crop',
      isImportant: false,
      isRead: true,
    ),
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

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((a) => a.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((a) =>
              a.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              a.summary.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Filter by important only
    if (_showImportantOnly) {
      filtered = filtered.where((a) => a.isImportant).toList();
    }

    return filtered;
  }

  void _markAsRead(String id) {
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
    // Navigate to announcement detail screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AnnouncementDetailScreen(announcement: announcement),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  Icon(
                    Icons.campaign,
                    size: 30.sp,
                    color: const Color(0xFF4C229C),
                  ),
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
                    icon: Icon(
                      Icons.filter_list,
                      size: 28.sp,
                      color: const Color(0xFF4C229C),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search announcements...',
                  prefixIcon: Icon(Icons.search, size: 24.sp),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                ),
              ),
            ),

            // Category filter chips
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
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
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

            // Important filter toggle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  FilterChip(
                    label: Text('Important Only'),
                    selected: _showImportantOnly,
                    onSelected: (selected) => _toggleImportantFilter(),
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
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Announcements list
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: () => _viewAnnouncementDetails(announcement),
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: Stack(
                children: [
                  Image.network(
                    announcement.imageUrl,
                    height: 180.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (announcement.isImportant)
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.priority_high,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'IMPORTANT',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
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
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEADCFB),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          announcement.category,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4C229C),
                          ),
                        ),
                      ),
                      if (!announcement.isRead)
                        Container(
                          width: 10.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    announcement.title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E2438),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    announcement.summary,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF6F6878),
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16.sp,
                        color: const Color(0xFF6F6878),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        announcement.date,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF6F6878),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.bookmark_border,
                          size: 20.sp,
                          color: const Color(0xFF6F6878),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.share_outlined,
                          size: 20.sp,
                          color: const Color(0xFF6F6878),
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
}

class Announcement {
  final String id;
  final String title;
  final String category;
  final String date;
  final String summary;
  final String fullDescription;
  final String imageUrl;
  final bool isImportant;
  bool isRead;

  Announcement({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.summary,
    required this.fullDescription,
    required this.imageUrl,
    required this.isImportant,
    required this.isRead,
  });
}

class AnnouncementDetailScreen extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetailScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final imageHeight = 300.h;
    final cardOverlap = 40.h;

    return Scaffold(
      backgroundColor: HomeColors.warmHearth,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Hero Image + Gradient + Title Card (all in one Stack) ──
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Hero Image
                ClipRRect(
                  child: SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: Image.network(
                      announcement.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: HomeColors.riverFlow.withOpacity(0.3),
                        child: Center(
                          child: Icon(Icons.campaign,
                              size: 64.sp,
                              color:
                                  HomeColors.heritagePurple.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ),
                ),

                // Gradient Overlay
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          HomeColors.deepAnchor.withOpacity(0.7),
                          HomeColors.heritagePurple.withOpacity(0.4),
                          HomeColors.deepAnchor.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                ),

                // Back Button & Top Actions
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8.h,
                  left: 8.w,
                  right: 8.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back,
                              size: 22.sp, color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.bookmark_border,
                                  size: 22.sp, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.share_outlined,
                                  size: 22.sp, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Category & Important tags (bottom-left of image)
                Positioned(
                  bottom: cardOverlap + 16.h,
                  left: 20.w,
                  right: 20.w,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 7.h),
                        decoration: BoxDecoration(
                          color: HomeColors.heritagePurple,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          announcement.category,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      if (announcement.isImportant) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 7.h),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.priority_high,
                                  size: 14.sp, color: Colors.white),
                              SizedBox(width: 3.w),
                              Text(
                                'IMPORTANT',
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Title Card (overlapping the bottom of the image)
                Positioned(
                  left: 16.w,
                  right: 16.w,
                  bottom: -cardOverlap,
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: HomeColors.cardWhite,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: HomeColors.deepAnchor.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                size: 15.sp, color: HomeColors.riverFlow),
                            SizedBox(width: 6.w),
                            Text(
                              'Published ${announcement.date}',
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: HomeColors.riverFlow,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          announcement.title,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: HomeColors.deepAnchor,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Extra space so title card doesn't clip into description ──
            SizedBox(height: cardOverlap + 8.h),

            // ── Full Description Content ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4.w,
                        height: 22.h,
                        decoration: BoxDecoration(
                          color: HomeColors.heritagePurple,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Full Details',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: HomeColors.deepAnchor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: HomeColors.cardWhite,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                          color: HomeColors.warmHearth.withOpacity(0.8),
                          width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: HomeColors.deepAnchor.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      announcement.fullDescription,
                      style: TextStyle(
                        fontSize: 15.sp,
                        height: 1.8,
                        color: const Color(0xFF495057),
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.print_outlined, size: 18.sp),
                          label:
                              Text('Print', style: TextStyle(fontSize: 14.sp)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: HomeColors.heritagePurple,
                            side: BorderSide(color: HomeColors.heritagePurple),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r)),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.info_outline, size: 18.sp),
                          label: Text('Report Issue',
                              style: TextStyle(fontSize: 14.sp)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: HomeColors.heritagePurple,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
