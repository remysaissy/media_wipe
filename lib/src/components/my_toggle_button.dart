import 'package:flutter/material.dart';

class MyToggleButton extends StatefulWidget {

  MyToggleButton({super.key, this.onPressed, required this.defaultOption, required this.options}) {
    selectedOptions = options.map((e) => (e == defaultOption) ? true : false).toList();
    widgetOptions = options.map((e) => Text(e)).toList();
  }

  final void Function(int index)? onPressed;
  final List<String> options;
  final String defaultOption;
  late final List<bool> selectedOptions;
  late final List<Widget> widgetOptions;

  @override
  State <StatefulWidget> createState () => _MyToggleButtonState();
}

class _MyToggleButtonState extends State<MyToggleButton> {

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / (widget.selectedOptions.length + 1);
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          // The button that is tapped is set to true, and the others to false.
          for (int i = 0; i < widget.selectedOptions.length; i++) {
            widget.selectedOptions[i] = i == index;
          }
          if (widget.onPressed != null) {
            widget.onPressed!(index);
          }
        });
      },
      constraints: BoxConstraints.expand(width: w),
      isSelected: widget.selectedOptions,
      children: widget.widgetOptions,
    );
  }
}