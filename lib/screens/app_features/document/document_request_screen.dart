import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../home/home.dart';
import '../../home/main_app.dart';

class DocumentRequestScreen extends StatefulWidget {
  const DocumentRequestScreen({super.key});

  @override
  State<DocumentRequestScreen> createState() => _DocumentRequestScreenState();
}

class _DocumentRequestScreenState extends State<DocumentRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _additionalNotesController =
      TextEditingController();

  String _selectedDocumentType = 'Barangay Clearance';
  String _selectedUrgency = 'Normal (3-5 days)';

  final List<File> _attachedFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  final List<String> _documentTypes = [
    'Barangay Clearance',
    'Barangay Certification',
    'Certificate of Indigency',
    'Business Permit',
    'Residency Certificate',
    'Police Clearance',
    'Death Certificate',
    'Birth Certificate',
  ];

  final List<Map<String, String>> _urgencyLevels = [
    {'label': 'Normal', 'desc': '3-5 days', 'icon': 'schedule'},
    {'label': 'Standard', 'desc': '1 week', 'icon': 'event_note'},
    {'label': 'Urgent', 'desc': '24 hours', 'icon': 'priority_high'},
  ];

  double _calculateFee() {
    switch (_selectedDocumentType) {
      case 'Barangay Clearance':
        return 100.0;
      case 'Barangay Certification':
        return 50.0;
      case 'Certificate of Indigency':
        return 0.0;
      case 'Business Permit':
        return 500.0;
      case 'Residency Certificate':
        return 75.0;
      case 'Police Clearance':
        return 150.0;
      case 'Death Certificate':
        return 200.0;
      case 'Birth Certificate':
        return 200.0;
      default:
        return 0.0;
    }
  }

  Color _urgencyColor(String urgency) {
    switch (urgency) {
      case 'Urgent':
        return const Color(0xFFD32F2F);
      case 'Normal':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFFF57C00);
    }
  }

  Color _urgencyBgColor(String urgency) {
    switch (urgency) {
      case 'Urgent':
        return const Color(0xFFFFEBEE);
      case 'Normal':
        return const Color(0xFFE8F5E9);
      default:
        return const Color(0xFFFFF3E0);
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _attachedFiles.add(File(image.path)));
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) {
      setState(() => _attachedFiles.add(File(photo.path)));
    }
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
              'Add Attachment',
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
                _takePhoto();
              },
              leading: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: HomeColors.heritagePurple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.camera_alt_rounded,
                    size: 22.sp, color: HomeColors.heritagePurple),
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
                _pickImage();
              },
              leading: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: HomeColors.heritagePurple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.photo_library_rounded,
                    size: 22.sp, color: HomeColors.heritagePurple),
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

  void _removeFile(int index) {
    setState(() => _attachedFiles.removeAt(index));
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    final refId =
        '#${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final urgencyLabel = _selectedUrgency.split(' ')[0];

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
              'Request Submitted',
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
            // Reference ID badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: HomeColors.warmHearth,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                refId,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: HomeColors.heritagePurple,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Detail rows
            _dialogDetailRow(
                Icons.description_outlined, 'Document', _selectedDocumentType),
            SizedBox(height: 10.h),
            _dialogDetailRow(
                Icons.schedule_outlined, 'Urgency', '$urgencyLabel Processing'),
            SizedBox(height: 10.h),
            _dialogDetailRow(Icons.payments_outlined, 'Fee',
                '₱${_calculateFee().toStringAsFixed(2)}'),
            SizedBox(height: 14.h),
            Text(
              'You will receive a notification once your request is processed. Track status in your Profile section.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
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
                Navigator.pop(ctx);
                _resetForm();
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

  Widget _dialogDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: HomeColors.heritagePurple),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF757575),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: HomeColors.deepAnchor,
            ),
          ),
        ),
      ],
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _addressController.clear();
    _purposeController.clear();
    _additionalNotesController.clear();
    setState(() {
      _selectedDocumentType = 'Barangay Clearance';
      _selectedUrgency = 'Normal (3-5 days)';
      _attachedFiles.clear();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _purposeController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
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

  // ─── TEXT FIELD DECORATION ──────────────────────────────
  InputDecoration _fieldDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: const Color(0xFFBDBDBD),
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(
        icon,
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
        borderSide:
            const BorderSide(color: HomeColors.heritagePurple, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFFD32F2F)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );
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
                  _buildDocumentTypeCard(),
                  SizedBox(height: 16.h),
                  _buildFeeCard(),
                  SizedBox(height: 16.h),
                  _buildPersonalInfoCard(),
                  SizedBox(height: 16.h),
                  _buildUrgencyCard(),
                  SizedBox(height: 16.h),
                  _buildAttachmentCard(),
                  SizedBox(height: 16.h),
                  _buildAdditionalNotesCard(),
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
                    Icons.description_rounded,
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
                        'Document Request',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Official Barangay Documents',
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
              'Request barangay clearances, certificates, and other official documents. Processing times vary by document type and urgency.',
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

  // ─── DOCUMENT TYPE CARD ─────────────────────────────────
  Widget _buildDocumentTypeCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Document Type'),
          SizedBox(height: 10.h),
          DropdownButtonFormField<String>(
            value: _selectedDocumentType,
            decoration: _dropDecoration(),
            items: _documentTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(
                  type,
                  style:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            onChanged: (value) =>
                setState(() => _selectedDocumentType = value!),
          ),
          SizedBox(height: 14.h),
          TextFormField(
            controller: _purposeController,
            maxLines: 3,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: HomeColors.deepAnchor,
            ),
            decoration: _fieldDecoration(
              'Purpose of request (e.g., Employment, School, Travel)',
              Icons.edit_note_rounded,
            ).copyWith(alignLabelWithHint: true),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please specify the purpose';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // ─── FEE CARD ───────────────────────────────────────────
  Widget _buildFeeCard() {
    final fee = _calculateFee();
    final isFree = fee == 0.0;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: isFree
                  ? const Color(0xFFE8F5E9)
                  : HomeColors.heritagePurple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              isFree ? Icons.check_circle_outline : Icons.receipt_long_rounded,
              size: 26.sp,
              color:
                  isFree ? const Color(0xFF2E7D32) : HomeColors.heritagePurple,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isFree ? 'Free of Charge' : 'Prepare Amount',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: HomeColors.deepAnchor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  isFree
                      ? 'No payment required for this document'
                      : 'Please prepare this amount for payment at Municipality Office',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF9E9E9E),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Text(
            isFree ? 'FREE' : '₱${fee.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color:
                  isFree ? const Color(0xFF2E7D32) : HomeColors.heritagePurple,
            ),
          ),
        ],
      ),
    );
  }

  // ─── PERSONAL INFO CARD ─────────────────────────────────
  Widget _buildPersonalInfoCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Personal Information'),
            SizedBox(height: 14.h),
            TextFormField(
              controller: _fullNameController,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: HomeColors.deepAnchor,
              ),
              decoration: _fieldDecoration('Full Name', Icons.person_rounded),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            SizedBox(height: 14.h),
            TextFormField(
              controller: _addressController,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: HomeColors.deepAnchor,
              ),
              decoration:
                  _fieldDecoration('Complete Address', Icons.home_rounded),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── URGENCY CARD ───────────────────────────────────────
  Widget _buildUrgencyCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Processing Urgency'),
          SizedBox(height: 4.h),
          Text(
            'Faster processing may include additional fees',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF9E9E9E),
              height: 1.4,
            ),
          ),
          SizedBox(height: 14.h),
          ..._urgencyLevels.map((urgency) {
            final urgencyLabel = '${urgency['label']} (${urgency['desc']})';
            final isSelected = _selectedUrgency == urgencyLabel;
            final color = _urgencyColor(urgency['label']!);
            final bg = _urgencyBgColor(urgency['label']!);

            IconData icon;
            switch (urgency['icon']) {
              case 'priority_high':
                icon = Icons.priority_high_rounded;
                break;
              case 'event_note':
                icon = Icons.event_note_rounded;
                break;
              default:
                icon = Icons.schedule_rounded;
            }

            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: InkWell(
                onTap: () => setState(() => _selectedUrgency = urgencyLabel),
                borderRadius: BorderRadius.circular(12.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: isSelected ? bg : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? color : const Color(0xFFE0E0E0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withOpacity(0.12)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(icon, size: 20.sp, color: color),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              urgency['label']!,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? HomeColors.deepAnchor
                                    : const Color(0xFF757575),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Estimated: ${urgency['desc']}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: const Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          size: 22.sp,
                          color: color,
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

  // ─── ATTACHMENT CARD ────────────────────────────────────
  Widget _buildAttachmentCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionLabel('Attachments'),
              if (_attachedFiles.isNotEmpty)
                Text(
                  '${_attachedFiles.length} attached',
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
            'Upload supporting documents like valid ID, proof of address, etc. (optional)',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF9E9E9E),
              height: 1.4,
            ),
          ),
          SizedBox(height: 14.h),

          // Attached files grid
          if (_attachedFiles.isNotEmpty) ...[
            SizedBox(
              height: 110.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _attachedFiles.length + 1,
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  if (index == _attachedFiles.length) {
                    return _buildAddFileThumb(
                      onTap: _showPhotoSourcePicker,
                    );
                  }
                  return _buildFileThumb(
                    file: _attachedFiles[index],
                    index: index,
                  );
                },
              ),
            ),
          ] else
            _buildEmptyAttachmentArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyAttachmentArea() {
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
                Icons.attach_file_rounded,
                size: 24.sp,
                color: HomeColors.heritagePurple,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Tap to attach files',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: HomeColors.heritagePurple,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'ID, proof of address, etc.',
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

  Widget _buildAddFileThumb({required VoidCallback onTap}) {
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

  Widget _buildFileThumb({required File file, required int index}) {
    final fileName = file.path.split('/').last;
    final fileSize = '${(file.lengthSync() / 1024).toStringAsFixed(1)} KB';

    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 110.h,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: HomeColors.warmHearth,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.picture_as_pdf_rounded,
                size: 28.sp,
                color: const Color(0xFFD32F2F),
              ),
              SizedBox(height: 6.h),
              Text(
                fileName,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: HomeColors.deepAnchor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                fileSize,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: const Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 6.w,
          right: 6.w,
          child: GestureDetector(
            onTap: () => _removeFile(index),
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

  // ─── ADDITIONAL NOTES ───────────────────────────────────
  Widget _buildAdditionalNotesCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Additional Notes'),
          SizedBox(height: 3.h),
          Text(
            'Any special instructions or details (optional)',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF9E9E9E),
              height: 1.4,
            ),
          ),
          SizedBox(height: 14.h),
          TextFormField(
            controller: _additionalNotesController,
            maxLines: 3,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: HomeColors.deepAnchor,
            ),
            decoration: _fieldDecoration(
              'Write any additional notes here...',
              Icons.sticky_note_2_rounded,
            ).copyWith(alignLabelWithHint: true),
          ),
        ],
      ),
    );
  }

  // ─── SUBMIT BUTTON ──────────────────────────────────────
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitRequest,
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
                    'Submit Request',
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
              'Documents are processed during office hours (8 AM – 5 PM, Mon–Fri). '
              'Please present a valid ID when picking up your document. '
              'You can track your request status in the Profile section.',
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

  // ─── CARD DECORATION ────────────────────────────────────
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: HomeColors.cardWhite,
      borderRadius: BorderRadius.circular(20.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
