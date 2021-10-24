import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/dialogs.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

/// Creates a screen that displays a list of [Measurement] entries, created by
/// the user.
///
/// ## Roadmap
///
/// ### Refactoring
/// * TODO: Paginate list of [Measurement] stream
///
/// ### Enhancement
///
class BodyFatEntriesScreen extends StatelessWidget {
  final Database database;
  final User user;

  const BodyFatEntriesScreen({
    Key? key,
    required this.database,
    required this.user,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required User user,
  }) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, auth, database) => BodyFatEntriesScreen(
        database: database,
        user: user,
      ),
    );
  }

  Future<void> _delete(BuildContext context, Measurement measurement) async {
    try {
      await database.deleteMeasurement(measurement: measurement);

      getSnackbarWidget(
        S.current.deleteMeasurementSnackbarTitle,
        S.current.deleteMeasurementSnackbar,
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
        title: Text(S.current.bodyMeasurement, style: TextStyles.subtitle2),
        centerTitle: true,
        leading: const AppBarBackButton(),
      ),
      body: CustomStreamBuilder<List<Measurement>>(
        stream: database.measurementsStream(limit: 100),
        builder: (context, data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                CustomListViewBuilder<Measurement>(
                  items: data,
                  itemBuilder: (context, measurement, i) {
                    final date = Formatter.yMdjm(measurement.loggedTime);
                    final bodyFat = Formatter.numWithDecimal(
                      measurement.bodyFat,
                    );

                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            label: S.current.delete,
                            backgroundColor: Colors.red,
                            icon: Icons.delete_rounded,
                            onPressed: (context) =>
                                _delete(context, measurement),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Text(
                          '$bodyFat %',
                          style: TextStyles.body1,
                        ),
                        trailing: Text(date, style: TextStyles.body1Grey),
                      ),
                    );
                  },
                ),
                const SizedBox(height: kBottomNavigationBarHeight + 48),
              ],
            ),
          );
        },
      ),
    );
  }
}
