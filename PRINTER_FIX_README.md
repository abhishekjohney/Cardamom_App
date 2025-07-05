# Thermal Printer Fix for Cardamom App

## Issue Description
The app was experiencing garbled text output when printing to 3-inch thermal printers, particularly with special characters and extended ASCII characters showing as random symbols.

## Root Cause
The issue was caused by character encoding problems in the Flutter Bluetooth Printer package. The package was not properly handling non-ASCII characters and special characters, leading to corrupted output.

## Solution Implemented

### 1. Created ThermalPrinterUtils Class
- **Location**: `lib/utils/thermal_printer_utils.dart`
- **Purpose**: Provides utility functions for proper ESC/POS command generation and text encoding
- **Key Features**:
  - Text sanitization for thermal printers
  - ESC/POS command generation
  - Proper character encoding handling
  - Pre-built receipt templates

### 2. Updated ReceiptScreen
- **Location**: `lib/views/cardamom/receiptscreen.dart`
- **Changes**:
  - Added proper character encoding handling
  - Implemented raw ESC/POS command printing
  - Added multiple printing methods for testing
  - Improved error handling and user feedback

### 3. Created Debug Screen
- **Location**: `lib/views/cardamom/printer_debug_screen.dart`
- **Purpose**: Provides debugging tools for printer connectivity and testing
- **Features**:
  - Device selection interface
  - Multiple test printing methods
  - Troubleshooting information

## Key Features of the Fix

### Text Sanitization
```dart
String cleanText(String text) {
  return text
      .replaceAll('–', '-')
      .replaceAll('—', '-')
      .replaceAll('"', '"')
      .replaceAll('"', '"')
      .replaceAll(RegExp(r'[^\x00-\x7F]'), '?'); // Replace non-ASCII with ?
}
```

### ESC/POS Command Generation
- Initialize printer: `[0x1B, 0x40]`
- Center alignment: `[0x1B, 0x61, 0x01]`
- Bold text: `[0x1B, 0x45, 0x01]`
- Cut paper: `[0x1D, 0x56, 0x00]`

### Proper API Usage
```dart
await FlutterBluetoothPrinter.printBytes(
  address: device.address,
  data: Uint8List.fromList(commands),
  keepConnected: false,
);
```

## How to Use

### Method 1: Using the Enhanced Receipt Screen
1. Navigate to the receipt screen
2. Click "Print with Enhanced Encoding" for the improved method
3. Select your thermal printer
4. The receipt will print with proper character encoding

### Method 2: Using the Debug Screen
1. Navigate to the debug screen
2. Select your printer using the "Select Printer" button
3. Test different printing methods to verify functionality

### Method 3: Using the Utility Class Directly
```dart
// Create receipt commands
List<int> commands = ThermalPrinterUtils.createReceipt(
  companyName: 'Your Company',
  companyAddress: 'Your Address',
  companyPhone: 'Your Phone',
  receiptTitle: 'Receipt Title',
  customerInfo: {...},
  items: [...],
  footer: {...},
);

// Print the receipt
bool success = await ThermalPrinterUtils.printRawData(
  printerAddress, 
  commands
);
```

## Troubleshooting

### Common Issues and Solutions

1. **Garbled Text Output**
   - Use the enhanced encoding method
   - Ensure text is cleaned using `ThermalPrinterUtils.cleanText()`

2. **Printer Not Found**
   - Make sure printer is turned on
   - Check Bluetooth is enabled
   - Pair the printer in device settings first

3. **Printing Fails**
   - Verify printer supports ESC/POS commands
   - Check if printer is 3-inch thermal printer
   - Ensure proper paper is loaded

4. **Partial Prints**
   - Check printer paper level
   - Verify power connection
   - Use proper feed commands

### Testing Steps
1. Use the debug screen to test basic connectivity
2. Try the "Test Basic Print" to verify raw printing works
3. Use "Test Cleaned Print" to verify text sanitization
4. Use "Test Utility Print" to verify the complete solution

## Dependencies
- `flutter_bluetooth_printer: ^2.19.0`
- `dart:convert` for UTF-8 encoding
- `dart:typed_data` for byte arrays

## Files Modified/Created
- `lib/utils/thermal_printer_utils.dart` (NEW)
- `lib/views/cardamom/receiptscreen.dart` (MODIFIED)
- `lib/views/cardamom/printer_debug_screen.dart` (NEW)

## Benefits
1. **Proper Character Encoding**: Eliminates garbled text
2. **Enhanced Error Handling**: Better user feedback
3. **Debugging Tools**: Easy troubleshooting capabilities
4. **Reusable Components**: Utility class for other screens
5. **Multiple Print Methods**: Fallback options for different printers

## Future Enhancements
- Add support for different paper sizes
- Implement automatic printer detection
- Add receipt templates for different business types
- Support for barcode/QR code printing
- Multi-language support with proper encoding
