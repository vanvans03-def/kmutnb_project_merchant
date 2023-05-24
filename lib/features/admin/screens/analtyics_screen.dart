import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';
import 'package:kmutnb_project/features/admin/widgets/category_product_chart.dart';

import '../../../common/widgets/loader.dart';
import '../model/sales.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminService adminService = AdminService();
  int? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningsData = await adminService.getEarnings(context);
    totalSales = earningsData['totalEarnings'];
    earnings = earningsData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            children: [
              Text(
                '฿ $totalSales',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CategoryProductsChart(sectors: earnings)
            ],
          );
  }
}
