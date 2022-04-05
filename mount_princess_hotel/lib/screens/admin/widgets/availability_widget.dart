import 'package:flutter/material.dart';

class AvailabilityWidget extends StatefulWidget {
  String roomName;
  AvailabilityWidget({Key? key, required this.roomName}) : super(key: key);

  @override
  State<AvailabilityWidget> createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  bool isSwitched = true;
  int standardRoomAvailable = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 20),
      decoration: widget.roomName == "Standard Room"
          ? const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1.5, color: Color.fromARGB(255, 214, 212, 212))),
            )
          : null,
      child: Column(
        children: [
          // standard room - booking_status & On-Off button
          Row(
            children: [
              // standard room - booking_status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.roomName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Bookable",
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    print(isSwitched);
                  });
                },
                activeTrackColor: Colors.lightBlue[200],
                activeColor: Colors.blue[700],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // avaiable, booked & (- +)
          Row(
            children: [
              // Available - booked
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Available",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Booked: 2",
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // - 1 +
              Row(
                children: [
                  // for minus
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (standardRoomAvailable != 0) {
                          standardRoomAvailable--;
                        }
                      });
                    },
                    child: const Icon(
                      Icons.remove,
                      size: 30,
                      color: Color.fromARGB(255, 39, 126, 224),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // digit
                  Text(
                    "$standardRoomAvailable",
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(width: 10),
                  // for addition
                  InkWell(
                    onTap: () {
                      setState(() {
                        standardRoomAvailable++;
                      });
                    },
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Color.fromARGB(255, 39, 126, 224),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
