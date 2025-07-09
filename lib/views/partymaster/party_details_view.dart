import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/model/party_list_model.dart';

class PartyDetailsView extends StatelessWidget {
  final PartyItem party;
  final List<Map<String, dynamic>>? paymentDetails;

  const PartyDetailsView({
    super.key, 
    required this.party,
    this.paymentDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          "Party Details",
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit party screen
              Get.snackbar(
                'Feature Coming Soon',
                'Edit party functionality will be available soon!',
                backgroundColor: theme.colorScheme.primary,
                colorText: theme.colorScheme.onPrimary,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Party Header Card
            _buildHeaderCard(theme),
            
            const SizedBox(height: 16),
            
            // Contact Information
            _buildContactCard(theme),
            
            const SizedBox(height: 16),
            
            // Financial Information
            _buildFinancialCard(theme),
            
            const SizedBox(height: 16),
            
            // Additional Information
            _buildAdditionalInfoCard(theme),
            
            const SizedBox(height: 16),
            
            // Payment Details (if available)
            if (paymentDetails != null && paymentDetails!.isNotEmpty)
              _buildPaymentDetailsCard(theme),
            
            if (paymentDetails != null && paymentDetails!.isNotEmpty)
              const SizedBox(height: 16),
            
            // Action Buttons
            _buildActionButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.primary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    party.byrNam.isNotEmpty ? party.byrNam[0].toUpperCase() : 'P',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        party.byrNam,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Code: ${party.byrCd}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: party.balanceColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: party.balanceColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: party.balanceColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Balance',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: party.balanceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹${party.balance.toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: party.balanceColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: party.balanceColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      party.balColor.toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_page,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Contact Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.location_on, 'Address', party.fullAddress, theme),
            if (party.phoneNo != null && party.phoneNo!.isNotEmpty)
              _buildInfoRow(Icons.phone, 'Phone', party.phoneNo!, theme),
            if (party.vatno != null && party.vatno!.isNotEmpty)
              _buildInfoRow(Icons.receipt_long, 'GST/VAT No', party.vatno!, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Financial Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFinancialTile(
                    'Max Credit Amount',
                    '₹${party.maxCreditAmount.toStringAsFixed(0)}',
                    Icons.credit_card,
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFinancialTile(
                    'Max Credit Days',
                    '${party.maxCreditDays} days',
                    Icons.calendar_today,
                    theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.category,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Group: ${party.groups}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Additional Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.badge, 'Party ID', party.accAutoIDClient, theme),
            _buildInfoRow(Icons.tag, 'Auto ID', party.accAutoID.toString(), theme),
            if (party.locationString != null && party.locationString!.isNotEmpty)
              _buildInfoRow(Icons.place, 'Location Info', party.locationString!, theme),
            if (party.locLatLong != null && party.locLatLong!.isNotEmpty)
              _buildInfoRow(Icons.my_location, 'Coordinates', party.locLatLong!, theme),
            if (party.partyRemarks != null && party.partyRemarks!.isNotEmpty)
              _buildInfoRow(Icons.note, 'Remarks', party.partyRemarks!, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialTile(String label, String value, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Navigate to payment history
              Get.snackbar(
                'Feature Coming Soon',
                'Payment history will be available soon!',
                backgroundColor: theme.colorScheme.primary,
                colorText: theme.colorScheme.onPrimary,
              );
            },
            icon: const Icon(Icons.history),
            label: const Text('View Payment History'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Add payment
                  Get.snackbar(
                    'Feature Coming Soon',
                    'Add payment functionality will be available soon!',
                    backgroundColor: theme.colorScheme.primary,
                    colorText: theme.colorScheme.onPrimary,
                  );
                },
                icon: const Icon(Icons.payment),
                label: const Text('Add Payment'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Create transaction
                  Get.snackbar(
                    'Feature Coming Soon',
                    'Create transaction functionality will be available soon!',
                    backgroundColor: theme.colorScheme.primary,
                    colorText: theme.colorScheme.onPrimary,
                  );
                },
                icon: const Icon(Icons.add_business),
                label: const Text('New Transaction'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Payment Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (paymentDetails != null && paymentDetails!.isNotEmpty) ...[
              // Display the first party data (main account info)
              if (paymentDetails!.first.containsKey('AccountLedger'))
                _buildAccountLedger(theme, paymentDetails!.first),
              
              // Display basic account info
              _buildAccountInfo(theme, paymentDetails!.first),
            ] else
              Text(
                'No payment details available',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfo(ThemeData theme, Map<String, dynamic> accountData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Information',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(Icons.account_tree, 'Account Type', accountData['LTYPE']?.toString() ?? 'N/A', theme),
        _buildInfoRow(Icons.group, 'Group', accountData['GROUPS']?.toString() ?? 'N/A', theme),
        _buildInfoRow(Icons.person, 'Customer Type', accountData['CUSTYPE']?.toString() ?? 'N/A', theme),
        _buildInfoRow(Icons.trending_down, 'Opening Dr Balance', '₹${accountData['OPDRBLC']?.toString() ?? '0'}', theme),
        _buildInfoRow(Icons.trending_up, 'Opening Cr Balance', '₹${accountData['OPCRBLC']?.toString() ?? '0'}', theme),
        if (accountData['MaxCreditAmount'] != null && accountData['MaxCreditAmount'] > 0)
          _buildInfoRow(Icons.credit_card, 'Max Credit Amount', '₹${accountData['MaxCreditAmount']}', theme),
        if (accountData['MaxCreditDays'] != null && accountData['MaxCreditDays'] > 0)
          _buildInfoRow(Icons.schedule, 'Max Credit Days', '${accountData['MaxCreditDays']} days', theme),
      ],
    );
  }

  Widget _buildAccountLedger(ThemeData theme, Map<String, dynamic> accountData) {
    final ledgerList = accountData['AccountLedger'] as List<dynamic>? ?? [];
    
    if (ledgerList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction History',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Create a simple table for transactions
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text('Date', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
                    Expanded(flex: 3, child: Text('Description', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('Debit', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('Credit', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
                    Expanded(flex: 2, child: Text('Balance', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              
              // Transactions (limit to first 5 for display)
              ...ledgerList.take(5).map((transaction) => _buildTransactionRow(theme, transaction)),
              
              if (ledgerList.length > 5)
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '... and ${ledgerList.length - 5} more transactions',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTransactionRow(ThemeData theme, Map<String, dynamic> transaction) {
    final balance = (transaction['BALANCE'] ?? 0).toDouble();
    final debitAmount = transaction['DRAMOUNT']?.toString() ?? '0';
    final creditAmount = transaction['CRAMOUNT']?.toString() ?? '0';
    final date = transaction['CT_DTStr']?.toString() ?? 'N/A';
    final description = transaction['ACCOUNT']?.toString() ?? 'N/A';
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(date, style: theme.textTheme.bodySmall)),
          Expanded(flex: 3, child: Text(description, style: theme.textTheme.bodySmall)),
          Expanded(flex: 2, child: Text('₹$debitAmount', style: theme.textTheme.bodySmall)),
          Expanded(flex: 2, child: Text('₹$creditAmount', style: theme.textTheme.bodySmall)),
          Expanded(
            flex: 2, 
            child: Text(
              '₹${balance.toStringAsFixed(2)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: balance >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
