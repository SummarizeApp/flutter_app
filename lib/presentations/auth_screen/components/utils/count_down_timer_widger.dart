import 'package:flutter/material.dart';

class CountdownTimer extends StatelessWidget {
  final int remainingTime;
  final String formattedTime;

  const CountdownTimer({
    Key? key,
    required this.remainingTime,
    required this.formattedTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.primaryContainer, width: 4),
        ),
        child: Center(
          child: Text(
            formattedTime,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}