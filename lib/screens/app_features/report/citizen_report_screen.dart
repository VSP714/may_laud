import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../home/home.dart';
import '../../home/main_app.dart';
import '../../../services/app_services.dart';

class CitizenReportScreen extends StatefulWidget {
  const CitizenReportScreen({super.key});

  @override
  State<CitizenReportScreen> createState() => _CitizenReportScreenState();
}

class _CitizenReportScreenState extends State<CitizenReportScreen> {
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

  final List<String> _categories = [
    'Infrastructure',
    'Sanitation',
    'Security',
    'Traffic',
    'Environment',
    'Health',
    'Other',
  ];

  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
    'Emergency',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _attachedPhotos.add(File(image.path)));
    }
  }

  Future<void> _pickFromCamera() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) {
      setState(() => _attachedPhotos.add(File(photo.path)));
    }
  }

  void _removePhoto(int index) {
    setState(() => _attachedPhotos.removeAt(index));
  }

  Color _priorityColor(String priority) {
    return HomeColors.heritagePurple.withOpacity(
      priority == 'Low'
          ? 0.55
          : priority == 'Medium'
              ? 0.70
              : priority == 'High'
                  ? 0.85
                  : 1.0,
    );
  }

  String _priorityLabel(String priority) {
    switch (priority) {
      case 'Low':
        return 'Low — Routine issue';
      case 'Medium':
        return 'Medium — Needs attention';
      case 'High':
        return 'High — Urgent concern';
      case 'Emergency':
        return 'Emergency — Immediate action';
      default:
        return priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.warmHearth,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildHeader(),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 20.h),
                  _buildCategoryCard(),
                  SizedBox(height: 16.h),
                  _buildDetailsCard(),
                  SizedBox(height: 16.h),
                  _buildLocationCard(),
                  SizedBox(height: 16.h),
                  _buildPhotoCard(),
                  SizedBox(height: 12.h),
                  _buildSubmitButton(),
                  SizedBox(height: 12.h),
                  _buildInfoNote(),
                  SizedBox(height: 40.h),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── GRADIENT HEADER ────────────────────────────────────
  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
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
              color: HomeColors.heritagePurple.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainApp()),
                (route) => false,
              ),
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Icon(Icons.arrow_back_rounded,
                    size: 22.sp, color: Colors.white),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.report_problem_rounded,
                    size: 26.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Citizen Report',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Report an Issue or Concern',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'Help improve Milaor by reporting issues you encounter in the community. Your report will be reviewed by the appropriate department.',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white60,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── CATEGORY + PRIORITY CARD ───────────────────────────
  Widget _buildCategoryCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: HomeColors.cardWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Category'),
          SizedBox(height: 10.h),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: _dropDecoration(),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(
                  category,
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedCategory = value!),
          ),
          SizedBox(height: 20.h),
          _sectionLabel('Priority Level'),
          SizedBox(height: 10.h),
          ..._priorities.map((priority) {
            final isSelected = _selectedPriority == priority;
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: InkWell(
                onTap: () => setState(() => _selectedPriority = priority),
                borderRadius: BorderRadius.circular(12.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? HomeColors.heritagePurple.withOpacity(0.06)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? _priorityColor(priority)
                          : const Color(0xFFE0E0E0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _priorityColor(priority),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          _priorityLabel(priority),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? HomeColors.deepAnchor
                                : const Color(0xFF757575),
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          size: 20.sp,
                          color: HomeColors.heritagePurple,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─── TITLE + DESCRIPTION CARD ───────────────────────────
  Widget _buildDetailsCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: HomeColors.cardWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Issue Details'),
          SizedBox(height: 14.h),
          TextFormField(
            controller: _titleController,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: HomeColors.deepAnchor,
            ),
            decoration: InputDecoration(
              hintText: 'Brief title of the issue',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFFBDBDBD),
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Icons.title_rounded,
                size: 20.sp,
                color: HomeColors.heritagePurple.withOpacity(0.6),
              ),
              filled: true,
              fillColor: HomeColors.warmHearth,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                    color: HomeColors.heritagePurple, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFD32F2F)),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          SizedBox(height: 14.h),
          TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: HomeColors.deepAnchor,
            ),
            decoration: InputDecoration(
              hintText:
                  'Describe the issue in detail — what happened, when, and who is affected...',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFFBDBDBD),
                fontWeight: FontWeight.w400,
              ),
              alignLabelWithHint: true,
              filled: true,
              fillColor: HomeColors.warmHearth,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                    color: HomeColors.heritagePurple, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFD32F2F)),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // ─── LOCATION CARD ──────────────────────────────────────
  Widget _buildLocationCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: HomeColors.cardWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Location'),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _locationController,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: HomeColors.deepAnchor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Street, Barangay, or Landmark',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFFBDBDBD),
                    ),
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      size: 20.sp,
                      color: HomeColors.heritagePurple.withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: HomeColors.warmHearth,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                          color: HomeColors.heritagePurple, width: 1.5),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 10.w),
              InkWell(
                onTap: () => _showSnack('Getting current location...'),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: HomeColors.heritagePurple.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.my_location_rounded,
                    size: 22.sp,
                    color: HomeColors.heritagePurple,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── PHOTO ATTACHMENTS CARD ─────────────────────────────
  Widget _buildPhotoCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: HomeColors.cardWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              _sectionLabel('Photo Evidence'),
              if (_attachedPhotos.isNotEmpty)
                Text(
                  '${_attachedPhotos.length} attached',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Photos help us understand the issue better (optional)',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF9E9E9E),
              height: 1.4,
            ),
          ),
          SizedBox(height: 14.h),

          // Photo grid
          if (_attachedPhotos.isNotEmpty) ...[
            SizedBox(
              height: 110.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _attachedPhotos.length + 1,
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  // Add photo button at the end
                  if (index == _attachedPhotos.length) {
                    return _buildAddPhotoThumb(
                      onTap: _showPhotoSourcePicker,
                    );
                  }
                  // Photo thumbnail
                  return _buildPhotoThumb(
                    file: _attachedPhotos[index],
                    index: index,
                  );
                },
              ),
            ),
          ] else
            _buildEmptyPhotoArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyPhotoArea() {
    return InkWell(
      onTap: _showPhotoSourcePicker,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 28.h),
        decoration: BoxDecoration(
          color: HomeColors.warmHearth,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: HomeColors.heritagePurple.withOpacity(0.15),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: HomeColors.heritagePurple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 24.sp,
                color: HomeColors.heritagePurple,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Tap to add photos',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: HomeColors.heritagePurple,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Gallery or Camera',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPhotoThumb({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 100.w,
        height: 110.h,
        decoration: BoxDecoration(
          color: HomeColors.heritagePurple.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: HomeColors.heritagePurple.withOpacity(0.2),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Icon(
          Icons.add_rounded,
          size: 28.sp,
          color: HomeColors.heritagePurple,
        ),
      ),
    );
  }

  Widget _buildPhotoThumb({required File file, required int index}) {
    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 110.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: FileImage(file),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 6.w,
          right: 6.w,
          child: GestureDetector(
            onTap: () => _removePhoto(index),
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.close_rounded, size: 14.sp, color: Colors.white),
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
            EdgeInsets.only(bottom: MediaQuery.of(ctx).padding.bottom + 16.h),
        decoration: BoxDecoration(
          color: HomeColors.cardWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h),
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Add Photo',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: HomeColors.deepAnchor,
              ),
            ),
            SizedBox(height: 20.h),
            ListTile(
              onTap: () {
                Navigator.pop(ctx);
                _pickFromCamera();
              },
              leading: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: HomeColors.heritagePurple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 22.sp,
                  color: HomeColors.heritagePurple,
                ),
              ),
              title: Text(
                'Take a Photo',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: HomeColors.deepAnchor,
                ),
              ),
              subtitle: Text(
                'Use your camera',
                style:
                    TextStyle(fontSize: 13.sp, color: const Color(0xFF9E9E9E)),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(ctx);
                _pickFromGallery();
              },
              leading: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: HomeColors.heritagePurple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.photo_library_rounded,
                  size: 22.sp,
                  color: HomeColors.heritagePurple,
                ),
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: HomeColors.deepAnchor,
                ),
              ),
              subtitle: Text(
                'Pick from your photos',
                style:
                    TextStyle(fontSize: 13.sp, color: const Color(0xFF9E9E9E)),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  // ─── SUBMIT BUTTON ──────────────────────────────────────
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: HomeColors.heritagePurple,
          foregroundColor: Colors.white,
          disabledBackgroundColor: HomeColors.heritagePurple.withOpacity(0.6),
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: _isSubmitting
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, size: 20.sp),
                  SizedBox(width: 10.w),
                  Text(
                    'Submit Report',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ─── INFO NOTE ──────────────────────────────────────────
  Widget _buildInfoNote() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: HomeColors.cardWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE8E0F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20.sp,
            color: HomeColors.heritagePurple.withOpacity(0.6),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Your report will be reviewed within 24–48 hours. For emergencies requiring immediate response, please call the Milaor hotline directly.',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF757575),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── SECTION LABEL HELPER ───────────────────────────────
  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: HomeColors.deepAnchor,
        letterSpacing: -0.2,
      ),
    );
  }

  // ─── DROPDOWN DECORATION ────────────────────────────────
  InputDecoration _dropDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: HomeColors.warmHearth,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide:
            const BorderSide(color: HomeColors.heritagePurple, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );
  }

  // ─── SUBMIT LOGIC ───────────────────────────────────────
  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final result = await _reportService.submitReport(
        categoryId: _selectedCategory,
        subcategory: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        photos: _attachedPhotos.map((file) => file.path).toList(),
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
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Column(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 32.sp,
                color: const Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Report Submitted',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: HomeColors.deepAnchor,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: HomeColors.warmHearth,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                reportId,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: HomeColors.heritagePurple,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              'Thank you for your report, kababayan. Your concern has been forwarded to $assignedTo. Estimated resolution: $estimatedResolution.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF616161),
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // close dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainApp()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: HomeColors.heritagePurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: Text(
                'OK, understood',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
        actionsPadding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        margin: EdgeInsets.all(12.w),
      ),
    );
  }
}
