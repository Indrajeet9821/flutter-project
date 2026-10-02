// ============================================================
// FILE: lib/utils/helpers.dart
// PURPOSE: Utility/helper functions used across the app.
//
// Contains:
// - Complaint ID generator
// - Date/time formatting helpers
// - Color helpers for priority & status
// - Snackbar/dialog helpers
// ============================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  // ─── Complaint ID Generator ───
  /// Generates a unique complaint ID in the format: CMP-YYYY-XXXX
  /// Example: CMP-2026-0001
  static String generateComplaintId(int sequenceNumber) {
    final year = DateTime.now().year;
    final sequence = sequenceNumber.toString().padLeft(4, '0');
    return 'CMP-$year-$sequence';
  }

  // ─── Date Formatting ───
  /// Formats a DateTime to "dd MMM yyyy" (e.g., "29 Sep 2026")
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Formats a DateTime to "dd MMM yyyy, hh:mm a" (e.g., "29 Sep 2026, 05:30 PM")
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  /// Formats a DateTime to relative time (e.g., "2 hours ago", "3 days ago")
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return formatDate(date);
    }
  }

  // ─── Priority Color ───
  /// Returns a color based on complaint priority level
  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return const Color(0xFF4CAF50); // Green
      case 'Medium':
        return const Color(0xFFFFA726); // Orange
      case 'High':
        return const Color(0xFFEF5350); // Red
      case 'Urgent':
        return const Color(0xFFD32F2F); // Dark Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  /// Returns a priority icon
  static IconData getPriorityIcon(String priority) {
    switch (priority) {
      case 'Low':
        return Icons.arrow_downward_rounded;
      case 'Medium':
        return Icons.remove_rounded;
      case 'High':
        return Icons.arrow_upward_rounded;
      case 'Urgent':
        return Icons.priority_high_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  // ─── Status Color ───
  /// Returns a color based on complaint status
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Submitted':
        return const Color(0xFF42A5F5); // Blue
      case 'Under Review':
        return const Color(0xFF7E57C2); // Purple
      case 'Assigned':
        return const Color(0xFF26A69A); // Teal
      case 'In Progress':
        return const Color(0xFFFFA726); // Orange
      case 'Waiting for Information':
        return const Color(0xFFFFCA28); // Yellow
      case 'Resolved':
        return const Color(0xFF66BB6A); // Green
      case 'Closed':
        return const Color(0xFF78909C); // Blue-grey
      case 'Reopened':
        return const Color(0xFFEF5350); // Red
      case 'Rejected':
        return const Color(0xFFE53935); // Dark Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  /// Returns a status icon
  static IconData getStatusIcon(String status) {
    switch (status) {
      case 'Submitted':
        return Icons.send_rounded;
      case 'Under Review':
        return Icons.visibility_rounded;
      case 'Assigned':
        return Icons.person_add_rounded;
      case 'In Progress':
        return Icons.engineering_rounded;
      case 'Waiting for Information':
        return Icons.hourglass_top_rounded;
      case 'Resolved':
        return Icons.check_circle_rounded;
      case 'Closed':
        return Icons.lock_rounded;
      case 'Reopened':
        return Icons.refresh_rounded;
      case 'Rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  // ─── Snackbar Helpers ───
  /// Shows a success snackbar
  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Shows an error snackbar
  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Shows an info snackbar
  static void showInfoSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF1976D2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ─── Dialog Helpers ───
  /// Shows a confirmation dialog. Returns true if confirmed, false otherwise.
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color confirmColor = const Color(0xFF1565C0),
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
