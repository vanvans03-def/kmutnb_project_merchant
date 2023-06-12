import 'package:flutter/material.dart';

import '../models/province.dart';

class ProvincesProvider extends ChangeNotifier {
  List<Province> provinces = [];
  String? _selectedProvinceId;

  String? get selectedProvinceId => _selectedProvinceId;

  set selectedProvinceId(String? value) {
    _selectedProvinceId = value;
    notifyListeners();
  }

  // เพิ่มเมธอดอื่น ๆ ที่เกี่ยวข้องตามต้องการ
}
