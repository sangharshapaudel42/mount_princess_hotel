import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookingPage extends StatefulWidget {
  final String documentId;
  const DetailBookingPage({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<DetailBookingPage> createState() => _DetailBookingPageState();
}

class _DetailBookingPageState extends State<DetailBookingPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Booking Detail'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Booking")
              .doc(widget.documentId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            Map<String, dynamic> document =
                snapshot.data!.data() as Map<String, dynamic>;

            String phoneNumber = document["phoneNumber"];
            String name = document["name"];
            String email = document["email"];
            int person = document["person"];
            var bookingCancelDate = document["bookingCancelDate"];
            String note = document["note"];
            Timestamp checkIn = document["checkIn"];
            Timestamp checkOut = document["checkOut"];
            int numberOfRooms = document["numberOfRooms"];
            int numberOfPeople = document["person"];
            double price = document["totalPrice"];
            bool bookingCancel = document["bookingCancel"];
            String roomType = document["roomType"];

            return Container(
              color: Colors.grey[100],
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // cancelled reservation
                    bookingCancel == true
                        ? cancelReservation(bookingCancelDate)
                        : const SizedBox(height: 0),
                    // guest details and contact them
                    guestDetailContact(phoneNumber, name, email, person,
                        numberOfRooms, bookingCancel),
                    SizedBox(height: size.height / 30),
                    // booking details
                    buildBookingDetail(checkIn, checkOut, numberOfRooms,
                        numberOfPeople, price, roomType),
                    // note from the guest
                    note != "" ? guestNote(name, note) : const SizedBox(),
                  ],
                ),
              ),
            );
          }),
    );
  }

// for booking cancel only
  Widget cancelReservation(String bookingCancelDateString) {
    DateTime bookingCancelDate = DateTime.parse(bookingCancelDateString);
    String bookingCancel = DateFormat.yMMMd().format(bookingCancelDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: MediaQuery.of(context).size.width,
      color: const Color.fromARGB(255, 243, 215, 174),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            color: Color.fromARGB(255, 255, 119, 0),
            size: 35,
          ),
          SizedBox(width: MediaQuery.of(context).size.width / 35),
          RichText(
            text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: "Cancelled reservation.\n\n",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                      text:
                          'This reservation was cancelled on $bookingCancel.'),
                ]),
          ),
        ],
      ),
    );
  }

  Widget guestDetailContact(String phoneNumber, String name, String email,
      int person, int numberOfRooms, bool bookingCancel) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          // guest details and contact
          SizedBox(height: size.height / 25),
          Row(
            children: [
              // guest-details
              InkWell(
                onTap: () => guestDetailsWidget(
                    name, email, phoneNumber, person, numberOfRooms),
                child: buildContactAndGuestDetails(
                    "Guest details", Icons.person, bookingCancel),
              ),
              SizedBox(width: size.width / 10),
              // conact
              InkWell(
                // disable if booking has been cancelled.
                onTap: bookingCancel == false
                    ? () async {
                        try {
                          launch('tel://$phoneNumber');
                        } catch (err) {
                          showSnackBar(context, "Sorry, something went wrong.");
                        }
                      }
                    : null,
                child: buildContactAndGuestDetails(
                    "Contact", Icons.phone, bookingCancel),
              ),
            ],
          )
        ],
      ),
    );
  }

  // the pop up from the bottom which contains guest info.
  Future guestDetailsWidget(String name, String email, String phoneNumber,
      int person, int numberOfRooms) async {
    var size = MediaQuery.of(context).size;

    await showModalBottomSheet(
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
              // name and close button
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
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
              SizedBox(height: size.height / 40),
              // email
              Row(
                children: [
                  const Icon(
                    Icons.email,
                    color: Colors.blue,
                    size: 22,
                  ),
                  SizedBox(width: size.width / 40),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height / 60),
              // phone
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    color: Colors.blue,
                    size: 22,
                  ),
                  SizedBox(width: size.width / 40),
                  Text(
                    phoneNumber,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height / 30),
              // line
              Container(
                height: 1,
                color: Colors.grey,
              ),
              // Total guests
              SizedBox(height: size.height / 30),
              const Text(
                "Total guests",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height / 60),
              Text(
                person.toString() + " person",
                style: const TextStyle(fontSize: 21),
              ),
              // Total rooms
              SizedBox(height: size.height / 30),
              const Text(
                "Total rooms",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height / 60),
              Text(
                numberOfRooms.toString() + " room",
                style: const TextStyle(fontSize: 21),
              ),
              // Preferred language
              SizedBox(height: size.height / 30),
              const Text(
                "Preferred language",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height / 60),
              const Text(
                "English / Nepali",
                style: TextStyle(fontSize: 21),
              ),
              // Address
              SizedBox(height: size.height / 30),
              const Text(
                "Address",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height / 60),
              const Text(
                "Address is not available",
                style: TextStyle(fontSize: 21),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildContactAndGuestDetails(
      String widgetName, IconData widgetIcon, bool bookingCancel) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              width: size.width / 6.5,
              height: size.height / 11,
              decoration: BoxDecoration(
                color: bookingCancel == true && widgetName == "Contact"
                    ? Color.fromARGB(255, 212, 212, 212)
                    : Color.fromARGB(255, 207, 228, 242),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Icon(
                widgetIcon,
                color: bookingCancel == true && widgetName == "Contact"
                    ? Color.fromARGB(255, 119, 118, 118)
                    : const Color.fromARGB(255, 49, 89, 235),
                size: 50,
              ),
            )
          ],
        ),
        SizedBox(height: size.height / 65),
        Text(
          widgetName,
          style: TextStyle(
            fontSize: 20,
            color: bookingCancel == true && widgetName == "Contact"
                ? const Color.fromARGB(255, 119, 118, 118)
                : const Color.fromARGB(255, 49, 89, 235),
          ),
        )
      ],
    );
  }

  Widget buildBookingDetail(Timestamp checkIn, Timestamp checkOut,
      int numberOfRooms, int numberOfPeople, double price, String roomType) {
    var size = MediaQuery.of(context).size;

    // get the checkIn date
    Timestamp timestampCheckIn = checkIn;
    DateTime dateTimeCheckIn = timestampCheckIn.toDate();
    String checkInDate = DateFormat.yMMMEd().format(dateTimeCheckIn);

    // get the checkOut date
    Timestamp timestampCheckOut = checkOut;
    DateTime dateTimeCheckOut = timestampCheckOut.toDate();
    String checkOutDate = DateFormat.yMMMEd().format(dateTimeCheckOut);

    // number of nights
    int nights = dateTimeCheckOut.difference(dateTimeCheckIn).inDays;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // check-in and check-out
          Row(
            children: [
              // check-in
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Check-in",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: size.height / 60),
                    Text(
                      checkInDate,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // check-out
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Check-out",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: size.height / 60),
                    Text(
                      checkOutDate,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: size.height / 30),
          // nights
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.nightlight_outlined,
                      color: Colors.grey[600],
                      size: 35,
                    ),
                    Text(
                      "$nights night",
                      style: const TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              // room type
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.bed_rounded,
                      color: Colors.grey[600],
                      size: 35,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      roomType,
                      style: const TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: size.height / 70),
          Row(
            children: [
              // number of people
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: Colors.grey[600],
                      size: 35,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$numberOfPeople person",
                      style: const TextStyle(
                        fontSize: 21,
                      ),
                    ),
                  ],
                ),
              ),
              // Price
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Colors.grey[600],
                      size: 35,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "US \$$price",
                      style: const TextStyle(
                        fontSize: 21,
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

// show this only if the guest has some note.
  Widget guestNote(String name, String note) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      width: size.width,
      margin: EdgeInsets.only(top: size.height / 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note from " + name.toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height / 80),
          Text(
            note,
            textScaleFactor: 1.1,
            style: const TextStyle(
              fontSize: 18,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
