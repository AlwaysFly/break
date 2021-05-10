import 'package:cloud_firestore/cloud_firestore.dart';

class Routine {
  final String routineId;
  final String routineOwnerId;
  final String routineOwnerUserName;
  final String routineTitle;
  final Timestamp lastEditedDate;
  final Timestamp routineCreatedDate;
  final List<dynamic> mainMuscleGroup;
  final List<dynamic>? secondMuscleGroup; // Nullable
  final String? description; // Nullable
  final String imageUrl;
  final num totalWeights;
  final int? averageTotalCalories; // Nullable
  final int duration;
  final List<dynamic> equipmentRequired;
  final int trainingLevel;
  final bool isPublic;
  final int initialUnitOfMass;
  final String location;
  final String? thumbnailImageUrl; // Nullable

  Routine({
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
  });

  factory Routine.fromMap(Map<String, dynamic> data, String documentId) {
    final String routineOwnerId = data['routineOwnerId'];
    final String routineOwnerUserName = data['routineOwnerUserName'];
    final String routineTitle = data['routineTitle'];
    final Timestamp lastEditedDate = data['lastEditedDate'];
    final Timestamp routineCreatedDate = data['routineCreatedDate'];
    final List<dynamic> mainMuscleGroup = data['mainMuscleGroup'];
    final List<dynamic>? secondMuscleGroup = data['secondMuscleGroup'];
    final String? description = data['description'];
    final String imageUrl = data['imageUrl'];
    final num totalWeights = data['totalWeights'];
    final int? averageTotalCalories = data['averageTotalCalories'];
    final int duration = data['duration'];
    final List<dynamic> equipmentRequired = data['equipmentRequired'];
    final int trainingLevel = data['trainingLevel'];
    final bool isPublic = data['isPublic'];
    final int initialUnitOfMass = data['initialUnitOfMass'];
    final String location = data['location'];
    final String? thumbnailImageUrl = data['thumbnailImageUrl'];

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
    );
  }

  Map<String, dynamic> toMap() {
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
    };
  }
}
