import 'package:select_field/select_field.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/Services/database_service.dart';

class FishingSpotPicker extends StatefulWidget {
  final SelectFieldMenuController<int> menuController;
  const FishingSpotPicker({super.key, required this.menuController});

  Future<List<Option<int>>> getOptions() async {
    var databaseService = DatabaseServiceFishingSpot();
    var fishingSpots = await databaseService.getAll();
    return [
      for (final fishingSpot in fishingSpots)
        Option<int>(label: fishingSpot.name, value: fishingSpot.id)
    ];
  }

  @override
  State<FishingSpotPicker> createState() => _FishingSpotPickerState();
}

class _FishingSpotPickerState extends State<FishingSpotPicker> {
  late Option<int> initalOption = Option(label: 'Okoń', value: 1);
  late final SelectFieldMenuController<int> menuController;
  late List<Option<int>> options = [];
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

  void initOptions() async {

    var options = await widget.getOptions();
    setState(() {
      this.options = options;
    });
  }

  @override
  void initState() {
    initOptions();
    menuController = widget.menuController;
    super.initState();
    menuController.isExpanded = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
