import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_project/features/chat/screens/SelectContact.dart';
import 'package:kmutnb_project/features/chat/screens/chat_screen.dart';
import 'package:kmutnb_project/features/chat/services/chat_service.dart';
import 'package:kmutnb_project/models/store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../common/CustomCard.dart';
import '../../../models/ChatModel.dart';
import '../../../models/chat.dart';
import '../../../models/user.dart';
import '../../../models/userData.dart';
import '../../../providers/store_provider.dart';
import '../../../providers/user_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static const String routeName = '/chat-page';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Chat> chatHistory = [];
  List<Chat> lastChatHistory = [];
  final ChatService chatService = ChatService();

  @override
  void initState() {
    super.initState();
    getAllChatHistory();
    setState(() {});
  }

  Future<String> getChatName(Chat lastchat) async {
    String chatName;
    Store storeData;
    UserData userdata;
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    if (storeProvider.store.user != lastchat.senderId) {
      storeData = await chatService.getStoreByUID(
          context: context, storeUID: lastchat.receiverId);
      chatName = storeData.storeName;
    } else {
      print('get user');
      userdata = await chatService.getUserByUID(
          context: context, userUID: lastchat.receiverId);
      print(userdata);
      chatName = userdata.fullName;
    }
    return chatName;
  }

  String getTime(DateTime time) {
    final outputFormat = DateFormat("dd/MM HH:mm 'น.'");
    final formattedDate = outputFormat.format(time);
    return formattedDate;
  }

  Future<void> getAllChatHistory() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    chatHistory = await chatService.getAllChatHistory(
      context: context,
      uid: userProvider.user.id,
    );

    setState(() {
      final uniqueReceiverIds = <String>{};
      lastChatHistory = [];

      for (final chat in chatHistory) {
        if (chat.senderId == userProvider.user.id) {
          uniqueReceiverIds.add(chat.receiverId);
        }
      }

      for (final receiverId in uniqueReceiverIds) {
        final lastChat = chatHistory.lastWhere(
          (chat) =>
              chat.receiverId == receiverId &&
              chat.senderId == userProvider.user.id,
        );
        lastChatHistory.add(lastChat);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Chat History Screens'),
      ),
      body: ListView.builder(
        itemCount: lastChatHistory.length,
        itemBuilder: (context, index) => GestureDetector(
          child: InkWell(
            onTap: () async {
              String chatName = '';
              Store storeData;
              UserData userdata;
              final storeProvider =
                  Provider.of<StoreProvider>(context, listen: false);
              if (storeProvider.store.user != lastChatHistory[index].senderId) {
                storeData = await chatService.getStoreByUID(
                    context: context,
                    storeUID: lastChatHistory[index].receiverId);
                chatName = storeData.storeName;
              } else {
                userdata = await chatService.getUserByUID(
                    context: context,
                    userUID: lastChatHistory[index].receiverId);
                chatName = userdata.fullName;
              }

              // ignore: use_build_context_synchronously
              Navigator.pushNamed(
                context,
                ChatScreen.routeName,
                arguments: {
                  'receiverId': lastChatHistory[index].receiverId,
                  'chatName': chatName,
                  'senderId': userProvider.user.id,
                },
              );
            },
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blueGrey,
                    child: Image.asset(
                      "assets/images/user.png",
                      color: Colors.white,
                      height: 36,
                      width: 36,
                    ),
                  ),
                  title: FutureBuilder<String>(
                    future: getChatName(lastChatHistory[index]),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Text(
                          snapshot.data!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  subtitle: Row(
                    children: [
                      const SizedBox(
                        width: 3,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            lastChatHistory[index].message,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          getTime(lastChatHistory[index].timestamp),
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 80),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
