import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'conversation_detail_screen.dart';
import 'dart:io'; // Import the dart.io library for Platform checks

/// A screen that displays a list of conversations.
///
/// This is a stateful widget that creates an instance of
/// `_ConversationsIndexScreenState` to manage its state.
class ConversationsIndexScreen extends StatefulWidget {
  const ConversationsIndexScreen({super.key});

  @override
  _ConversationsIndexScreenState createState() =>
      _ConversationsIndexScreenState();
}

/// Manages the state of the Conversations Index Screen, including fetching and displaying conversations.
class _ConversationsIndexScreenState extends State<ConversationsIndexScreen> {
  /// This screen uses `FlutterSecureStorage` to securely store and retrieve data.
  /// It maintains a list of conversations, a loading state, and the current user's ID.
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  List<dynamic> _conversations = [];
  bool _isLoading = false;
  int _currentUserId = 0;

  /// Initializes the state of the widget and fetches the conversations.
  /// 
  /// This method is called when the state object is created. It calls the 
  /// `_fetchConversations` method to retrieve the list of conversations.
  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  /// Fetches the list of conversations from the server.
  ///
  /// This method retrieves the authentication token and user ID from secure storage.
  /// If either the token or user ID is not found, it stops the loading state and returns.
  /// It then makes an HTTP GET request to the server to fetch the conversations.
  /// If the request is successful (status code 200), it updates the `_conversations` state with the fetched data.
  /// If the request fails, it prints an error message with the status code.
  /// If an exception occurs during the process, it prints the error message.
  /// Finally, it stops the loading state.
  ///
  /// This method should be called within a `StatefulWidget` as it uses `setState` to manage the loading state and update the UI.
  Future<void> _fetchConversations() async {
    setState(() {
      _isLoading = true;
    });

    final String? token = await _secureStorage.read(key: 'auth_token');
    if (token == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      /// Dynamically determine the API URL based on the platform
      final apiURL = Platform.isAndroid
          ? 'http://10.0.2.2:3000/api/v0/conversations' // For Android Emulator
          : 'http://localhost:3000/api/v0/conversations'; // For iOS or Web

      final String? userId = await _secureStorage.read(key: 'user_id');
      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      _currentUserId = int.parse(userId);

      final response = await http.get(
        Uri.parse(apiURL),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> conversationData = jsonDecode(response.body);
        setState(() {
          _conversations = conversationData;
        });
      } else {
        print('Failed to load conversations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching conversations: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Retrieves the names of participants in a conversation who are not the current user.
  ///
  /// This method takes a conversation map and extracts the names of participants
  /// who do not match the current user's ID. It returns a string of these names
  /// concatenated and separated by commas. If no other participants are found,
  /// it returns "No other participants".
  ///
  /// - Parameters:
  ///   - conversation: A map containing conversation details, including participants.
  /// - Returns: A string of non-user participant names or "No other participants" if none are found.
  String _getNonUserParticipantsNames(Map<String, dynamic> conversation) {
    final participants = conversation['conversation_participants'];
    List<String> nonUserNames = [];

    for (var participant in participants) {
      if (participant['user_id'] != _currentUserId) {
        final user = participant['user'];
        final firstName = user != null && user['first_name'] != null
            ? user['first_name']
            : 'Unknown';
        final lastName = user != null && user['last_name'] != null
            ? user['last_name']
            : 'Unknown';

        nonUserNames.add('$firstName $lastName');
      }
    }

    return nonUserNames.isEmpty
        ? "No other participants"
        : nonUserNames.join(', ');
  }

  /// Builds the Conversations Index Screen which displays a list of conversations.
  /// 
  /// The screen shows a loading indicator while the data is being fetched.
  /// Once the data is available, it displays a list of conversations in a card format.
  /// Each card contains:
  /// - A leading CircleAvatar with the first letter of the first participant's name.
  /// - The name of the other participants as the title.
  /// - The conversation title as the subtitle.
  /// 
  /// When a conversation card is tapped, it navigates to the ConversationDetailScreen
  /// with the conversation's ID, title, and non-user participants' information.
  /// 
  /// Returns:
  /// - A Scaffold widget containing an AppBar and a body with either a loading indicator
  ///   or a ListView of conversation cards.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                final otherParticipantInfo =
                    _getNonUserParticipantsNames(conversation);

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        otherParticipantInfo.isNotEmpty
                            ? otherParticipantInfo[0] // Use the first letter of the first participant's name
                            : 'N/A',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    title: Text(
                      otherParticipantInfo,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      conversation['title'] ?? "No Title",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationDetailScreen(
                            conversationId: conversation['id'],
                            conversationTitle: conversation['title'],
                            nonUserParticipants: otherParticipantInfo, // Pass the parameter here
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}