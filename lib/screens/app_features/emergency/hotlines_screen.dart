// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HotlinesScreen extends StatefulWidget {
  const HotlinesScreen({super.key});

  @override
  State<HotlinesScreen> createState() => _HotlinesScreenState();
}

class _HotlinesScreenState extends State<HotlinesScreen> {
  final List<EmergencyContact> _emergencyContacts = [
    EmergencyContact(
      name: 'Police Station',
      number: '911',
      description: 'Emergency police assistance',
      category: 'Emergency',
      icon: Icons.local_police,
      color: Colors.blue,
    ),
    EmergencyContact(
      name: 'Fire Department',
      number: '912',
      description: 'Fire and rescue services',
      category: 'Emergency',
      icon: Icons.fire_truck,
      color: Colors.red,
    ),
    EmergencyContact(
      name: 'Ambulance',
      number: '913',
      description: 'Medical emergency services',
      category: 'Emergency',
      icon: Icons.medical_services,
      color: Colors.green,
    ),
    EmergencyContact(
      name: 'Milaor Municipal Hall',
      number: '(054) 555-1234',
      description: 'Local government office',
      category: 'Government',
      icon: Icons.account_balance,
      color: Colors.purple,
    ),
    EmergencyContact(
      name: 'Barangay Hall',
      number: '(054) 555-5678',
      description: 'Barangay administration',
      category: 'Government',
      icon: Icons.home_work,
      color: Colors.orange,
    ),
    EmergencyContact(
      name: 'Disaster Risk Reduction',
      number: '(054) 555-9012',
      description: 'DRRM Office for disasters',
      category: 'Emergency',
      icon: Icons.warning,
      color: Colors.amber,
    ),
    EmergencyContact(
      name: 'Health Center',
      number: '(054) 555-3456',
      description: 'Community health services',
      category: 'Health',
      icon: Icons.local_hospital,
      color: Colors.teal,
    ),
    EmergencyContact(
      name: 'Public Works',
      number: '(054) 555-7890',
      description: 'Road and infrastructure issues',
      category: 'Services',
      icon: Icons.construction,
      color: Colors.brown,
    ),
    EmergencyContact(
      name: 'Water District',
      number: '(054) 555-2345',
      description: 'Water supply concerns',
      category: 'Utilities',
      icon: Icons.water_drop,
      color: Colors.blue,
    ),
    EmergencyContact(
      name: 'Electric Cooperative',
      number: '(054) 555-6789',
      description: 'Power outage reports',
      category: 'Utilities',
      icon: Icons.electrical_services,
      color: Colors.yellow.shade700,
    ),
  ];

  final List<String> _categories = [
    'All',
    'Emergency',
    'Government',
    'Health',
    'Services',
    'Utilities',
  ];

  String _selectedCategory = 'All';

  List<EmergencyContact> get _filteredContacts {
    if (_selectedCategory == 'All') {
      return _emergencyContacts;
    }
    return _emergencyContacts
        .where((contact) => contact.category == _selectedCategory)
        .toList();
  }

  Future<void> _launchCall(String phoneNumber) async {
    final Uri telUri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot make call to $phoneNumber'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showContactDetails(EmergencyContact contact) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(contact.icon, color: contact.color),
            SizedBox(width: 12.w),
            Text(contact.name),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.description,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Phone: ${contact.number}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Category: ${contact.category}',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _launchCall(contact.number);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: contact.color,
            ),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      appBar: AppBar(
        title: Text(
          'Milaor Hotlines',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4C229C),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Emergency banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade700, Colors.orange.shade700],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.white, size: 30.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Hotline',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Dial 911 for immediate police, fire, or medical assistance',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _launchCall('911'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    'CALL 911',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category filter
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Category',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 50.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            fontSize: 14.sp,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Contacts list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ListTile(
                    onTap: () => _showContactDetails(contact),
                    leading: Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: contact.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Icon(
                        contact.icon,
                        color: contact.color,
                        size: 28.sp,
                      ),
                    ),
                    title: Text(
                      contact.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        Text(
                          contact.number,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          contact.description,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () => _launchCall(contact.number),
                      icon: Icon(
                        Icons.phone,
                        color: Colors.green,
                        size: 28.sp,
                      ),
                      tooltip: 'Call ${contact.number}',
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick dial section
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Dial',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickDialButton(
                      icon: Icons.local_police,
                      label: 'Police',
                      number: '911',
                      color: Colors.blue,
                    ),
                    _buildQuickDialButton(
                      icon: Icons.fire_truck,
                      label: 'Fire',
                      number: '912',
                      color: Colors.red,
                    ),
                    _buildQuickDialButton(
                      icon: Icons.medical_services,
                      label: 'Ambulance',
                      number: '913',
                      color: Colors.green,
                    ),
                    _buildQuickDialButton(
                      icon: Icons.warning,
                      label: 'DRRM',
                      number: '(054) 555-9012',
                      color: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDialButton({
    required IconData icon,
    required String label,
    required String number,
    required Color color,
  }) {
    return Column(
      children: [
        IconButton(
          onPressed: () => _launchCall(number),
          icon: Icon(icon, size: 32.sp),
          style: IconButton.styleFrom(
            backgroundColor: color.withOpacity(0.2),
            foregroundColor: color,
            padding: EdgeInsets.all(16.w),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class EmergencyContact {
  final String name;
  final String number;
  final String description;
  final String category;
  final IconData icon;
  final Color color;

  EmergencyContact({
    required this.name,
    required this.number,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
  });
}
