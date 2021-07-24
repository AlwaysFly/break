import 'package:json_annotation/json_annotation.dart';

enum CustomHealthDataType {
  @JsonValue('ACTIVE_ENERGY_BURNED')
  ACTIVE_ENERGY_BURNED,

  @JsonValue('BASAL_ENERGY_BURNED')
  BASAL_ENERGY_BURNED,

  @JsonValue('BLOOD_GLUCOSE')
  BLOOD_GLUCOSE,

  @JsonValue('BLOOD_OXYGEN')
  BLOOD_OXYGEN,

  @JsonValue('BLOOD_PRESSURE_DIASTOLIC')
  BLOOD_PRESSURE_DIASTOLIC,

  @JsonValue('BLOOD_PRESSURE_SYSTOLIC')
  BLOOD_PRESSURE_SYSTOLIC,

  @JsonValue('BODY_FAT_PERCENTAGE')
  BODY_FAT_PERCENTAGE,

  @JsonValue('BODY_MASS_INDEX')
  BODY_MASS_INDEX,

  @JsonValue('BODY_TEMPERATURE')
  BODY_TEMPERATURE,

  @JsonValue('HEART_RATE')
  HEART_RATE,

  @JsonValue('HEART_RATE_VARIABILITY_SDNN')
  HEART_RATE_VARIABILITY_SDNN,

  @JsonValue('HEIGHT')
  HEIGHT,

  @JsonValue('RESTING_HEART_RATE')
  RESTING_HEART_RATE,

  @JsonValue('STEPS')
  STEPS,

  @JsonValue('WAIST_CIRCUMFERENCE')
  WAIST_CIRCUMFERENCE,

  @JsonValue('WALKING_HEART_RATE')
  WALKING_HEART_RATE,

  @JsonValue('WEIGHT')
  WEIGHT,

  @JsonValue('DISTANCE_WALKING_RUNNING')
  DISTANCE_WALKING_RUNNING,

  @JsonValue('FLIGHTS_CLIMBED')
  FLIGHTS_CLIMBED,

  @JsonValue('MOVE_MINUTES')
  MOVE_MINUTES,

  @JsonValue('DISTANCE_DELTA')
  DISTANCE_DELTA,

  @JsonValue('MINDFULNESS')
  MINDFULNESS,

  @JsonValue('WATER')
  WATER,

  @JsonValue('SLEEP_IN_BED')
  SLEEP_IN_BED,

  @JsonValue('SLEEP_ASLEEP')
  SLEEP_ASLEEP,

  @JsonValue('SLEEP_AWAKE')
  SLEEP_AWAKE,

  @JsonValue('HIGH_HEART_RATE_EVENT')
  HIGH_HEART_RATE_EVENT,

  @JsonValue('LOW_HEART_RATE_EVENT')
  LOW_HEART_RATE_EVENT,

  @JsonValue('IRREGULAR_HEART_RATE_EVENT')
  IRREGULAR_HEART_RATE_EVENT,

  @JsonValue('ELECTRODERMAL_ACTIVITY')
  ELECTRODERMAL_ACTIVITY,
}
