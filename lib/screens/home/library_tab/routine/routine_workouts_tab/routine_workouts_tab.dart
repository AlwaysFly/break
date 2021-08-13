import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:workout_player/classes/combined/routine_detail_screen_class.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/combined/auth_and_database.dart';
import 'package:workout_player/classes/routine_workout.dart';
import 'package:workout_player/screens/home/library_tab/routine/add_workout/add_workouts_to_routine.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_workouts_tab/reorder_routine_workouts_button.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';

import 'routine_workout_card/routine_workout_card.dart';

class RoutineWorkoutsTab extends StatelessWidget {
  final RoutineDetailScreenClass data;
  final AuthBase auth;
  final Database database;

  const RoutineWorkoutsTab({
    Key? key,
    required this.data,
    required this.auth,
    required this.database,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOwner = auth.currentUser!.uid == data.routine?.routineOwnerId;

    // Widgets to show only if one's routine's owner
    final List<Widget> routineOwnerWidgets = [
      kCustomDividerIndent8,
      const SizedBox(height: 16),
      MaxWidthRaisedButton(
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        buttonText: S.current.addWorkoutkButtonText,
        color: kCardColor,
        onPressed: () => AddWorkoutsToRoutine.show(
          context,
          routine: data.routine!,
          routineWorkouts: data.routineWorkouts!,
          authAndDatabase: AuthAndDatabase(
            database: database,
            auth: auth,
          ),
        ),
      ),
      const SizedBox(height: 8),
      ReorderRoutineWorkoutsButton(
        routine: data.routine!,
        list: data.routineWorkouts!,
      ),
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.routineWorkouts!.isEmpty)
              EmptyContent(message: S.current.routineWorkoutEmptyText),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ImplicitlyAnimatedList<RoutineWorkout>(
                shrinkWrap: true,
                items: data.routineWorkouts!,
                physics: NeverScrollableScrollPhysics(),
                areItemsTheSame: (a, b) =>
                    a.routineWorkoutId == b.routineWorkoutId,
                removeDuration: Duration(milliseconds: 200),
                insertDuration: Duration(milliseconds: 200),
                itemBuilder: (context, animation, item, index) {
                  return SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeInOut,
                    animation: animation,
                    child: RoutineWorkoutCard(
                      index: index,
                      authAndDatabase: AuthAndDatabase(
                        auth: auth,
                        database: database,
                      ),
                      routine: data.routine!,
                      routineWorkout: item,
                    ),
                  );
                },
              ),
            ),
            if (isOwner) ...routineOwnerWidgets,
            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }
}
