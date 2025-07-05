import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/dashboardcontroller.dart';
import 'package:shopapp/controllers/logincontroller.dart';
import 'package:shopapp/controllers/partycontroller.dart';
import 'package:shopapp/controllers/stockcontroller.dart';
// import 'package:shopapp/utils/dbhandler.dart'; // Commented out - using API-based authentication
import 'package:shopapp/views/cardamom/scanner_screen.dart';
import 'package:shopapp/views/cardamom/transaction_view.dart';
import 'package:shopapp/views/cardamom/viewscannedproduct.dart';
import 'package:shopapp/views/itemmaster/itemmaster.dart';
import 'package:shopapp/views/order/orderMaster.dart';
import 'package:shopapp/views/order/selectitems.dart';
import 'package:shopapp/views/partymaster/partymaster.dart';
import 'package:shopapp/views/profile/profile.dart';
import 'package:shopapp/views/settings/settings.dart';


class CardamomDashboard extends StatefulWidget {
  const CardamomDashboard({super.key});

  @override
  State<CardamomDashboard> createState() => _CardamomDashboardState();
}

class _CardamomDashboardState extends State<CardamomDashboard> {
  final Dashboardcontroller dashboardcontroller =
      Get.put(Dashboardcontroller());
  final StockController stockController = Get.put(StockController());
  final PartyController partyController = Get.put(PartyController());

  final LoginController loginController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // DBHandler().checkAllTables(); // Commented out - using API-based authentication
  }

  void _showMenu(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset =
        renderBox.localToGlobal(Offset.zero); // Get position of the icon button

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx + renderBox.size.width, // X position (same X as the button)
        offset.dy + 100, // Y position (just below the button)
        offset.dx, // X position (right of the button)
        offset.dy, // Y position (bottom of the button)
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Get.back(); // Close the menu
              Get.to(() => ProfileScreen()); // Navigate to Profile Screen
            },
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              Get.back(); // Close the menu
              await loginController.logout(); // Call logout function
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text(
          "Cardamom Management",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.green[900],
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.green[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Animated background lines
          Positioned.fill(
            child: CustomPaint(
              painter: _AnimatedLinesPainter(),
            ),
          ),
          // Animated floating card
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: Duration(milliseconds: 900),
              curve: Curves.elasticOut,
              builder: (context, scale, child) => Transform.scale(
                scale: scale,
                child: child,
              ),
              child: Material(
                elevation: 18,
                borderRadius: BorderRadius.circular(36),
                color: Colors.white.withOpacity(0.98),
                child: InkWell(
                  borderRadius: BorderRadius.circular(36),
                  splashColor: Colors.green[100],
                  highlightColor: Colors.green[50],
                  onTap: () {
                    Get.to(() => TransactionView());
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 420,
                      minWidth: 260,
                      minHeight: 320,
                      maxHeight: size.height * 0.8,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 18),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 700),
                            curve: Curves.easeInOutBack,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.green[400]!, Colors.green[700]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.18),
                                  blurRadius: 22,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(24),
                            child: Icon(
                              Icons.spa,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 28),
                          Text(
                            'Cardamom Management',
                            style: TextStyle(
                              fontSize: size.width < 350 ? 20 : 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                              letterSpacing: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 14),
                          Text(
                            'Digitally manage your cardamom business with ease. Track receipts, parties, and transactions in a beautiful, modern dashboard.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width < 350 ? 13.5 : 16.5,
                              color: Colors.green[800],
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[600],
                                foregroundColor: Colors.white,
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                textStyle: TextStyle(fontSize: size.width < 350 ? 15 : 18, fontWeight: FontWeight.bold),
                              ),
                              icon: Icon(Icons.dashboard_customize, size: 22),
                              label: Text('Open Management'),
                              onPressed: () {
                                Get.to(() => TransactionView());
                              },
                            ),
                          ),
                          SizedBox(height: 14),
                          AnimatedOpacity(
                            opacity: 1.0,
                            duration: Duration(seconds: 2),
                            child: Text(
                              'Grow your business, the smart way! 🌱',
                              style: TextStyle(
                                fontSize: size.width < 350 ? 12.5 : 15.5,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for animated background lines
class _AnimatedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.08)
      ..strokeWidth = 2;
    for (double y = 0; y < size.height; y += 48) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final paint2 = Paint()
      ..color = Colors.green.withOpacity(0.13)
      ..strokeWidth = 1.2;
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint2);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
