import 'package:select_field/select_field.dart';
import 'package:flutter/material.dart';

class MultiSelectOptionsControl<int> extends StatefulWidget {
  final List<Option<int>> options;


 final MultiSelectFieldMenuController<int> menuController;

  const MultiSelectOptionsControl({
    super.key,
    required this.options,
    required this.menuController,
  });

  @override
  State<MultiSelectOptionsControl<int>> createState() =>
      _MultiSelectOptionsControlState<int>();
}

class _MultiSelectOptionsControlState<int> extends State<MultiSelectOptionsControl<int>> {

  late final List<Option<int>> initalOptions;
  late final MultiSelectFieldMenuController<int> menuController;

  void onOptionSelected(List<Option<int>> options) {
    setState(() {
      menuController.selectedOptions = options;
    });
  }

  void onOptionRemoved(Option<int> option) {
    final options = menuController.selectedOptions;
    options.remove(option);
    setState(() {
      menuController.selectedOptions = options;
    });
  }

  void onTapOutside() {
    menuController.isExpanded = false;
  }

  void onTap() {
    menuController.isExpanded = !menuController.isExpanded;
  }

  @override
  void initState() {
    super.initState();
    menuController = widget.menuController;
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MultiSelectField<int>(
          options: widget.options,
          fieldText: 'Select fruit',
          onTap: onTap,
          onTapOutside: onTapOutside,
          onOptionsSelected: onOptionSelected,
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
        Wrap(
          spacing: 10,
          runSpacing: 20,
          children: menuController.selectedOptions
              .map(
                (option) => Chip(
                  label: Text(option.label),
                  onDeleted: () => onOptionRemoved(option),
                  shape: const StadiumBorder(),
                ),
              )
              .toList(),
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