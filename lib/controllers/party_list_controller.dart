import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/model/party_list_model.dart';
import 'package:shopapp/services/party_list_service.dart';

class PartyListController extends GetxController {
  final PartyListService _partyListService = PartyListService();

  // Observable variables
  final _partyList = <PartyItem>[].obs;
  final _filteredPartyList = <PartyItem>[].obs;
  final _isLoading = false.obs;
  final _error = ''.obs;
  final _totalSum = TotalSum(
    due: 0.0,
    advance: 0.0,
    total: 0.0,
    grandTotal: 0.0,
    totalParties: 0,
  ).obs;

  // Search and filter variables
  final _searchQuery = ''.obs;
  final _selectedGroup =
      'Sundry Creditors'.obs; // Changed to match working React payload
  final _sortType = ''.obs;
  final _excludeZeroBalance = false.obs;

  // Getters
  List<PartyItem> get partyList => _partyList;
  List<PartyItem> get filteredPartyList => _filteredPartyList;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  TotalSum get totalSum => _totalSum.value;
  String get searchQuery => _searchQuery.value;
  String get selectedGroup => _selectedGroup.value;
  String get sortType => _sortType.value;
  bool get excludeZeroBalance => _excludeZeroBalance.value;

  // Available groups for filtering
  final List<String> availableGroups = [
    'All Groups',
    'Sundry Debtors',
    'Sundry Creditors',
    'Cash Account',
    'Bank Account',
  ];

  // Available sort types
  final List<String> availableSortTypes = [
    'Default',
    'A-Z',
    'Z-A',
    'Balance Low to High',
    'Balance High to Low',
  ];

  @override
  void onInit() {
    super.onInit();
    print('🎯 === PARTY LIST CONTROLLER INITIALIZED ===');
    print('📱 Controller onInit called - loading party list');
    loadPartyList();
  }

  Future<void> loadPartyList({String? groups}) async {
    try {
      print('🔄 === LOADING PARTY LIST ===');
      print('📋 Requested groups: ${groups ?? _selectedGroup.value}');

      _isLoading.value = true;
      _error.value = '';

      final groupToLoad = groups ?? _selectedGroup.value;
      print('🏷️ Final group to load: $groupToLoad');

      final response = await _partyListService.getPartyList(
        groups: groupToLoad == 'All Groups' ? '' : groupToLoad,
      );

      _partyList.value = response.partyList;
      _applyFiltersAndSort();
      _calculateTotalSum();

      print('✅ Successfully loaded ${_partyList.length} parties');
      print('📊 Total sum calculated: ${_totalSum.value.grandTotal}');
    } catch (e) {
      _error.value = e.toString();
      print('❌ Error loading party list: $e');
    } finally {
      _isLoading.value = false;
      print('🔄 Loading complete, isLoading: ${_isLoading.value}');
    }
  }

  void searchParties(String query) {
    _searchQuery.value = query;
    _applyFiltersAndSort();
  }

  void sortParties(String sortType) {
    _sortType.value = sortType;
    _applyFiltersAndSort();
  }

  void filterByGroup(String group) {
    _selectedGroup.value = group;
    loadPartyList(groups: group);
  }

  void toggleExcludeZeroBalance(bool exclude) {
    _excludeZeroBalance.value = exclude;
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    var filtered = List<PartyItem>.from(_partyList);

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((party) =>
              party.byrNam
                  .toLowerCase()
                  .contains(_searchQuery.value.toLowerCase()) ||
              party.accAddress
                  .toLowerCase()
                  .contains(_searchQuery.value.toLowerCase()) ||
              party.byrCd
                  .toLowerCase()
                  .contains(_searchQuery.value.toLowerCase()) ||
              (party.phoneNo
                      ?.toLowerCase()
                      .contains(_searchQuery.value.toLowerCase()) ??
                  false))
          .toList();
    }

    // Apply zero balance filter
    if (_excludeZeroBalance.value) {
      filtered = filtered.where((party) => party.balance != 0.0).toList();
    }

    // Apply sorting
    switch (_sortType.value) {
      case 'A-Z':
        filtered.sort((a, b) => a.byrNam.compareTo(b.byrNam));
        break;
      case 'Z-A':
        filtered.sort((a, b) => b.byrNam.compareTo(a.byrNam));
        break;
      case 'Balance Low to High':
        filtered.sort((a, b) => a.balance.compareTo(b.balance));
        break;
      case 'Balance High to Low':
        filtered.sort((a, b) => b.balance.compareTo(a.balance));
        break;
      default:
        // Keep original order
        break;
    }

    _filteredPartyList.value = filtered;
  }

  void _calculateTotalSum() {
    double greenTotal = 0.0;
    double blueTotal = 0.0;
    double redTotal = 0.0;
    double grandTotal = 0.0;

    for (var party in _partyList) {
      grandTotal += party.balance;
      switch (party.balColor.toUpperCase()) {
        case 'GREEN':
          greenTotal += party.balance;
          break;
        case 'BLUE':
          blueTotal += party.balance;
          break;
        case 'RED':
          redTotal += party.balance;
          break;
      }
    }

    _totalSum.value = TotalSum(
      due: greenTotal,
      advance: blueTotal,
      total: redTotal,
      grandTotal: grandTotal,
      totalParties: _partyList.length,
    );
  }

  Future<void> refreshPartyList() async {
    await loadPartyList();
  }

  void clearError() {
    _error.value = '';
  }

  PartyItem? getPartyById(int accAutoID) {
    try {
      return _partyList.firstWhere((party) => party.accAutoID == accAutoID);
    } catch (e) {
      return null;
    }
  }

  List<PartyItem> getPartiesByGroup(String group) {
    return _partyList.where((party) => party.groups == group).toList();
  }

  // Helper method to format currency
  String formatCurrency(double amount) {
    if (amount.abs() >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount.abs() >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${amount.toStringAsFixed(0)}';
    }
  }

  // Get balance display color
  Color getBalanceDisplayColor(PartyItem party) {
    return party.balanceColor;
  }

  // Get summary statistics
  Map<String, dynamic> getSummaryStats() {
    final debtors =
        _partyList.where((p) => p.groups.contains('Debtors')).length;
    final creditors =
        _partyList.where((p) => p.groups.contains('Creditors')).length;
    final positiveBalance = _partyList.where((p) => p.balance > 0).length;
    final negativeBalance = _partyList.where((p) => p.balance < 0).length;
    final zeroBalance = _partyList.where((p) => p.balance == 0).length;

    return {
      'total': _partyList.length,
      'debtors': debtors,
      'creditors': creditors,
      'positiveBalance': positiveBalance,
      'negativeBalance': negativeBalance,
      'zeroBalance': zeroBalance,
    };
  }

  // Fetch party payment details when party is clicked
  Future<List<Map<String, dynamic>>> getPartyPaymentDetails(
      PartyItem party) async {
    try {
      print('🎯 === FETCHING PARTY PAYMENT DETAILS ===');
      print('📋 Party: ${party.byrNam} (${party.byrCd})');
      print('🔢 AccAutoID: ${party.accAutoID}');

      // Important: First ensure we have a fresh party list (this establishes session)
      print('🔐 Ensuring session is active by calling party list first...');
      await loadPartyList();

      print('✅ Session refreshed, now calling payment details...');

      final response = await _partyListService.getPartyPaymentDetails(
        accName: party.byrNam,
        accCode: party.accAutoID,
      );

      print('✅ Successfully fetched payment details for ${party.byrNam}');
      print('📊 Number of records: ${response.length}');

      return response;
    } catch (e) {
      print('❌ Error fetching payment details for ${party.byrNam}: $e');
      rethrow;
    }
  }
}
