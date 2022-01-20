import 'package:flutter/material.dart';
import 'package:utem_foodir_vendor/chart/bar_chart_sample1.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);
  static const String id = 'report-screen';

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 50, bottom: 50, right: 10, left: 10),
          child: BarChartSample1(),
        ),
      ),
    );
  }
}
