import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';
import 'package:kmutnb_project/features/admin/widgets/category_product_chart.dart';

import '../../../common/widgets/loader.dart';
import '../model/sales.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminService adminService = AdminService();
  int? totalSales;
  List<Sales>? earnings;
  late DateTime startDate;
  late DateTime endDate;
  String start = "";
  String end = "";

  @override
  void initState() {
    super.initState();
    getEarnings();
    startDate = DateTime.now();
    endDate = DateTime.now();
  }

  Future<void> getEarnings() async {
    var earningsData = await adminService.getEarningsByDate(
      context: context,
      endDate: end,
      startDate: start,
    );
    totalSales = earningsData['totalEarnings'];
    earnings = earningsData['sales'];
    setState(() {});
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        start = startDate.toString().substring(0, 10);
        end = endDate.toString().substring(0, 10);
      });
      await getEarnings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => _selectDateRange(context),
                              child: const Text(
                                'เลือกแสดงยอดขายโดยระบุวันที่',
                                textAlign: TextAlign.right,
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _selectDateRange(context),
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Start Date: ${startDate.toString().substring(0, 10)}',
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'End Date: ${endDate.toString().substring(0, 10)}',
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                CategoryProductsChart(
                  key:
                      UniqueKey(), // เพิ่ม UniqueKey เพื่อรีเฟรชวิดเจ็ต CategoryProductsChart
                  sectors: earnings!,
                  seriesList: [
                    charts.Series(
                      id: 'Sales',
                      data: earnings!,
                      domainFn: (Sales sales, _) => sales.label,
                      measureFn: (Sales sales, _) => sales.earning,
                    )
                  ],
                  totalsale: totalSales,
                  onDateChanged: (DateTime newStartDate, DateTime newEndDate) {
                    setState(() {
                      startDate = newStartDate;
                      endDate = newEndDate;
                      start = startDate.toString().substring(0, 10);
                      end = endDate.toString().substring(0, 10);
                    });
                    getEarnings();
                  },
                )
              ],
            ),
          );
  }
}
