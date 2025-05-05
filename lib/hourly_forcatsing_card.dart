import 'package:flutter/material.dart';

class HourlyForecastingCard extends StatelessWidget {
  final String hour;
  final Icon icon;
  final String value;
  const HourlyForecastingCard({
    super.key,
    required this.hour,
    required this.icon,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(
              hour,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            icon,
            SizedBox(
              height: 8,
            ),
            Text(
              value,
            ),
          ],
        ),
      ),
    );
  }
}
