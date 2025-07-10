import 'package:flutter/material.dart';
import '../models/party.dart';
import '../services/api_service.dart';

class PartyFormWidget extends StatefulWidget {
  final Function? onSuccess;
  final Party? initialData;

  const PartyFormWidget({
    Key? key,
    this.onSuccess,
    this.initialData,
  }) : super(key: key);

  @override
  _PartyFormWidgetState createState() => _PartyFormWidgetState();
}

class _PartyFormWidgetState extends State<PartyFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isProcessing = false;
  bool _isCredit = false;
  String _selectedGroup = 'Sundry Debtors';
  final List<String> _groupOptions = [
    'Sundry Debtors',
    'Sundry Creditors',
    'Staff',
    'Bank Accounts',
    'Cash in Hand'
  ];

  // Text controllers
  final _codeController = TextEditingController();
  final _accountHeadController = TextEditingController();
  final _openingBalanceController = TextEditingController(text: '0');
  final _gstNoController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _maxCreditDaysController = TextEditingController(text: '0');
  final _maxCreditAmountController = TextEditingController(text: '0');
  final _discountController = TextEditingController(text: '0');
  final _bankDetailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize form with existing data if provided
    if (widget.initialData != null) {
      _codeController.text = widget.initialData!.partyCode;
      _accountHeadController.text = widget.initialData!.partyName;
      _openingBalanceController.text = widget.initialData!.balance.toString();
      _addressController.text = widget.initialData!.address;
      _cityController.text = widget.initialData!.city;
      _pinCodeController.text = widget.initialData!.pinCode;
      _phoneController.text = widget.initialData!.phoneNumber;
      _contactPersonController.text = widget.initialData!.contactPerson;

      // These fields aren't in the basic Party model but might be in an extended version
      // For now, we'll leave them with default values
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _accountHeadController.dispose();
    _openingBalanceController.dispose();
    _gstNoController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    _phoneController.dispose();
    _contactPersonController.dispose();
    _maxCreditDaysController.dispose();
    _maxCreditAmountController.dispose();
    _discountController.dispose();
    _bankDetailsController.dispose();
    super.dispose();
  }

  Future<void> _saveParty() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Create Party object with available fields
    final newParty = Party(
      id: widget.initialData?.id,
      partyCode: _codeController.text,
      partyName: _accountHeadController.text,
      contactPerson: _contactPersonController.text,
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      city: _cityController.text,
      pinCode: _pinCodeController.text,
      balance: double.tryParse(_openingBalanceController.text) ?? 0.0,
    );

    // Use additional fields in API call if needed
    // These can be added to the Party model if required

    try {
      final result = await _apiService.addParty(newParty);

      if (!mounted) return;

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        // Show a success popup dialog
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Party added successfully!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        // Call success callback if provided
        if (widget.onSuccess != null) {
          widget.onSuccess!();
        }
        // Close the form
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _isProcessing = false;
        });

        // Check if session expired
        if (result['sessionExpired'] == true) {
          // Show a more specific message for session expiry
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('Session Expired'),
              content: const Text(
                  'Your session has expired. Please log in again to continue.'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Navigate to login screen and clear navigation stack
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', // Replace with your login route
                      (route) => false,
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Show regular error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 1: Code and Account Head
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _codeController,
                    label: 'Code',
                    hint: 'Enter unique party code',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Code is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _accountHeadController,
                    label: 'Account Head',
                    hint: 'Enter account head',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Account head is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 2: Group Name and Opening Balance
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Group Name',
                    value: _selectedGroup,
                    items: _groupOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue != null) {
                          _selectedGroup = newValue;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _openingBalanceController,
                          label: 'Opening',
                          hint: '0',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Checkbox(
                          value: _isCredit,
                          onChanged: (bool? value) {
                            setState(() {
                              _isCredit = value ?? false;
                            });
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Text('Cr'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 3: Address and GST No
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _addressController,
                    label: 'Address 1',
                    hint: 'Enter address',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _gstNoController,
                    label: 'GST No',
                    hint: 'Enter GST number',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 4: State and City/Location
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'State',
                    value: _stateController.text.isEmpty
                        ? 'Select State'
                        : _stateController.text,
                    items: ['Select State', 'Kerala', 'Tamil Nadu', 'Karnataka']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue != null && newValue != 'Select State') {
                          _stateController.text = newValue;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _cityController,
                    label: 'City/Location',
                    hint: 'Enter city or location',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 5: PIN Code and Max Credit Days
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _pinCodeController,
                    label: 'PIN Code',
                    hint: 'Enter PIN code',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _maxCreditDaysController,
                    label: 'Max Credit Days',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 6: Phone and Max Credit Amount
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _phoneController,
                    label: 'Phone',
                    hint: 'Enter phone number',
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _maxCreditAmountController,
                    label: 'Max Credit Amount',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 7: Discount and Contact Person
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _discountController,
                    label: 'Discount %',
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _contactPersonController,
                    label: 'Contact Person',
                    hint: 'Enter contact person name',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 8: Bank Account Details
            _buildTextField(
              controller: _bankDetailsController,
              label: 'Bank Account Details',
              hint: 'Enter bank account details',
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _saveParty,
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(widget.initialData != null
                          ? 'Update Party'
                          : 'Save Party'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
