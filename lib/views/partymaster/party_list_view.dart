import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/party_list_controller.dart';
import 'package:shopapp/model/party_list_model.dart';
import 'package:shopapp/views/partymaster/party_details_view.dart';

class PartyListView extends StatefulWidget {
  const PartyListView({super.key});

  @override
  State<PartyListView> createState() => _PartyListViewState();
}

class _PartyListViewState extends State<PartyListView> {
  final PartyListController controller = Get.put(PartyListController());
  final TextEditingController searchController = TextEditingController();

  _PartyListViewState() {
    print('🏗️ === PARTY LIST VIEW STATE CONSTRUCTOR ===');
    print('📱 PartyListView state being created');
  }

  @override
  void initState() {
    super.initState();
    print('🎯 === PARTY LIST VIEW INITIALIZED ===');
    print('📱 PartyListView initState called');
    
    // Initialize search controller
    searchController.addListener(() {
      controller.searchParties(searchController.text);
    });
    
    print('🔍 Search controller initialized');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          "Party List",
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 4,
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Total: ${controller.filteredPartyList.length}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Header
          _buildSearchAndFilterHeader(theme),
          
          // Summary Stats
          _buildSummaryStats(theme),
          
          // Party List
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return _buildLoadingState(theme);
              }
              
              if (controller.error.isNotEmpty) {
                return _buildErrorState(theme);
              }
              
              if (controller.filteredPartyList.isEmpty) {
                return _buildEmptyState(theme);
              }
              
              return _buildPartyList(theme);
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add party screen
          Get.snackbar(
            'Feature Coming Soon',
            'Add new party functionality will be available soon!',
            backgroundColor: theme.colorScheme.primary,
            colorText: theme.colorScheme.onPrimary,
          );
        },
        label: const Text('Add Party'),
        icon: const Icon(Icons.person_add),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildSearchAndFilterHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search by name, code, or address...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Filter Row
          Row(
            children: [
              // Group Filter
              Expanded(
                flex: 1,
                child: Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedGroup,
                  decoration: InputDecoration(
                    labelText: 'Group',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    isDense: true,
                  ),
                  isExpanded: true,
                  items: controller.availableGroups.map((group) {
                    return DropdownMenuItem(
                      value: group,
                      child: Text(
                        group, 
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.filterByGroup(value);
                    }
                  },
                )),
              ),
              
              const SizedBox(width: 8),
              
              // Sort Filter
              Expanded(
                flex: 1,
                child: Obx(() => DropdownButtonFormField<String>(
                  value: controller.sortType.isEmpty ? 'Default' : controller.sortType,
                  decoration: InputDecoration(
                    labelText: 'Sort',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    isDense: true,
                  ),
                  isExpanded: true,
                  items: controller.availableSortTypes.map((sort) {
                    return DropdownMenuItem(
                      value: sort,
                      child: Text(
                        sort, 
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.sortParties(value == 'Default' ? '' : value);
                    }
                  },
                )),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Zero Balance Filter
          Obx(() => CheckboxListTile(
            title: Text(
              'Exclude Zero Balance',
              style: theme.textTheme.bodyMedium,
            ),
            value: controller.excludeZeroBalance,
            onChanged: (value) {
              controller.toggleExcludeZeroBalance(value ?? false);
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
          )),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(ThemeData theme) {
    return Obx(() {
      final totalSum = controller.totalSum;
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              'Financial Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Due Amount',
                    controller.formatCurrency(totalSum.due),
                    Colors.green,
                    theme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Advance',
                    controller.formatCurrency(totalSum.advance),
                    Colors.blue,
                    theme,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Grand Total',
                    controller.formatCurrency(totalSum.grandTotal),
                    theme.colorScheme.primary,
                    theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryCard(String title, String amount, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPartyList(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: controller.refreshPartyList,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.filteredPartyList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final party = controller.filteredPartyList[index];
          return _buildPartyCard(party, theme);
        },
      ),
    );
  }

  Widget _buildPartyCard(PartyItem party, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          print('🎯 === PARTY CARD CLICKED ===');
          print('📋 Party: ${party.byrNam} (${party.byrCd})');
          
          try {
            // Show loading indicator
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(),
              ),
              barrierDismissible: false,
            );
            
            // Fetch party payment details
            final paymentDetails = await controller.getPartyPaymentDetails(party);
            
            // Close loading dialog
            Get.back();
            
            print('✅ Payment details fetched, navigating to details view');
            
            // Navigate to party details view with the fetched data
            Get.to(() => PartyDetailsView(
              party: party,
              paymentDetails: paymentDetails,
            ));
          } catch (e) {
            // Close loading dialog
            Get.back();
            
            print('❌ Error fetching payment details: $e');
            
            // Show error dialog
            Get.dialog(
              AlertDialog(
                title: const Text('Error'),
                content: Text('Failed to fetch payment details: $e'),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          party.byrNam,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          party.byrCd,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: party.balanceColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: party.balanceColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      controller.formatCurrency(party.balance),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: party.balanceColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                party.fullAddress,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (party.phoneNo != null && party.phoneNo!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      party.phoneNo!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      party.groups,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading party list...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Party List',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                controller.clearError();
                controller.refreshPartyList();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No Parties Found',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                searchController.clear();
                controller.filterByGroup('All Groups');
                controller.toggleExcludeZeroBalance(false);
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
