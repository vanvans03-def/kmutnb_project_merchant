import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/store/services/add_store_service.dart';

import '../../../models/province.dart';

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String selectedProvince = '';
  double minPrice = 0;
  double maxPrice = 0;
  bool sortByPriceAscending = false;
  bool sortByRating = false;

  final ProvinceService provinceService = ProvinceService();
  List<Province> provinces = [];
  String selectedProvinceId = '';

  void _getProvinces() async {
    provinces = await provinceService.fetchAllProvince(context);
    selectedProvinceId = provinces.first.id;
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
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _openFilterOptions();
              _getProvinces();
              setState(() {});
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
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location',
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
                      value: sortByPriceAscending,
                      onChanged: (value) {
                        setState(() {
                          sortByPriceAscending = value ?? false;
                        });
                      },
                    ),
                    const Text('Sort by Price (Low to High)'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: sortByRating,
                      onChanged: (value) {
                        setState(() {
                          sortByRating = value ?? false;
                        });
                      },
                    ),
                    const Text('Sort by Rating'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  child: Text('Apply Filters'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _applyFilters() {
    // Perform filtering and sorting operations based on the selected options
    // You can use the values of `selectedProvince`, `minPrice`, `maxPrice`, `sortByPriceAscending`, and `sortByRating` to apply the filters
    // Update your product list accordingly
  }
}
