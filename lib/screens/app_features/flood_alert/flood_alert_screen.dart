// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloodAlertScreen extends StatefulWidget {
  const FloodAlertScreen({super.key});

  @override
  State<FloodAlertScreen> createState() => _FloodAlertScreenState();
}

class _FloodAlertScreenState extends State<FloodAlertScreen> {
  // Mock flood data
  final Map<String, dynamic> _floodData = {
    'riverLevel': 2.4, // meters
    'dangerLevel': 3.0, // meters
    'status': 'Normal',
    'trend': 'stable', // rising, falling, stable
    'lastUpdate': DateTime.now().subtract(const Duration(minutes: 30)),
    'forecast': [
      {'time': 'Now', 'level': 2.4, 'status': 'Normal'},
      {'time': '3h', 'level': 2.5, 'status': 'Normal'},
      {'time': '6h', 'level': 2.7, 'status': 'Normal'},
      {'time': '12h', 'level': 2.9, 'status': 'Alert'},
      {'time': '24h', 'level': 3.2, 'status': 'Warning'},
    ],
  };

  final List<Map<String, dynamic>> _alerts = [
    {
      'title': 'Bicol River Monitoring',
      'level': 'Normal',
      'color': Color(0xFF4CAF50),
      'updated': '30 minutes ago',
    },
    {
      'title': 'Milaor Creek',
      'level': 'Normal',
      'color': Color(0xFF4CAF50),
      'updated': '1 hour ago',
    },
    {
      'title': 'San Francisco River',
      'level': 'Alert',
      'color': Color(0xFFFF9800),
      'updated': '2 hours ago',
    },
  ];

  final List<Map<String, dynamic>> _safetyTips = [
    {
      'title': 'During Flood Warnings',
      'tips': [
        'Move to higher ground immediately.',
        'Avoid walking or driving through flood waters.',
        'Stay tuned to local news for updates.',
        'Prepare emergency kit with food, water, and medicines.',
      ],
    },
    {
      'title': 'Emergency Contacts',
      'tips': [
        'Milaor Disaster Risk Reduction Office: (054) 123-4567',
        'Emergency Hotline: 911',
        'Barangay Hall: (054) 123-4568',
        'Rescue Team: 0912-345-6789',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7FF),
      appBar: AppBar(
        title: Text(
          'Flood Alert System',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4C229C),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _refreshData,
            icon: Icon(
              Icons.refresh,
              size: 28.sp,
              color: const Color(0xFF4C229C),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Status Card
            _buildStatusCard(),
            SizedBox(height: 24.h),

            // River Level Chart
            _buildRiverLevelChart(),
            SizedBox(height: 24.h),

            // Area Alerts
            Text(
              'Area Flood Alerts',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 12.h),
            ..._alerts.map((alert) => _buildAlertCard(alert)),
            SizedBox(height: 24.h),

            // Safety Information
            Text(
              'Safety Information',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 12.h),
            ..._safetyTips.map((tip) => _buildSafetyTipCard(tip)),
            SizedBox(height: 24.h),

            // Emergency Actions
            _buildEmergencyActions(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor;
    String statusText = _floodData['status'];

    switch (statusText.toLowerCase()) {
      case 'normal':
        statusColor = const Color(0xFF4CAF50);
        break;
      case 'alert':
        statusColor = const Color(0xFFFF9800);
        break;
      case 'warning':
        statusColor = const Color(0xFFF44336);
        break;
      default:
        statusColor = const Color(0xFF4C229C);
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Status',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: statusColor, width: 1),
                ),
                child: Text(
                  statusText.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric(
                label: 'River Level',
                value: '${_floodData['riverLevel']} m',
                subtext: 'Danger: ${_floodData['dangerLevel']} m',
              ),
              _buildMetric(
                label: 'Trend',
                value: _floodData['trend'].toString().toUpperCase(),
                subtext: 'Last 6 hours',
              ),
              _buildMetric(
                label: 'Last Update',
                value: _formatTime(_floodData['lastUpdate']),
                subtext: '30 min ago',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric({
    required String label,
    required String value,
    required String subtext,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF666666),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4C229C),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtext,
          style: TextStyle(
            fontSize: 10.sp,
            color: const Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  Widget _buildRiverLevelChart() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'River Level Forecast',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 150.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _floodData['forecast'].map<Widget>((point) {
                final level = point['level'] as double;
                final status = point['status'] as String;

                Color barColor;
                switch (status) {
                  case 'Normal':
                    barColor = const Color(0xFF4CAF50);
                    break;
                  case 'Alert':
                    barColor = const Color(0xFFFF9800);
                    break;
                  case 'Warning':
                    barColor = const Color(0xFFF44336);
                    break;
                  default:
                    barColor = const Color(0xFF4C229C);
                }

                final height = (level / 5.0) * 100.h; // Scale for visualization

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30.w,
                      height: height,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      point['time'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${level}m',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem('Normal', const Color(0xFF4CAF50)),
              _buildLegendItem('Alert', const Color(0xFFFF9800)),
              _buildLegendItem('Warning', const Color(0xFFF44336)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: alert['color'] as Color,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: alert['color'] as Color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['title'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Status: ${alert['level']} • Updated ${alert['updated']}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // View details
              _showAlertDetails(alert);
            },
            icon: Icon(
              Icons.chevron_right,
              size: 24.sp,
              color: const Color(0xFF4C229C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTipCard(Map<String, dynamic> tip) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tip['title'],
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4C229C),
            ),
          ),
          SizedBox(height: 12.h),
          ...(tip['tips'] as List<String>).map((tipText) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16.sp,
                      color: const Color(0xFF4CAF50),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        tipText,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF666666),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildEmergencyActions() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0F8),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Actions',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4C229C),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Call emergency
                    _showMessage(context, 'Calling emergency hotline...');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF44336),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                  ),
                  icon: Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  label: Text(
                    'Call Emergency',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Report flood
                    _showMessage(context, 'Opening flood report form...');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C229C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                  ),
                  icon: Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  label: Text(
                    'Report Flood',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _refreshData() {
    _showMessage(context, 'Refreshing flood data...');
    // In a real app, this would fetch new data from API
  }

  void _showAlertDetails(Map<String, dynamic> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert['title']),
        content: Text(
          'Detailed information about ${alert['title']} flood status.\n\n'
          'Current Level: ${alert['level']}\n'
          'Last Updated: ${alert['updated']}\n\n'
          'Residents in this area are advised to monitor water levels and follow safety guidelines.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
