import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/resources/send_email.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class CancelBookingPopUpDialog extends StatefulWidget {
  final String bookingId;
  final String roomType;
  final int noOfRooms;
  final String name;
  final String checkIn;
  final String phoneNumber;
  const CancelBookingPopUpDialog({
    Key? key,
    required this.bookingId,
    required this.roomType,
    required this.noOfRooms,
    required this.name,
    required this.checkIn,
    required this.phoneNumber,
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

  late TwilioFlutter twilioFlutter;

  @override
  void initState() {
    super.initState();

    twilioFlutter = TwilioFlutter(
      accountSid: "ACd93747d0d38729e77ebbf0538c6c0a06",
      authToken: "ed86ae256314451f8d9bcc9d8a5cc44f",
      twilioNumber: "+19793169548",
    );
  }

  // changing "bookingCancel" to true in 'Booking'
  // changing "..BookedRooms" and "..TotalRooms" in 'BookingStatus'
  Future<String> cancelBooking() async {
    String res = "error";
    try {
      // add booking cancel date to the database
      DateTime todayDate = DateTime.now();
      String todayDateInString = DateFormat('yyyy-MM-dd').format(todayDate);

      // change "bookingCancel" to true and add booking cancel date
      _bookingQuery.doc(widget.bookingId).update({
        "bookingCancel": true,
        "bookingCancelDate": todayDateInString,
      });

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

                          twilioFlutter.sendSMS(
                            // hotel owner phone number.
                            toNumber: "+9779861963866",
                            messageBody:
                                "BOOKING CANCEL \n${widget.noOfRooms}x ${widget.roomType}. Arrival on ${widget.checkIn} by ${widget.name.toUpperCase()} \n${widget.phoneNumber} ",
                          );

                          sendEmail(
                            context: context,
                            name: "",
                            phoneNumber: "",
                            email: "",
                            subject:
                                "Booking Cancel for ${widget.checkIn} for ${widget.noOfRooms} nights",
                            message:
                                "Booked by: ${widget.name.toUpperCase()} \nNumber Of Rooms: ${widget.noOfRooms}x \nRoom Type: ${widget.roomType}. \nArrival on ${widget.checkIn} \nPhone Number: ${widget.phoneNumber}",
                          );
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
