import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/theme_colors.dart';
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

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.getUserDocument(auth.currentUser!.uid);

    await HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => BodyFatEntriesScreen(
          database: database,
          user: user!,
        ),
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
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        title: Text(S.current.bodyMeasurement, style: TextStyles.subtitle2),
        centerTitle: true,
        backgroundColor: ThemeColors.appBar,
        flexibleSpace: const AppbarBlurBG(),
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
      // body: PaginateFirestore(
      //   shrinkWrap: true,
      //   itemsPerPage: 10,
      //   query: database.measurementsQuery(),
      //   itemBuilderType: PaginateBuilderType.listView,
      //   emptyDisplay: EmptyContent(
      //     message: S.current.measurementsEmptyMessage,
      //   ),
      //   header: const SliverToBoxAdapter(child: SizedBox(height: 16)),
      //   footer: const SliverToBoxAdapter(child: SizedBox(height: 16)),
      //   onError: (error) => EmptyContent(
      //     message: '${S.current.somethingWentWrong}: $error',
      //   ),
      //   physics: const BouncingScrollPhysics(),
      //   itemBuilder: (index, context, documentSnapshot) {
      //     final measurement = documentSnapshot.data()! as Measurement;

      //     final date = Formatter.yMdjm(measurement.loggedTime);

      //     final unit = Formatter.unitOfMass(
      //       user.unitOfMass,
      //       user.unitOfMassEnum,
      //     );

      //     return Slidable(
      //       endActionPane: ActionPane(
      //         motion: const ScrollMotion(),
      //         children: [
      //           SlidableAction(
      //             label: S.current.delete,
      //             backgroundColor: Colors.red,
      //             icon: Icons.delete_rounded,
      //             onPressed: (context) => _delete(context, measurement),
      //           ),
      //         ],
      //       ),
      //       child: ListTile(
      //         leading: Text(
      //           '${measurement.bodyWeight}$unit',
      //           style: TextStyles.body1,
      //         ),
      //         trailing: Text(date, style: TextStyles.body1Grey),
      //       ),
      //     );
      //   },
      //   isLive: true,
      // ),
    );
  }
}