import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/custom_textfield.dart';
import '../../../models/province.dart';
import '../../../models/store.dart';
import '../../store/services/add_store_service.dart';

class StoreDetailsScreen extends StatefulWidget {
  static const routeName = '/storeDetails';
  StoreDetailsScreen({Key? key, required this.store}) : super(key: key);
  final Store store;

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreen();
}

class _StoreDetailsScreen extends State<StoreDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<Province> provinces = [];
  final ProvinceService provinceService = ProvinceService();
  Future<String> _getProvinces(String pvId) async {
    String provicneName = '';
    provinces = await provinceService.fetchAllProvince(context);
    for (int i = 0; i < provinces.length; i++) {
      if (provinces[i].id == pvId) {
        provicneName = provinces[i].provinceThai;
        break;
      }
    }
    return provicneName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดร้านค้า'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents
          Column(
            children: <Widget>[
              Column(
                children: [
                  if (widget.store.banner == '') ...[
                    Container(
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'กรุณาเพิ่มรูปปก',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else if (widget.store.banner != '') ...[
                    Container(
                      height: 150.0,
                      color: Colors.orange,
                      child: Image.network(
                        widget.store.banner,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ]
                ],
              ),
              Container(
                child: Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: SingleChildScrollView(
                          child: Form(
                              child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    text: "ชื่อร้านค้า",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(1.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(20),
                                    dashPattern: const [1300, 5],
                                    strokeCap: StrokeCap.round,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 30,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            widget.store.storeName,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    text: "คำอธิบายร้านค้า",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(1.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(20),
                                    dashPattern: const [1300, 5],
                                    strokeCap: StrokeCap.round,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 30,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            widget.store.storeShortDescription,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    text: "เบอร์โทรศัพท์ร้านค้า",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(1.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(20),
                                    dashPattern: const [1300, 5],
                                    strokeCap: StrokeCap.round,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 30,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            widget.store.phone,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    text: "จังหวัดที่ตั้งของร้านค้า",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(1.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(20),
                                    dashPattern: const [1300, 5],
                                    strokeCap: StrokeCap.round,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 30,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          FutureBuilder<String>(
                                            future: _getProvinces(
                                                widget.store.province),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                // สถานะรอการเชื่อมต่อ
                                                return CircularProgressIndicator(); // หรือวิดเจ็ตที่แสดงการรอ
                                              } else if (snapshot.hasError) {
                                                // กรณีเกิดข้อผิดพลาดในการดึงข้อมูล
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                // กรณีค่าพร้อมใช้งาน
                                                String provinceName =
                                                    snapshot.data!;
                                                return Text(provinceName);
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    text: "รหัสบัตรประชาชน",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(1.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(20),
                                    dashPattern: const [1300, 5],
                                    strokeCap: StrokeCap.round,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 30,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            widget.store.idcardNo,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    text: "รูปบัตรประชาชน",
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(1.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: Container(
                                    height: 150.0,
                                    color: Colors.orange,
                                    child: Image.network(
                                      widget.store.idcardImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          // Profile image
          Positioned(
            top: 100.0, // (background container size) - (circle height / 2)
            child: Container(
              height: 100.0,
              width: 100.0,
              child: _buildPositionedImage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionedImage() {
    if (widget.store.storeImage == '') {
      return const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blueGrey,
        child: Icon(
          Icons.store,
          size: 40,
          color: Colors.white,
        ),
      );
    } else if (widget.store.storeImage != '') {
      return CircleAvatar(
        backgroundColor: Colors.teal,
        radius: 50,
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            widget.store.storeImage,
          ),
          radius: 45,
        ),
      );
    } else {
      return Container(); // ถ้าไม่ใช่เงื่อนไขใดเลยให้คืนค่า Container ว่าง
    }
  }
}
