import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../providers/user_provider.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  final String userId;
  final String userName;
  const ChatScreen({Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  List<String> chatMessages = [];

  @override
  void initState() {
    super.initState();
    connectSocket();
    print(widget.userName);
  }

  void connectSocket() {
    socket = IO.io(uri, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'userId': widget.userId,
      'userName': widget.userName,
    });
    socket.on('connect', (_) {
      print('Connected to socket.io server');
    });
    socket.on('chat message', (data) {
      setState(() {
        chatMessages.add(data);
      });
    });
    socket.connect();
  }

  void sendMessage(String message) {
    socket.emit('chat message', {
      'userId': widget.userId,
      'userName': widget.userName,
      'message': message,
    });
    messageController.clear();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false);
    final userIdA = user.user.id;
    final userNameA = user.user.fullName;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Chat Screen - ${widget.userName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final message = chatMessages[index];
                return ListTile(
                  title: Text(message),
                );
              },
              itemCount: chatMessages.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage(messageController.text);
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
