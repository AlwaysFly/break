import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';

class PasswordStrengthMeter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            _passwordStrengthMeter(context, PrimaryColor),
            _passwordStrengthMeter(context, Colors.grey),
            _passwordStrengthMeter(context, Colors.grey),
            _passwordStrengthMeter(context, Colors.grey),
          ],
        ),
        const SizedBox(height: 8),
        Text('Weak', style: BodyText1),
      ],
    );
  }

  Widget _passwordStrengthMeter(BuildContext context, Color color) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 2,
      ),
      child: Container(
        height: 4,
        width: (size.width - 48) / 4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
