import 'package:flutter/material.dart';

// Activity New Booking widget
Widget buildBookingCancelWidget(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(right: 15, left: 15, top: 20, bottom: 20),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(left: BorderSide(width: 3, color: Color(0xffd60b0b))),
    ),
    // inner content of the container
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // new booking and the ago
        Row(
          children: [
            const Text(
              "Cancellation",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              "an hour ago",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // Room type
        const Text(
          "Deluxe Room",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 20),
        // guest name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Guest name",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ishan Panta",
              style: TextStyle(
                fontSize: 20,
                // color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // arrival, nights
        Row(
          children: [
            // arrival - date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Arrival",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Wed 3 December 2022",
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
              padding: const EdgeInsets.only(right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Nights",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "1",
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