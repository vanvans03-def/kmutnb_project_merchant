import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_project/features/chat/services/chat_service.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../models/ChatModel.dart';
import '../../../models/chat.dart';
import '../../../providers/user_provider.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String chatName;
  final String senderId;
  static const String routeName = '/chat';

  const ChatScreen({
    Key? key,
    required this.receiverId,
    required this.senderId,
    required this.chatName,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  double? latitude;
  double? longtitude;

  TextEditingController messageController = TextEditingController();
  List<String> chatMessages = [];
  List<Chat> chatHistory = [];
  final ChatService chatService = ChatService();
  @override
  void initState() {
    super.initState();
    connectSocket();
    loadChatHistory();
  }

  Future<void> loadChatHistory() async {
    chatHistory = await chatService.getChatHistory(
      context: context,
      senderId: widget.senderId,
      receiverId: widget.receiverId,
    );

    setState(() {
      // อัปเดตสถานะของ UI หลังจากเรียงลำดับ
    });
  }

  void connectSocket() {
    socket = IO.io('http://192.168.1.159:3700', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.on('chat message', (data) {
      setState(() {
        chatMessages.add(data['message']);
      });
    });
    socket.connect();
  }

  void sendMessage(String message) {
    socket.emit('message', {
      'senderId': widget.senderId,
      'receiverId': widget.receiverId,
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Chat Screen - ${widget.chatName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // เพื่อให้เรียงลำดับจากล่าสุดไปยังเก่าสุด
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final chat = chatHistory[index];
                final isSentMessage = chat.senderId == widget.senderId;
                final timeDate = chat.timestamp.toString();

                final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'");
                final outputFormat = DateFormat("dd/MM/yy - HH:mm 'น.'");

                final parsedDate = inputFormat.parse(timeDate);
                final formattedDate = outputFormat.format(parsedDate);

                bool showDate =
                    false; // Variable to track the display of the date

                return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (isSentMessage
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showDate =
                              !showDate; // Toggle the display of the date
                        });
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (isSentMessage
                                  ? Colors.orange[200]
                                  : Colors.grey.shade200),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              chat.message,
                              style: TextStyle(
                                fontWeight:
                                    isSentMessage ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
                    messageController.clear();
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
