import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';

class ThermalPrinterUtils {
  // ESC/POS commands for thermal printer
  static const List<int> ESC_INIT = [0x1B, 0x40]; // Initialize printer
  static const List<int> ESC_ALIGN_CENTER = [0x1B, 0x61, 0x01]; // Center alignment
  static const List<int> ESC_ALIGN_LEFT = [0x1B, 0x61, 0x00]; // Left alignment
  static const List<int> ESC_ALIGN_RIGHT = [0x1B, 0x61, 0x02]; // Right alignment
  static const List<int> ESC_BOLD_ON = [0x1B, 0x45, 0x01]; // Bold on
  static const List<int> ESC_BOLD_OFF = [0x1B, 0x45, 0x00]; // Bold off
  static const List<int> ESC_SIZE_NORMAL = [0x1B, 0x21, 0x00]; // Normal size
  static const List<int> ESC_SIZE_DOUBLE = [0x1B, 0x21, 0x30]; // Double size
  static const List<int> ESC_SIZE_DOUBLE_HEIGHT = [0x1B, 0x21, 0x10]; // Double height
  static const List<int> ESC_SIZE_DOUBLE_WIDTH = [0x1B, 0x21, 0x20]; // Double width
  static const List<int> ESC_CUT = [0x1D, 0x56, 0x00]; // Cut paper
  static const List<int> ESC_NEWLINE = [0x0A]; // New line
  static const List<int> ESC_FEED = [0x1B, 0x64, 0x03]; // Feed paper
  static const List<int> ESC_UNDERLINE_ON = [0x1B, 0x2D, 0x01]; // Underline on
  static const List<int> ESC_UNDERLINE_OFF = [0x1B, 0x2D, 0x00]; // Underline off

  /// Clean and sanitize text for thermal printer
  /// Removes or replaces special characters that may cause encoding issues
  static String cleanText(String text) {
    return text
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('"', '"')
        .replaceAll('"', '"')
        .replaceAll(''', "'")
        .replaceAll(''', "'")
        .replaceAll('…', '...')
        .replaceAll('®', '(R)')
        .replaceAll('™', '(TM)')
        .replaceAll('©', '(C)')
        .replaceAll('°', ' deg')
        .replaceAll('₹', 'Rs.')
        .replaceAll('€', 'EUR')
        .replaceAll('£', 'GBP')
        .replaceAll('¥', 'JPY')
        .replaceAll('¢', 'cents')
        .replaceAll(RegExp(r'[^\x00-\x7F]'), '?'); // Replace non-ASCII with ?
  }

  /// Add text with formatting
  static List<int> addText(String text, {
    bool bold = false,
    bool center = false,
    bool right = false,
    bool doubleSize = false,
    bool doubleHeight = false,
    bool doubleWidth = false,
    bool underline = false,
    bool newLine = true,
  }) {
    List<int> commands = [];
    
    // Set alignment
    if (center) {
      commands.addAll(ESC_ALIGN_CENTER);
    } else if (right) {
      commands.addAll(ESC_ALIGN_RIGHT);
    } else {
      commands.addAll(ESC_ALIGN_LEFT);
    }
    
    // Set text formatting
    if (bold) commands.addAll(ESC_BOLD_ON);
    if (underline) commands.addAll(ESC_UNDERLINE_ON);
    
    // Set text size
    if (doubleSize) {
      commands.addAll(ESC_SIZE_DOUBLE);
    } else if (doubleHeight) {
      commands.addAll(ESC_SIZE_DOUBLE_HEIGHT);
    } else if (doubleWidth) {
      commands.addAll(ESC_SIZE_DOUBLE_WIDTH);
    } else {
      commands.addAll(ESC_SIZE_NORMAL);
    }
    
    // Add the text
    commands.addAll(utf8.encode(cleanText(text)));
    
    // Reset formatting
    if (bold) commands.addAll(ESC_BOLD_OFF);
    if (underline) commands.addAll(ESC_UNDERLINE_OFF);
    commands.addAll(ESC_SIZE_NORMAL);
    commands.addAll(ESC_ALIGN_LEFT);
    
    // Add newline if requested
    if (newLine) {
      commands.addAll(ESC_NEWLINE);
    }
    
    return commands;
  }

  /// Add a horizontal line separator
  static List<int> addSeparator({int length = 32}) {
    List<int> commands = [];
    commands.addAll(ESC_ALIGN_CENTER);
    commands.addAll(utf8.encode('-' * length));
    commands.addAll(ESC_NEWLINE);
    commands.addAll(ESC_ALIGN_LEFT);
    return commands;
  }

  /// Add a blank line
  static List<int> addBlankLine() {
    return List.from(ESC_NEWLINE);
  }

  /// Add multiple blank lines
  static List<int> addBlankLines(int count) {
    List<int> commands = [];
    for (int i = 0; i < count; i++) {
      commands.addAll(ESC_NEWLINE);
    }
    return commands;
  }

  /// Add a two-column row (left and right aligned)
  static List<int> addTwoColumnRow(String left, String right, {int totalWidth = 32}) {
    List<int> commands = [];
    
    String cleanLeft = cleanText(left);
    String cleanRight = cleanText(right);
    
    // Calculate spacing
    int leftLength = cleanLeft.length;
    int rightLength = cleanRight.length;
    int spacesNeeded = totalWidth - leftLength - rightLength;
    
    if (spacesNeeded > 0) {
      String spaces = ' ' * spacesNeeded;
      commands.addAll(utf8.encode(cleanLeft + spaces + cleanRight));
    } else {
      // If text is too long, truncate left text
      int maxLeft = totalWidth - rightLength - 1;
      if (maxLeft > 0) {
        String truncatedLeft = cleanLeft.substring(0, maxLeft);
        commands.addAll(utf8.encode(truncatedLeft + ' ' + cleanRight));
      } else {
        commands.addAll(utf8.encode(cleanRight));
      }
    }
    
    commands.addAll(ESC_NEWLINE);
    return commands;
  }

  /// Print raw data to thermal printer
  static Future<bool> printRawData(String printerAddress, List<int> data) async {
    try {
      Uint8List bytes = Uint8List.fromList(data);
      await FlutterBluetoothPrinter.printBytes(
        address: printerAddress,
        data: bytes,
        keepConnected: false,
      );
      return true;
    } catch (e) {
      print('Error printing raw data: $e');
      return false;
    }
  }

  /// Create a complete receipt with proper formatting
  static List<int> createReceipt({
    required String companyName,
    required String companyAddress,
    required String companyPhone,
    required String receiptTitle,
    required Map<String, String> customerInfo,
    required List<Map<String, String>> items,
    required Map<String, String> footer,
  }) {
    List<int> commands = [];
    
    // Initialize printer
    commands.addAll(ESC_INIT);
    
    // Company header
    commands.addAll(addText(companyName, bold: true, center: true, doubleSize: true));
    commands.addAll(addText(companyAddress, center: true));
    commands.addAll(addText(companyPhone, center: true));
    commands.addAll(addBlankLine());
    
    // Receipt title
    commands.addAll(addSeparator());
    commands.addAll(addText(receiptTitle, bold: true, center: true));
    commands.addAll(addSeparator());
    commands.addAll(addBlankLine());
    
    // Customer information
    customerInfo.forEach((key, value) {
      commands.addAll(addTwoColumnRow(key, value));
    });
    commands.addAll(addBlankLine());
    
    // Items
    items.forEach((item) {
      item.forEach((key, value) {
        commands.addAll(addTwoColumnRow(key, value));
      });
    });
    commands.addAll(addBlankLine());
    
    // Footer
    commands.addAll(addSeparator());
    commands.addAll(addBlankLine());
    footer.forEach((key, value) {
      commands.addAll(addText(value, center: true));
    });
    
    // Feed and cut
    commands.addAll(addBlankLines(3));
    commands.addAll(ESC_CUT);
    
    return commands;
  }
}
