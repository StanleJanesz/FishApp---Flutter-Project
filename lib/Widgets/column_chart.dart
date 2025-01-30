
import 'dart:math';
import 'package:fish_app/Classes/fish.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ColumnChart extends StatefulWidget {
  final Map<int, List<Fish>> fishMap;
  final int valueType;
  const ColumnChart({super.key, required this.fishMap, required this.valueType});
  @override
  ColumnChartState createState() => ColumnChartState();
}

class ColumnChartState extends State<ColumnChart> {
  int maxY = 50;
  int findMax() {
    switch (widget.valueType) {
      case 0:
        return max(
            widget.fishMap.entries.fold(
                0,
                (previousValue, element) => max(
                    previousValue,
                    element.value.fold(
                        0,
                        (previousValue, element) =>
                            max(previousValue, element.size)))),
            50);
      case 1:
        return max(
            widget.fishMap.entries.fold(
                0,
                (previousValue, element) =>
                    max(previousValue, element.value.length)),
            50);
    }
    return 50;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
      constraints: BoxConstraints(
      maxHeight: 9000,
      minHeight: 6000 ),
      child:  BarChart(     
        BarChartData(
          alignment: BarChartAlignment.center,
          maxY: findMax().toDouble(),
          barGroups: generateBarGroups(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitles,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> generateBarGroups() {
    List<BarChartGroupData> groups =
        List<BarChartGroupData>.empty(growable: true);
    for (var fishGroup in widget.fishMap.entries) {
      switch (widget.valueType) {
        case 0:
          groups.add(makeBarGroupData(
              fishGroup.key,
              fishGroup.value
                  .fold(
                      0,
                      (previousValue, element) =>
                          max(previousValue, element.size))
                  .toDouble(),
              Colors.blue));
          break;
        case 1:
          groups.add(makeBarGroupData(
              fishGroup.key, fishGroup.value.length.toDouble(), Colors.blue));
          break;
      }
    }
    groups.sort((a, b) => a.x.compareTo(b.x));
    for (var group in groups) {
      maxY = max(maxY, group.barRods[0].toY.toInt());
    }
    return groups;
  }

  BarChartGroupData makeBarGroupData(
    int x,
    double y,
    Color barColor,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: 10,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final Widget text = Text(
      value.toInt().toString(),
      style: TextStyle(fontSize: 10),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: text,
    );
  }
}
