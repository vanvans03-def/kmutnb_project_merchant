import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kmutnb_project/features/admin/model/sales.dart';

class CategoryProductsChart extends StatefulWidget {
  final List<Sales>? sectors;
  const CategoryProductsChart({Key? key, required this.sectors})
      : super(key: key);

  @override
  _CategoryProductsChartState createState() => _CategoryProductsChartState();
}

class _CategoryProductsChartState extends State<CategoryProductsChart> {
  bool _isPieChart = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          isSelected: [_isPieChart, !_isPieChart],
          onPressed: (index) {
            setState(() {
              _isPieChart = index == 0;
            });
          },
          children: [
            Icon(Icons.bar_chart),
            Icon(Icons.pie_chart),
          ],
        ),
        AspectRatio(
          aspectRatio: 1.0,
          child: _isPieChart ? _buildBarChart() : _buildPieChart(),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: _chartSections(widget.sectors!),
        centerSpaceRadius: 80.0,
      ),
    );
  }

  Widget _buildBarChart() {
    // TODO: Implement the bar chart
    return Container();
  }

  List<PieChartSectionData> _chartSections(List<Sales> sectors) {
    final List<PieChartSectionData> list = [];
    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
    ];

    for (var i = 0; i < sectors.length; i++) {
      const double radius = 80.0;
      final data = PieChartSectionData(
        color: colors[i % colors.length],
        value: sectors[i].earning.toDouble(),
        radius: radius,
        title: sectors[i].label,
      );
      list.add(data);
    }

    return list;
  }
}
