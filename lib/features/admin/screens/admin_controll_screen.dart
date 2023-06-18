import 'package:flutter/material.dart';
import 'package:kmutnb_project_merchant/features/admin/screens/store_details.dart';
import 'package:kmutnb_project_merchant/features/admin/services/admin_service.dart';
import 'package:kmutnb_project_merchant/features/auth/widgets/constants.dart';
import 'package:kmutnb_project_merchant/features/myprofile/services/profile_service.dart';

import '../../../constants/global_variables.dart';
import '../../../models/store.dart';

class AdminControlScreen extends StatefulWidget {
  const AdminControlScreen({Key? key}) : super(key: key);

  @override
  _AdminControlScreenState createState() => _AdminControlScreenState();
}

class _AdminControlScreenState extends State<AdminControlScreen> {
  List<Store> storeList = [];
  AdminService adminService = AdminService();

  @override
  void initState() {
    super.initState();
    fetchStore();
  }

  Future<void> fetchStore() async {
    storeList = await adminService.fetchAllStore(context);
    setState(() {});
  }

  ProfileService profileService = ProfileService();
  void changeStatusStore(Store store, String status) async {
    profileService.changeStatusStore(
      context: context,
      status: status,
      store: store,
    );
    await fetchStore(); // เรียกใช้ fetchStore เพื่อดึงข้อมูลร้านค้าล่าสุด
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 2.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradientStore,
              borderRadius: const BorderRadius.only(),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 5.0),
                  blurRadius: 4.0,
                ),
              ],
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 22,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'Admin',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: storeList.length,
        itemBuilder: (context, index) {
          final store = storeList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Colors.grey.shade200,
            child: ListTile(
              leading: store.storeImage != ""
                  ? CircleAvatar(
                      radius: 20,
                      backgroundColor: kPrimaryColor,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(store.storeImage),
                      ),
                    )
                  : const CircleAvatar(
                      radius: 20,
                      backgroundColor: kPrimaryColor,
                      child: Icon(
                        Icons.store,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
              title: Text(store.storeName),
              subtitle: store.storeStatus == '0'
                  ? const Text(
                      'รออนุมัติ',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Text(
                      'ร้านค้าใช้งานได้',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 110,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          changeStatusStore(store, "1");
                          setState(() {});
                        },
                        child: const Text(
                          'อนุมัติร้านค้า',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 110,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('แบนร้านค้า ?'),
                                content: const Text(
                                    'คุณต้องการยกเลิกสถานะของร้านค้าใช่หรือไม่ ?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('ยกเลิก'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'ตกลง',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    onPressed: () {
                                      changeStatusStore(store, "0");
                                      setState(() {
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          'แบนร้านค้า',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreDetailsScreen(store: store),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
