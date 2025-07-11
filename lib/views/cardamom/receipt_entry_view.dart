// lib/views/receipt_entry_view.dart

import 'package:flutter/material.dart';
import 'package:shopapp/model/receipt_model.dart';
import 'package:shopapp/services/api_service.dart';
import 'dart:async'; // Added for Timer

class ReceiptEntryView extends StatefulWidget {
  final int? gcrid;
  final String? compRefNo;
  final String? date;
  final String? party;
  final int? partyId;
  final double? qty;
  final double? rate;
  final double? processingCharges;

  const ReceiptEntryView({
    Key? key,
    this.gcrid,
    this.compRefNo,
    this.date,
    this.party,
    this.partyId,
    this.qty,
    this.rate,
    this.processingCharges,
  }) : super(key: key);

  @override
  _ReceiptEntryViewState createState() => _ReceiptEntryViewState();
}

class _ReceiptEntryViewState extends State<ReceiptEntryView> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  late Receipt _receipt;
  bool _isLoading = false;
  bool _isProcessing = false;
  bool _isLoadingParties = false;
  bool _isSearchingParties = false;

  // Party selection
  List<dynamic> _partyList = [];
  List<dynamic> _filteredPartyList = [];
  dynamic _selectedParty;
  bool _showPartyDropdown = false;

  // Search debouncing
  Timer? _searchDebounceTimer;

  final TextEditingController _compRefController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _refNoController = TextEditingController();
  final TextEditingController _partyController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _processingChargesController =
      TextEditingController();
  final TextEditingController _numberOfBagsController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeReceipt();
    _loadPartyList(); // Load party list for dropdown
  }

  Future<void> _loadPartyList({String? searchQuery}) async {
    try {
      print("🎭 LOADING PARTY LIST - START");
      print("   Widget party: '${widget.party ?? 'null'}'");
      print("   Widget partyId: ${widget.partyId ?? 'null'}");
      print("   Search query: '${searchQuery ?? 'null'}'");

      setState(() => _isLoadingParties = true);
      final parties = await _apiService.getPartyList(searchByName: searchQuery);

      print("🎭 PARTY LIST LOADED:");
      print("   Total parties: ${parties.length}");
      if (parties.isNotEmpty) {
        print("   First 3 parties:");
        for (int i = 0; i < 3 && i < parties.length; i++) {
          final party = parties[i];
          print("     [$i] ID: ${party['ID']}, Name: '${party['ByrNam']}'");
        }

        // Show available keys in party objects
        if (parties.isNotEmpty) {
          print("   Available party fields: ${parties[0].keys.toList()}");
        }
      } else {
        print("   ⚠️ No parties returned from API!");
      }

      setState(() {
        if (searchQuery != null && searchQuery.isNotEmpty) {
          // For search results, replace the filtered list
          _filteredPartyList = parties;
        } else {
          // For initial load, set both lists
          _partyList = parties;
          _filteredPartyList = parties; // Initialize filtered list
        }

        // Try to select party based on widget parameters OR current receipt data
        String partyToFind = widget.party ?? _receipt.party;
        int partyIdToFind = widget.partyId ?? _receipt.partyId;

        if (partyToFind.isNotEmpty || partyIdToFind > 0) {
          print("🔍 SEARCHING FOR PARTY TO SELECT:");
          print("   Looking for party name: '$partyToFind'");
          print("   Looking for party ID: $partyIdToFind");

          _selectedParty = parties.firstWhere(
            (party) =>
                party['ByrNam'] == partyToFind || party['ID'] == partyIdToFind,
            orElse: () => <String, dynamic>{},
          );

          if (_selectedParty != null && _selectedParty.isNotEmpty) {
            print(
                "✅ Found and selected party: '${_selectedParty['ByrNam']}' (ID: ${_selectedParty['ID']})");
            // Update receipt object with selected party info
            _receipt.party = _selectedParty['ByrNam'] ?? '';
            _receipt.partyId = _selectedParty['ID'] ?? 0;
            _partyController.text = _receipt.party;
          } else {
            print(
                "❌ Could not find party with name: '$partyToFind' or ID: $partyIdToFind");
            // Reset selected party
            _selectedParty = null;
            // List all party names for debugging
            print(
                "   Available party names: ${parties.map((p) => "'${p['ByrNam']}'").take(10).join(', ')}${parties.length > 10 ? '...' : ''}");
          }
        } else {
          print("📝 New receipt - no party pre-selected");
          // Initialize filtered list for search
          _filteredPartyList = _partyList;
        }
      });

      print("🎭 PARTY LIST LOADING - COMPLETE");
    } catch (e) {
      print('❌ PARTY LIST ERROR: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Stack trace: ${StackTrace.current}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading party list: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoadingParties = false);
    }
  }

  void _initializeReceipt() {
    _receipt = Receipt(
      gcrid: widget.gcrid ?? 0,
      compRefNo: widget.compRefNo ?? '',
      date: widget.date ?? _formatDate(DateTime.now()),
      refNo: '',
      party: widget.party ?? '',
      partyId: widget.partyId ?? 0,
      qty: widget.qty ?? 0,
      rate: widget.rate ?? 0,
      processingCharges: widget.processingCharges ?? 0,
      numberOfBags: 1,
      remark: '',
    );

    _compRefController.text = _receipt.compRefNo;
    _dateController.text = _receipt.date;
    _refNoController.text = _receipt.refNo;
    _partyController.text = _receipt.party;
    _qtyController.text = _receipt.qty.toString();
    _rateController.text = _receipt.rate.toString();
    _processingChargesController.text = _receipt.processingCharges.toString();
    _numberOfBagsController.text = _receipt.numberOfBags.toString();
    _remarkController.text = _receipt.remark;

    // Only load receipt details if we have a valid gcrid > 0
    if (widget.gcrid != null && widget.gcrid! > 0) {
      _loadReceiptDetails();
    } else {
      print("✨ Creating new receipt (GCRID: ${widget.gcrid ?? 0})");
    }
  }

  Future<void> _loadReceiptDetails() async {
    try {
      setState(() => _isLoading = true);
      print("🔄 Loading receipt details for GCRID: ${widget.gcrid}");

      final receipt =
          await _apiService.getGreenCardamomReceiptByCode(widget.gcrid!);

      if (receipt != null) {
        print("📋 Loaded receipt: ${receipt.party} (ID: ${receipt.partyId})");
        setState(() {
          _receipt = receipt;
          _updateControllers();
        });

        // Wait for party list to be loaded if it's not already loaded
        await _ensurePartySelection(receipt);
      } else {
        print("⚠️ No receipt data returned from API");
      }
    } catch (e) {
      print("❌ Error loading receipt details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading receipt: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _ensurePartySelection(Receipt receipt) async {
    print("🔍 ENSURING PARTY SELECTION:");
    print("   Receipt party: '${receipt.party}' (ID: ${receipt.partyId})");
    print("   Party list loaded: ${_partyList.isNotEmpty}");

    // Wait for party list to load if it's still loading
    int attempts = 0;
    while (_isLoadingParties && attempts < 50) {
      // Wait up to 5 seconds
      await Future.delayed(Duration(milliseconds: 100));
      attempts++;
    }

    if (_partyList.isNotEmpty && receipt.party.isNotEmpty) {
      final foundParty = _partyList.firstWhere(
        (party) =>
            party['ID'] == receipt.partyId || party['ByrNam'] == receipt.party,
        orElse: () => <String, dynamic>{},
      );

      if (foundParty.isNotEmpty) {
        setState(() {
          _selectedParty = foundParty;
        });
        print(
            "✅ Auto-selected party from loaded receipt: '${foundParty['ByrNam']}' (ID: ${foundParty['ID']})");
      } else {
        print("❌ Could not find party in list:");
        print("   Looking for: '${receipt.party}' (ID: ${receipt.partyId})");
        print(
            "   Available parties: ${_partyList.map((p) => "'${p['ByrNam']}' (ID: ${p['ID']})").take(5).join(', ')}${_partyList.length > 5 ? '...' : ''}");
      }
    } else {
      print("⚠️ Cannot select party: party list empty or receipt party empty");
    }
  }

  void _updateControllers() {
    _compRefController.text = _receipt.compRefNo;
    _dateController.text = _receipt.date;
    _refNoController.text = _receipt.refNo;
    _partyController.text = _receipt.party;
    _qtyController.text = _receipt.qty.toString();
    _rateController.text = _receipt.rate.toString();
    _processingChargesController.text = _receipt.processingCharges.toString();
    _numberOfBagsController.text = _receipt.numberOfBags.toString();
    _remarkController.text = _receipt.remark;
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _compRefController.dispose();
    _dateController.dispose();
    _refNoController.dispose();
    _partyController.dispose();
    _qtyController.dispose();
    _rateController.dispose();
    _processingChargesController.dispose();
    _numberOfBagsController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant,
      appBar: _buildAppBar(theme),
      body: _buildBody(theme),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.colorScheme.primary,
      title: const Text(
        'Green Cardamom Receipt Entry',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 2,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTopRow(theme),
                  const SizedBox(height: 20),
                  _buildPartyField(theme),
                  const SizedBox(height: 20),
                  _buildQuantityRateRow(theme),
                  const SizedBox(height: 20),
                  _buildProcessingChargesRow(theme),
                  const SizedBox(height: 20),
                  _buildRemarkField(theme),
                  const SizedBox(height: 32),
                  _buildActionButtons(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _compRefController,
            readOnly: true,
            decoration: _buildInputDecoration(
              'Comp Ref. No.',
              theme,
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _dateController,
            decoration: _buildInputDecoration('Date', theme),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _refNoController,
            decoration: _buildInputDecoration('Ref No.', theme),
            onChanged: (value) => _receipt.refNo = value,
          ),
        ),
      ],
    );
  }

  Widget _buildPartyField(ThemeData theme) {
    return GestureDetector(
      onTap: () {
        // Close dropdown when tapping outside
        if (_showPartyDropdown) {
          setState(() {
            _showPartyDropdown = false;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Party *',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.surface,
            ),
            child: _isLoadingParties
                ? Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Loading parties...',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.colorScheme.secondary),
                        ),
                      ],
                    ),
                  )
                : _buildPartySearchField(theme),
          ),
          if (_selectedParty != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Party Details',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (_selectedParty['AccAddress'] != null &&
                      _selectedParty['AccAddress'].toString().isNotEmpty)
                    Text(
                      'Address: ${_selectedParty['AccAddress']}',
                      style: theme.textTheme.bodySmall,
                    ),
                  if (_selectedParty['ID'] != null)
                    Text(
                      'ID: ${_selectedParty['ID']}',
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPartySearchField(ThemeData theme) {
    return Column(
      children: [
        TextFormField(
          controller: _partyController,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: 'Search and select party...',
            suffixIcon: _selectedParty != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearPartySearch,
                  )
                : _isSearchingParties
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _filterParties(value);
            });
          },
          onTap: () {
            setState(() {
              _showPartyDropdown = true;
              if (_partyController.text.isEmpty) {
                _filteredPartyList = _partyList;
              }
            });
          },
          validator: (value) {
            return _selectedParty == null ? 'Please select a party' : null;
          },
        ),
        if (_showPartyDropdown)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              color: theme.colorScheme.surface,
            ),
            child: _isSearchingParties
                ? Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Searching parties...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : _filteredPartyList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredPartyList.length,
                        itemBuilder: (context, index) {
                          final party = _filteredPartyList[index];
                          return ListTile(
                            title: Text(
                              party['ByrNam'] ?? 'Unknown Party',
                              style: theme.textTheme.bodyLarge,
                            ),
                            subtitle: party['AccAddress'] != null &&
                                    party['AccAddress'].toString().isNotEmpty
                                ? Text(
                                    party['AccAddress'],
                                    style: theme.textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : null,
                            trailing: Text(
                              'ID: ${party['ID']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedParty = party;
                                _receipt.party = party['ByrNam'] ?? '';
                                _receipt.partyId = party['ID'] ?? 0;
                                _partyController.text = _receipt.party;
                                _showPartyDropdown = false;
                              });
                            },
                          );
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'No parties found matching "${_partyController.text}"',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
          ),
      ],
    );
  }

  void _filterParties(String query) {
    // Cancel previous search timer
    _searchDebounceTimer?.cancel();

    if (query.isEmpty) {
      // If query is empty, show all parties from initial load
      setState(() {
        _filteredPartyList = _partyList;
        _showPartyDropdown = true;
      });
    } else {
      // Debounce the search to avoid too many API calls
      _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
        print("🔍 SEARCHING PARTIES: '$query'");
        setState(() {
          _isSearchingParties = true;
          _showPartyDropdown = true;
        });

        try {
          await _loadPartyList(searchQuery: query);
        } catch (e) {
          print("❌ Search error: $e");
          // On search error, fall back to local filtering
          setState(() {
            _filteredPartyList = _partyList.where((party) {
              final name = party['ByrNam']?.toString().toLowerCase() ?? '';
              final address =
                  party['AccAddress']?.toString().toLowerCase() ?? '';
              final id = party['ID']?.toString() ?? '';
              final queryLower = query.toLowerCase();

              return name.contains(queryLower) ||
                  address.contains(queryLower) ||
                  id.contains(queryLower);
            }).toList();
          });
        } finally {
          setState(() {
            _isSearchingParties = false;
          });
        }
      });
    }
  }

  void _clearPartySearch() {
    setState(() {
      _selectedParty = null;
      _receipt.party = '';
      _receipt.partyId = 0;
      _partyController.clear();
      _showPartyDropdown = false;
      _filteredPartyList = _partyList;
      _searchDebounceTimer?.cancel();
    });
  }

  Widget _buildQuantityRateRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _qtyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _buildInputDecoration('Qty', theme),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Required';
              if (double.tryParse(value!) == null) return 'Invalid number';
              if (double.parse(value) <= 0) return 'Must be greater than 0';
              return null;
            },
            onChanged: (value) {
              _receipt.qty = double.tryParse(value) ?? 0;
              _calculateProcessingCharges();
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _rateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _buildInputDecoration('Rate', theme),
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Required';
              if (double.tryParse(value!) == null) return 'Invalid number';
              if (double.parse(value) <= 0) return 'Must be greater than 0';
              return null;
            },
            onChanged: (value) {
              _receipt.rate = double.tryParse(value) ?? 0;
              _calculateProcessingCharges();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingChargesRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _processingChargesController,
            readOnly: true,
            decoration: _buildInputDecoration(
              'Processing Charges',
              theme,
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _numberOfBagsController,
            keyboardType: TextInputType.number,
            decoration: _buildInputDecoration('No. of Bags', theme),
            onChanged: (value) {
              _receipt.numberOfBags = int.tryParse(value) ?? 1;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRemarkField(ThemeData theme) {
    return TextFormField(
      controller: _remarkController,
      maxLines: 3,
      decoration: _buildInputDecoration('Remark', theme),
      onChanged: (value) => _receipt.remark = value,
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FilledButton.icon(
          onPressed: _isProcessing ? null : _handleSubmit,
          icon: _isProcessing
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: const Text('Save'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          label: const Text('Close'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label, ThemeData theme,
      {bool filled = false, Color? fillColor}) {
    return InputDecoration(
      labelText: label,
      filled: filled,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary),
      ),
    );
  }

  void _calculateProcessingCharges() {
    final qty = double.tryParse(_qtyController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final processingCharges = qty * rate;

    setState(() {
      _receipt.processingCharges = processingCharges;
      _processingChargesController.text = processingCharges.toString();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue[600],
            colorScheme: ColorScheme.light(primary: Colors.blue[600]!),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _receipt.date = _formatDate(picked);
        _dateController.text = _receipt.date;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Future<void> _handleSubmit() async {
    print("📝 FORM SUBMIT TRIGGERED");
    print("   Form valid: ${_formKey.currentState?.validate() ?? false}");
    print(
        "   Selected party before validation: ${_selectedParty != null ? "'${_selectedParty['ByrNam']}' (ID: ${_selectedParty['ID']})" : 'null'}");

    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() => _isProcessing = true);

        print("📋 UPDATING RECEIPT OBJECT:");
        print(
            "   Before update - Party: '${_receipt.party}' (ID: ${_receipt.partyId})");

        // Update receipt object with latest form values
        _receipt.compRefNo = _compRefController.text;
        _receipt.date = _dateController.text;
        _receipt.refNo = _refNoController.text;
        _receipt.qty = double.tryParse(_qtyController.text) ?? 0;
        _receipt.rate = double.tryParse(_rateController.text) ?? 0;
        _receipt.processingCharges =
            double.tryParse(_processingChargesController.text) ?? 0;
        _receipt.numberOfBags = int.tryParse(_numberOfBagsController.text) ?? 1;
        _receipt.remark = _remarkController.text;

        // Ensure party information is set from dropdown selection
        if (_selectedParty != null) {
          _receipt.party = _selectedParty['ByrNam'] ?? '';
          _receipt.partyId = _selectedParty['ID'] ?? 0;
          print(
              "✅ Party set from dropdown: '${_receipt.party}' (ID: ${_receipt.partyId})");
        } else {
          print("⚠️ No party selected in dropdown!");
        }

        print("🚀 FINAL RECEIPT DATA FOR SUBMISSION:");
        print("   GCRID: ${_receipt.gcrid}");
        print("   CompRefNo: '${_receipt.compRefNo}'");
        print("   Party: '${_receipt.party}' (ID: ${_receipt.partyId})");
        print("   Date: '${_receipt.date}'");
        print("   RefNo: '${_receipt.refNo}'");
        print("   Qty: ${_receipt.qty}");
        print("   Rate: ${_receipt.rate}");
        print("   Processing Charges: ${_receipt.processingCharges}");
        print("   Number of Bags: ${_receipt.numberOfBags}");
        print("   Remark: '${_receipt.remark}'");

        bool success;
        if (_receipt.gcrid == 0) {
          // New receipt creation
          print("🆕 Creating new receipt...");
          success = await _apiService.createGreenCardamomReceipt(_receipt);
        } else {
          // Update existing receipt
          print("📝 Updating existing receipt...");
          success = await _apiService.updateGreenCardamomReceipt(_receipt);
        }

        print("📊 API Result: ${success ? 'SUCCESS' : 'FAILED'}");

        if (success) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_receipt.gcrid == 0
                  ? 'Receipt created successfully'
                  : 'Receipt updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Server returned false for receipt operation');
        }
      } catch (e) {
        print("❌ SUBMIT ERROR: $e");
        print("❌ Error type: ${e.runtimeType}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to ${_receipt.gcrid == 0 ? "create" : "update"} receipt: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isProcessing = false);
      }
    } else {
      print("❌ FORM VALIDATION FAILED");
      // Validation failed - show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields correctly'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
