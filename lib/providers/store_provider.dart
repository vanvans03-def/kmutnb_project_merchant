import 'package:kmutnb_project/models/store.dart';
import 'package:flutter/material.dart';

class StoreProvider extends ChangeNotifier {
  Store _store = Store(
      user: '',
      banner: '',
      phone: '',
      storeDescription: '',
      storeId: '',
      storeImage: '',
      storeName: '',
      storeStatus: '',
      storeShortDescription: '');

  Store get store => _store;

  void setStore(Map<String, dynamic> storeData) {
    _store = Store.fromMap(storeData['data']);
    notifyListeners();
  }

  void setStorerFromModel(Store store) {
    _store = store;
    notifyListeners();
  }
}
