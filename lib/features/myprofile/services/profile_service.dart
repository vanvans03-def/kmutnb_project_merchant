import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kmutnb_project/constants/error_handling.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/features/home/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class ProfileService {
  void updateUser({
    required BuildContext context,
    required String fullName,
    required String phoneNumber,
    required String address,
    required File? productImage_,
    required bool select,
  }) async {
    try {
      String imageUrls = '';
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (select) {
        final cloudinary = CloudinaryPublic('dp6dsdn8y', 'x2sxr5vn');
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(productImage_!.path, folder: fullName),
        );
        imageUrls = (response.secureUrl);
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/updateUserData'),
        body: jsonEncode(
          {
            'id': userProvider.user.id,
            'image': imageUrls,
            'address': address,
            'fullName': fullName,
            'phoneNumber': phoneNumber
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = jsonDecode(res.body);
          var data = responseJson['data'];
          User user = userProvider.user.copyWith(
            image: data['image'],
            address: data['address'],
            fullName: data['fullName'],
            phoneNumber: data['phoneNumber'],
          );
          userProvider.setUserFromModel(user);
          Navigator.pushReplacementNamed(context, '/actual-home');
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
  }
}
