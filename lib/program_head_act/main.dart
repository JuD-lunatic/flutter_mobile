import 'package:flutter/material.dart';
import 'implement_subjects.dart';
import 'profile.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ACTProgramHeadScreen(),
    );
  }
}

class ACTProgramHeadScreen extends StatelessWidget {
  const ACTProgramHeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF6CBCFB),
        toolbarHeight: 140,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: const Text(
          '  Dashboard',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'KronaOne',
          ),
        ),
      ),
      body: const BarGraph(),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          color: Colors.white,
          child: SizedBox(
            height: 80.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.dashboard,
                        color: Color(0xFF0187F1),
                      ),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0187F1),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ImplementingSubjectsScreen()),
                    );
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.manage_accounts,
                      ),
                      Text(
                        'Manage Subjects',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GrowthData {
  final String month;
  final double value;

  GrowthData(this.month, this.value);
}

class BarGraph extends StatefulWidget {
  const BarGraph({super.key});

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  late List<charts.Series<GrowthData, String>> _seriesList;

  @override
  void initState() {
    super.initState();
    _seriesList = _createSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Computer Studies Completion Rate Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1500,
              child: charts.BarChart(
                _seriesList,
                animate: true,
                domainAxis: charts.OrdinalAxisSpec(
                  viewport: charts.OrdinalViewport('Aug', 5),
                ),
                defaultRenderer: charts.BarRendererConfig(
                  cornerStrategy: const charts.ConstCornerStrategy(4),
                ),
                behaviors: [
                  charts.SeriesLegend(),
                  charts.ChartTitle('Month',
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea),
                  charts.ChartTitle('Completion Rate',
                      behaviorPosition: charts.BehaviorPosition.start,
                      titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea),
                ],
                primaryMeasureAxis: charts.NumericAxisSpec(
                  tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                    (num? value) => value != null ? '${value.toInt()}%' : '',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<charts.Series<GrowthData, String>> _createSampleData() {
    List<String> months = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    List<GrowthData> beginningData = [];
    List<GrowthData> developingData = [];
    List<GrowthData> approachingData = [];
    List<GrowthData> proficientData = [];

    for (var month in months) {
      beginningData.add(GrowthData(month, (Random().nextDouble() * 100)));
      developingData.add(GrowthData(month, (Random().nextDouble() * 100)));
      approachingData.add(GrowthData(month, (Random().nextDouble() * 100)));
      proficientData.add(GrowthData(month, (Random().nextDouble() * 100)));
    }

    return [
      charts.Series<GrowthData, String>(
        id: 'BSIT',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: beginningData,
        displayName: 'BSIT',
      ),
      charts.Series<GrowthData, String>(
        id: 'BSCS',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: developingData,
        displayName: 'BSCS',
      ),
      charts.Series<GrowthData, String>(
        id: 'BLIS',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: approachingData,
        displayName: 'BLIS',
      ),
      charts.Series<GrowthData, String>(
        id: 'ACT',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: proficientData,
        displayName: 'ACT',
      ),
    ];
  }
}
