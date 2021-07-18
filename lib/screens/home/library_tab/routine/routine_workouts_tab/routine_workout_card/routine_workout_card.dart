import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/auth_and_database.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_workouts_tab/workout_set_widget/workout_set_widget.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_workouts_tab/workout_set_widget/workout_set_widget_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/list_item_builder.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_set.dart';

import 'routine_workout_card_model.dart';

class RoutineWorkoutCard extends ConsumerWidget {
  final Routine routine;
  final RoutineWorkout routineWorkout;
  final AuthAndDatabase authAndDatabase;

  const RoutineWorkoutCard({
    required this.routine,
    required this.routineWorkout,
    required this.authAndDatabase,
  });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(routineWorkoutCardModelProvider(authAndDatabase));
    final workoutSetModel = watch(
      workoutSetWidgetModelProvider(authAndDatabase),
    );

    // FORMATTING
    final numberOfSets = routineWorkout.numberOfSets;
    final formattedNumberOfSets = (numberOfSets > 1)
        ? '$numberOfSets ${S.current.sets}'
        : '$numberOfSets ${S.current.set}';

    final weights = Formatter.weights(routineWorkout.totalWeights);
    final unit = Formatter.unitOfMass(routine.initialUnitOfMass);

    final formattedTotalWeights =
        (routineWorkout.isBodyWeightWorkout && routineWorkout.totalWeights == 0)
            ? S.current.bodyweight
            : (routineWorkout.isBodyWeightWorkout)
                ? '${S.current.bodyweight} + $weights $unit'
                : '$weights $unit';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        leading: Container(
          height: 48,
          width: 48,
          child: Center(
            child: Text(
              routineWorkout.index.toString(),
              style: TextStyles.blackHans1,
            ),
          ),
        ),
        initiallyExpanded: true,
        title: _buildTitle(),
        subtitle: Row(
          children: <Widget>[
            Text(formattedNumberOfSets, style: TextStyles.subtitle2),
            const Text('   |   ', style: TextStyles.subtitle2),
            Text(formattedTotalWeights, style: TextStyles.subtitle2),
          ],
        ),
        childrenPadding: const EdgeInsets.all(0),
        maintainState: true,
        children: [
          const Divider(endIndent: 8, indent: 8, color: kGrey700),
          ListItemBuilder<WorkoutSet>(
            items: routineWorkout.sets,
            emptyContentWidget: Column(
              children: [
                Container(
                  height: 80,
                  child: Center(
                    child: Text(S.current.addASet, style: TextStyles.body2),
                  ),
                ),
                const Divider(endIndent: 8, indent: 8, color: kGrey700),
              ],
            ),
            itemBuilder: (context, item, index) {
              return WorkoutSetWidget(
                database: authAndDatabase.database,
                routine: routine,
                routineWorkout: routineWorkout,
                workoutSet: item,
                index: index,
                auth: authAndDatabase.auth,
                model: workoutSetModel,
              );
            },
          ),

          /// TODO: ADD Implicitily Animated List
          // if (routineWorkout.sets.isNotEmpty)
          //   ImplicitlyAnimatedList<WorkoutSet>(
          //     items: routineWorkout.sets,
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     areItemsTheSame: (a, b) => a.workoutSetId == b.workoutSetId,
          //     removeDuration: Duration(milliseconds: 200),
          //     insertDuration: Duration(milliseconds: 200),
          //     itemBuilder: (context, animation, item, index) {
          //       print('index is $index');

          //       return SizeFadeTransition(
          //         sizeFraction: 0.7,
          //         curve: Curves.easeInOut,
          //         animation: animation,
          //         child: WorkoutSetWidget(
          //           database: authAndDatabase.database,
          //           routine: routine,
          //           routineWorkout: routineWorkout,
          //           workoutSet: item,
          //           index: index,
          //           auth: authAndDatabase.auth,
          //           model: workoutSetModel,
          //         ),
          //       );
          //     },
          //   ),
          if (routineWorkout.sets.isNotEmpty == true &&
              authAndDatabase.auth.currentUser!.uid == routine.routineOwnerId)
            const Divider(endIndent: 8, indent: 8, color: kGrey700),
          if (authAndDatabase.auth.currentUser!.uid == routine.routineOwnerId)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  child: IconButton(
                    onPressed: () => model.addNewSet(
                      context,
                      routine: routine,
                      routineWorkout: routineWorkout,
                    ),
                    icon: const Icon(Icons.add_rounded, color: Colors.grey),
                  ),
                ),
                Container(height: 36, width: 1, color: kGrey800),
                Container(
                  width: 100,
                  child: IconButton(
                    onPressed: () => model.addNewRest(
                      context,
                      routine: routine,
                      routineWorkout: routineWorkout,
                    ),
                    icon: const Icon(Icons.timer_rounded, color: Colors.grey),
                  ),
                ),
                Container(height: 36, width: 1, color: kGrey800),
                Container(
                  width: 100,
                  child: IconButton(
                    onPressed: () => _showModalBottomSheet(context, model),
                    icon: const Icon(Icons.delete_rounded, color: Colors.grey),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final locale = Intl.getCurrentLocale();
    final translation = routineWorkout.translated;
    final title = translation.isEmpty
        ? routineWorkout.workoutTitle
        : (locale == 'ko' || locale == 'en')
            ? routineWorkout.translated[locale]
            : routineWorkout.workoutTitle;

    if (title.length > 24) {
      return FittedBox(
        fit: BoxFit.cover,
        child: Text(title, style: TextStyles.headline6),
      );
    } else {
      return Text(
        title,
        style: TextStyles.headline6,
        overflow: TextOverflow.fade,
        softWrap: false,
        maxLines: 1,
      );
    }
  }

  Future<bool?> _showModalBottomSheet(
    BuildContext context,
    RoutineWorkoutCardModel model,
  ) {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: Text(
          S.current.deleteRoutineWorkoutMessage,
          textAlign: TextAlign.center,
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => model.deleteRoutineWorkout(
              context,
              routine: routine,
              routineWorkout: routineWorkout,
            ),
            child: Text(S.current.deleteRoutineWorkoutButton),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.current.cancel),
        ),
      ),
    );
  }
}