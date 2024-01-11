// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedGender = 'Male';

  Future<void> loginUser(String username, String password) async {
  var url ="http://localhost/localconnect/login.php";
    var response= await http.post(Uri.parse(url) .replace(queryParameters: {"username": username, "password": password}),
     headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: {
      'username': username,
      "password":password
    });
 
  // Inside loginUser function
if (response.statusCode == 200) {
  // Parse the JSON response
  Map<String, dynamic> data = json.decode(response.body);
  
if (data["status"] == "success") {
  print('Login successful');  // Add this line for debugging
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen(
        username: _usernameController.text,
        gender: _selectedGender,
      ),
    ),
  );
} else {
    // Login failed, show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(data["message"]),
      ),
    );
  }
} else {
  // Handle other response status codes
  print('Failed to connect to the server');
  print('Response code: ${response.statusCode}');
  print('Response body: ${response.body}');
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Gender:'),
                SizedBox(width: 8),
                Radio(
                  value: 'Male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value.toString();
                    });
                  },
                ),
                Text('Male'),
                SizedBox(width: 8),
                Radio(
                  value: 'Female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value.toString();
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  loginUser(
                    _usernameController.text,
                    _passwordController.text,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid credentials'),
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
