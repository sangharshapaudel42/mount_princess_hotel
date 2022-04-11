import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBookingPage extends StatefulWidget {
  final DocumentSnapshot document;
  const DetailBookingPage({Key? key, required this.document}) : super(key: key);

  @override
  State<DetailBookingPage> createState() => _DetailBookingPageState();
}

class _DetailBookingPageState extends State<DetailBookingPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final phoneNumber = widget.document["phoneNumber"];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Booking Detail'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[100],
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // cancelled reservation
              widget.document["bookingCancel"] == true
                  ? cancelReservation(widget.document)
                  : const SizedBox(height: 0),
              // guest details and contact them
              guestDetailContact(phoneNumber),
              SizedBox(height: size.height / 30),
              // booking details
              buildBookingDetail(widget.document),
              // note from the guest
              widget.document["note"] != "" ? guestNote() : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

// for booking cancel only
  Widget cancelReservation(DocumentSnapshot data) {
    DateTime bookingCancelDate = DateTime.parse(data["bookingCancelDate"]);
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

  Widget guestDetailContact(String phoneNumber) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.document["name"],
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
                onTap: () => guestDetailsWidget(widget.document),
                child:
                    buildContactAndGuestDetails("Guest details", Icons.person),
              ),
              SizedBox(width: size.width / 10),
              // conact
              InkWell(
                // disable if booking has been cancelled.
                onTap: widget.document["bookingCancel"] == false
                    ? () async {
                        try {
                          launch('tel://$phoneNumber');
                        } catch (err) {
                          showSnackBar(context, "Sorry, something went wrong.");
                        }
                      }
                    : null,
                child: buildContactAndGuestDetails("Contact", Icons.phone),
              ),
            ],
          )
        ],
      ),
    );
  }

  // the pop up from the bottom which contains guest info.
  Future guestDetailsWidget(DocumentSnapshot data) async {
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
                    data["name"],
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
                    data["email"],
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
                    data["phoneNumber"],
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
                data["person"].toString() + " person",
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
                data["numberOfRooms"].toString() + " room",
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

  Widget buildContactAndGuestDetails(String widgetName, IconData widgetIcon) {
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
                color: widget.document["bookingCancel"] == true &&
                        widgetName == "Contact"
                    ? Color.fromARGB(255, 212, 212, 212)
                    : Color.fromARGB(255, 207, 228, 242),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Icon(
                widgetIcon,
                color: widget.document["bookingCancel"] == true &&
                        widgetName == "Contact"
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
            color: widget.document["bookingCancel"] == true &&
                    widgetName == "Contact"
                ? const Color.fromARGB(255, 119, 118, 118)
                : const Color.fromARGB(255, 49, 89, 235),
          ),
        )
      ],
    );
  }

  Widget buildBookingDetail(DocumentSnapshot data) {
    var size = MediaQuery.of(context).size;

    // get the checkIn date
    Timestamp timestampCheckIn = data['checkIn'];
    DateTime dateTimeCheckIn = timestampCheckIn.toDate();
    String checkInDate = DateFormat.yMMMEd().format(dateTimeCheckIn);

    // get the checkOut date
    Timestamp timestampCheckOut = data['checkOut'];
    DateTime dateTimeCheckOut = timestampCheckOut.toDate();
    String checkOutDate = DateFormat.yMMMEd().format(dateTimeCheckOut);

    // number of nights
    int nights = dateTimeCheckOut.difference(dateTimeCheckIn).inDays;

    // numbers of rooms
    int numberOfRooms = data["numberOfRooms"];

    // number of people
    int numberOfPeople = data["person"];

    // total price
    double price = data["totalPrice"];

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
                      widget.document["roomType"],
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
  Widget guestNote() {
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
            "Note from " + widget.document["name"].toString().toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height / 80),
          Text(
            widget.document["note"],
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
