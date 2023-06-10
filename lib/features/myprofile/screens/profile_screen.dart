import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/store_provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile-screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              storeProvider.store.storeImage[0],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            storeProvider.store.storeName,
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
