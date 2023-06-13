import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/account/widgets/orders.dart';
import 'package:provider/provider.dart';

import 'package:kmutnb_project/features/myprofile/screens/edit_profile_screen.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';
import '../../account/screens/account_screen.dart';

class UserProfileScreen extends StatefulWidget {
  static const String routeName = '/user-profile-screen';

  const UserProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  User? user;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.user;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            if (user!.image == "") ...[
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
                  user!.image,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              user!.fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('แก้ไขโปรไฟล์ส่วนตัว'),
              onTap: () async {
                final value = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(),
                  ),
                );
                if (value != null) {
                  setState(() {
                    user = value;
                  });
                }
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()),
                );
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
      ),
    );
  }
}
