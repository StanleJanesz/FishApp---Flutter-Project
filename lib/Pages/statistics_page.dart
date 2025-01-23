 import 'dart:ffi';
import 'dart:math';

import 'package:fish_app/Classes/fish.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fish_app/Widgets/fishing_spot_picker.dart';
import 'package:fish_app/Classes/fishing_place.dart';
import 'package:fish_app/Services/database_service.dart';
import 'package:select_field/select_field.dart';
import 'package:fish_app/Widgets/fish_type_picker.dart';
import 'package:fish_app/Widgets/multichoice_lisr.dart';
import 'package:fish_app/Widgets/group_by_widget.dart'; 
class  StatisticsPage extends StatefulWidget {
  final List<Fish> fishes;
  int valueType = 0;
  int chartType = 0;
  @override
 StatisticsPageState createState() => StatisticsPageState();
 StatisticsPage({super.key, required this.fishes});
}

class StatisticsPageState extends State<StatisticsPage> {

  List<Fish> fishes = [];
  late final  List<FilterData> filters ;
  int valueType = 0;
  int chartType = 0;
//  List<bool> filtersSelected = [false, false, false];
 // List<int> filterValues = [0,0,0];
 // final SelectFieldMenuController<int> fishingSpotController = SelectFieldMenuController<int>();
  //final SelectFieldMenuController<int> fishTypeController = SelectFieldMenuController<int>();
  final SelectFieldMenuController<int> groupController = SelectFieldMenuController<int>();
  final MultiSelectFieldMenuController<int> optionSeletionController = MultiSelectFieldMenuController<int>();

  final List<String> valueOptions = [
    'Size',
    'Count',
  ];
  void _valueOptionsCounter() => setState( () => valueType = (valueType + 1) % valueOptions.length) ;
  void _chartOptionsCounter() => setState( () => chartType = (chartType + 1) % valueOptions.length) ;
  final List<String> chartOptions = [
    'Columns',
    'Line',
  ];
  bool isSize = true;
  @override
  void initState() {


    filters = createFilters();
        getFishes();
        groupController.addListener(() { setState(() {
          getFishes();
        });
        });
      optionSeletionController.addListener(() {
      setState(() {
        for (var filter in filters)
        {
            filter.isSelected = false;
        }
        for (var values in optionSeletionController.selectedOptions)
        {
            filters[values.value].isSelected = true;
        }
        getFishes();  
      });
    });
    super.initState();
    
  }
  void getFishes() async
  {
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
                SizedBox(height: 60, width: 80, child:     ClickableLabelExample(texts: valueOptions, currentTextIndex: valueType,onTap: _valueOptionsCounter), ),
                Expanded(child: Container(),),
                Text('Chart: '),
                SizedBox(height: 60, width: 80,child:     ClickableLabelExample(texts: chartOptions, currentTextIndex: chartType,onTap: _chartOptionsCounter),),
              ],
            ),
            Expanded(
             child: SizedBox(
              height: 200,
              child:  ChartCreator(fishes: fishes, groupBy: groupController.selectedOption?.value ?? 0, chartType: chartType, valueType: valueType),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                height: 400,
                child: ListView(
                 shrinkWrap: true,
                 
                children: [
                  Text('Select fishing spot'),
                  
                  GroupByWidget(menuController: groupController),
                  MultiSelectOptionsControl(
                    options: createFilterOptions(),
                    menuController:optionSeletionController ,
                    ),

                ] + ShowFilters(),
              ),
            ),
            )
          ],
        )

    );
    
  }
  List<int> getFilterValues()
  {
    List<int> values = List<int>.empty(growable: true);
    for (var filter in filters)
    {
      if (filter.isSelected)
      {
      values.add(filter.controller.selectedOption?.value ?? 0);
      } 
      else 
      {
        values.add(0);
      }
    }
    return values;
  }
  List<Widget> ShowFilters()
  {
    List<Widget> selected = List<Widget>.empty(growable: true);
    for (var filter in filters)
    {
      if (filter.isSelected)
      {
        selected.add( filter.widget);
      }
    }
    return selected;
  }
  List<FilterData> createFilters()
  {
    List<FilterData> filters = List<FilterData>.empty(growable: true);
    SelectFieldMenuController<int> fishingSpotController = SelectFieldMenuController<int>();
    fishingSpotController.addListener(() {
      getFishes();
    });
    filters.add(FilterData(label: 'Fishing Spot', widget: FishingSpotPicker(menuController: fishingSpotController), controller: fishingSpotController, isSelected: false));
    SelectFieldMenuController<int> fishTypeController = SelectFieldMenuController<int>();
    fishTypeController.addListener(() {
      getFishes();
    });
    filters.add(FilterData(label: 'Fish Type', widget: FishTypePicker(menuController: fishTypeController), controller: fishTypeController, isSelected: false));
    return filters;
  }
  List<Option<int>> createFilterOptions()
  {
    List<Option<int>> options = List<Option<int>>.empty(growable: true);
    for (int i = 0; i < filters.length; i++)
    {
      options.add(Option<int>(label: filters[i].label, value: i));
    }
    return options;
  }

}
class FilterData 
{
  final String label;
  final Widget widget;
  final SelectFieldMenuController<int> controller;
  bool isSelected;
  FilterData({required this.label, required this.widget, required this.controller, required this.isSelected});
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
  ChartCreator({super.key, required this.fishes, required this.groupBy, required this.chartType, required this.valueType});

  @override
  ChartCreatorState createState() => ChartCreatorState();


 }

class ChartCreatorState extends State<ChartCreator> {
  late List<Fish> fishes;

  @override
  void initState() {
    print("ChartCreatorState created");
    print(widget.fishes.length);
    fishes = widget.fishes;
    super.initState();
  }
 
  Map<int, List<Fish>> groupFish()
  {
    Map<int,List<Fish>> fishMap = {};
    switch(widget.groupBy)
    {
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
  Map<int, List<Fish>> groupFishBySize()
  {
    Map<int,List<Fish>> fishMap = {};
    for (final fish in widget.fishes)
    {
      if(fishMap.containsKey(fish.size))
      {
        fishMap[fish.size]!.add(fish);
      }
      else
      {
        fishMap[fish.size] = [fish];
      }
    }
    return fishMap;
  }
  Map<int, List<Fish>> groupFishByLocation()
  {
    Map<int,List<Fish>> fishMap = {};
    for (final fish in widget.fishes)
    {
      if(fishMap.containsKey(fish.spotId))
      {
        fishMap[fish.spotId]!.add(fish);
      }
      else
      {
        fishMap[fish.spotId] = [fish];
      }
    }
    return fishMap;
  }
    Map<int, List<Fish>> groupFishByType()
  {
    Map<int,List<Fish>> fishMap = {};
    for (final fish in widget.fishes)
    {
      if(fishMap.containsKey(fish.type))
      {
        fishMap[fish.type]!.add(fish);
      }
      else
      {
        fishMap[fish.type] = [fish];
      }
    }
    return fishMap;
  }

  
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: 
            SizedBox(
              height: 100,
              child: ColumnChart(fishMap: groupFish(), valueType: widget.valueType),
          
            
      
      ),
    );
  }


  List<FlSpot> generateChartPoints()
  {
    print("generating chart points");
    print(widget.chartType);
    Map<int, List<Fish>> fishMap = groupFish();
    List<FlSpot> points = List<FlSpot>.empty(growable: true);

  for (var fishGroup in fishMap.entries)
  {
    if (widget.valueType == 0)
    {
      points.add(FlSpot(fishGroup.key.toDouble(), fishGroup.value.fold(0, (previousValue, element) => max(previousValue,  element.size)).toDouble()));
    }
    else
    {
    points.add(FlSpot(fishGroup.key.toDouble(), fishGroup.value.length.toDouble()));
    }
  }
  return points;
  }
}















class ClickableLabelExample extends StatefulWidget {
  final List<String> texts;
  int currentTextIndex = 0;
  final VoidCallback onTap;
  ClickableLabelExample({super.key, required this.texts,required this.currentTextIndex,required this.onTap});

  @override
  _ClickableLabelExampleState createState() => _ClickableLabelExampleState();
}

class _ClickableLabelExampleState extends State<ClickableLabelExample> {
  // List of texts to cycle through when clicking
 late final List<String> _texts;

  // Track the current index of the text
  @override
  void initState() {
    _texts = widget.texts;
    super.initState();
  }

  void _changeText() {
    setState(() {
      widget.onTap();
     // widget.currentTextIndex = (widget.currentTextIndex + 1) % _texts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
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
  
  final SelectFieldMenuController<int> fishingSpotController = SelectFieldMenuController<int>();
  bool isSize = true;
 List<Fish> fishes;


  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: 
            SizedBox(
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
                  maxX: generateChartPoints().length.toDouble() -1 ,
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
  List<FlSpot> generateChartPoints()
  {
    List<FlSpot> points = List<FlSpot>.empty(growable: true);
         
  for (int i = 0; i < fishes.length; i++)
  {
    points.add(FlSpot(i.toDouble(), fishes[i]?.size.toDouble() ?? 0.0));
  }
  return points;
  }

}



class ColumnChart extends StatefulWidget {
  Map<int, List<Fish>> fishMap;
  final int valueType;
  ColumnChart({super.key, required this.fishMap,required this.valueType});
  @override
  _ColumnChartState createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sales Column Chart')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: 50,
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
  List<BarChartGroupData> generateBarGroups()
  {
    List<BarChartGroupData> groups = List<BarChartGroupData>.empty(growable: true);
    for (var fishGroup in widget.fishMap.entries)
    {
    switch(widget.valueType)
    {
      case 0:
        groups.add(makeBarGroupData(fishGroup.key, fishGroup.value.fold(0, (previousValue, element) => max(previousValue,  element.size)).toDouble(), Colors.blue));
        break;
      case 1:
        groups.add(makeBarGroupData(fishGroup.key, fishGroup.value.length.toDouble(), Colors.blue));
        break;
    }
    }
    groups.sort((a, b) => a.x.compareTo(b.x));
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
  //  final titles = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
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


