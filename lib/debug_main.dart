import 'package:flutter/material.dart';
import 'package:shopapp/utils/api_debugger.dart';

/// Simple test app to run the API debugger
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Debugger Test',
      home: DebuggerScreen(),
    );
  }
}

class DebuggerScreen extends StatefulWidget {
  @override
  _DebuggerScreenState createState() => _DebuggerScreenState();
}

class _DebuggerScreenState extends State<DebuggerScreen> {
  bool isRunning = false;
  String output = 'Tap the button below to run API debugging.\n\nThis will analyze the cardamom receipt list API response and help identify any issues.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Debugger'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cardamom API Debug Tool',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This tool will test the GetGreenCardamomReceiptList API and provide detailed debugging information to help resolve "Failed to process response" errors.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isRunning ? null : _runDebugger,
                child: isRunning
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Running Debug...'),
                        ],
                      )
                    : Text('Run API Debug'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Debug Output:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            output,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runDebugger() async {
    setState(() {
      isRunning = true;
      output = 'Starting API debug analysis...\n\nCheck the console/debug output for detailed results.\n\n';
    });

    try {
      // Run the debugger - output will be in console
      await ApiDebugger.debugCardamomReceiptListApi();

      setState(() {
        output += 'Debug analysis completed!\n\n';
        output += 'Please check the console output (in your IDE or flutter logs) for detailed debugging information.\n\n';
        output += 'Look for patterns like:\n';
        output += '- Response status codes\n';
        output += '- Response content analysis\n';
        output += '- JSON parsing results\n';
        output += '- ||JasonEnd delimiter detection\n';
        output += '- JSONData1 field extraction\n\n';
        output += 'This information will help identify the exact cause of "Failed to process response" errors.';
      });
    } catch (e) {
      setState(() {
        output += 'Error running debugger: $e\n\n';
        output += 'This could indicate a network connectivity issue or server problem.';
      });
    } finally {
      setState(() {
        isRunning = false;
      });
    }
  }
}
