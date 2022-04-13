import 'package:flutter/material.dart';

Widget arrivalsDepartures(BuildContext context, String type, int value) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width / 3.3,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          type,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "$value",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ],
    ),
  );
}
