import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:action_cable/action_cable.dart';
import 'package:uuid/uuid.dart';
import 'dart:io'; // Import the dart.io library for Platform checks

class ConversationDetailScreen extends StatefulWidget {
  /// The unique identifier for the conversation.
  final int conversationId;

  /// The title of the conversation.
  final String conversationTitle;

  /// A string representing the participants in the conversation who are not users.
  final String nonUserParticipants;

  /// Creates a new instance of [ConversationDetailScreen].
  ///
  /// The [conversationId] parameter is required and specifies the ID of the conversation.
  /// The [conversationTitle] parameter is required and specifies the title of the conversation.
  /// The [nonUserParticipants] parameter is required and specifies the list of participants who are not users.
  ///
  /// The [key] parameter is optional and can be used to specify a key for the widget.
  const ConversationDetailScreen({
    Key? key,
    required this.conversationId,
    required this.conversationTitle,
    required this.nonUserParticipants,
  }) : super(key: key);

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// This method is typically overridden to return a new instance of the
  /// corresponding State class for this StatefulWidget.
  ///
  /// In this case, it returns an instance of `_ConversationDetailScreenState`.
  @override
  _ConversationDetailScreenState createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  /// Controller for the message input field.
  final TextEditingController _messageController = TextEditingController();

  /// Controller for scrolling the conversation view.
  final ScrollController _scrollController = ScrollController();

  /// Secure storage for storing sensitive data.
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// List of messages in the conversation.
  List<dynamic> _messages = [];

  /// List of participants in the conversation.
  List<dynamic> _participants = [];

  /// Indicates whether data is currently being loaded.
  bool _isLoading = false;

  /// ID of the current user, if available.
  int? _currentUserId;

  /// Instance of ActionCable for real-time communication.
  ActionCable? _cable;

  /// Tracks the connection status of the ActionCable.
  bool _isConnected = false;
  // ActionCable? _cable; // ✅ ActionCable instance
  // bool _isConnected = false; // ✅ Track connection status

  /// Initializes the state of the conversation detail screen.
  ///
  /// This method is called when the state object is first created. It performs
  /// the following actions:
  /// - Calls the `super.initState()` method to ensure that any inherited
  ///   initialization logic is executed.
  /// - Loads the user ID by calling the `_loadUserId()` method.
  /// - Fetches the messages for the conversation by calling the `_fetchMessages()` method.
  /// - Connects to the Action Cable for real-time updates by calling the `_connectToActionCable()` method.
  @override
  void initState() {
    super.initState();
    _loadUserId();
    _fetchMessages();
    _connectToActionCable();
  }

  /// Loads the user ID from secure storage and updates the state with the current user ID.
  ///
  /// This method reads the user ID from secure storage using the key 'user_id'.
  /// If the user ID is found, it is parsed as an integer and assigned to `_currentUserId`.
  /// If the user ID is not found, `_currentUserId` is set to null.
  ///
  /// This method is asynchronous and should be awaited.
  Future<void> _loadUserId() async {
    String? userId = await _secureStorage.read(key: 'user_id');
    setState(() {
      _currentUserId = userId != null ? int.parse(userId) : null;
    });
  }

  Future<void> _fetchMessages() async {
    /// Sets the state to indicate that a loading process is in progress.
    ///
    /// This method updates the `_isLoading` variable to `true`, which can be used
    /// to show a loading indicator in the UI.
    setState(() {
      _isLoading = true;
    });

    /// Reads the authentication token from secure storage. If the token is null,
    /// it sets the `_isLoading` state to false and returns.
    ///
    /// This ensures that the app does not proceed with an invalid or missing token.
    final String? token = await _secureStorage.read(key: 'auth_token');
    if (token == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    /// Dynamically determine the API URL based on the platform
    final apiURL = Platform.isAndroid
        ? 'http://10.0.2.2:3000/api/v0/conversations/${widget.conversationId}' // For Android Emulator
        : 'http://localhost:3000/api/v0/conversations/${widget.conversationId}'; // For iOS or Web

    /// Fetches conversation messages from the server and updates the state.
    ///
    /// This function sends an HTTP GET request to the server to retrieve messages
    /// for the conversation identified by `widget.conversationId`. The request
    /// includes an authorization token in the headers.
    ///
    /// If the request is successful (status code 200), the response body is
    /// decoded into a list of messages and the `_messages` state is updated with
    /// this data. If the request fails, an error message is printed to the debug
    /// console with the status code.
    ///
    /// If an exception occurs during the request, an error message is printed to
    /// the debug console with the exception details.
    ///
    /// Regardless of the outcome, the `_isLoading` state is set to false and the
    /// `_scrollToBottom` function is called to scroll the view to the bottom.
    try {
      final response = await http.get(
        Uri.parse(apiURL),
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

  void _connectToActionCable() async {
    /// Reads the authentication token from secure storage.
    /// If the token is null, the function returns immediately.
    final String? authToken = await _secureStorage.read(key: 'auth_token');
    if (authToken == null) return;

    
    final String wsUrl = Platform.isAndroid
      ? "ws://10.0.2.2:3000/cable" // For Android Emulator
      : "ws://127.0.0.1:3000/cable"; // For iOS or Web

    debugPrint("🔍 Attempting to connect to WebSocket: $wsUrl");

    /// Initializes a WebSocket connection using ActionCable and subscribes to a conversation channel.
    ///
    /// The WebSocket connection is established with the provided `wsUrl` and `authToken`.
    ///
    /// On successful subscription to the `ConversationChannel`, the `_isConnected` state is set to true.
    /// If the connection is disconnected, the `_isConnected` state is set to false.
    ///
    /// When a message is received from the WebSocket:
    /// - If the message is a valid `Map<String, dynamic>`:
    ///   - If the message contains a `client_message_id`, it is checked against existing messages to avoid duplication.
    ///     - If a message with the same `client_message_id` exists, it confirms the previous message received by the server.
    ///     - If the message is new, it is added to the `_messages` list and the `client_message_id` is removed.
    ///     - The `_scrollToBottom` method is called to scroll to the bottom of the message list.
    ///   - If the message does not contain `content` or `content` is null, a warning is logged.
    /// - If the message format is invalid, an error is logged.
    ///
    /// If an error occurs during the connection process, it is caught and logged.
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
            if (_messages.any((m) =>
                m['client_message_id'] == message['client_message_id'])) {
              debugPrint("📩 Message confirmed.");

              final confirmedMessageIndex = _messages.indexWhere((m) =>
                  m['client_message_id'] != null &&
                  m['client_message_id'] == message['client_message_id']);
              _messages[confirmedMessageIndex].remove('client_message_id');
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

  /// Retrieves the first name of a participant based on their user ID.
  ///
  /// This method searches through the list of participants to find the one
  /// with the matching user ID. If a participant with the given user ID is
  /// found, their first name is returned. If no participant is found, the
  /// method returns 'Unknown'.
  ///
  /// - Parameter userId: The ID of the user whose first name is to be retrieved.
  /// - Returns: The first name of the participant, or 'Unknown' if no participant
  ///   with the given user ID is found.
  String _getParticipantFirstName(int userId) {
    final participant = _participants.firstWhere(
      (participant) => participant['user_id'] == userId,
      orElse: () => {'first_name': 'Unknown'},
    );
    return participant['first_name'] ?? 'Unknown';
  }

  /// Sends a message to the server.
  ///
  /// This function retrieves the message content from the `_messageController`,
  /// checks if it is not empty, and then reads the authentication token from
  /// secure storage. If the token is available, it generates a unique identifier
  /// for the message and sends a POST request to the server with the message
  /// content. If the server responds with a status code of 204, the message is
  /// added to the local list of messages and the message input field is cleared.
  /// The view is then scrolled to the bottom to show the new message. If there
  /// is an error during the process, it is logged to the console.
  Future<void> _sendMessage() async {
    final String messageContent = _messageController.text.trim();
    if (messageContent.isEmpty) return;

    final String? token = await _secureStorage.read(key: 'auth_token');
    if (token == null) return;

    var uuid = Uuid();
    String uuid_string = uuid.v1();

    try {
      Map<String, dynamic> message = {
        'client_message_id': uuid_string,
        'content': messageContent
      };

      /// Dynamically determine the API URL based on the platform
      final apiURL = Platform.isAndroid
          ? 'http://10.0.2.2:3000/api/v0/conversations/${widget.conversationId}/messages' // For Android Emulator
          : 'http://localhost:3000/api/v0/conversations/${widget.conversationId}/messages'; // For iOS or Web

      final response = await http.post(
        Uri.parse(apiURL),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 204) {
        setState(() {
          message['user_id'] = _currentUserId;
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

  /// Scrolls the conversation view to the bottom.
  ///
  /// This method uses a post-frame callback to ensure that the scroll
  /// controller has clients before attempting to animate to the bottom
  /// of the scrollable content. The animation duration is set to 300
  /// milliseconds with an ease-out curve.
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

  /// Builds the conversation detail screen which displays a list of messages
  /// and an input field to send new messages.
  ///
  /// The screen consists of:
  /// - An AppBar displaying the non-user participants.
  /// - A body containing:
  ///   - A loading indicator or a list of messages.
  ///   - Each message is displayed with the content, sender's first name, and sent time.
  ///   - Messages are aligned to the right if sent by the current user, otherwise to the left.
  ///   - Unconfirmed messages have a different margin.
  /// - A message input row with a text field and a send button.
  ///
  /// The message content is ensured to be a string, and the user ID is ensured to be an integer.
  /// If the message content is null, a default error message is shown.
  /// If the sent date is null, the current date and time are used.
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
                      // final participantFirstName =
                      //     _getParticipantFirstName(userId);

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
                                    "${sentDate.hour}:${sentDate.minute.toString().padLeft(2, '0')}",
                                    // "$participantFirstName - ${sentDate.hour}:${sentDate.minute.toString().padLeft(2, '0')}",
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
          // Message Input Row
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 8.0, 20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(19.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
