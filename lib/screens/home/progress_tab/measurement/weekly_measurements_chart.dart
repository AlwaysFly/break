import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/measurement.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/measurement/weely_measurements_chart_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

class WeeklyMeasurementsChart extends StatefulWidget {
  final WeeklyMeasurementsChartModel model;
  final User user;
  final List<Measurement> measurements;

  const WeeklyMeasurementsChart({
    Key? key,
    required this.model,
    required this.user,
    required this.measurements,
  }) : super(key: key);

  @override
  _WeeklyMeasurementsChartState createState() =>
      _WeeklyMeasurementsChartState();
}

class _WeeklyMeasurementsChartState extends State<WeeklyMeasurementsChart> {
  List<Color> gradientColors = [
    kSecondaryColor,
    kSecondaryColor.withOpacity(0.95),
  ];

  double? flipNumber(double number) {
    switch (number.toInt()) {
      case 6:
        return 0.toDouble();
      case 5:
        return 1.toDouble();
      case 4:
        return 2.toDouble();
      case 3:
        return 3.toDouble();
      case 2:
        return 4.toDouble();
      case 1:
        return 5.toDouble();
      case 0:
        return 6.toDouble();
    }
  }

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
    widget.model.setMaxY(widget.measurements);

    return Expanded(
      child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                horizontalInterval: widget.model.horizontalInterval,
                drawVerticalLine: false,
                show: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.white12,
                    strokeWidth: 1,
                  );
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(
                    color: Colors.white12,
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  margin: 24,
                  getTextStyles: (value) => TextStyles.body2,
                  getTitles: (value) {
                    switch (value.toInt()) {
                      case 0:
                        return '${widget.model.daysOfTheWeek[6]}';
                      case 1:
                        return '${widget.model.daysOfTheWeek[5]}';
                      case 2:
                        return '${widget.model.daysOfTheWeek[4]}';
                      case 3:
                        return '${widget.model.daysOfTheWeek[3]}';
                      case 4:
                        return '${widget.model.daysOfTheWeek[2]}';
                      case 5:
                        return '${widget.model.daysOfTheWeek[1]}';
                      case 6:
                        return '${widget.model.daysOfTheWeek[0]}';

                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  margin: 24,
                  getTextStyles: (_) => TextStyles.caption1_grey,
                  getTitles: (value) {
                    final unit = Formatter.unitOfMass(
                      widget.user.unitOfMass,
                    );
                    final maxY = widget.model.maxY;
                    final minY = widget.model.minY;

                    final interaval = (maxY - minY) / 4;

                    if (value == maxY) {
                      return '${maxY.toInt()} $unit';
                    } else if (value == maxY - interaval) {
                      return '${(maxY - interaval).toInt()} $unit';
                    } else if (value == maxY - interaval * 2) {
                      return '${(maxY - interaval * 2).toInt()} $unit';
                    } else if (value == maxY - interaval * 3) {
                      return '${(maxY - interaval * 3).toInt()} $unit';
                    } else if (value == minY) {
                      return '${minY.toInt()} $unit';
                    }
                    return '';
                  },
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: Colors.white12, width: 1),
                ),
              ),
              minX: 0,
              maxX: 6,
              minY: widget.model.minY,
              maxY: widget.model.maxY,
              lineBarsData: [
                LineChartBarData(
                  spots: (widget.model.thisWeekData.isNotEmpty)
                      ? actualSpots()
                      : _randomSpots(),
                  isCurved: true,
                  colors: gradientColors,
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          )),
    );
  }

  List<FlSpot> actualSpots() {
    return List.generate(
      widget.model.thisWeekData.length,
      (index) {
        final diff = widget.model.now
            .difference(widget.model.thisWeekData[index]!.loggedDate)
            .inDays
            .toDouble();

        return FlSpot(
          flipNumber(diff)!,
          widget.model.thisWeekData[index]!.bodyWeight!.toDouble(),
        );
      },
    );
  }

  List<FlSpot> _randomSpots() {
    return [
      FlSpot(0, 77),
      FlSpot(1, 76.6),
      FlSpot(2, 76),
      FlSpot(3, 75.4),
      FlSpot(4, 75.5),
      FlSpot(5, 75),
      FlSpot(6, 74.2),
    ];
  }
}
