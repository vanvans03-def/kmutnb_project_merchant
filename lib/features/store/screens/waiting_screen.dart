import 'package:flutter/material.dart';
import 'package:kmutnb_project_merchant/features/auth/widgets/constants.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: kPrimaryColor,
              radius: 50,
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blueGrey,
                child: Icon(
                  Icons.lock_clock,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'ร้านค้าของคุณยังไม่ถูกเปิดให้ใช้งาน',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
