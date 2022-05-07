import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/resources/send_email.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:mount_princess_hotel/widgets/booking_cancel_pop_up.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twilio_flutter/twilio_flutter.dart';

// Activity New Booking widget
Widget buildBookingCancelWidget(
    BuildContext context, QueryDocumentSnapshot data) {
  // get the checkIn date
  Timestamp timestampCheckIn = data['checkIn'];
  DateTime dateTimeCheckIn = timestampCheckIn.toDate();
  String checkInDate = DateFormat.yMMMEd().format(dateTimeCheckIn);

  // get the checkOut date
  Timestamp timestampCheckOut = data['checkOut'];
  DateTime dateTimeCheckOut = timestampCheckOut.toDate();
  String checkOutDate = DateFormat.yMMMEd().format(dateTimeCheckOut);

  // today date
  DateTime todayDate = DateTime.now();

  // get the bookingDate date
  Timestamp timestampBookingDate = data['bookingDate'];
  DateTime dateTimeBookingDate = timestampBookingDate.toDate();
  String bookingDate = DateFormat.yMMMMEEEEd().format(dateTimeBookingDate);

  // number of nights
  int nights = dateTimeCheckOut.difference(dateTimeCheckIn).inDays;

  // numbers of rooms
  int numberOfRooms = data["numberOfRooms"];

  // total price
  double price = data["totalPrice"];

  String roomType = data["roomType"];

  String name = data["name"];

  var size = MediaQuery.of(context).size;

  // text fields' controllers
  TextEditingController? _noteController;

  final _bookingQuery = FirebaseFirestore.instance.collection('Booking');

  // function to add/update note of the user
  Future<void> addNote(DocumentSnapshot documentSnapshot) async {
    _noteController = TextEditingController();
    if (documentSnapshot["note"] != "") {
      _noteController!.text = documentSnapshot['note'];
    }

    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    await showModalBottomSheet(
        backgroundColor: Colors.grey[200],
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Send note to hotel",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 40,
                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 30),
                TextField(
                  controller: _noteController,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "Note",
                    hintStyle: const TextStyle(fontSize: 20),
                    fillColor: Colors.white,
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    enabledBorder: inputBorder,
                    filled: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  height: 45,
                  minWidth: double.infinity,
                  color: const Color(0xff024DB8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  onPressed: () async {
                    final String? note = _noteController!.text;
                    String res = "";

                    if (note != null) {
                      try {
                        // add/update note of the booking
                        await _bookingQuery.doc(documentSnapshot.id).update({
                          "note": note,
                        });

                        res = "success";

                        _noteController = null;
                      } catch (err) {
                        print(err.toString());
                      }
                    }

                    if (res == "success") {
                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  return SingleChildScrollView(
    child: Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.only(right: 10, left: 10, top: 15, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookingDate,
            style: const TextStyle(
              color: Color(0xff0b29d6),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 15, bottom: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border:
                  Border(left: BorderSide(width: 3, color: Color(0xff0f8204))),
            ),
            // inner content of the container
            child: Stack(
              children: [
                // all inner stuff
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // room type and the time ago
                      Row(
                        children: [
                          Text(
                            data["roomType"],
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            // time ago booking date.
                            timeago.format(dateTimeBookingDate),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
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
                              Text(
                                checkInDate,
                                style: const TextStyle(
                                  fontSize: 20,
                                  // color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Nights - no_of_nights
                          Padding(
                            padding: const EdgeInsets.only(right: 25),
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
                                Text(
                                  "$nights",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    // color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          // departure - date
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Departure",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                checkOutDate,
                                style: const TextStyle(
                                  fontSize: 20,
                                  // color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Rooms
                          Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Rooms",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "$numberOfRooms",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    // color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // guest name, Price
                      Row(
                        children: [
                          // guest name - name
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
                              Text(
                                data["name"],
                                style: const TextStyle(
                                  fontSize: 20,
                                  // color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Price - price
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Price",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "US \$$price",
                                style: const TextStyle(
                                  fontSize: 20,
                                  // color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // email / phone number
                      Row(
                        children: [
                          // email
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                data["email"].length > 20
                                    ? data["email"].substring(0, 20) + '...'
                                    : data["email"],
                                style: const TextStyle(
                                  fontSize: 20,
                                  // color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // phone number
                          Column(
                            children: [
                              Text(
                                "Phone number",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                data["phoneNumber"],
                                style: const TextStyle(
                                  fontSize: 20,
                                  // color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // show the note
                      data["note"] != ""
                          ? Container(
                              color: Colors.grey[200],
                              margin: const EdgeInsets.only(top: 10),
                              width: size.width,
                              padding: const EdgeInsets.only(
                                  right: 10, left: 10, top: 15, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Note from YOU",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      // edit button
                                      InkWell(
                                        onTap: () => addNote(data),
                                        child: Icon(
                                          Icons.edit_note,
                                          color: Colors.grey[800],
                                          size: 35,
                                        ),
                                      ),
                                      SizedBox(width: size.width / 100),
                                      // delete button
                                      InkWell(
                                        onTap: () async {
                                          try {
                                            // deleting the note means changing note to ""
                                            await _bookingQuery
                                                .doc(data.id)
                                                .update({
                                              "note": "",
                                            });
                                          } catch (err) {
                                            showSnackBar(context,
                                                "Something went wrong.");
                                          }
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.grey[800],
                                          size: 30,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: size.height / 80),
                                  Text(
                                    data["note"],
                                    textScaleFactor: 1.1,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                // cancel booking button
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // show this botton only if there is no note added yet.
                      data["note"] == ""
                          ? InkWell(
                              onTap: () => addNote(data),
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 10, right: 5),
                                color: const Color.fromARGB(255, 11, 190, 11),
                                // color: const Color.fromARGB(255, 12, 12, 231),
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Send note to hotel",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(height: 0),
                      // booking cancel icon
                      // dont show cancel icon if checkOut has already gone.
                      dateTimeCheckOut.difference(todayDate).inDays >= 0
                          ? IconButton(
                              icon:
                                  const Icon(Icons.free_cancellation_outlined),
                              color: Colors.black,
                              iconSize: 35,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CancelBookingPopUpDialog(
                                    bookingId: data.id,
                                    roomType: data["roomType"],
                                    noOfRooms: data["numberOfRooms"],
                                    name: data["name"],
                                    checkIn: checkInDate,
                                    phoneNumber: data["phoneNumber"],
                                  ),
                                );
                              },
                            )
                          : const SizedBox(height: 0)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
