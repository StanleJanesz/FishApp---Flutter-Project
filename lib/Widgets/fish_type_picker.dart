  import 'package:fish_app/Classes/fish.dart';
import 'package:select_field/select_field.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/Services/database_service.dart';
class FishTypePicker extends StatefulWidget {
  

  Future<List<Option<int>>> GetOptions() async
  {
    var databaseService = DatabaseServiceFishType();
    var fishTypes = await databaseService.getAll();
    int i = 1;
    return [
      for (final fishType in fishTypes)
        Option<int>(label: fishType.type,value: fishType.id ) 
    ];
  }



  @override
  State<FishTypePicker> createState() =>
      _FishTypePickerState();
}

class _FishTypePickerState
    extends State<FishTypePicker> {
  late  Option<int> initalOption = Option(label: 'Okoń',value: 1);
  late final SelectFieldMenuController<int> menuController;
  late  List<Option<int>> options =[];
  void onOptionSelected(Option<int> options) {
    setState(() {
      menuController.selectedOption = options;
    });
  }
  
  void onOptionRemoved(Option<String> option) {
    final options = menuController.selectedOption;
    
    setState(() {
      menuController.selectedOption = options;
    });
  }

  void onTapOutside() {
    menuController.isExpanded = false;
  }

  void onTap() {
    menuController.isExpanded = !menuController.isExpanded;
  }
void initOptions() async
{
  var initalOption = (await widget.GetOptions())[0];
   
   var options = await widget.GetOptions();
    setState(() {
      
      this.options = options;
    });
}
  @override
  void initState()  {
    initOptions();
     this.menuController = SelectFieldMenuController(
      isExpanded: true,
    );
    super.initState();
    this.menuController.isExpanded = false;
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        SelectField<int>(
          options: options,
          onTap: onTap,
          onTapOutside: onTapOutside,
          menuController: menuController,
          menuDecoration: MenuDecoration(
            childBuilder: (context, option, isSelected) {
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context)
                            .textButtonTheme
                            .style
                            ?.foregroundColor
                            ?.resolve({}),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank_outlined,
                    color: Theme.of(context)
                        .textButtonTheme
                        .style
                        ?.foregroundColor
                        ?.resolve({}),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

List<Option<String>> optionsGenerator()
  {
    List<Option<String>> options = [];
    options.add(Option(label: 'Okoń',value:  'Okoń'));
    options.add(Option(label: 'Sum',value:  'Sum'));
    options.add(Option(label: 'Leszcz', value: 'Leszcz'));
    options.add(Option(label: 'Szczsssupak',value:  'Szczupak'));
    options.add(Option(label: 'Szczssupak',value:  'Szczupak'));
    options.add(Option(label: 'Szczssupak',value:  'Szczupak'));
    options.add(Option(label: 'Szczuaaapak',value:  'Szczupak'));
    options.add(Option(label: 'Szczssupsak',value:  'Szczupak'));
    options.add(Option(label: 'Szczaaupak',value:  'Szczupak'));
    options.add(Option(label: 'Szcazupsak',value:  'Szczupak'));
    options.add(Option(label: 'Szczupak',value:  'Szczupak'));
    options.add(Option(label: 'Szczaasupak',value:  'Szczupak'));
    options.add(Option(label: 'Szczssupak',value:  'Szczupak'));
    options.add(Option(label: 'Szcszsupak',value:  'Szczupak'));
    options.add(Option(label: 'Szczupsak',value:  'Szczupak'));
    return options;
  }