import 'package:flutter/material.dart';
import '../models/party.dart';
import '../services/api_service.dart';
import '../widgets/party_form_widget.dart';

class PartyListScreen extends StatefulWidget {
  const PartyListScreen({Key? key}) : super(key: key);
  
  @override
  _PartyListScreenState createState() => _PartyListScreenState();
}

class _PartyListScreenState extends State<PartyListScreen> {
  final ApiService _apiService = ApiService();
  List<Party> _parties = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchParties();
  }

  Future<void> _fetchParties() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final parties = await _apiService.getPartyList();
      setState(() {
        _parties = parties;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Party List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchParties,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPartyModal,
        child: const Icon(Icons.add),
        tooltip: 'Add New Party',
      ),
    );
  }

  // Show modal bottom sheet with party form
  Future<void> _showAddPartyModal() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true, // Important for keyboard handling
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        // Wrap in a container with padding to handle keyboard
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add New Party',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Use the reusable party form widget
                PartyFormWidget(
                  onSuccess: () {
                    // Refresh party list when new party is successfully added
                    _fetchParties();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    // Refresh list if result is true (success)
    if (result == true) {
      _fetchParties();
    }
  }

  // Alternative method: show a dialog with party form
  Future<void> _showAddPartyDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Party'),
        content: SizedBox(
          width: double.maxFinite,
          child: PartyFormWidget(
            onSuccess: () {
              // Refresh party list when new party is successfully added
              _fetchParties();
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    // Refresh list if result is true (success)
    if (result == true) {
      _fetchParties();
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Error loading parties',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchParties,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (_parties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No parties found',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add New Party'),
              onPressed: _showAddPartyModal, // Use modal instead of navigation
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _fetchParties,
      child: ListView.builder(
        itemCount: _parties.length,
        itemBuilder: (context, index) {
          final party = _parties[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  party.partyName.isNotEmpty ? party.partyName[0].toUpperCase() : '?',
                ),
                backgroundColor: Colors.green,
              ),
              title: Text(
                party.partyName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (party.contactPerson.isNotEmpty)
                    Text('Contact: ${party.contactPerson}'),
                  if (party.phoneNumber.isNotEmpty)
                    Text('Phone: ${party.phoneNumber}'),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹ ${party.balance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: party.balance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(party.partyCode),
                ],
              ),
              onTap: () {
                // Show party details or edit form
                _showEditPartyModal(party);
              },
            ),
          );
        },
      ),
    );
  }

  // Show modal for editing an existing party
  Future<void> _showEditPartyModal(Party party) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Party',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Pass the existing party data to the form
                PartyFormWidget(
                  initialData: party,
                  onSuccess: () {
                    _fetchParties();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == true) {
      _fetchParties();
    }
  }
}
