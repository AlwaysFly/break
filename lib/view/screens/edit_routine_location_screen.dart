import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';

class EditRoutineLocationScreen extends StatefulWidget {
  const EditRoutineLocationScreen({
    Key? key,
    required this.routine,
    required this.database,
    required this.user,
  }) : super(key: key);

  final Routine routine;
  final Database database;
  final User user;

  static void show(
    BuildContext context, {
    required User user,
    required Routine routine,
  }) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, auth, database) => EditRoutineLocationScreen(
        database: database,
        user: user,
        routine: routine,
      ),
    );
  }

  @override
  _EditRoutineLocationScreenState createState() =>
      _EditRoutineLocationScreenState();
}

class _EditRoutineLocationScreenState extends State<EditRoutineLocationScreen> {
  late String _location;

  @override
  void initState() {
    _location = widget.routine.location;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Submit data to Firestore
  Future<void> _updateLocation() async {
    try {
      final routine = {
        'location': _location,
      };
      await widget.database.updateRoutine(widget.routine, routine);

      getSnackbarWidget(
        S.current.updateLocationTitle,
        S.current.updateLocationMessage(S.current.routine),
      );
    } on FirebaseException catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.current.location, style: TextStyles.subtitle1),
        leading: const AppBarBackButton(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        ListTile(
          tileColor: (_location == Location.atHome.toString())
              ? theme.primaryColor
              : Colors.transparent,
          title: Text(Location.atHome.translation!, style: TextStyles.body1),
          trailing: (_location == Location.atHome.toString())
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _location = Location.atHome.toString();
            });
            _updateLocation();
          },
        ),
        ListTile(
          tileColor: (_location == Location.gym.toString())
              ? theme.primaryColor
              : Colors.transparent,
          title: Text(Location.gym.translation!, style: TextStyles.body1),
          trailing: (_location == Location.gym.toString())
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _location = Location.gym.toString();
            });
            _updateLocation();
          },
        ),
        ListTile(
          tileColor: (_location == Location.outdoor.toString())
              ? theme.primaryColor
              : Colors.transparent,
          title: Text(Location.outdoor.translation!, style: TextStyles.body1),
          trailing: (_location == Location.outdoor.toString())
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _location = Location.outdoor.toString();
            });
            _updateLocation();
          },
        ),
        ListTile(
          tileColor: (_location == Location.others.toString())
              ? theme.primaryColor
              : Colors.transparent,
          title: Text(Location.others.translation!, style: TextStyles.body1),
          trailing: (_location == Location.others.toString())
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () {
            setState(() {
              _location = Location.others.toString();
            });
            _updateLocation();
          },
        ),
      ],
    );
  }
}
