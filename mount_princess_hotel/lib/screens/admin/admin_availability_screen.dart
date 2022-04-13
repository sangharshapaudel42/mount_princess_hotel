import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:mount_princess_hotel/widgets/admin_navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/widgets/refresh_widget.dart';
import 'package:telephony/telephony.dart';

import '../../utils/colors.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({Key? key}) : super(key: key);

  @override
  State<AvailabilityPage> createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  final Telephony telephony = Telephony.instance;
  late Future bookingStatusLoaded;
  bool isSwitchedStandard = true;
  bool isSwitchedDeluxe = true;
  int? _standardRoomBookedRooms;
  int? _deluxeRoomBookedRooms;
  int? _standardRoomTotalRooms;
  int? _deluxeRoomTotalRooms;
  String? _standardRoomStatus;
  String? _deluxeRoomStatus;

  // NOTE: if user changes anything then '_isChanged' will be true and check button
  // will appear then update can be done.
  bool _isChanged = false;

  final _bookingStatusQuery = FirebaseFirestore.instance
      .collection('BookingStatus')
      .doc("booking_status");

  @override
  void initState() {
    super.initState();
    bookingStatusLoaded = getBookingStatusStreamSnapshots();
  }

  // get booking status
  Future getBookingStatusStreamSnapshots() async {
    // await Future.delayed(const Duration(microseconds: 10000));

    try {
      var data = await _bookingStatusQuery.get();

      setState(() {
        _standardRoomBookedRooms = data["standardRoomBookedRooms"];
        _deluxeRoomBookedRooms = data["deluxeRoomBookedRooms"];
        _standardRoomTotalRooms = data["standardRoomTotalRooms"];
        _deluxeRoomTotalRooms = data["deluxeRoomTotalRooms"];
        _standardRoomStatus = data["standardRoomStatus"];
        _deluxeRoomStatus = data["deluxeRoomStatus"];

        if (_standardRoomStatus == "Un-Bookable") {
          isSwitchedStandard = false;
        }
        if (_deluxeRoomStatus == "Un-Bookable") {
          isSwitchedDeluxe = false;
        }
      });
      return "complete";
    } catch (err) {
      print(err.toString());
    }
  }

  // update the booking status
  updateBookingStatus() async {
    try {
      await _bookingStatusQuery.update({
        "standardRoomBookedRooms": _standardRoomBookedRooms,
        "deluxeRoomBookedRooms": _deluxeRoomBookedRooms,
        "standardRoomTotalRooms": _standardRoomTotalRooms,
        "deluxeRoomTotalRooms": _deluxeRoomTotalRooms,
        "standardRoomStatus": _standardRoomStatus,
        "deluxeRoomStatus": _deluxeRoomStatus,
      });
      setState(() {
        _isChanged = false;
      });
      showSnackBar(context, "Successfully Changed.");
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const AdminNavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Availability'),
          centerTitle: true,
          // show the check button only when something has been changed
          actions: _isChanged
              ? [
                  IconButton(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 10, bottom: 8.0),
                    icon:
                        const Icon(Icons.check, color: Colors.white, size: 35),
                    onPressed: () => updateBookingStatus(),
                  )
                ]
              : null,
        ),
        body: _standardRoomBookedRooms != null &&
                _deluxeRoomBookedRooms != null &&
                _standardRoomTotalRooms != null &&
                _deluxeRoomTotalRooms != null &&
                _standardRoomStatus!.isNotEmpty &&
                _deluxeRoomStatus!.isNotEmpty
            ? RefreshWidget(
                onRefresh: getBookingStatusStreamSnapshots,
                child: ListView.builder(
                  itemCount: 1,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemBuilder: (context, i) => Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[100],
                    // all fields
                    child: SingleChildScrollView(
                      child: Container(
                        margin:
                            const EdgeInsets.only(right: 10, left: 10, top: 30),
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        color: Colors.white,
                        child: Column(
                          children: [
                            availabilityWidget("Standard Room"),
                            availabilityWidget("Deluxe Room"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(
                  "Sorry, something went wrong!!",
                  style: TextStyle(color: Colors.grey[600], fontSize: 25),
                ),
              ),
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
                          _standardRoomStatus!,
                          style: TextStyle(
                            fontSize: 19,
                            color: _standardRoomStatus == "Bookable"
                                // if bookable
                                ? Colors.green[700]
                                // if unbookable
                                : Colors.red,
                          ),
                        )
                      // for deluxe room
                      : Text(
                          _deluxeRoomStatus!,
                          style: TextStyle(
                            fontSize: 19,
                            color: _deluxeRoomStatus == "Bookable"
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
                        _standardRoomStatus = "Bookable";
                        _isChanged = true;
                        // else then un-bookable
                      } else {
                        _standardRoomStatus = "Un-Bookable";
                        _isChanged = true;
                      }
                      // for deluxe room
                    } else {
                      isSwitchedDeluxe = value;
                      if (value == true) {
                        _deluxeRoomStatus = "Bookable";
                        _isChanged = true;
                      } else {
                        _deluxeRoomStatus = "Un-Bookable";
                        _isChanged = true;
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
                    roomName == "Standard Room"
                        ? "Booked: $_standardRoomBookedRooms"
                        : "Booked: $_deluxeRoomBookedRooms",
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
                          if (_standardRoomTotalRooms != 0) {
                            _standardRoomTotalRooms =
                                _standardRoomTotalRooms! - 1;
                            _isChanged = true;
                          }
                          // for deluxe room
                        } else {
                          if (_deluxeRoomTotalRooms != 0) {
                            _deluxeRoomTotalRooms = _deluxeRoomTotalRooms! - 1;

                            _isChanged = true;
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
                        ? "$_standardRoomTotalRooms"
                        : "$_deluxeRoomTotalRooms",
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(width: 10),
                  // for addition
                  InkWell(
                    onTap: () {
                      setState(() {
                        // for standard room
                        if (roomName == "Standard Room") {
                          _standardRoomTotalRooms =
                              _standardRoomTotalRooms! + 1;

                          _isChanged = true;
                          // for deluxe room
                        } else {
                          _deluxeRoomTotalRooms = _deluxeRoomTotalRooms! + 1;

                          _isChanged = true;
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
