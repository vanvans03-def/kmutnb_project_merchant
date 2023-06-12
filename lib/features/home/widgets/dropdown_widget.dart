import 'package:flutter/material.dart';

import '../../../models/province.dart';

class DropdownWidget extends StatelessWidget {
  final List<Province> provinces;
  final String selectedProvinceId;
  final ValueChanged<String> onChanged;

  const DropdownWidget({
    required this.provinces,
    required this.selectedProvinceId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onChanged(newVal!);
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
    );
  }
}
