import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/show_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

Logger logger = Logger();

class EditWorkoutEquipmentRequiredScreen extends StatefulWidget {
  const EditWorkoutEquipmentRequiredScreen({
    Key key,
    this.workout,
    this.database,
    this.user,
  }) : super(key: key);

  final Workout workout;
  final Database database;
  final User user;

  static Future<void> show(BuildContext context, {Workout workout}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EditWorkoutEquipmentRequiredScreen(
          database: database,
          workout: workout,
          user: auth.currentUser,
        ),
      ),
    );
  }

  @override
  _EditWorkoutEquipmentRequiredScreenState createState() =>
      _EditWorkoutEquipmentRequiredScreenState();
}

class _EditWorkoutEquipmentRequiredScreenState
    extends State<EditWorkoutEquipmentRequiredScreen> {
  Map<String, bool> _equipmentRequired = {
    'Barbell': false,
    'Dumbbell': false,
    'Bodyweight': false,
    'Cable': false,
    'Machine': false,
    'EZ Bar': false,
    'Gym ball': false,
    'Bench': false,
  };
  List _selectedEquipmentRequired = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, bool> equipmentRequired = {
      'Barbell':
          (widget.workout.equipmentRequired.contains('Barbell')) ? true : false,
      'Dumbbell': (widget.workout.equipmentRequired.contains('Dumbbell'))
          ? true
          : false,
      'Bodyweight': (widget.workout.equipmentRequired.contains('Bodyweight'))
          ? true
          : false,
      'Cable':
          (widget.workout.equipmentRequired.contains('Cable')) ? true : false,
      'Machine':
          (widget.workout.equipmentRequired.contains('Machine')) ? true : false,
      'EZ Bar':
          (widget.workout.equipmentRequired.contains('EZ Bar')) ? true : false,
      'Gym ball': (widget.workout.equipmentRequired.contains('Gym ball'))
          ? true
          : false,
      'Bench':
          (widget.workout.equipmentRequired.contains('Bench')) ? true : false,
    };
    _equipmentRequired = equipmentRequired;
    _equipmentRequired.forEach((key, value) {
      if (_equipmentRequired[key]) {
        _selectedEquipmentRequired.add(key);
      } else {
        _selectedEquipmentRequired.remove(key);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _addOrRemoveEquipmentRequired(String key, bool value) async {
    try {
      setState(() {
        _equipmentRequired[key] = value;
      });
      if (_equipmentRequired[key]) {
        _selectedEquipmentRequired.add(key);
        final workout = {
          'equipmentRequired': _selectedEquipmentRequired,
        };
        await widget.database.updateWorkout(widget.workout, workout);
      } else {
        _selectedEquipmentRequired.remove(key);
        final workout = {
          'equipmentRequired': _selectedEquipmentRequired,
        };
        await widget.database.updateWorkout(widget.workout, workout);
      }
      debugPrint('$_selectedEquipmentRequired');
    } on FirebaseException catch (e) {
      logger.d(e);
      ShowExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            if (_selectedEquipmentRequired.length >= 1) {
              Navigator.of(context).pop();
            } else {
              showAlertDialog(
                context,
                title: 'No Equipment Required Selected',
                content:
                    'Please Select at least one equipment required for this routine',
                defaultActionText: 'OK',
              );
            }
          },
        ),
        title: const Text('Equipment Required', style: Subtitle1),
        flexibleSpace: AppbarBlurBG(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: _equipmentRequired.keys.map((String key) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: (_equipmentRequired[key]) ? PrimaryColor : Grey700,
                      child: CheckboxListTile(
                        selected: _equipmentRequired[key],
                        activeColor: Primary700Color,
                        title: Text(key, style: ButtonText),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: _equipmentRequired[key],
                        onChanged: (bool value) =>
                            _addOrRemoveEquipmentRequired(key, value),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}