 import 'package:fish_app/Classes/fish.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class  StatisticsPage extends StatefulWidget {
  final List<Fish?> fishes;
  @override
 StatisticsPageState createState() => StatisticsPageState(fishes : fishes);
 const StatisticsPage({super.key, required this.fishes});
}

class StatisticsPageState extends State<StatisticsPage> {

 StatisticsPageState({ required this.fishes});
  final List<Fish?> fishes;

  @override
  Widget build(BuildContext context) {
    return ChartPage(fishes :fishes);
  }


}


class ChartPage extends StatelessWidget {
  const ChartPage({super.key, required this.fishes});
final List<Fish?> fishes;
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
                  maxX: generateChartPoints(fishes).length.toDouble() -1 ,
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: generateChartPoints(fishes),
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
  List<FlSpot> generateChartPoints(List<Fish?> fishes)
  {
    List<FlSpot> points = List<FlSpot>.empty(growable: true);
  for (int i = 0; i < fishes.length; i++)
  {
    points.add(FlSpot(i.toDouble(), fishes[i]?.size.toDouble() ?? 0.0));
  }

  return points;
  }
}