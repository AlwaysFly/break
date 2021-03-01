import 'package:flutter/material.dart';
import 'package:workout_player/models/enum_values.dart';

import '../constants.dart';

typedef void StringCallback(String val);

class ChoiceChipsAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final StringCallback callback;

  const ChoiceChipsAppBarWidget({Key key, this.callback}) : super(key: key);

  @override
  _ChoiceChipsAppBarWidgetState createState() =>
      _ChoiceChipsAppBarWidgetState();

  @override
  Size get preferredSize {
    return new Size.fromHeight(48.0);
  }
}

class _ChoiceChipsAppBarWidgetState extends State<ChoiceChipsAppBarWidget> {
  List<String> _mainMuscleGroup = ['All'];

  int _selectedIndex = 0;
  String _selectedChipLabel = 'All';

  @override
  void initState() {
    for (int i = 0; i < MainMuscleGroup.values.length; i++) {
      var value = MainMuscleGroup.values[i].label;
      _mainMuscleGroup.add(value);
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = new List();

    chips.add(SizedBox(width: 12));
    for (int i = 0; i < _mainMuscleGroup.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        padding: EdgeInsets.symmetric(horizontal: 8),
        label: Text(_mainMuscleGroup[i], style: ButtonText),
        selected: _selectedIndex == i,
        backgroundColor: Colors.grey[700],
        selectedColor: PrimaryColor,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
              _selectedChipLabel = _mainMuscleGroup[i];
              widget.callback(_selectedChipLabel);
            }
            debugPrint(_selectedChipLabel);
          });
        },
      );

      chips.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: choiceChip,
        ),
      );
    }
    chips.add(SizedBox(width: 12));

    return PreferredSize(
      preferredSize: Size.fromHeight(48),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips,
        ),
      ),
    );
  }
}