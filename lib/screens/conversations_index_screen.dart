import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'conversation_detail_screen.dart';

class ConversationsIndexScreen extends StatefulWidget {
  const ConversationsIndexScreen({super.key});

  @override
  _ConversationsIndexScreenState createState() =>
      _ConversationsIndexScreenState();
}

class _ConversationsIndexScreenState extends State<ConversationsIndexScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  List<dynamic> _conversations = [];
  bool _isLoading = false;
  int _currentUserId = 0;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

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
      final String? userId = await _secureStorage.read(key: 'user_id');
      if (userId == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      _currentUserId = int.parse(userId);

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/v0/conversations'),
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