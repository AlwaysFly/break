import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../../../constants.dart';

class RoutineDescriptionWidget extends StatelessWidget {
  final String? description;

  const RoutineDescriptionWidget({
    Key? key,
    required this.description,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('description is $description');

    if (description != null) {
      if (description!.isNotEmpty) {
        return Text(
          description!,
          style: kBodyText2LightGrey,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        );
      } else {
        return Text(S.current.addDescription, style: kBodyText2LightGrey);
      }
    } else {
      return Text(S.current.addDescription, style: kBodyText2LightGrey);
    }
  }
}
