import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // เชื่อมต่อกับเซิร์ฟเวอร์ Socket.IO
    socket = IO.io(uri, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    // ตัวอย่างการตั้งค่า event listener
    socket.on('connect', (_) {
      // ignore: avoid_print
      print('Connected to socket.io server');
    });
    socket.on('chat message', (data) {
      // ignore: avoid_print
      print('Received message: $data');
    });
    socket.connect(); // เชื่อมต่อกับเซิร์ฟเวอร์ Socket.IO
  }

  void sendMessage(String message) {
    // ส่งข้อความผ่าน socket
    socket.emit('chat message', message);
    messageController.clear();
  }

  @override
  void dispose() {
    // ยกเลิกการเชื่อมต่อ socket เมื่อหน้าจอถูกทำลาย
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
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              // แสดงรายการข้อความแชท
              itemBuilder: (context, index) {
                // TODO: ดึงข้อมูลข้อความแชทจากสถานะที่เก็บไว้ (เช่น List<String>)
                // และแสดงผลในรูปแบบที่คุณต้องการ
                return ListTile(
                  title: Text('Message $index'),
                );
              },
              itemCount: 10, // TODO: แก้ไขจำนวนรายการข้อความแชทที่แสดง
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
