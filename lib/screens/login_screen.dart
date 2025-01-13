import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A `StatefulWidget` that represents the login screen of the application.
/// 
/// This widget creates an instance of `_LoginScreenState` which contains
/// the logic and UI for the login screen.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Controller for the email input field.
  final TextEditingController _emailController = TextEditingController();

  /// Controller for the password input field.
  final TextEditingController _passwordController = TextEditingController();

  /// Instance of FlutterSecureStorage for securely storing sensitive data.
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  
  /// A boolean flag indicating whether a loading process is ongoing.
  bool _isLoading = false;

  /// A nullable string that holds an error message if an error occurs.
  String? _errorMessage;

  Future<void> _login() async {
    /// Retrieves the email and password input from their respective text controllers.
    /// 
    /// The email is obtained from `_emailController` and the password is obtained
    /// from `_passwordController`.
    /// 
    /// These values are typically used for authentication purposes.
    final String email = _emailController.text;
    final String password = _passwordController.text;

    /// Checks if the email or password fields are empty. If either field is empty,
    /// sets an error message indicating that all fields must be filled out and
    /// returns early.
    /// 
    /// This function is typically used to validate user input before proceeding
    /// with further actions, such as attempting to log in.
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please fill out all fields.";
      });
      return;
    }

    /// Updates the state to indicate that a loading process has started
    /// and clears any existing error message.
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    /// Sends a login request and handles the response, storing the token and user ID if successful.
    try {
      /// Sends a POST request to the login API endpoint with the provided email and password.
      /// 
      /// The request is sent to 'http://localhost:3000/api/v0/login' with a JSON body containing
      /// the email and password. The content type of the request is set to 'application/json'.
      /// 
      /// Returns the response from the server.
      /// 
      /// Example:
      /// ```dart
      /// final response = await http.post(
      ///   Uri.parse('http://localhost:3000/api/v0/login'),
      ///   headers: {'Content-Type': 'application/json'},
      ///   body: jsonEncode({'email': email, 'password': password}),
      /// );
      /// ```
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/v0/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      // Log the response status code and body for debugging
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      /// Handles the response from the login API call.
      /// 
      /// If the response status code is 201, it extracts the token and user ID from the response body,
      /// stores them securely using FlutterSecureStorage, and navigates to the Conversations Index Page.
      /// If the response status code is not 201, it sets an error message indicating invalid email or password.
      /// 
      /// @param response The HTTP response from the login API call.
      /// @param context The BuildContext used for navigation.
      /// 
      /// @throws Exception if there is an error writing to FlutterSecureStorage.
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final String token = data['token']; // Extract the token
        final String userId = data['userId'].toString(); // Extract user ID and convert to string

        // Store the token and user ID securely in FlutterSecureStorage
        await _secureStorage.write(key: 'auth_token', value: token);
        await _secureStorage.write(key: 'user_id', value: userId.toString());

        debugPrint("Logged in successfully: $token");

        // Navigate to Conversations Index Page
        Navigator.pushReplacementNamed(context, '/conversations');
      } else {
        setState(() {
          _errorMessage = "Invalid email or password.";
        });
      }
    /// Handles exceptions that occur during the login process.
    /// 
    /// If an exception is caught, an error message is displayed to the user.
    /// Regardless of whether an exception occurs, the loading state is reset.
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Builds the login screen widget.
  ///
  /// This widget includes:
  /// - An AppBar with the title "Login".
  /// - A Column containing:
  ///   - A TextField for email input with an email keyboard type.
  ///   - A TextField for password input with obscured text.
  ///   - A loading indicator or a login button, depending on the `_isLoading` state.
  ///   - An error message displayed in red text if `_errorMessage` is not null.
  ///
  /// The login button triggers the `_login` function when pressed.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _login,
                    child: Text("Login"),
                  ),
            if (_errorMessage != null) ...[
              SizedBox(height: 20),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
