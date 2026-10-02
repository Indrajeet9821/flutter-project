import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

/// General helper utilities for CCMS
class AppHelpers {
  /// Generates a standardized Complaint ID formatted as CMP-YYYY-XXXX
  /// Example: CMP-2026-0001
  static String generateComplaintId(int sequenceNumber) {
    final year = DateTime.now().year;
    final paddedNumber = sequenceNumber.toString().padLeft(4, '0');
    return 'CMP-$year-$paddedNumber';
  }

  /// Formats DateTime into user-friendly string
  /// Example: 29 Sep 2026, 08:30 PM
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  /// Formats DateTime to date only
  /// Example: 29 Sep 2026
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  /// Displays standardized SnackBar feedback message
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: isError
            ? const Color(0xFFDC2626)
            : isSuccess
                ? const Color(0xFF16A34A)
                : const Color(0xFF1E3A8A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Returns a representative icon for complaint category
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Teacher/Faculty':
        return Icons.school_outlined;
      case 'Classroom':
        return Icons.meeting_room_outlined;
      case 'Laboratory':
        return Icons.biotech_outlined;
      case 'Library':
        return Icons.local_library_outlined;
      case 'Canteen':
        return Icons.restaurant_outlined;
      case 'Hostel':
        return Icons.hotel_outlined;
      case 'Washroom':
        return Icons.wc_outlined;
      case 'Drinking Water':
        return Icons.water_drop_outlined;
      case 'Electricity':
        return Icons.bolt_outlined;
      case 'Internet/Wi-Fi':
        return Icons.wifi_outlined;
      case 'Computer/IT Equipment':
        return Icons.computer_outlined;
      case 'Projector/Smart Classroom':
        return Icons.videocam_outlined;
      case 'Furniture':
        return Icons.chair_outlined;
      case 'Sports Facilities':
        return Icons.sports_basketball_outlined;
      case 'Transportation':
        return Icons.directions_bus_outlined;
      case 'Campus Cleanliness':
        return Icons.cleaning_services_outlined;
      case 'Security':
        return Icons.security_outlined;
      case 'Parking':
        return Icons.local_parking_outlined;
      case 'Examination':
        return Icons.description_outlined;
      case 'Academic Issues':
        return Icons.assignment_outlined;
      case 'Administrative Office':
        return Icons.business_outlined;
      case 'Fees/Accounts':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.help_outline;
    }
  }

  /// Returns a representative icon for complaint status
  static IconData getStatusIcon(String status) {
    switch (status) {
      case AppConstants.statusSubmitted:
        return Icons.send_rounded;
      case AppConstants.statusUnderReview:
        return Icons.visibility_rounded;
      case AppConstants.statusAssigned:
        return Icons.person_pin_rounded;
      case AppConstants.statusInProgress:
        return Icons.engineering_rounded;
      case AppConstants.statusWaitingForInfo:
        return Icons.hourglass_top_rounded;
      case AppConstants.statusResolved:
        return Icons.check_circle_rounded;
      case AppConstants.statusClosed:
        return Icons.archive_rounded;
      case AppConstants.statusReopened:
        return Icons.replay_rounded;
      case AppConstants.statusRejected:
        return Icons.cancel_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }
}
