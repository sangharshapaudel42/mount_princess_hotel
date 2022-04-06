import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/utils/utils.dart';

class CancelBookingPopUpDialog extends StatefulWidget {
  final String bookingId;
  final String roomType;
  final int noOfRooms;
  const CancelBookingPopUpDialog({
    Key? key,
    required this.bookingId,
    required this.roomType,
    required this.noOfRooms,
  }) : super(key: key);

  @override
  State<CancelBookingPopUpDialog> createState() =>
      _CancelBookingPopUpDialogState();
}

class _CancelBookingPopUpDialogState extends State<CancelBookingPopUpDialog> {
  final _bookingQuery = FirebaseFirestore.instance.collection("Booking");
  final _bookingStatusQuery = FirebaseFirestore.instance
      .collection('BookingStatus')
      .doc("booking_status");

  // changing "bookingCancel" to true in 'Booking'
  // changing "..BookedRooms" and "..TotalRooms" in 'BookingStatus'
  Future<String> cancelBooking() async {
    String res = "error";
    try {
      // change "bookingCancel" to true
      _bookingQuery.doc(widget.bookingId).update({"bookingCancel": true});

      // get values of "BookingStatus"
      var data = await _bookingStatusQuery.get();

      int standardRoomBookedRooms = data["standardRoomBookedRooms"];
      int deluxeRoomBookedRooms = data["deluxeRoomBookedRooms"];
      int standardRoomTotalRooms = data["standardRoomTotalRooms"];
      int deluxeRoomTotalRooms = data["deluxeRoomTotalRooms"];

      // now update/change the "totalRooms" and "bookedRooms"
      // "..RoomBookedRooms" will be previous_booked_rooms - noOfRooms
      // "..RoomTotalRooms" will be previous_total_rooms + noOfRooms
      if (widget.roomType.toLowerCase() == "standard room") {
        await _bookingStatusQuery.update({
          "standardRoomBookedRooms": standardRoomBookedRooms - widget.noOfRooms,
          "standardRoomTotalRooms": standardRoomTotalRooms + widget.noOfRooms,
        });
      } else if (widget.roomType.toLowerCase() == "deluxe room") {
        await _bookingStatusQuery.update({
          "deluxeRoomBookedRooms": deluxeRoomBookedRooms - widget.noOfRooms,
          "deluxeRoomTotalRooms": deluxeRoomTotalRooms + widget.noOfRooms,
        });
      }

      res = "success";
      return res;
    } catch (err) {
      return err.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.9,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: MediaQuery.of(context).size.height / 5.8,
                  color: Colors.red,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Are you sure?",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Do you really want to cancel this booking? This process cannot be undone.",
                  style: TextStyle(fontSize: 21, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      height: MediaQuery.of(context).size.width / 8,
                      minWidth: MediaQuery.of(context).size.width / 4,
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 30),
                    MaterialButton(
                      height: MediaQuery.of(context).size.width / 8,
                      minWidth: MediaQuery.of(context).size.width / 3,
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "Cancel Booking",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        String res = await cancelBooking();

                        if (res == "success") {
                          Navigator.pop(context);
                          showSnackBar(context,
                              "You have succesfully canceled booking.");
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
