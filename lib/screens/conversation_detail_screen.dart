// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class ConversationDetailScreen extends StatefulWidget {
//   final int conversationId;
//   final String conversationTitle;
//   final String nonUserParticipants;

//   const ConversationDetailScreen({
//     Key? key,
//     required this.conversationId,
//     required this.conversationTitle,
//     required this.nonUserParticipants, // Ensure this is passed
//   }) : super(key: key);

//   @override
//   _ConversationDetailScreenState createState() =>
//     _ConversationDetailScreenState();
// }

// class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
//   List<dynamic> _messages = [];
//   List<dynamic> _participants = [];
//   bool _isLoading = false;
//   int? _currentUserId;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//     _fetchMessages();
//   }

//   // Load current user's ID
//   Future<void> _loadUserId() async {
//     String? userId = await _secureStorage.read(key: 'user_id');
//     setState(() {
//       _currentUserId = userId != null ? int.parse(userId) : null;
//     });
//   }

//   Future<void> _fetchMessages() async {
//     setState(() {
//       _isLoading = true;
//     });

//     final String? token = await _secureStorage.read(key: 'auth_token');
//     if (token == null) {
//       setState(() {
//         _isLoading = false;
//       });
//       return;
//     }

//     try {
//       final response = await http.get(
//         Uri.parse('http://localhost:3000/api/v0/conversations/${widget.conversationId}'),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         // Here, we assume the response body is a list of messages
//         final List<dynamic> messagesData = jsonDecode(response.body);
//         setState(() {
//           _messages = messagesData; // Store the list of messages
//         });
//       } else {
//         debugPrint('Failed to load messages. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error fetching messages: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   String _getParticipantFirstName(int userId) {
//     final participant = _participants.firstWhere(
//       (participant) => participant['user_id'] == userId,
//       orElse: () => {'first_name': 'Unknown'},
//     );
//     return participant['first_name'] ?? 'Unknown';
//   }

//   Future<void> _sendMessage() async {
//     final String messageContent = _messageController.text.trim();
//     if (messageContent.isEmpty) return;

//     final String? token = await _secureStorage.read(key: 'auth_token');
//     if (token == null) return;

//     try {
//       final response = await http.post(
//         Uri.parse('http://localhost:3000/api/v0/conversations/${widget.conversationId}/messages'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'content': messageContent}),
//       );

//       if (response.statusCode == 201) {
//         final newMessage = jsonDecode(response.body);
//         setState(() {
//           _messages.add(newMessage); // Add new message to the list
//           _messageController.clear(); // Clear input field
//         });

//         _scrollToBottom();
//       } else {
//         debugPrint("Failed to send message: ${response.statusCode}");
//       }
//     } catch (e) {
//       debugPrint("Error sending message: $e");
//     }
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // title: Text(widget.conversationTitle),
//         title: Text('${widget.nonUserParticipants}'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Column(
//         children: [
//           // Participants Info
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             // child: Text(
//             //   // 'Participants: ${widget.nonUserParticipants}', // Display the participants
//             //   widget.conversationTitle,
//             //   style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//             // ),
//           ),

//           // Messages List
//           Expanded(
//             child: _isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                   controller: _scrollController,
//                   itemCount: _messages.length,
//                   itemBuilder: (context, index) {
//                     final message = _messages[index]; // This should be a map if each message is a map
//                     final isUserMessage = message['user_id'] == _currentUserId;
//                     final sentDate = DateTime.parse(message['sent_date']).toLocal();
//                     final participantFirstName = _getParticipantFirstName(message['user_id']);

//                     return Align(
//                       alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints(maxWidth: 250),
//                         child: Container(
//                           margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//                           padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//                           decoration: BoxDecoration(
//                             color: isUserMessage ? Colors.blueAccent : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(16.0),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 message['content'],
//                                 style: TextStyle(
//                                   color: isUserMessage ? Colors.white : Colors.black87,
//                                   fontSize: 14.0,
//                                 ),
//                               ),
//                               SizedBox(height: 4.0),
//                               Text(
//                                 "$participantFirstName - ${sentDate.hour}:${sentDate.minute.toString().padLeft(2, '0')}",
//                                 style: TextStyle(
//                                   fontSize: 10.0,
//                                   color: isUserMessage ? Colors.white70 : Colors.black54,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 )

//           ),

//           // Message Input Row
//           Padding(
//             padding: const EdgeInsets.fromLTRB(10.0, 8.0, 8.0, 20.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(19.0),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:action_cable/action_cable.dart';
import 'package:uuid/uuid.dart';

class ConversationDetailScreen extends StatefulWidget {
  final int conversationId;
  final String conversationTitle;
  final String nonUserParticipants;

  const ConversationDetailScreen({
    Key? key,
    required this.conversationId,
    required this.conversationTitle,
    required this.nonUserParticipants,
  }) : super(key: key);

  @override
  _ConversationDetailScreenState createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  List<dynamic> _messages = [];
  List<dynamic> _participants = [];
  bool _isLoading = false;
  int? _currentUserId;
  ActionCable? _cable; // ✅ ActionCable instance
  bool _isConnected = false; // ✅ Track connection status

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _fetchMessages();
    _connectToActionCable();
  }

  Future<void> _loadUserId() async {
    String? userId = await _secureStorage.read(key: 'user_id');
    setState(() {
      _currentUserId = userId != null ? int.parse(userId) : null;
    });
  }

  Future<void> _fetchMessages() async {
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
      final response = await http.get(
        Uri.parse(
            'http://localhost:3000/api/v0/conversations/${widget.conversationId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> messagesData = jsonDecode(response.body);
        setState(() {
          _messages = messagesData;
        });
      } else {
        debugPrint(
            'Failed to load messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _scrollToBottom();
      });
    }
  }

  // ORIGINAL FIX
  void _connectToActionCable() async {
    final String? authToken = await _secureStorage.read(key: 'auth_token');
    if (authToken == null) return;

    final String wsUrl = "ws://127.0.0.1:3000/cable";

    debugPrint("🔍 Attempting to connect to WebSocket: $wsUrl");

    try {
      _cable = ActionCable.Connect(
        wsUrl,
        headers: {"Authorization": "Bearer $authToken"},
      );

      debugPrint("✅ WebSocket connection initialized to: $wsUrl");

      _cable!.subscribe("ConversationChannel",
          channelParams: {"id": widget.conversationId}, onSubscribed: () {
        debugPrint(
            "✅ Subscribed to ConversationChannel for conversation ${widget.conversationId}");
        setState(() {
          _isConnected = true;
        });
      }, onDisconnected: () {
        debugPrint("❌ Disconnected from ActionCable");
        setState(() {
          _isConnected = false;
        });
      }, onMessage: (message) {
        debugPrint("📩 Received message from WebSocket: $message");

        if (message is Map<String, dynamic>) {
          if (!message.containsKey('content') || message['content'] == null) {
            debugPrint("⚠️ Received message with missing content: $message");
          }

          // If the message has a client_message_id, dedupe from existing messages list
          if (message.containsKey('client_message_id')) {
            // If there is an existing message in the list with the same client_message_id, it was sent from this client and does not need to be added as a new message-instead confirm previous message received by server.
            if (_messages.any((m) => m['client_message_id'] == message['client_message_id'])) {
              debugPrint("📩 Message confirmed.");

              var confirmedMessage = _messages.first((m) =>
                  m['client_message_id'] == message['client_message_id']);
              confirmedMessage.remove('client_message_id');
            } else {
              debugPrint("📩 Message is new.");

              // This is not needed on the receiving client(s), remove it.
              message.remove('client_message_id');

              setState(() {
                _messages.add(message);
              });

              _scrollToBottom();
            }
          } else {
            debugPrint("❌ Received an invalid message format: $message");
          }
        }
      });
    } catch (e) {
      debugPrint("❌ Error connecting to ActionCable: $e");
    }
  }

  String _getParticipantFirstName(int userId) {
    final participant = _participants.firstWhere(
      (participant) => participant['user_id'] == userId,
      orElse: () => {'first_name': 'Unknown'},
    );
    return participant['first_name'] ?? 'Unknown';
  }

  Future<void> _sendMessage() async {
    final String messageContent = _messageController.text.trim();
    if (messageContent.isEmpty) return;

    final String? token = await _secureStorage.read(key: 'auth_token');
    if (token == null) return;

    var uuid = Uuid();
    String uuid_string = uuid.v1();

    try {
      var message = {'client_message_id': uuid_string, 'content': messageContent};
      final response = await http.post(
        Uri.parse(
            'http://localhost:3000/api/v0/conversations/${widget.conversationId}/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 204) {
        setState(() {
          _messages.add(message);
          _messageController.clear();
        });

        _scrollToBottom();
      } else {
        debugPrint("Failed to send message: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.nonUserParticipants}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      // ✅ Ensure message content is always a string
                      final String messageContent =
                          (message['content'] ?? '⚠️ Error: No content')
                              .toString();

                      // ✅ Ensure user_id is always an integer
                      final int userId = message['user_id'] ?? -1;

                      final isUserMessage = userId == _currentUserId;

                      bool isUnconfirmedMessage =
                          message['client_message_id'] != null;

                      final sentDate = message['sent_date'] != null
                          ? DateTime.parse(message['sent_date']).toLocal()
                          : DateTime.now();
                      final participantFirstName =
                          _getParticipantFirstName(userId);

                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 250),
                          child: Container(
                            margin: isUnconfirmedMessage
                                ? EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 10.0)
                                : EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 8.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? Colors.blueAccent
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Column(
                              crossAxisAlignment: isUserMessage
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(messageContent,
                                    style: TextStyle(
                                        color: isUserMessage
                                            ? Colors.white
                                            : Colors.black87,
                                        fontSize: 14.0)),
                                SizedBox(height: 4.0),
                                Text(
                                    "$participantFirstName - ${sentDate.hour}:${sentDate.minute.toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: isUserMessage
                                            ? Colors.white70
                                            : Colors.black54)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 8.0, 20.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: _messageController,
                        decoration:
                            InputDecoration(hintText: "Type a message..."))),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
