import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/complaint_model.dart';
import '../../models/feedback_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/status_badge.dart';

/// Screen displaying complete details of a complaint, timeline,
/// comments, role actions (status update, assignment), and feedback.
class ComplaintDetailsScreen extends StatefulWidget {
  final ComplaintModel complaint;

  const ComplaintDetailsScreen({
    super.key,
    required this.complaint,
  });

  @override
  State<ComplaintDetailsScreen> createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleAddComment(AuthProvider auth, ComplaintProvider provider) {
    if (_commentController.text.trim().isEmpty) return;

    provider.addComment(
      complaintId: widget.complaint.complaintId,
      userId: auth.currentUser?.uid ?? 'guest',
      userName: auth.currentUser?.name ?? 'Anonymous User',
      comment: _commentController.text.trim(),
    );

    _commentController.clear();
    setState(() {});
    AppHelpers.showSnackBar(context, 'Comment added successfully.');
  }

  void _showStatusUpdateDialog(AuthProvider auth, ComplaintProvider provider) {
    String selectedStatus = widget.complaint.status;
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Update Complaint Status',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Select New Status:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.statuses.map((status) {
                  final isSelected = selectedStatus == status;
                  final color = AppTheme.getStatusColor(status);
                  return ChoiceChip(
                    label: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : color,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: color,
                    backgroundColor: color.withValues(alpha: 0.1),
                    onSelected: (selected) {
                      if (selected) setSheetState(() => selectedStatus = status);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Staff Action Note (Optional)',
                  hintText: 'e.g. Technician dispatched / Parts ordered',
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Confirm Status Change',
                onPressed: () async {
                  await provider.updateComplaintStatus(
                    complaintId: widget.complaint.complaintId,
                    newStatus: selectedStatus,
                    comment: noteController.text.trim().isNotEmpty
                        ? 'Status changed to "$selectedStatus": ${noteController.text.trim()}'
                        : 'Status updated to "$selectedStatus"',
                    updatedBy: auth.currentUser?.name,
                  );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  setState(() {});
                  if (context.mounted) {
                    AppHelpers.showSnackBar(
                      context,
                      'Status updated to $selectedStatus',
                      isSuccess: true,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAssignStaffDialog(AuthProvider auth, ComplaintProvider provider) {
    String selectedStaff = AppConstants.staffAssignmentTypes.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Assign Complaint'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select responsible staff or department role:'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedStaff,
                isExpanded: true,
                items: AppConstants.staffAssignmentTypes.map((staff) {
                  return DropdownMenuItem(
                    value: staff,
                    child: Text(staff, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => selectedStaff = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await provider.assignComplaint(
                  complaintId: widget.complaint.complaintId,
                  staffName: selectedStaff,
                );
                if (ctx.mounted) Navigator.of(ctx).pop();
                setState(() {});
                if (context.mounted) {
                  AppHelpers.showSnackBar(
                    context,
                    'Complaint assigned to $selectedStaff',
                    isSuccess: true,
                  );
                }
              },
              child: const Text('Assign'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog(AuthProvider auth, ComplaintProvider provider) {
    int rating = 5;
    final commentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Grievance Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'How satisfied are you with the resolution of this complaint?',
                style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final star = index + 1;
                  return IconButton(
                    icon: Icon(
                      star <= rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: Colors.amber.shade600,
                      size: 32,
                    ),
                    onPressed: () => setDialogState(() => rating = star),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Share any comments or feedback...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.submitFeedback(
                  FeedbackModel(
                    complaintId: widget.complaint.complaintId,
                    studentId: auth.currentUser?.studentId ?? 'CS-2024-042',
                    rating: rating,
                    comment: commentCtrl.text.trim(),
                    createdAt: DateTime.now(),
                  ),
                );
                Navigator.of(ctx).pop();
                setState(() {});
                AppHelpers.showSnackBar(
                  context,
                  'Thank you for your feedback!',
                  isSuccess: true,
                );
              },
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final complaintProvider = Provider.of<ComplaintProvider>(context);

    // Fetch live complaint instance in case updated
    final liveComplaint = complaintProvider.allComplaints.firstWhere(
      (c) => c.complaintId == widget.complaint.complaintId,
      orElse: () => complaintProvider.studentComplaints.firstWhere(
        (c) => c.complaintId == widget.complaint.complaintId,
        orElse: () => widget.complaint,
      ),
    );

    final comments = complaintProvider.getComments(liveComplaint.complaintId);
    final existingFeedback = complaintProvider.getFeedback(liveComplaint.complaintId);
    final priorityColor = AppTheme.getPriorityColor(liveComplaint.priority);

    final isStudent = authProvider.isStudent;
    final isStaff = authProvider.isStaff;
    final isAdmin = authProvider.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: Text(liveComplaint.complaintId),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: 'Delete Complaint',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Complaint?'),
                    content: const Text(
                      'Are you sure you want to remove this grievance from the CCMS database?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          Navigator.of(ctx).pop();
                          await complaintProvider.deleteComplaint(liveComplaint.complaintId);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            AppHelpers.showSnackBar(
                              context,
                              'Complaint ${liveComplaint.complaintId} deleted.',
                              isSuccess: true,
                            );
                          }
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status & Priority Banner
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(status: liveComplaint.status),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: priorityColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.flag_rounded, size: 14, color: priorityColor),
                      const SizedBox(width: 4),
                      Text(
                        '${liveComplaint.priority} Priority',
                        style: TextStyle(
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Complaint Title
            Text(
              liveComplaint.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                height: 1.3,
              ),
            ),

            const SizedBox(height: 10),

            // Metadata Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildInfoChip(
                  AppHelpers.getCategoryIcon(liveComplaint.category),
                  liveComplaint.category,
                ),
                _buildInfoChip(Icons.location_on_outlined, liveComplaint.location),
                _buildInfoChip(
                  Icons.calendar_today_outlined,
                  AppHelpers.formatDate(liveComplaint.createdAt),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Student Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Complainant Details',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const Divider(height: 14),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFFEFF6FF),
                          child: Icon(Icons.person, color: Color(0xFF1E3A8A), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                liveComplaint.studentName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                'Roll No: ${liveComplaint.studentId} • ${liveComplaint.department}',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Description Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      liveComplaint.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                        height: 1.5,
                      ),
                    ),
                    if (liveComplaint.additionalInfo != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Note: ${liveComplaint.additionalInfo}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Assignment & Resolution Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.engineering_rounded,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Assigned Staff / Officer',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            liveComplaint.assignedTo ?? 'Pending Assignment by Admin',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: liveComplaint.assignedTo != null
                                  ? const Color(0xFF0F172A)
                                  : Colors.amber.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isAdmin)
                      TextButton(
                        onPressed: () => _showAssignStaffDialog(authProvider, complaintProvider),
                        child: Text(liveComplaint.assignedTo != null ? 'Reassign' : 'Assign'),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Timeline / Status Progress Tracker
            _buildTimelineCard(liveComplaint),

            const SizedBox(height: 18),

            // Resolution Feedback Display (if existing)
            if (existingFeedback != null) ...[
              Card(
                color: Colors.green.shade50.withValues(alpha: 0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Student Resolution Feedback',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                i < existingFeedback.rating
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: Colors.amber.shade700,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (existingFeedback.comment.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          '"${existingFeedback.comment}"',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],

            // Action Buttons by Role
            if (isStaff || isAdmin) ...[
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Update Status',
                      icon: Icons.update_rounded,
                      onPressed: () => _showStatusUpdateDialog(authProvider, complaintProvider),
                    ),
                  ),
                  if (liveComplaint.status != AppConstants.statusResolved) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        text: 'Mark Resolved',
                        icon: Icons.check_circle_outline,
                        backgroundColor: const Color(0xFF16A34A),
                        onPressed: () async {
                          await complaintProvider.updateComplaintStatus(
                            complaintId: liveComplaint.complaintId,
                            newStatus: AppConstants.statusResolved,
                            comment: 'Issue verified and marked as resolved by staff.',
                            updatedBy: authProvider.currentUser?.name,
                          );
                          setState(() {});
                          if (context.mounted) {
                            AppHelpers.showSnackBar(
                              context,
                              'Complaint marked as Resolved.',
                              isSuccess: true,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 18),
            ],

            // Student Rating Button if Resolved
            if (isStudent &&
                (liveComplaint.isResolved || liveComplaint.isClosed) &&
                existingFeedback == null) ...[
              CustomButton(
                text: 'Rate Resolution & Give Feedback',
                icon: Icons.star_outline_rounded,
                backgroundColor: Colors.amber.shade700,
                onPressed: () => _showFeedbackDialog(authProvider, complaintProvider),
              ),
              const SizedBox(height: 18),
            ],

            // Comments Section
            const Text(
              'Activity & Staff Comments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),

            if (comments.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Text(
                  'No comments yet. Add an update or comment below.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
              )
            else
              ...comments.map(
                (c) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            c['userName'] ?? 'User',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(
                            AppHelpers.formatDateTime(c['createdAt'] as DateTime),
                            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        c['comment'] ?? '',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF334155)),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Add Comment Field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment or status note...',
                      hintStyle: const TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppTheme.primaryColor),
                  onPressed: () => _handleAddComment(authProvider, complaintProvider),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard(ComplaintModel complaint) {
    final stages = [
      AppConstants.statusSubmitted,
      AppConstants.statusUnderReview,
      AppConstants.statusAssigned,
      AppConstants.statusInProgress,
      AppConstants.statusResolved,
      AppConstants.statusClosed,
    ];

    int currentIndex = stages.indexOf(complaint.status);
    if (currentIndex == -1) currentIndex = 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grievance Resolution Progress',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Column(
              children: List.generate(stages.length, (index) {
                final stage = stages[index];
                final isPassed = index <= currentIndex;
                final isCurrent = index == currentIndex;
                final isLast = index == stages.length - 1;
                final stageColor = isPassed ? AppTheme.primaryColor : Colors.grey.shade300;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isPassed ? AppTheme.primaryColor : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: stageColor, width: 2),
                          ),
                          child: isPassed
                              ? const Icon(Icons.check, size: 12, color: Colors.white)
                              : null,
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 24,
                            color: stageColor,
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0),
                      child: Text(
                        stage,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                          color: isPassed ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF64748B)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF334155)),
          ),
        ],
      ),
    );
  }
}
