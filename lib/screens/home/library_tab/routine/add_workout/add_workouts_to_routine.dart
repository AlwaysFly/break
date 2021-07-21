import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/auth_and_database.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/enum/main_muscle_group.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/classes/routine_workout.dart';
import 'package:workout_player/classes/workout.dart';
import 'package:workout_player/screens/home/library_tab/routine/add_workout/add_workouts_to_routine_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/appbar_close_button.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/list_item_builder.dart';
import 'package:workout_player/widgets/shimmer/list_view_shimmer.dart';

import 'workout_list_tile.dart';

class AddWorkoutsToRoutine extends StatefulWidget {
  final Routine routine;
  final List<RoutineWorkout> routineWorkouts;
  final AddWorkoutsToRoutineScreenModel model;
  final AuthAndDatabase authAndDatabase;

  const AddWorkoutsToRoutine({
    Key? key,
    required this.routine,
    required this.routineWorkouts,
    required this.model,
    required this.authAndDatabase,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required Routine routine,
    required List<RoutineWorkout> routineWorkouts,
    required AuthAndDatabase authAndDatabase,
  }) async {
    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => Consumer(
          builder: (context, watch, child) => AddWorkoutsToRoutine(
            routine: routine,
            routineWorkouts: routineWorkouts,
            model: watch(addWorkoutsToRoutineScreenModelProvider),
            authAndDatabase: authAndDatabase,
          ),
        ),
      ),
    );
  }

  @override
  _AddWorkoutsToRoutineState createState() => _AddWorkoutsToRoutineState();
}

class _AddWorkoutsToRoutineState extends State<AddWorkoutsToRoutine> {
  @override
  void initState() {
    super.initState();
    widget.model.init(widget.routine, widget.authAndDatabase);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, _) {
          return <Widget>[_appBarWidget(context)];
        },
        body: _buildBody(context),
      ),
      floatingActionButton: SizedBox(
        width: size.width - 32,
        child: FloatingActionButton.extended(
          onPressed: (widget.model.selectedWorkouts.isEmpty)
              ? null
              : () => widget.model.addWorkoutsToRoutine(
                    context,
                    widget.routine,
                    widget.routineWorkouts,
                  ),
          backgroundColor: (widget.model.selectedWorkouts.isEmpty)
              ? Colors.grey
              : kPrimaryColor,
          label: Text(
            S.current.addWorkoutFABTitle(widget.model.selectedWorkouts.length),
            style: TextStyles.button1,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: CustomStreamBuilderWidget<List<Workout>>(
        stream: widget.authAndDatabase.database.workoutsSearchStream(
          arrayContainsVariableName: 'mainMuscleGroup',
          arrayContainsValue: widget.model.selectedMainMuscleGroup,
        ),
        errorWidget: EmptyContent(),
        loadingWidget: ListViewShimmer(),
        hasDataWidget: (context, data) => ListItemBuilder<Workout>(
          items: data,
          emptyContentTitle: S.current.noWorkoutEmptyContent(
            widget.model.selectedChipTranslated,
          ),
          itemBuilder: (context, workout, index) {
            final locale = Intl.getCurrentLocale();

            final difficulty = Formatter.difficulty(workout.difficulty);
            final leadingText = MainMuscleGroup.values
                .firstWhere((e) => e.toString() == workout.mainMuscleGroup[0])
                .translation;

            final equipment = EquipmentRequired.values
                .firstWhere((e) => e.toString() == workout.equipmentRequired[0])
                .translation;

            final title = (locale == 'ko' || locale == 'en')
                ? workout.translated[locale]
                : workout.workoutTitle;

            return WorkoutListTile(
              imageUrl: workout.imageUrl,
              leadingText: leadingText!,
              title: title,
              subtitle: '$difficulty,  ${S.current.usingEquipment(equipment!)}',
              selected: widget.model.selectedWorkouts.contains(workout),
              onTap: () => widget.model.selectWorkout(context, workout),
            );
          },
        ),
      ),
    );
  }

  Widget _appBarWidget(BuildContext context) {
    final List<String> _mainMuscleGroup = MainMuscleGroup.values[0].list;
    final List<Widget> chips = _mainMuscleGroup.map(
      (e) {
        final label = MainMuscleGroup.values
            .firstWhere((element) => element.toString() == e)
            .translation!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: ChoiceChip(
            backgroundColor: kAppBarColor,
            selectedColor: kPrimaryColor,
            label: Text(label, style: TextStyles.button1),
            labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: StadiumBorder(
              side: BorderSide(
                color: (widget.model.selectedMainMuscleGroup == e)
                    ? kPrimary300Color
                    : Colors.grey,
                width: 1,
              ),
            ),
            selected: widget.model.selectedMainMuscleGroup == e,
            onSelected: (selected) => widget.model.onSelectChoiceChip(
              selected,
              e,
            ),
          ),
        );
      },
    ).toList();

    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: false,
      centerTitle: true,
      brightness: Brightness.dark,
      title: Text(S.current.addWorkoutkButtonText, style: TextStyles.subtitle1),
      flexibleSpace: AppbarBlurBG(),
      backgroundColor: Colors.transparent,
      leading: AppBarCloseButton(),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: chips),
          ),
        ),
      ),
    );
  }
}
