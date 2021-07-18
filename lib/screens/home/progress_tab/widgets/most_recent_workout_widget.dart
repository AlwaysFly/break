import 'package:timeago/timeago.dart' as timeago;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/progress_tab_class.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/blur_background_card.dart';

import 'weekly_weights_lifted_chart/routine_histories_screen.dart';

class MostRecentWorkout extends StatelessWidget {
  final BoxConstraints constraints;
  final ProgressTabClass data;

  const MostRecentWorkout({
    Key? key,
    required this.constraints,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightFactor = (constraints.maxHeight > 600) ? 4 : 3.5;

    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    final locale = Intl.getCurrentLocale();

    RoutineHistory? last =
        data.routineHistories.isEmpty ? null : data.routineHistories.last;

    final weight = Formatter.weights(last?.totalWeights ?? 0);
    final unit = Formatter.unitOfMass(last?.unitOfMass ?? 0);
    final time = Formatter.durationInMin(last?.totalDuration ?? 0);

    String ago = (last != null)
        ? timeago.format(last.workoutEndTime.toDate(), locale: locale)
        : '';

    String title = last?.routineTitle ?? 'No recent workout yet!';

    return SizedBox(
      height: constraints.maxHeight / heightFactor,
      width: constraints.maxWidth,
      child: BlurBackgroundCard(
        onTap: () => RoutineHistoriesScreen.show(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: Text(ago, style: TextStyles.overline_grey),
              ),
              FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyles.body1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$weight $unit',
                              style: TextStyles.headline5_menlo_w900_primary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              S.current.liftedWeights,
                              style: TextStyles.caption1_grey,
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 48,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          color: Colors.white24,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$time ${S.current.minutes}',
                              style: TextStyles.headline5_menlo_w900_primary,
                            ),
                            const SizedBox(height: 4),
                            Text(S.current.time,
                                style: TextStyles.caption1_grey),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}