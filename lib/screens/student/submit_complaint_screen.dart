import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/complaint_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/complaint_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

/// Screen allowing students to submit a new complaint
class SubmitComplaintScreen extends StatefulWidget {
  const SubmitComplaintScreen({super.key});

  @override
  State<SubmitComplaintScreen> createState() => _SubmitComplaintScreenState();
}

class _SubmitComplaintScreenState extends State<SubmitComplaintScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _generatedComplaintId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  String _selectedCategory = AppConstants.defaultCategories.first;
  String _selectedLocation = AppConstants.defaultLocations.first;
  String _selectedPriority = AppConstants.priorityMedium;
  bool _hasAttachedImage = false;

  @override
  void initState() {
    super.initState();
    final complaintProvider =
        Provider.of<ComplaintProvider>(context, listen: false);
    _generatedComplaintId = complaintProvider.generateNextComplaintId();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final complaintProvider =
        Provider.of<ComplaintProvider>(context, listen: false);
    final user = authProvider.currentUser;

    final newComplaint = ComplaintModel(
      complaintId: _generatedComplaintId,
      studentUid: user?.uid ?? 'demo-student-001',
      studentId: user?.studentId ?? 'CS-2024-042',
      studentName: user?.name ?? 'Rahul Sharma',
      department: user?.department ?? 'Computer Science',
      category: _selectedCategory,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _selectedLocation,
      priority: _selectedPriority,
      status: AppConstants.statusSubmitted,
      imageUrl: _hasAttachedImage
          ? 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=800'
          : null,
      additionalInfo: _additionalInfoController.text.trim().isNotEmpty
          ? _additionalInfoController.text.trim()
          : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final success = await complaintProvider.submitNewComplaint(newComplaint);

    if (!mounted) return;

    if (success) {
      AppHelpers.showSnackBar(
        context,
        'Complaint submitted successfully. Reference: $_generatedComplaintId',
        isSuccess: true,
      );

      // Show confirmation dialog with generated ID
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 28),
              SizedBox(width: 10),
              Text('Complaint Lodged'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your grievance has been registered with the College Redressal Cell.'),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    const Text('Unique Complaint ID', style: TextStyle(fontSize: 11, color: Color(0xFF475569))),
                    const SizedBox(height: 4),
                    Text(
                      _generatedComplaintId,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Department officers will review your complaint within 24 hours.',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(false);
              },
              child: const Text('Back to Dashboard'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(true);
              },
              child: const Text('View in My Complaints →'),
            ),
          ],
        ),
      );
    } else {
      AppHelpers.showSnackBar(
        context,
        complaintProvider.errorMessage ?? 'Failed to submit complaint. Try again.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Complaint'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Generated Complaint ID banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Complaint ID (Auto-Generated):',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _generatedComplaintId,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Student Identity Card (Readonly)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_pin_rounded, color: AppTheme.primaryColor, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Rahul Sharma',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              '${user?.studentId ?? "CS-2024-042"} • ${user?.department ?? "Computer Science"}',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Category Selector (23 Categories)
                const Text(
                  'Complaint Category *',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category_outlined, size: 20),
                  ),
                  isExpanded: true,
                  items: complaintProvider.categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Row(
                        children: [
                          Icon(AppHelpers.getCategoryIcon(cat), size: 18, color: AppTheme.secondaryColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(cat, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  },
                ),

                const SizedBox(height: 16),

                // Complaint Title
                CustomTextField(
                  controller: _titleController,
                  label: 'Complaint Title *',
                  hint: 'Brief summary of the issue (e.g. Broken projector)',
                  prefixIcon: Icons.title_rounded,
                  validator: (v) => AppValidators.validateRequired(v, 'Complaint Title'),
                ),

                const SizedBox(height: 16),

                // Description
                CustomTextField(
                  controller: _descriptionController,
                  label: 'Detailed Description *',
                  hint: 'Please provide full details about the issue...',
                  prefixIcon: Icons.description_outlined,
                  maxLines: 4,
                  validator: (v) => AppValidators.validateRequired(v, 'Description'),
                ),

                const SizedBox(height: 16),

                // Campus Location Dropdown (13 Locations)
                const Text(
                  'Campus Location / Block *',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedLocation,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined, size: 20),
                  ),
                  items: complaintProvider.locations.map((loc) {
                    return DropdownMenuItem(
                      value: loc,
                      child: Text(loc, style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedLocation = val);
                  },
                ),

                const SizedBox(height: 16),

                // Priority Selection (Low, Medium, High, Urgent)
                const Text(
                  'Priority Level *',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: AppConstants.priorities.map((priority) {
                    final isSelected = _selectedPriority == priority;
                    final color = AppTheme.getPriorityColor(priority);
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: InkWell(
                          onTap: () => setState(() => _selectedPriority = priority),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? color : color.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? color : color.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.flag_rounded,
                                  size: 16,
                                  color: isSelected ? Colors.white : color,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  priority,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 18),

                // Image Attachment Simulation
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _hasAttachedImage
                              ? Colors.green.shade50
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _hasAttachedImage ? Icons.image_rounded : Icons.add_photo_alternate_outlined,
                          color: _hasAttachedImage ? Colors.green.shade700 : const Color(0xFF64748B),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _hasAttachedImage ? 'Photo Attached (1 file)' : 'Attach Photo Evidence',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            Text(
                              _hasAttachedImage ? 'evidence_photo.jpg (Uploaded)' : 'Optional JPG/PNG of the issue',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() => _hasAttachedImage = !_hasAttachedImage);
                        },
                        child: Text(_hasAttachedImage ? 'Remove' : '+ Attach'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Additional Info (Optional)
                CustomTextField(
                  controller: _additionalInfoController,
                  label: 'Additional Information (Optional)',
                  hint: 'Room number, bench number, specific timings...',
                  prefixIcon: Icons.info_outline,
                  maxLines: 2,
                ),

                const SizedBox(height: 28),

                // Submit Button
                CustomButton(
                  text: 'Submit Grievance Complaint',
                  icon: Icons.send_rounded,
                  isLoading: complaintProvider.isLoading,
                  onPressed: _handleSubmit,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
