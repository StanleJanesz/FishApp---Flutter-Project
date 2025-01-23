 import 'dart:ffi';

import 'package:fish_app/Classes/fish.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fish_app/Widgets/fishing_spot_picker.dart';
import 'package:fish_app/Classes/fishing_place.dart';
import 'package:fish_app/Services/database_service.dart';
import 'package:select_field/select_field.dart';
import 'package:fish_app/Widgets/fish_type_picker.dart';
import 'package:fish_app/Widgets/multichoice_lisr.dart';
class  StatisticsPage extends StatefulWidget {
  final List<Fish> fishes;
  @override
 StatisticsPageState createState() => StatisticsPageState();
 const StatisticsPage({super.key, required this.fishes});
}

class StatisticsPageState extends State<StatisticsPage> {

  List<Fish> fishes = [];
  List<bool> filtersSelected = [false, false, false];
  List<int> filterValues = [0,0,0];
  final SelectFieldMenuController<int> fishingSpotController = SelectFieldMenuController<int>();
  final SelectFieldMenuController<int> fishTypeController = SelectFieldMenuController<int>();
  final MultiSelectFieldMenuController<String> optionSeletionController = MultiSelectFieldMenuController<String>();
  bool isSize = true;
  @override
  void initState() {
    
    getFishes();
    fishingSpotController.addListener(() {
      filterValues[0] = fishingSpotController.selectedOption?.value ?? 0;
      getFishes();
    });
    fishTypeController.addListener(() {
      filterValues[1] = fishTypeController.selectedOption?.value ?? 0;
      getFishes();
    });
    super.initState();
   
  }
  void getFishes() async
  {
    DatabaseServiceFish databaseServiceFish = DatabaseServiceFish();
    fishes = await databaseServiceFish.getByFilter(filterValues);
    print(fishes.length);
     setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
        ),
        body: Column(
          children: [
            Expanded(
             child: SizedBox(
              height: 200,
              child: ChartPage(fishes: fishes),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                height: 400,
                child:ListView(
                 shrinkWrap: true,
                 
                children: [
                  Text('Select fishing spot'),
                  MultiSelectOptionsControl(
                    options: filterOptions,
                    menuController:optionSeletionController ,
                    ),
                    FiltersWidget(fishingSpotController: fishingSpotController,isSize: isSize,optionSeletionController: optionSeletionController, filtersSelected: filtersSelected,fishTypeController: fishTypeController,),
                ],
              ),
            ),
            )
          ],
        )

    );
    
  }

 

}


 final List<Option<String>> filterOptions = [
    Option<String>(value: 'Location', label: 'Location'),
    Option<String>(value: 'BaitType', label: 'BaitType'),
  ];



class FiltersWidget extends StatefulWidget {
  final SelectFieldMenuController<int> fishingSpotController;
  final SelectFieldMenuController<int> fishTypeController;
  final MultiSelectFieldMenuController<String> optionSeletionController;
  List<bool> filtersSelected = [false,false,false];
   bool isSize;
  FiltersWidget({required this.fishingSpotController,required this.isSize,required this.optionSeletionController, required this.filtersSelected,required this.fishTypeController});
  @override
  FiltersWidgetState createState() => FiltersWidgetState();
}

class FiltersWidgetState extends State<FiltersWidget> {
  late final SelectFieldMenuController<int> fishingSpotController;
  late final SelectFieldMenuController<int> fishTypeController;
  late bool isSize;
  List<bool> filtersSelected = [false,false,false];
  @override
  void initState() {
    fishingSpotController = widget.fishingSpotController;
    fishTypeController = widget.fishTypeController;
    filtersSelected = widget.filtersSelected;
    widget.optionSeletionController.addListener(() {
      setState(() {
       filtersSelected[0] =  widget.optionSeletionController.selectedOptions.contains(filterOptions[0]);
       filtersSelected[1] =  widget.optionSeletionController.selectedOptions.contains(filterOptions[1]);
      });
    });
    isSize = widget.isSize;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     
    return Column(
      children: 
        createFilters()
      ,
    );
    
  }
  List<Widget> createFilters()
  {
    List<Widget> filters = List<Widget>.empty(growable: true);
    filters.add(Text('Filters'));
    if(filtersSelected[0])
    {
    filters.add(FishingSpotPicker(menuController: fishingSpotController));
    }
    if(filtersSelected[1])
    {
    filters.add(FishTypePicker(menuController: fishTypeController));
    }
    return filters;
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