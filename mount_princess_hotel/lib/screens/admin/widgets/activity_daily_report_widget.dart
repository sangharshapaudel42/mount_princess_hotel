import 'package:flutter/material.dart';

// Activity Daily Report widget
Widget buildDailyReportWidget(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(right: 15, left: 15, top: 20, bottom: 20),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(
          left: BorderSide(width: 3, color: Color.fromARGB(255, 3, 11, 166))),
    ),
    // inner content of the container
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // new booking and the ago
        const Text(
          "Daily Report",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        // arrival, nights
        Row(
          children: [
            // arrival - date
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Arrivals",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "2",
                  style: TextStyle(
                    fontSize: 20,
                    // color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Nights - no_of_nights
            Padding(
              padding: const EdgeInsets.only(right: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Departures",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "0",
                    style: TextStyle(
                      fontSize: 20,
                      // color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
