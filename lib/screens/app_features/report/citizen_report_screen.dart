// lib/screens/app_features/report/citizen_report_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../home/home.dart';
import '../../home/nav_bar_button.dart';
import '../../../services/app_services.dart';
import '../../../utils/guest_guard.dart'; // ✅ Import guest guard

// ─── REPORT COLOR PALETTE ─────────────────────────────
class ReportColors {
  static const Color heritagePurple = HomeColors.heritagePurple;
  static const Color deepAnchor = HomeColors.deepAnchor;
  static const Color warmHearth = HomeColors.warmHearth;
  static const Color cardWhite = HomeColors.cardWhite;
  static const Color riverFlow = HomeColors.riverFlow;

  static const Color priorityLow = Color(0xFF22C55E);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityHigh = Color(0xFFF97316);
  static const Color priorityEmergency = Color(0xFFEF4444);

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepAnchor, heritagePurple],
  );

  static const LinearGradient submitGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [heritagePurple, riverFlow],
  );
}

class CitizenReportScreen extends ConsumerStatefulWidget {
  const CitizenReportScreen({super.key});

  @override
  ConsumerState<CitizenReportScreen> createState() => _CitizenReportScreenState();
}

class _CitizenReportScreenState extends ConsumerState<CitizenReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _selectedCategory = 'Infrastructure';
  String _selectedPriority = 'Medium';
  final List<File> _attachedPhotos = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  final CitizenReportService _reportService = CitizenReportService();

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Infrastructure',
      'icon': Icons.construction_rounded,
      'color': const Color(0xFF6366F1)
    },
    {
      'name': 'Sanitation',
      'icon': Icons.cleaning_services_rounded,
      'color': const Color(0xFF22C55E)
    },
    {
      'name': 'Security',
      'icon': Icons.security_rounded,
      'color': const Color(0xFF0EA5E9)
    },
    {
      'name': 'Traffic',
      'icon': Icons.traffic_rounded,
      'color': const Color(0xFFF59E0B)
    },
    {
      'name': 'Environment',
      'icon': Icons.eco_rounded,
      'color': const Color(0xFF10B981)
    },
    {
      'name': 'Health',
      'icon': Icons.medical_services_rounded,
      'color': const Color(0xFFEF4444)
    },
    {
      'name': 'Other',
      'icon': Icons.more_horiz_rounded,
      'color': const Color(0xFF8B5CF6)
    },
  ];

  final List<Map<String, dynamic>> _priorities = [
    {
      'level': 'Low',
      'label': 'Routine issue',
      'icon': Icons.flag_rounded,
      'color': ReportColors.priorityLow
    },
    {
      'level': 'Medium',
      'label': 'Needs attention',
      'icon': Icons.flag_rounded,
      'color': ReportColors.priorityMedium
    },
    {
      'level': 'High',
      'label': 'Urgent concern',
      'icon': Icons.flag_rounded,
      'color': ReportColors.priorityHigh
    },
    {
      'level': 'Emergency',
      'label': 'Immediate action',
      'icon': Icons.warning_rounded,
      'color': ReportColors.priorityEmergency
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) setState(() => _attachedPhotos.add(File(image.path)));
  }

  Future<void> _pickFromCamera() async {
    final XFile? photo =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (photo != null) setState(() => _attachedPhotos.add(File(photo.path)));
  }

  void _removePhoto(int index) =>
      setState(() => _attachedPhotos.removeAt(index));

  // ─── SUBMIT REPORT WITH GUEST CHECK ──────────────────
  Future<void> _submitReport() async {
    // ✅ Guest restriction: guests cannot submit reports
    if (GuestGuard.isGuest(ref)) {
      await GuestGuard.showGuestRestrictionDialog(context);
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final result = await _reportService.submitReport(
        categoryId: _selectedCategory,
        subcategory: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        photoFiles: _attachedPhotos,
      );

      if (!mounted) return;
      _showSuccessDialog(
        reportId: result['reportId'] as String,
        assignedTo: result['assignedTo'] as String,
        estimatedResolution: result['estimatedResolution'] as String,
      );
    } catch (e) {
      if (!mounted) return;
      _showSnack('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog({
    required String reportId,
    required String assignedTo,
    required String estimatedResolution,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(28.w),
          decoration: BoxDecoration(
            color: ReportColors.cardWhite,
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: const Icon(Icons.check_circle_rounded,
                    size: 40, color: Color(0xFF2E7D32)),
              ),
              SizedBox(height: 20.h),
              Text(
                'Report Submitted!',
                style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: ReportColors.deepAnchor),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: ReportColors.warmHearth,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  reportId,
                  style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: ReportColors.heritagePurple,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Thank you, kababayan! Your concern has been forwarded to $assignedTo. Estimated resolution: $estimatedResolution.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 14.sp, color: Colors.grey[600], height: 1.6),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainApp()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ReportColors.heritagePurple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r)),
                    elevation: 0,
                  ),
                  child: Text(
                    'OK, understood',
                    style: GoogleFonts.inter(
                        fontSize: 15.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        margin: EdgeInsets.all(12.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ReportColors.warmHearth,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildCategorySection(),
                  SizedBox(height: 20.h),
                  _buildPrioritySection(),
                  SizedBox(height: 20.h),
                  _buildDetailsCard(),
                  SizedBox(height: 20.h),
                  _buildLocationCard(),
                  SizedBox(height: 20.h),
                  _buildPhotoCard(),
                  SizedBox(height: 24.h),
                  _buildSubmitButton(),
                  SizedBox(height: 16.h),
                  _buildInfoBanner(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SLIVER APP BAR ─────────────────────────────────
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180.h,
      pinned: true,
      elevation: 0,
      backgroundColor: ReportColors.heritagePurple,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration:
              const BoxDecoration(gradient: ReportColors.headerGradient),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: const Icon(Icons.report_problem_rounded,
                            color: Colors.white, size: 26),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CITIZEN REPORT',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white54,
                                letterSpacing: 3,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Report an Issue',
                              style: GoogleFonts.poppins(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    'Help improve Milaor by reporting community issues. Your report will be reviewed by the appropriate department.',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.white60,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── CATEGORY SELECTOR ──────────────────────────────
  Widget _buildCategorySection() {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Category', Icons.category_rounded),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat['name']),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (cat['color'] as Color).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isSelected
                          ? (cat['color'] as Color)
                          : Colors.grey[300]!,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(cat['icon'] as IconData,
                          size: 18.sp,
                          color: isSelected
                              ? (cat['color'] as Color)
                              : Colors.grey[500]),
                      SizedBox(width: 6.w),
                      Text(
                        cat['name'],
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? (cat['color'] as Color)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.04, end: 0);
  }

  // ─── PRIORITY SELECTOR ──────────────────────────────
  Widget _buildPrioritySection() {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Priority Level', Icons.flag_circle_rounded),
          SizedBox(height: 14.h),
          ..._priorities.map((p) {
            final isSelected = _selectedPriority == p['level'];
            final Color color = p['color'];
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () => setState(() => _selectedPriority = p['level']),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withOpacity(0.06)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isSelected ? color : Colors.grey[200]!,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: isSelected ? color : color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                        color: color.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3))
                                  ]
                                : null,
                          ),
                          child: Icon(p['icon'] as IconData,
                              color: isSelected ? Colors.white : color,
                              size: 20.sp),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p['level'],
                                style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? ReportColors.deepAnchor
                                      : Colors.grey[700],
                                ),
                              ),
                              Text(
                                p['label'],
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_rounded,
                                color: Colors.white, size: 16),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 100.ms)
        .slideY(begin: 0.04, end: 0);
  }

  // ─── DETAILS CARD ───────────────────────────────────
  Widget _buildDetailsCard() {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Issue Details', Icons.description_rounded),
          SizedBox(height: 16.h),
          _buildTextField(
            controller: _titleController,
            hint: 'Brief title of the issue',
            icon: Icons.title_rounded,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter a title' : null,
          ),
          SizedBox(height: 14.h),
          _buildTextField(
            controller: _descriptionController,
            hint:
                'Describe the issue in detail — what happened, when, and who is affected...',
            icon: Icons.article_rounded,
            maxLines: 5,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Please enter a description'
                : null,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideY(begin: 0.04, end: 0);
  }

  // ─── LOCATION CARD ──────────────────────────────────
  Widget _buildLocationCard() {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Location', Icons.location_on_rounded),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _locationController,
                  hint: 'Street, Barangay, or Landmark',
                  icon: Icons.pin_drop_rounded,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter a location'
                      : null,
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () => _showSnack('Getting current location...'),
                child: Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: ReportColors.heritagePurple.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                        color: ReportColors.heritagePurple.withOpacity(0.15)),
                  ),
                  child: Icon(Icons.my_location_rounded,
                      size: 22.sp, color: ReportColors.heritagePurple),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 300.ms)
        .slideY(begin: 0.04, end: 0);
  }

  // ─── PHOTO CARD ─────────────────────────────────────
  Widget _buildPhotoCard() {
    return Container(
      padding: EdgeInsets.all(22.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Photo Evidence', Icons.camera_alt_rounded),
              if (_attachedPhotos.isNotEmpty)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ReportColors.heritagePurple.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${_attachedPhotos.length} attached',
                    style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: ReportColors.heritagePurple),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Photos help us understand the issue better (optional)',
            style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey[500]),
          ),
          SizedBox(height: 16.h),
          if (_attachedPhotos.isNotEmpty)
            SizedBox(
              height: 120.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _attachedPhotos.length + 1,
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  if (index == _attachedPhotos.length) return _addPhotoThumb();
                  return _photoThumb(index);
                },
              ),
            )
          else
            _emptyPhotoArea(),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 400.ms)
        .slideY(begin: 0.04, end: 0);
  }

  Widget _emptyPhotoArea() {
    return GestureDetector(
      onTap: _showPhotoSourcePicker,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 32.h),
        decoration: BoxDecoration(
          color: ReportColors.warmHearth,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
              color: ReportColors.heritagePurple.withOpacity(0.15), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: ReportColors.heritagePurple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(Icons.add_a_photo_rounded,
                  size: 26.sp, color: ReportColors.heritagePurple),
            ),
            SizedBox(height: 12.h),
            Text(
              'Tap to add photos',
              style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: ReportColors.heritagePurple),
            ),
            SizedBox(height: 4.h),
            Text(
              'Gallery or Camera',
              style:
                  GoogleFonts.inter(fontSize: 12.sp, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addPhotoThumb() {
    return GestureDetector(
      onTap: _showPhotoSourcePicker,
      child: Container(
        width: 110.w,
        height: 120.h,
        decoration: BoxDecoration(
          color: ReportColors.heritagePurple.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
              color: ReportColors.heritagePurple.withOpacity(0.2), width: 1.5),
        ),
        child: Icon(Icons.add_rounded,
            size: 30.sp, color: ReportColors.heritagePurple.withOpacity(0.6)),
      ),
    );
  }

  Widget _photoThumb(int index) {
    return Stack(
      children: [
        Container(
          width: 110.w,
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            image: DecorationImage(
                image: FileImage(_attachedPhotos[index]), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 6.w,
          right: 6.w,
          child: GestureDetector(
            onTap: () => _removePhoto(index),
            child: Container(
              width: 26.w,
              height: 26.w,
              decoration: const BoxDecoration(
                  color: Colors.black54, shape: BoxShape.circle),
              child:
                  Icon(Icons.close_rounded, size: 15.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _showPhotoSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(ctx).padding.bottom + 20.h),
        decoration: BoxDecoration(
          color: ReportColors.cardWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r)),
            ),
            SizedBox(height: 22.h),
            Text('Add Photo',
                style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: ReportColors.deepAnchor)),
            SizedBox(height: 22.h),
            _photoOption(
              icon: Icons.camera_alt_rounded,
              title: 'Take a Photo',
              subtitle: 'Use your camera',
              onTap: () {
                Navigator.pop(ctx);
                _pickFromCamera();
              },
            ),
            _photoOption(
              icon: Icons.photo_library_rounded,
              title: 'Choose from Gallery',
              subtitle: 'Pick from your photos',
              onTap: () {
                Navigator.pop(ctx);
                _pickFromGallery();
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _photoOption(
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: ReportColors.heritagePurple.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(icon, size: 24.sp, color: ReportColors.heritagePurple),
      ),
      title: Text(title,
          style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: ReportColors.deepAnchor)),
      subtitle: Text(subtitle,
          style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.grey[500])),
    );
  }

  // ─── SUBMIT BUTTON ──────────────────────────────────
  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 58.h,
      decoration: BoxDecoration(
        gradient: ReportColors.submitGradient,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: ReportColors.heritagePurple.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: _isSubmitting ? null : _submitReport,
          child: Center(
            child: _isSubmitting
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.send_rounded,
                          color: Colors.white, size: 22),
                      SizedBox(width: 10.w),
                      Text(
                        'Submit Report',
                        style: GoogleFonts.poppins(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 500.ms);
  }

  // ─── INFO BANNER ────────────────────────────────────
  Widget _buildInfoBanner() {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: ReportColors.cardWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E0F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: ReportColors.heritagePurple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.info_outline_rounded,
                size: 20.sp, color: ReportColors.heritagePurple),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Your report will be reviewed within 24–48 hours. For emergencies, please call the Milaor hotline directly.',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 600.ms);
  }

  // ─── SHARED HELPERS ─────────────────────────────────
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: ReportColors.cardWhite,
      borderRadius: BorderRadius.circular(24.r),
      boxShadow: [
        BoxShadow(
          color: ReportColors.heritagePurple.withOpacity(0.06),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 34.w,
          height: 34.w,
          decoration: BoxDecoration(
            color: ReportColors.heritagePurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.sp, color: ReportColors.heritagePurple),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: ReportColors.deepAnchor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: ReportColors.deepAnchor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.inter(fontSize: 14.sp, color: const Color(0xFFBDBDBD)),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Icon(icon,
              size: 20.sp, color: ReportColors.heritagePurple.withOpacity(0.5)),
        ),
        filled: true,
        fillColor: ReportColors.warmHearth,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide:
              const BorderSide(color: ReportColors.heritagePurple, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: maxLines > 1 ? 16.h : 14.h),
      ),
      validator: validator,
    );
  }
}