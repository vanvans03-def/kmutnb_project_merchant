// ignore_for_file: unused_field

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project_merchant/common/widgets/custom_textfield.dart';
import 'package:kmutnb_project_merchant/common/widgets/customer_button.dart';

import 'package:kmutnb_project_merchant/models/province.dart';

import '../services/add_store_service.dart';
import 'package:file_picker/file_picker.dart';

class AddStoreScreen extends StatefulWidget {
  static const String routeName = '/add-store';
  const AddStoreScreen({Key? key}) : super(key: key);

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController idcardController = TextEditingController();
  TextEditingController _coverImageController = TextEditingController();
  TextEditingController _storeImageController = TextEditingController();
  File? _selectedImageCover;
  File? _selectedImageProfile;
  final AddStoreService addStoreService = AddStoreService();
  final ProvinceService provinceService = ProvinceService();
  File? _selectedImageid;
  final _addStoreFormKey = GlobalKey<FormState>();
  File? _profileImage;
  File? _coverImage;
  File? images;
  @override
  void dispose() {
    super.dispose();
    storeNameController.dispose();
    descriptionController.dispose();
    _phoneNumberController.dispose();
  } //สร้างตัวแปรตาม json

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('คุณยังไม่มีร้านค้าในระบบ'),
            content: Text('กรุณาสร้างร้านค้าเพื่อใช้งานต่อไป'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
    });
    _getProvinces();
  }

  List<Province> provinces = [];
  String selectedProvinceId = '';

  void _getProvinces() async {
    provinces = await provinceService.fetchAllProvince(context);
    selectedProvinceId = provinces.first.id;

    setState(() {});
  }

  void createStore() {
    if (_addStoreFormKey.currentState!.validate() && _selectedImageid != null) {
      //image is not emopty
      addStoreService.createStore(
        context: context,
        storetName_: storeNameController.text,
        storetDescription_: descriptionController.text,
        storeImage_: _selectedImageCover!,
        banner_: _selectedImageProfile!,
        phone_: _phoneNumberController.text,
        storeShortDescription_: '',
        storeStatus_: '0',
        user_: '',
        idcardImage_: _selectedImageid!,
        province_: selectedProvinceId,
        idcardNo_: idcardController.text,
      );

      setState(() {});
    } else {
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please enter valid product data and at least one image.'),
        ),
      );
    }
  }

  void selectImages() async {
    var res = await pickOneImage();
    setState(() {
      images = res;
    });
  }

  Future<File?> pickOneImage() async {
    File? image;
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (files != null && files.files.isNotEmpty) {
        image = File(files.files.first.path!);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สร้างร้านค้า'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents
          Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    if (_selectedImageCover == null) ...[
                      GestureDetector(
                        onTap: () async {
                          File? image = await pickOneImage();
                          setState(() {
                            _selectedImageCover = image;
                          });
                        },
                        child: Container(
                          height: 150.0,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
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
                                'Add Banner',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else if (_selectedImageCover != null) ...[
                      GestureDetector(
                        onTap: () async {
                          File? image = await pickOneImage();
                          setState(() {
                            _selectedImageCover = image;
                          });
                        },
                        child: Container(
                          height: 150.0,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                          ),
                          child: Image.file(
                            _selectedImageCover!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ],
                ),
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
                              key: _addStoreFormKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                    CustomTextField(
                                      controller: storeNameController,
                                      hintText: 'Store Name',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Store Name is required';
                                        }
                                        return null;
                                      },
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
                                    CustomTextField(
                                      controller: descriptionController,
                                      hintText: 'Description',
                                      maxLines: 7,
                                      validator: (value) {
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        text: "รหัสบัตรประชาชน 13 หลัก",
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(1.0),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    CustomTextField(
                                      controller: idcardController,
                                      hintText: 'ID No.',
                                      validator: (value) {
                                        return null;
                                      },
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
                                    const SizedBox(height: 5),
                                    if (_selectedImageid == null) ...[
                                      GestureDetector(
                                        onTap: () async {
                                          File? image = await pickOneImage();
                                          setState(() {
                                            _selectedImageid = image;
                                          });
                                        },
                                        child: Container(
                                          height: 150.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: const Radius.circular(10),
                                            dashPattern: const [10, 4],
                                            strokeCap: StrokeCap.round,
                                            child: Container(
                                              width: double.infinity,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.folder_open,
                                                    size: 40,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text(
                                                    'Select Images',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ] else if (_selectedImageid != null) ...[
                                      GestureDetector(
                                        onTap: () async {
                                          File? image = await pickOneImage();
                                          setState(() {
                                            _selectedImageid = image;
                                          });
                                        },
                                        child: Container(
                                          height: 150.0,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                          ),
                                          alignment: Alignment.center,
                                          child: Image.file(
                                            _selectedImageid!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    ],
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
                                    CustomTextField(
                                      controller: _phoneNumberController,
                                      hintText: 'Phone number',
                                      validator: (value) {
                                        return null;
                                      },
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
                                      height: 50,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          value: selectedProvinceId,
                                          onChanged: (String? newVal) {
                                            setState(() {
                                              selectedProvinceId = newVal!;
                                            });
                                          },
                                          items: provinces.map((province) {
                                            return DropdownMenuItem<String>(
                                              value: province.id,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Text(province.provinceThai),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    CustomButton(
                                      text: 'ยืนยันการสร้างร้านค้า',
                                      onTap: createStore,
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
    if (_selectedImageProfile == null) {
      return GestureDetector(
        onTap: () async {
          File? image = await pickOneImage();
          setState(() {
            _selectedImageProfile = image;
          });
        },
        child: const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blueGrey,
          child: Icon(
            Icons.add_a_photo,
            size: 40,
            color: Colors.white,
          ),
        ),
      );
    } else if (_selectedImageProfile != null) {
      return GestureDetector(
        onTap: () async {
          File? image = await pickOneImage();
          setState(() {
            _selectedImageProfile = image;
          });
        },
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blueGrey,
          child: CircleAvatar(
            radius: 45,
            backgroundImage: FileImage(
              _selectedImageProfile!,
            ),
          ),
        ),
      );
    } else {
      return Container(); // ถ้าไม่ใช่เงื่อนไขใดเลยให้คืนค่า Container ว่าง
    }
  }
}
