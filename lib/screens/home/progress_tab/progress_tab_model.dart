import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/classes/auth_and_database.dart';
import 'package:workout_player/classes/progress_tab_class.dart';
import 'package:workout_player/screens/home/progress_tab/widgets/latest_body_fat_widget.dart';
import 'package:workout_player/screens/home/progress_tab/widgets/most_recent_workout_widget.dart';
import 'package:workout_player/screens/home/progress_tab/widgets/steps_widget.dart';
import 'package:workout_player/screens/home/progress_tab/widgets/weekly_weights_lifted_chart/weekly_lifted_weights_card.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import 'widgets/daily_activity_ring_widget/daily_activty_ring_widget.dart';
import 'widgets/latest_weight_widget.dart';
import 'widgets/measurement/weekly_measurements_card.dart';
import 'widgets/nutritions_chart/weekly_nutrition_card.dart';
import 'widgets/weekly_workout_summary/weekly_workout_summary.dart';

final progressTabModelProvider2 =
    ChangeNotifierProvider.family<ProgressTabModel, AuthAndDatabase>(
  (ref, authAndDatabase) => ProgressTabModel(
    auth: authAndDatabase.auth,
    database: authAndDatabase.database,
  ),
);

final progressTabModelProvider = ChangeNotifierProvider(
  (ref) => ProgressTabModel(),
);

class ProgressTabModel with ChangeNotifier {
  late AuthBase? auth;
  late Database? database;

  ProgressTabModel({
    this.auth,
    this.database,
  });

  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _showBanner = true;
  late AnimationController _animationController;
  late Animation<double> _blurTween;
  late Animation<double> _brightnessTween;
  late bool Function(ScrollNotification) _onNotification;
  Map<String, Widget> _keysAndWidgets = {};
  List<Widget> _widgets = [];
  List _widgetKeysList = [
    'empty2x2',
    'activityRing',
    'weeklyWorkoutHistorySmall',
    'latestBodyFat',
    'latestWeight',
    'recentWorkout',
    'weeklyMeasurementsChart',
    'weeklyNutritionChart',
    'weeklyWorkoutHistoryMedium',
    'stepsWidget',
  ];

  List<DateTime> get dates => _dates;
  List<String> get daysOfTheWeek => _daysOfTheWeek;
  DateTime get focusedDate => _focusedDate;
  DateTime get selectedDate => _selectedDate;
  bool get showBanner => _showBanner;
  AnimationController get animationController => _animationController;
  Animation<double> get blurTween => _blurTween;
  Animation<double> get brightnessTween => _brightnessTween;
  bool Function(ScrollNotification) get onNotification => _onNotification;
  Map<String, Widget> get keysAndWidgets => _keysAndWidgets;
  List<Widget> get widgets => _widgets;
  List get widgetKeysList => _widgetKeysList;

  void selectSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void selectFocusedDate(DateTime date) {
    _focusedDate = date;
    notifyListeners();
  }

  void setShowBanner(bool value) {
    _showBanner = value;
    notifyListeners();
  }

  void initWeeklyDates() {
    DateTime now = DateTime.now();

    // Create list of 7 days
    _dates = List<DateTime>.generate(7, (index) {
      return DateTime.utc(now.year, now.month, now.day - index);
    });
    _dates = _dates.reversed.toList();

    // Create list of 7 days of the week
    _daysOfTheWeek = List<String>.generate(
      7,
      (index) => DateFormat.E().format(_dates[index]),
    );
  }

  Future<void> init({
    required TickerProvider vsync,
    required AuthAndDatabase authAndDatabase,
  }) async {
    // INIT Auth and Database
    auth = authAndDatabase.auth;
    database = authAndDatabase.database;

    // INIT Background Blur Animation
    _animationController = AnimationController(
      vsync: vsync,
      duration: Duration(seconds: 0),
    );

    _blurTween = Tween<double>(begin: 0, end: 20).animate(animationController);
    _brightnessTween = Tween<double>(begin: 1, end: 0.0).animate(
      animationController,
    );
    _onNotification = (ScrollNotification scrollInfo) {
      if (scrollInfo.metrics.axis == Axis.vertical) {
        _animationController.animateTo(
          scrollInfo.metrics.pixels / 1400,
        );

        return true;
      }
      return false;
    };

    // // // INIT show banner
    // final uid = auth!.currentUser!.uid;
    // final user = await database!.getUserDocument(uid);
    // if (user!.dailyProteinGoal == null ||
    //     user.dailyWeightsGoal == null ||
    //     user.weightGoal == null ||
    //     user.bodyFatPercentageGoal == null) {
    //   _showBanner = true;
    // } else {
    //   _showBanner = false;
    // }
  }

  Widget buildDraggableFeedback(context, constraints, child) {
    return ConstrainedBox(
      constraints: constraints,
      child: FittedBox(
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: Colors.grey.withOpacity(0.5),
          radius: Radius.circular(24),
          strokeCap: StrokeCap.round,
          dashPattern: [16, 4],
          child: child,
        ),
      ),
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    // if (newIndex > oldIndex) {
    //   print('new index is > than old index');
    //   newIndex -= 1;
    // }

    List<String> _newKeys = [];

    final itemToReorder = _widgets.removeAt(oldIndex);
    _widgets.insert(newIndex, itemToReorder);

    _widgets.forEach((e) {
      final key = e.key.toString().replaceAll(RegExp(r'[^\w\s]+'), '');

      _newKeys.add(key);
    });
    _widgetKeysList = _newKeys;

    final updatedUser = {
      'widgetsList': _newKeys,
    };

    database!.updateUser(auth!.currentUser!.uid, updatedUser);
  }

  void initWidgets(
    BuildContext context, {
    required ProgressTabClass data,
    required BoxConstraints constraints,
  }) {
    _widgetKeysList = data.user.widgetsList ?? _widgetKeysList;

    Widget latestBodyFat = LatestBodyFatWidget(
      key: Key('latestBodyFat'),
      data: data,
      constraints: constraints,
    );

    Widget latestWeight = LatestWeightWidget(
      key: Key('latestWeight'),
      constraints: constraints,
      data: data,
    );

    Widget weeklyWorkoutHistorySmall = WeeklyWorkoutWidget.create(
      key: Key('weeklyWorkoutHistorySmall'),
      user: data.user,
      routineHistories: data.routineHistories,
      constraints: constraints,
    );

    Widget weeklyWorkoutHistoryMedium = WeeklyLiftedWeightsCard(
      key: Key('weeklyWorkoutHistoryMedium'),
      progressTabClass: data,
      constraints: constraints,
    );

    Widget weeklyNutritionChart = WeeklyNutritionCard(
      key: Key('weeklyNutritionChart'),
      progressTabClass: data,
      constraints: constraints,
    );

    Widget weeklyMeasurementsChart = WeeklyMeasurementsCard(
      key: Key('weeklyMeasurementsChart'),
      progressTabClass: data,
      constraints: constraints,
    );
    Widget activityRing = DailyActivityRingWidget(
      key: Key('activityRing'),
      progressTabClass: data,
      constraints: constraints,
    );
    Widget recentWorkout = MostRecentWorkout(
      key: Key('recentWorkout'),
      constraints: constraints,
      data: data,
    );
    Widget stepsWidget = StepsWidget(
      key: Key('stepsWidget'),
      steps: data.steps,
    );
    Widget empty2x2 = SizedBox(
      key: Key('empty2x2'),
      width: constraints.maxWidth,
      height: constraints.maxHeight / 2,
    );
    Widget empty1x2 = SizedBox(
      key: Key('empty1x2'),
      width: constraints.maxWidth,
      height: constraints.maxHeight / 4,
    );
    Widget empty1x1 = SizedBox(
      key: Key('empty1x1'),
      width: constraints.maxWidth / 2,
      height: constraints.maxHeight / 4,
    );

    _keysAndWidgets = {
      'activityRing': activityRing,
      'empty1x2': empty1x2,
      'empty2x2': empty2x2,
      'weeklyMeasurementsChart': weeklyMeasurementsChart,
      'weeklyNutritionChart': weeklyNutritionChart,
      'weeklyWorkoutHistoryMedium': weeklyWorkoutHistoryMedium,
      'weeklyWorkoutHistorySmall': weeklyWorkoutHistorySmall,
      'recentWorkout': recentWorkout,
      'empty1x1': empty1x1,
      'latestBodyFat': latestBodyFat,
      'latestWeight': latestWeight,
      'stepsWidget': stepsWidget,
    };

    _widgetKeysList = data.user.widgetsList ?? _widgetKeysList;
    _widgets = List.generate(
      data.user.widgetsList?.length ?? _widgetKeysList.length,
      (index) => _keysAndWidgets[
          data.user.widgetsList?[index] ?? _widgetKeysList[index]]!,
    );
  }

  // CONST VARIABLES
  static const bgURL = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg001_1000x1000.jpeg?alt=media&token=199346a5-fb06-4871-a2e6-3f2ed7f628c1',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg002_1000x1000.jpeg?alt=media&token=2b60a27e-1efa-4b19-9325-7436b0f3d4fc',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg003_1000x1000.jpeg?alt=media&token=4e9d2e6f-b550-4bd6-8a21-7d8e95a169fb',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg004_1000x1000.jpeg?alt=media&token=592ae255-735c-4c94-9b04-a00ae743047c',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg005_1000x1000.jpeg?alt=media&token=16aea7d3-596c-4e80-92e8-acd4c2d4d3b7',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg006_1000x1000.jpeg?alt=media&token=2f95cfc4-38c9-4105-b0f8-150c94758d3a',
  ];
}
