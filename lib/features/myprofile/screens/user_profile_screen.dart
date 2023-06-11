import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/store_provider.dart';
import '../../../providers/user_provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const String routeName = '/user-profile-screen';

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          if (userProvider.user.image == "") ...[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey,
              child: Image.asset(
                "assets/images/user.png",
                color: Color.fromRGBO(255, 255, 255, 1),
                height: 60,
                width: 60,
              ),
            ),
          ] else ...[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                userProvider.user.image,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            userProvider.user.fullName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('แก้ไขโปรไฟล์ส่วนตัว'),
            onTap: () {
              // ทำงานเมื่อกดแก้ไขโปรไฟล์ส่วนตัว
            },
          ),
          const Divider(
            height: 2,
            thickness: 2,
            indent: 20,
            endIndent: 0,
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('กดดูประวัติออร์เดอร์'),
            onTap: () {
              // ทำงานเมื่อกดดูประวัติออร์เดอร์
            },
          ),
          const Divider(
            height: 2,
            thickness: 2,
            indent: 20,
            endIndent: 0,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('ออกจากระบบ'),
            onTap: () {
              // ทำงานเมื่อกดออกจากระบบ
            },
          ),
          const Divider(
            height: 2,
            thickness: 2,
            indent: 20,
            endIndent: 0,
          ),
        ],
      ),
    );
  }
}
