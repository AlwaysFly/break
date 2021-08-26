import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/view/screens/routine_histories_screen.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/cards/blur_background_card.dart';

import '../../../../view_models/weekly_workout_summary_model.dart';

class WeeklyWorkoutWidget extends StatefulWidget {
  final User user;
  final WeeklyWorkoutSummaryModel model;
  final List<RoutineHistory> routineHistories;
  final BoxConstraints constraints;

  const WeeklyWorkoutWidget({
    Key? key,
    required this.user,
    required this.model,
    required this.routineHistories,
    required this.constraints,
  }) : super(key: key);

  static Widget create({
    Key? key,
    required User user,
    required List<RoutineHistory> routineHistories,
    required BoxConstraints constraints,
  }) {
    return Consumer(
      key: const Key('weeklyWorkoutHistorySmall'),
      builder: (context, watch, child) => WeeklyWorkoutWidget(
        user: user,
        model: watch(weeklyWorkoutSummaryModelProvider),
        routineHistories: routineHistories,
        constraints: constraints,
      ),
    );
  }

  @override
  _WeeklyWorkoutWidgetState createState() => _WeeklyWorkoutWidgetState();
}

class _WeeklyWorkoutWidgetState extends State<WeeklyWorkoutWidget> {
  @override
  void initState() {
    super.initState();
    widget.model.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightFactor = (widget.constraints.maxHeight > 600) ? 4 : 3.5;
    final locale = Intl.getCurrentLocale();

    widget.model.setData(widget.routineHistories, locale);

    return SizedBox(
      height: widget.constraints.maxHeight / heightFactor,
      width: widget.constraints.maxWidth,
      child: BlurBackgroundCard(
        onTap: () => RoutineHistoriesScreen.show(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: kPrimaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      S.current.wokroutsThisWeek,
                      style: TextStyles.subtitle1_w900_primary,
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: kPrimaryColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  7,
                  (index) => Column(
                    children: [
                      Text(
                        widget.model.daysOfTheWeek[index],
                        style: TextStyles.body2_grey_bold,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: CircleAvatar(
                          backgroundColor:
                              (widget.model.weeklyWorkedOutMuscles[index] !=
                                      null)
                                  ? kPrimaryColor
                                  : Colors.transparent,
                          // maxRadius: widget.model.radiuses[index],
                          maxRadius: 16,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: FittedBox(
                              child: Text(
                                widget.model.weeklyWorkedOutMuscles[index] ??
                                    widget.model.dates[index].day.toString(),
                                style: TextStyles.caption1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
