import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/enum/main_muscle_group.dart';

import 'enum/unit_of_mass.dart';

class Routine {
  final String routineId;
  final String routineOwnerId;
  final String routineOwnerUserName;
  final String routineTitle;
  final Timestamp lastEditedDate;
  final Timestamp routineCreatedDate;
  final List<dynamic>? mainMuscleGroup;
  final List<dynamic>? secondMuscleGroup; // Nullable
  final String? description; // Nullable
  final String imageUrl;
  final num totalWeights;
  final int? averageTotalCalories; // Nullable
  final int duration;
  final List<dynamic>? equipmentRequired;
  final int trainingLevel;
  final bool isPublic;
  final int? initialUnitOfMass;
  final String location;
  final String? thumbnailImageUrl; // Nullable
  final List<MainMuscleGroup?>? mainMuscleGroupEnum; // Nullable
  final List<EquipmentRequired?>? equipmentRequiredEnum; // Nullable
  final UnitOfMass? unitOfMassEnum; // Nullable

  const Routine({
    required this.routineId,
    required this.routineOwnerId,
    required this.routineOwnerUserName,
    required this.routineTitle,
    required this.lastEditedDate,
    required this.routineCreatedDate,
    required this.mainMuscleGroup,
    this.secondMuscleGroup,
    this.description,
    required this.imageUrl,
    required this.totalWeights,
    this.averageTotalCalories,
    required this.duration,
    required this.equipmentRequired,
    required this.trainingLevel,
    required this.isPublic,
    required this.initialUnitOfMass,
    required this.location,
    this.thumbnailImageUrl,
    this.mainMuscleGroupEnum,
    this.equipmentRequiredEnum,
    this.unitOfMassEnum,
  });

  factory Routine.fromJson(Map<String, dynamic>? data, String documentId) {
    if (data != null) {
      final String routineOwnerId = data['routineOwnerId'];
      final String routineOwnerUserName = data['routineOwnerUserName'];
      final String routineTitle = data['routineTitle'];
      final Timestamp lastEditedDate = data['lastEditedDate'];
      final Timestamp routineCreatedDate = data['routineCreatedDate'];
      final List<dynamic>? mainMuscleGroup = data['mainMuscleGroup'];
      final List<dynamic>? secondMuscleGroup = data['secondMuscleGroup'];
      final String? description = data['description'];
      final String imageUrl = data['imageUrl'];
      final num totalWeights = data['totalWeights'];
      final int? averageTotalCalories = data['averageTotalCalories'];
      final int duration = data['duration'];
      final List<dynamic>? equipmentRequired = data['equipmentRequired'];
      final int trainingLevel = data['trainingLevel'];
      final bool isPublic = data['isPublic'];
      final int? initialUnitOfMass = data['initialUnitOfMass'];
      final String location = data['location'];
      final String? thumbnailImageUrl = data['thumbnailImageUrl'];
      final List<MainMuscleGroup?>? mainMuscleGroupEnum =
          (data['mainMuscleGroupEnum'] != null)
              ? EnumToString.fromList(
                  MainMuscleGroup.values,
                  data['mainMuscleGroupEnum'],
                )
              : null;

      final List<EquipmentRequired?>? equipmentRequiredEnum =
          (data['equipmentRequiredEnum'] != null)
              ? EnumToString.fromList(
                  EquipmentRequired.values,
                  data['equipmentRequiredEnum'],
                )
              : null;

      final UnitOfMass? unitOfMassEnum = (data['unitOfMassEnum'] != null)
          ? EnumToString.fromString<UnitOfMass>(
              UnitOfMass.values,
              data['unitOfMassEnum'],
            )
          : null;

      return Routine(
        routineId: documentId,
        routineOwnerId: routineOwnerId,
        routineOwnerUserName: routineOwnerUserName,
        routineTitle: routineTitle,
        lastEditedDate: lastEditedDate,
        routineCreatedDate: routineCreatedDate,
        mainMuscleGroup: mainMuscleGroup,
        secondMuscleGroup: secondMuscleGroup,
        description: description,
        imageUrl: imageUrl,
        totalWeights: totalWeights,
        averageTotalCalories: averageTotalCalories,
        duration: duration,
        equipmentRequired: equipmentRequired,
        trainingLevel: trainingLevel,
        isPublic: isPublic,
        initialUnitOfMass: initialUnitOfMass,
        location: location,
        thumbnailImageUrl: thumbnailImageUrl,
        mainMuscleGroupEnum: mainMuscleGroupEnum,
        equipmentRequiredEnum: equipmentRequiredEnum,
        unitOfMassEnum: unitOfMassEnum,
      );
    } else {
      throw 'null';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'routineOwnerId': routineOwnerId,
      'routineTitle': routineTitle,
      'routineOwnerUserName': routineOwnerUserName,
      'lastEditedDate': lastEditedDate,
      'routineCreatedDate': routineCreatedDate,
      'mainMuscleGroup': mainMuscleGroup,
      'secondMuscleGroup': secondMuscleGroup,
      'description': description,
      'imageUrl': imageUrl,
      'totalWeights': totalWeights,
      'averageTotalCalories': averageTotalCalories,
      'duration': duration,
      'equipmentRequired': equipmentRequired,
      'trainingLevel': trainingLevel,
      'isPublic': isPublic,
      'initialUnitOfMass': initialUnitOfMass,
      'location': location,
      'thumbnailImageUrl': thumbnailImageUrl,
      'mainMuscleGroupEnum': mainMuscleGroupEnum
          ?.map((e) => EnumToString.convertToString(e))
          .toList(),
      'equipmentRequiredEnum': equipmentRequiredEnum
          ?.map((e) => EnumToString.convertToString(e))
          .toList(),
      'unitOfMassEnum': EnumToString.convertToString(unitOfMassEnum),
    };
  }
}
