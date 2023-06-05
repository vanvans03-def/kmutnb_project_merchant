import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/chat/screens/SelectContact.dart';
import 'package:kmutnb_project/features/chat/screens/chat_screen.dart';

import '../../../common/CustomCard.dart';
import '../../../models/ChatModel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.chatmodels, required this.sourchat})
      : super(key: key);

  final List<ChatModel> chatmodels;
  final ChatModel sourchat;
  static const String routeName = '/chat-page';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
        title: const Text('Chat History Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectContact()),
          );
        },
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: widget.chatmodels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  chatName: '',
                  receiverId: '',
                  senderId: '',
                ),
              ),
            );
          },
          child: CustomCard(
            chatModel: widget.chatmodels[index],
            sourchat: widget.sourchat,
          ),
        ),
      ),
    );
  }
}
