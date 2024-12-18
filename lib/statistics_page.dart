import 'package:fish_app/Classes/fish.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class  StatisticsPage extends StatefulWidget {
  final List<Fish?> fishes;
  @override
 StatisticsPageState createState() => StatisticsPageState();
 const StatisticsPage({super.key, required this.fishes});
}

class StatisticsPageState extends State<StatisticsPage> {
  // Example variables to represent statistics
  String totalPosts = '120';
  String totalLikes = '340';
  String totalFollowers = '230';
  String totalComments = '56';

  // Example method to update statistics (this could be triggered by some event)
  void updateStatistics() {
    setState(() {
      totalPosts = '150';  // Example new value
      totalLikes = '400';  // Example new value
      totalFollowers = '300';  // Example new value
      totalComments = '75';  // Example new value
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChartPage();
  }


}


class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Charts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Line Chart',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 6,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 3),
                        FlSpot(2, 2),
                        FlSpot(3, 5),
                        FlSpot(4, 3),
                        FlSpot(5, 4),
                        FlSpot(6, 5),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}