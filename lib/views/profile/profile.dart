import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopapp/controllers/logincontroller.dart';

class ProfileScreen extends StatelessWidget {
  final LoginController loginController = Get.find();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              loginController.logout();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade800, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Title
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 40),

                // Load user data when controller is initialized
                Obx(() {
                  loginController.loadUserData();
                  usernameController.text = loginController.username.value;
                  passwordController.text = loginController.password.value;
                  return Column(
                    children: [
                      // Username TextField
                      _buildTextField(

                        controller: usernameController,
                        label: 'Username',
                        icon: Icons.person,
                        isPassword: false,
                      ),
                      SizedBox(height: 20),

                      // Password TextField
                      _buildTextField(
                        controller: passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        isPassword: false,
                      ),
                      SizedBox(height: 20),

                      // Role Dropdown
                      _buildDropdownButton(),
                    ],
                  );
                }),
                SizedBox(height: 40),

                // Update Button
                MaterialButton(
                  onPressed: () async{
                    // Call the updateUser method to save the updated data
                   await loginController.updateUser(
                      usernameController.text,
                      passwordController.text,
                      loginController.selectedRole.value,
                    );
                  },
                  color: Colors.blue,
                  child: Text(
                    'Update',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to create the custom text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isPassword,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.black),
            prefixIcon: Icon(icon, color: Colors.black),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // Method to create the dropdown for selecting role
  Widget _buildDropdownButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: loginController.selectedRole.value,
        isExpanded: true,
        dropdownColor: Colors.white.withOpacity(0.7),
        style: TextStyle(color: Colors.black),
        icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
        items: ['Admin', 'Manager', 'Client']
            .map((role) => DropdownMenuItem<String>(
          value: role,
          child: Text(role),
        ))
            .toList(),
        onChanged: (value) {
          loginController.selectedRole.value = value!;
        },
      ),
    );
  }
}
