import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatelessWidget {
  static const String routeName = '/chat_history';

  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: ดึงประวัติการแชทจากแหล่งข้อมูล เช่น API หรือฐานข้อมูล

    // สมมติให้ประวัติการแชทเป็น List ของผู้ใช้ (User) ที่เกี่ยวข้อง
    List<User> chatUsers = [
      User(id: 1, name: 'John'),
      User(id: 2, name: 'Alice'),
      User(id: 3, name: 'Bob'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
      ),
      body: ListView.builder(
        itemCount: chatUsers.length,
        itemBuilder: (context, index) {
          User user = chatUsers[index];
          return Column(
            children: [
              ListTile(
                title: Text(user.name),
                onTap: () {
                  // เมื่อผู้ใช้ถูกแตะ เรียกเมธอดเพื่อเปิดหน้าแชท 1-1
                  _openChatScreen(context, user);
                },
              ),
              const Divider(
                thickness: 1,
              ), // เพิ่มเส้นขีดระหว่างผู้ใช้
            ],
          );
        },
      ),
    );
  }

  void _openChatScreen(BuildContext context, User user) {
    // TODO: นำข้อมูลผู้ใช้ไปใช้ในหน้าแชท 1-1 โดยใช้ user.id หรือข้อมูลที่เกี่ยวข้อง

    // ตัวอย่างการเปิดหน้าแชท 1-1
    Navigator.pushNamed(context, '/chat', arguments: {
      'userId': user.id,
      'userName': user.name,
    });
  }
}

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});
}
