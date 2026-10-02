import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/complaint_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../widgets/complaint_card.dart';
import '../complaint/complaint_details_screen.dart';

/// Tab 1: Student's My Complaints List with search and filtering
class StudentComplaintsTab extends StatefulWidget {
  final VoidCallback onSubmitComplaint;

  const StudentComplaintsTab({
    super.key,
    required this.onSubmitComplaint,
  });

  @override
  State<StudentComplaintsTab> createState() => _StudentComplaintsTabState();
}

class _StudentComplaintsTabState extends State<StudentComplaintsTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final complaintProvider = Provider.of<ComplaintProvider>(context);
    final complaints = complaintProvider.filteredComplaints;

    if (complaintProvider.searchQuery.isEmpty && _searchController.text.isNotEmpty) {
      _searchController.clear();
    }

    final filterStatuses = ['All', 'Pending', ...AppConstants.statuses];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Submit Complaint',
            onPressed: widget.onSubmitComplaint,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header Container
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            color: Colors.white,
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _searchController,
                  onChanged: (val) => complaintProvider.setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Search by title, ID, category, or location...',
                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              complaintProvider.setSearchQuery('');
                            },
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Status Filter Chips Carousel
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: filterStatuses.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final status = filterStatuses[index];
                      final isSelected =
                          complaintProvider.selectedStatusFilter == status;

                      return FilterChip(
                        label: Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF475569),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppTheme.primaryColor,
                        backgroundColor: const Color(0xFFF1F5F9),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        onSelected: (selected) {
                          complaintProvider.setStatusFilter(selected ? status : 'All');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Count & Clear Filter indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${complaints.length} complaint${complaints.length == 1 ? "" : "s"}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                if (complaintProvider.selectedStatusFilter != 'All' ||
                    complaintProvider.searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      complaintProvider.clearFilters();
                    },
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Complaint Cards List
          Expanded(
            child: complaints.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 56,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No complaints found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF475569),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Try adjusting your search criteria or filter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Submit Complaint'),
                            onPressed: widget.onSubmitComplaint,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final item = complaints[index];
                      return ComplaintCard(
                        complaint: item,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ComplaintDetailsScreen(complaint: item),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
