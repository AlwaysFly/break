import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/custom_list_tile_64.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/empty_content_widget.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';

import 'create_routine/create_new_routine_screen.dart';
import 'create_routine/create_new_routine_widget.dart';
import 'routine_detail_screen.dart';
import 'saved_routines/saved_routines_tile_widget.dart';

class RoutinesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return PaginateFirestore(
      shrinkWrap: true,
      query: database.routinesPaginatedUserQuery(),
      physics: const BouncingScrollPhysics(),
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            SavedRoutinesTileWidget(),
            EmptyContentWidget(
              imageUrl: 'assets/images/saved_routines_empty_bg.png',
              bodyText: S.current.savedRoutineEmptyText,
              onPressed: () => CreateNewRoutineScreen.show(context),
            ),
          ],
        ),
      ),
      itemsPerPage: 10,
      header: SliverToBoxAdapter(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            // if (query.snapshots() != null) CreateNewRoutineWidget(),
            CreateNewRoutineWidget(),
            SavedRoutinesTileWidget(),
          ],
        ),
      ),
      footer: SliverToBoxAdapter(child: const SizedBox(height: 160)),
      onError: (error) => EmptyContent(
        message: '${S.current.somethingWentWrong} \n error message: $error',
      ),
      itemBuilder: (index, context, documentSnapshot) {
        // final documentId = documentSnapshot.id;
        // final data = documentSnapshot.data();
        // final routine = Routine.fromJson(data!, documentId);

        // final snapshot = documentSnapshot as DocumentSnapshot<Routine?>;
        // final routine = snapshot.data()!;
        final routine = documentSnapshot.data() as Routine;

        final subtitle = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == routine.mainMuscleGroup[0])
            .translation!;
        return CustomListTile64(
          tag: 'savedRoutines-${routine.routineId}',
          title: routine.routineTitle,
          subtitle: subtitle,
          imageUrl: routine.imageUrl,
          onTap: () => RoutineDetailScreen.show(
            context,
            routine: routine,
            tag: 'savedRoutines-${routine.routineId}',
          ),
        );
      },
      isLive: true,
    );
  }
}