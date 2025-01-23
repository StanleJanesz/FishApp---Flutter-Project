  import 'package:fish_app/Classes/fish.dart';
import 'package:select_field/select_field.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/Services/database_service.dart';
class GroupByWidget extends StatefulWidget {
  
final SelectFieldMenuController<int> menuController;

 GroupByWidget({required this.menuController});

  Future<List<Option<int>>> GetOptions() async
  {
    
    return [
      
        Option<int>(label: "Size ", value: 0),
        Option<int>(label: "Location ", value: 1),
        Option<int>(label: "Fish Type ", value: 2), 
    ];
  }



  @override
  State<GroupByWidget> createState() =>
      _GroupByWidgetState();
}

class _GroupByWidgetState
    extends State<GroupByWidget> {

  late  Option<int> initalOption = Option<int>(label: "Size ", value: 0);

  late final SelectFieldMenuController<int> menuController;

  late  List<Option<int>> options =[];

  void onOptionSelected(Option<int> options) {
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
   var options = await widget.GetOptions();
    setState(() {
      
      this.options = options;
    });
}
  @override
  void initState()  {
    initOptions();
    this.menuController = widget.menuController;
    super.initState();
    this.menuController.isExpanded = false;
  }

  @override
  void dispose() {
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

