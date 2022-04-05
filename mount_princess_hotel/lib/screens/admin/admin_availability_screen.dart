import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/screens/admin/widgets/availability_widget.dart';
import 'package:mount_princess_hotel/widgets/admin_navigation_drawer_widget.dart';

import '../../utils/colors.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({Key? key}) : super(key: key);

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  bool isSwitchedStandard = true;
  bool isSwitchedDeluxe = true;
  int standardRoomAvailable = 0;
  int deluxeRoomAvailable = 1;
  String standardRoomStatus = "Bookable";
  String deluxeRoomStatus = "Bookable";

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Availability'),
          centerTitle: true,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[100],
            // all fields
            child: SingleChildScrollView(
              child: Container(
                  margin: const EdgeInsets.only(right: 10, left: 10, top: 30),
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  color: Colors.white,
                  child: Column(
                    children: [
                      // AvailabilityWidget(roomName: "Standard Room"),
                      // AvailabilityWidget(roomName: "Deluxe Room"),
                      availabilityWidget("Standard Room"),
                      availabilityWidget("Deluxe Room"),
                    ],
                  )),
            )),
      );

  // widget for each room
  Widget availabilityWidget(String roomName) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 20),
      decoration: roomName == "Standard Room"
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
                    roomName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  roomName == "Standard Room"
                      // for standard room
                      ? Text(
                          standardRoomStatus,
                          style: TextStyle(
                            fontSize: 19,
                            color: standardRoomStatus == "Bookable"
                                // if bookable
                                ? Colors.green[700]
                                // if unbookable
                                : Colors.red,
                          ),
                        )
                      // for deluxe room
                      : Text(
                          deluxeRoomStatus,
                          style: TextStyle(
                            fontSize: 19,
                            color: deluxeRoomStatus == "Bookable"
                                // if bookable
                                ? Colors.green[700]
                                // if unbookable
                                : Colors.red,
                          ),
                        )
                ],
              ),
              const Spacer(),
              Switch(
                value: roomName == "Standard Room"
                    ? isSwitchedStandard
                    : isSwitchedDeluxe,
                onChanged: (value) {
                  setState(() {
                    // for standard room
                    if (roomName == "Standard Room") {
                      isSwitchedStandard = value;
                      // if on then bookable
                      if (value == true) {
                        standardRoomStatus = "Bookable";
                        // else then un-bookable
                      } else {
                        standardRoomStatus = "Un-Bookable";
                      }
                      // for deluxe room
                    } else {
                      isSwitchedDeluxe = value;
                      if (value == true) {
                        deluxeRoomStatus = "Bookable";
                      } else {
                        deluxeRoomStatus = "Un-Bookable";
                      }
                    }
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
                        // for standard room
                        if (roomName == "Standard Room") {
                          if (standardRoomAvailable != 0) {
                            standardRoomAvailable--;
                          }
                          // for deluxe room
                        } else {
                          if (deluxeRoomAvailable != 0) {
                            deluxeRoomAvailable--;
                          }
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
                    roomName == "Standard Room"
                        ? "$standardRoomAvailable"
                        : "$deluxeRoomAvailable",
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(width: 10),
                  // for addition
                  InkWell(
                    onTap: () {
                      setState(() {
                        // for standard room
                        if (roomName == "Standard Room") {
                          standardRoomAvailable++;
                          // for deluxe room
                        } else {
                          deluxeRoomAvailable++;
                        }
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
