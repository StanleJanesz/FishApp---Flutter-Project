
import 'dart:math';
import 'package:fish_app/Widgets/column_chart.dart';
import 'package:fish_app/Classes/fish.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fish_app/Widgets/drop_dow_widgets/fishing_spot_picker.dart';
import 'package:fish_app/Services/database_service.dart';
import 'package:select_field/select_field.dart';
import 'package:fish_app/Widgets/drop_dow_widgets/fish_type_picker.dart';
import 'package:fish_app/Widgets/drop_dow_widgets/multichoice_lisr.dart';
import 'package:fish_app/Widgets/drop_dow_widgets/group_by_widget.dart';

class StatisticsPage extends StatefulWidget {
  final List<Fish> fishes;
  @override
  StatisticsPageState createState() => StatisticsPageState();
  const StatisticsPage({super.key, required this.fishes});
}

class StatisticsPageState extends State<StatisticsPage> {
  List<Fish> fishes = [];
  late final List<FilterData> filters;
  int valueType = 0;
  int chartType = 0;
  final SelectFieldMenuController<int> groupController =
      SelectFieldMenuController<int>();
  final MultiSelectFieldMenuController<int> optionSeletionController =
      MultiSelectFieldMenuController<int>();

  final List<String> valueOptions = [
    'Size',
    'Count',
  ];
  void _valueOptionsCounter() =>
      setState(() => valueType = (valueType + 1) % valueOptions.length);
  void _chartOptionsCounter() =>
      setState(() => chartType = (chartType + 1) % valueOptions.length);
  final List<String> chartOptions = [
    'Columns',
    'Line',
  ];
  bool isSize = true;
  @override
  void initState() {
    filters = createFilters();
    getFishes();
    groupController.addListener(() {
      setState(() {
        getFishes();
      });
    });
    optionSeletionController.addListener(() {
      setState(() {
        for (var filter in filters) {
          filter.isSelected = false;
        }
        for (var values in optionSeletionController.selectedOptions) {
          filters[values.value].isSelected = true;
        }
        getFishes();
      });
    });
    super.initState();
  }

  void getFishes() async {
    DatabaseServiceFish databaseServiceFish = DatabaseServiceFish();
    fishes = await databaseServiceFish.getByFilter(getFilterValues());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Text('Value: '),
                SizedBox(
                  height: 60,
                  width: 80,
                  child: ClickableLabelExample(
                      texts: valueOptions,
                      currentTextIndex: valueType,
                      onTap: _valueOptionsCounter),
                ),
                Expanded(
                  child: Container(),
                ),
                Text('Chart: '),
                SizedBox(
                  height: 60,
                  width: 80,
                  child: ClickableLabelExample(
                      texts: chartOptions,
                      currentTextIndex: chartType,
                      onTap: _chartOptionsCounter),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ChartCreator(
                    fishes: fishes,
                    groupBy: groupController.selectedOption?.value ?? 0,
                    chartType: chartType,
                    valueType: valueType),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Select Type of grouping'),
                        ),
                        GroupByWidget(menuController: groupController),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Select filters'),
                        ),
                        MultiSelectOptionsControl(
                          options: createFilterOptions(),
                          menuController: optionSeletionController,
                        ),
                      ] +
                      showFilters() +
                      [
                          SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),

                      ]
                    
                ),
              ),
            )
          ],
        ));
  }

  List<int> getFilterValues() {
    List<int> values = List<int>.empty(growable: true);
    for (var filter in filters) {
      if (filter.isSelected) {
        values.add(filter.controller.selectedOption?.value ?? 0);
      } else {
        values.add(0);
      }
    }
    return values;
  }

  List<Widget> showFilters() {
    List<Widget> selected = List<Widget>.empty(growable: true);
    for (var filter in filters) {
      if (filter.isSelected) {
        selected.add(Text("Select ${filter.label}"));
        selected.add(filter.widget);
      }
    }
    return selected;
  }

  List<FilterData> createFilters() {
    List<FilterData> filters = List<FilterData>.empty(growable: true);
    SelectFieldMenuController<int> fishingSpotController =
        SelectFieldMenuController<int>();
    fishingSpotController.addListener(() {
      getFishes();
    });
    filters.add(FilterData(
        label: 'Fishing Spot',
        widget: FishingSpotPicker(menuController: fishingSpotController),
        controller: fishingSpotController,
        isSelected: false));
    SelectFieldMenuController<int> fishTypeController =
        SelectFieldMenuController<int>();
    fishTypeController.addListener(() {
      getFishes();
    });
    filters.add(FilterData(
        label: 'Fish Type',
        widget: FishTypePicker(menuController: fishTypeController),
        controller: fishTypeController,
        isSelected: false));
    return filters;
  }

  List<Option<int>> createFilterOptions() {
    List<Option<int>> options = List<Option<int>>.empty(growable: true);
    for (int i = 0; i < filters.length; i++) {
      options.add(Option<int>(label: filters[i].label, value: i));
    }
    return options;
  }
}

class FilterData {
  final String label;
  final Widget widget;
  final SelectFieldMenuController<int> controller;
  bool isSelected;
  FilterData(
      {required this.label,
      required this.widget,
      required this.controller,
      required this.isSelected});
}

final List<Option<String>> filterOptions = [
  Option<String>(value: 'Location', label: 'Location'),
  Option<String>(value: 'BaitType', label: 'BaitType'),
];

class ChartCreator extends StatefulWidget {
  final List<Fish> fishes;
  final int groupBy;
  final int chartType;
  final int valueType;
  const ChartCreator(
      {super.key,
      required this.fishes,
      required this.groupBy,
      required this.chartType,
      required this.valueType});

  @override
  ChartCreatorState createState() => ChartCreatorState();
}

class ChartCreatorState extends State<ChartCreator> {
  late List<Fish> fishes;

  @override
  void initState() {
    fishes = widget.fishes;
    super.initState();
  }

  Map<int, List<Fish>> groupFish() {
    Map<int, List<Fish>> fishMap = {};
    switch (widget.groupBy) {
      case 0:
        fishMap = groupFishBySize();
        break;
      case 1:
        fishMap = groupFishByLocation();
        break;
      case 2:
        fishMap = groupFishByType();
        break;
    }
    return fishMap;
  }

  Map<int, List<Fish>> groupFishBySize() {
    Map<int, List<Fish>> fishMap = {};
    for (final fish in widget.fishes) {
      if (fishMap.containsKey(fish.size)) {
        fishMap[fish.size]!.add(fish);
      } else {
        fishMap[fish.size] = [fish];
      }
    }
    return fishMap;
  }

  Map<int, List<Fish>> groupFishByLocation() {
    Map<int, List<Fish>> fishMap = {};
    for (final fish in widget.fishes) {
      if (fishMap.containsKey(fish.spotId)) {
        fishMap[fish.spotId]!.add(fish);
      } else {
        fishMap[fish.spotId] = [fish];
      }
    }
    return fishMap;
  }

  Map<int, List<Fish>> groupFishByType() {
    Map<int, List<Fish>> fishMap = {};
    for (final fish in widget.fishes) {
      if (fishMap.containsKey(fish.type)) {
        fishMap[fish.type]!.add(fish);
      } else {
        fishMap[fish.type] = [fish];
      }
    }
    return fishMap;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 400,
        child: ColumnChart(fishMap: groupFish(), valueType: widget.valueType),
      ),
    );
  }

  List<FlSpot> generateChartPoints() {
    Map<int, List<Fish>> fishMap = groupFish();
    List<FlSpot> points = List<FlSpot>.empty(growable: true);

    for (var fishGroup in fishMap.entries) {
      if (widget.valueType == 0) {
        points.add(FlSpot(
            fishGroup.key.toDouble(),
            fishGroup.value
                .fold(
                    0,
                    (previousValue, element) =>
                        max(previousValue, element.size))
                .toDouble()));
      } else {
        points.add(FlSpot(
            fishGroup.key.toDouble(), fishGroup.value.length.toDouble()));
      }
    }
    return points;
  }
}

class ClickableLabelExample extends StatefulWidget {
  final List<String> texts;
  final int currentTextIndex;
  final VoidCallback onTap;
  const ClickableLabelExample(
      {super.key,
      required this.texts,
      required this.currentTextIndex,
      required this.onTap});

  @override
  ClickableLabelExampleState createState() => ClickableLabelExampleState();
}

class ClickableLabelExampleState extends State<ClickableLabelExample> {
  // List of texts to cycle through when clicking
  late final List<String> _texts;
  late int currentTextIndex;
  // Track the current index of the text
  @override
  void initState() {
    currentTextIndex = widget.currentTextIndex;
    _texts = widget.texts;
    super.initState();
  }

  void _changeText() {
    setState(() {
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _changeText,
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.blue),
          ),
          child: Text(
            _texts[widget.currentTextIndex],
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[800],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartPage extends StatelessWidget {
  ChartPage({super.key, required this.fishes});

  final SelectFieldMenuController<int> fishingSpotController =
      SelectFieldMenuController<int>();
  // bool isSize = true;
  final List<Fish> fishes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 100,
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
            maxX: generateChartPoints().length.toDouble() - 1,
            minY: 0,
            maxY: 100,
            lineBarsData: [
              LineChartBarData(
                spots: generateChartPoints(),
                isCurved: true,
                color: Colors.blue,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> generateChartPoints() {
    List<FlSpot> points = List<FlSpot>.empty(growable: true);

    for (int i = 0; i < fishes.length; i++) {
      points.add(FlSpot(i.toDouble(), fishes[i].size.toDouble()));
    }
    return points;
  }
}
