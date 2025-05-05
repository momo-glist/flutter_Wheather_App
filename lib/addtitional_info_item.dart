import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInformation(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
          ),
          SizedBox(
            height: 8,
          ),
          Text(label),
          SizedBox(
            height: 8,
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
