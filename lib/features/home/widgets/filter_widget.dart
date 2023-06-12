import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/home/screens/filter_product.dart';
import 'package:kmutnb_project/features/home/services/home_service.dart';
import 'package:kmutnb_project/features/home/widgets/map_screen.dart';
import 'package:kmutnb_project/features/store/services/add_store_service.dart';

import '../../../models/product.dart';
import '../../../models/province.dart';

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String selectedProvince = '';
  double minPrice = 0.0;
  double maxPrice = 0.0;
  bool sortByPriceLow = false;
  bool sortByPriceHigh = false;

  final ProvinceService provinceService = ProvinceService();
  List<Province> provinces = [];
  String selectedProvinceId = '';
  Key dropdownKey = UniqueKey();
  String keyword = '';
  void _getProvinces() async {
    provinces = await provinceService.fetchAllProvince(context);
    selectedProvinceId = provinces.first.id;

    // เพิ่มตัวเลือกแรกใน dropdown
    provinces.insert(
      0,
      Province(
        id: "",
        provinceThai: "เลือกจากทุกจังหวัดในประเทศไทย",
        area: '',
        bangkokMetropolitan: '',
        femalePopulation62: '',
        fourRegion: '',
        malePopulation62: '',
        officialRegion: '',
        population62: '',
        provinceEng: '-Select from all provinces in Thailand-',
        provinceID: '',
        tourismRegion: '',
      ),
    );
    setState(() {
      dropdownKey = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    _getProvinces();

    selectedProvinceId = ''; // เพิ่มค่า default
    minPrice = 0.0; // เพิ่มค่า default
    maxPrice = 0.0; // เพิ่มค่า default
  }

  void _openMapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    ).then((value) {
      if (value != null) {
        print('Selected Location: $value');
        // ทำสิ่งที่คุณต้องการกับตำแหน่งที่เลือก
        // เช่น แยกข้อมูลเป็นจังหวัด ถนน ตำบล
        // และใช้ข้อมูลเหล่านี้ต่อไป
      }
    });
  }

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // อย่าลืม dispose controller เมื่อสิ้นสุดการใช้งาน
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _openFilterOptions();
            },
          ),
          const Text(
            'Select Filter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _openFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Keyword',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Material(
                      borderRadius: BorderRadius.circular(7),
                      elevation: 1,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            keyword = value;
                          });
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(top: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(7),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 1,
                            ),
                          ),
                          hintText: 'Search ',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    IconButton(
                      icon: const Icon(Icons.map),
                      onPressed: () {
                        _openMapScreen();
                      },
                    ),
                    const Text(
                      'Location Store',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          key: dropdownKey,
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
                                padding: const EdgeInsets.all(8.0),
                                child: Text(province.provinceThai),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Min Price',
                            ),
                            onChanged: (value) {
                              setState(() {
                                minPrice = double.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Max Price',
                            ),
                            onChanged: (value) {
                              setState(() {
                                maxPrice = double.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: sortByPriceLow,
                          onChanged: (value) {
                            setState(() {
                              sortByPriceLow = value ?? false;
                            });
                          },
                        ),
                        const Text('Sort by Price (Low to High)'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: sortByPriceHigh,
                          onChanged: (value) {
                            setState(() {
                              sortByPriceHigh = value ?? false;
                            });
                          },
                        ),
                        const Text('Sort by Price (High to Low)'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      child: const Text('Apply Filters'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  HomeService homeService = HomeService();
  List<Product> productList = [];
  Future<void> _applyFilters() async {
    productList = await homeService.fetchFilterProduct(
      context: context,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortByPriceLow: sortByPriceLow,
      sortByPriceHigh: sortByPriceHigh,
      province: selectedProvinceId,
      productName: keyword,
    );

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterProduct(products: productList),
      ),
    );
  }
}
