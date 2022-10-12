import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/resources/booking_method.dart';
import 'package:mount_princess_hotel/resources/send_email.dart';
import 'package:mount_princess_hotel/screens/customer/booking_screen.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:mount_princess_hotel/widgets/text_field_input.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class BuildPopDialog extends StatefulWidget {
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String roomType;
  final int noOfPerson;
  final double roomPrice;
  final String name;
  final String email;
  final String phoneNumber;

  const BuildPopDialog({
    Key? key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.roomType,
    required this.noOfPerson,
    required this.roomPrice,
    required this.name,
    required this.email,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<BuildPopDialog> createState() => _BuildPopDialogState();
}

class _BuildPopDialogState extends State<BuildPopDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _noRoomsController = TextEditingController();
  bool _isLoading = false;
  double roomTotalPrice = 0.0;
  bool showSnackBarPopUp = false;
  bool standardRoomShowSnackBar = false;
  bool deluxeRoomShowSnackBar = false;
  int standardRooms = 1;
  int deluxeRooms = 1;

  late TwilioFlutter twilioFlutter;

  // query of booking status
  final _bookingStatusQuery = FirebaseFirestore.instance
      .collection('BookingStatus')
      .doc("booking_status");

  @override
  void initState() {
    twilioFlutter = TwilioFlutter(
      accountSid: "ACd93747d0d38729e77ebbf0538c6c0a06",
      authToken: "ed86ae256314451f8d9bcc9d8a5cc44f",
      twilioNumber: "+19793169548",
    );
    super.initState();
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _phoneNumberController.text = widget.phoneNumber.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _noRoomsController.dispose();
  }

  // calculate total price
  double calculateTotalPrice() {
    double totalPrice = 0.0;
    int noOfDays;

    // difference between checkInDate and checkOutDate
    noOfDays = widget.checkOutDate.difference(widget.checkInDate).inDays;

    // if noOfRooms text field is choose then only the actual totalPrice is shown.
    // till the text field is empty the totalPrice will be 0.0.
    if (_noRoomsController.text.isNotEmpty) {
      if (widget.roomType == "Standard Room") {
        // totalPrice = (Standard_Room_price - 5) + ($5 * widget.noOfPerson)
        totalPrice =
            (widget.roomPrice - 5) + (5 * widget.noOfPerson.toDouble());
      } else if (widget.roomType == "Deluxe Room") {
        totalPrice =
            (widget.roomPrice - 5) + (5 * widget.noOfPerson.toDouble());
      }
      // totalPrice (roomType and noOfPerson) * noOfRooms
      totalPrice =
          (noOfDays + 1) * totalPrice * int.parse(_noRoomsController.text);
    }
    return totalPrice;
  }

  // Add booking Info into the firebase
  void addBookingInfo() async {
    String res = "";
    String updateStatus = "";
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // first convert the dateTime to string
    String checkInDateToString =
        DateFormat('MM-dd-yyyy').format(widget.checkInDate);
    String checkOutDateToString =
        DateFormat('MM-dd-yyyy').format(widget.checkOutDate);

    String bookingDateToString =
        DateFormat('MM-dd-yyyy').format(DateTime.now());

    String checkInDate = DateFormat.yMMMEd().format(widget.checkInDate);

    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _noRoomsController.text.isNotEmpty) {
      // change the totalRoom and booked in 'BookingStatus'
      // get snapshots
      var data = await _bookingStatusQuery.get();

      // get room's total and booked rooms
      int standardRoomTotalRooms = data["standardRoomTotalRooms"];
      int deluxeRoomTotalRooms = data["deluxeRoomTotalRooms"];
      int standardRoomBookedRooms = data["standardRoomBookedRooms"];
      int deluxeRoomBookedRooms = data["deluxeRoomBookedRooms"];

      // change the number of total rooms of stadard and deluxe rooms according
      // to database.
      setState(() {
        standardRooms = standardRoomTotalRooms;
        deluxeRooms = deluxeRoomTotalRooms;
      });

      /* booking paxi: 
        - number_of_total_rooms chai gatxa. (total_rooms - now_booked_room) 
        - booked_room chai badxa. (previous_booked_room + now_booked_room) */

      // for standard room
      // "standardRoomBookedRooms" will be the previous booked room + this booked room
      // "standardRoomTotalRooms" will be the previous defined total room - this booked room
      if (widget.roomType.toLowerCase() == "standard room") {
        // if avaiable rooms are same or greater in number then required_rooms(now_booked_room)
        if (standardRoomTotalRooms >= int.parse(_noRoomsController.text)) {
          try {
            await _bookingStatusQuery.update({
              "standardRoomTotalRooms":
                  standardRoomTotalRooms - int.parse(_noRoomsController.text),
              "standardRoomBookedRooms":
                  standardRoomBookedRooms + int.parse(_noRoomsController.text),
            });
            updateStatus = "done";
          } catch (e) {
            print(e.toString());
          }

          // if less then show the snackBar saying there is only few rooms left.
        } else {
          // initilly it will be true
          setState(() {
            standardRoomShowSnackBar = true;
          });
          // after 3 seconds it will be false
          Timer(const Duration(seconds: 3), () {
            setState(() {
              standardRoomShowSnackBar = false;
            });
          });
        }

        // for deluxe room
      } else if (widget.roomType.toLowerCase() == "deluxe room") {
        if (deluxeRoomTotalRooms >= int.parse(_noRoomsController.text)) {
          try {
            await _bookingStatusQuery.update({
              "deluxeRoomTotalRooms":
                  deluxeRoomTotalRooms - int.parse(_noRoomsController.text),
              "deluxeRoomBookedRooms":
                  deluxeRoomBookedRooms + int.parse(_noRoomsController.text),
            });
            updateStatus = "done";
          } catch (err) {
            print(err.toString());
          }
        } else {
          // initilly it will be true
          setState(() {
            deluxeRoomShowSnackBar = true;
          });
          // after 3 seconds it will be false
          Timer(const Duration(seconds: 3), () {
            setState(() {
              deluxeRoomShowSnackBar = false;
            });
          });
        }
      }

      // current user uid
      final user = FirebaseAuth.instance.currentUser!;
      final userID = user.uid;

      // upload the booking info only after checking above conditions
      if (updateStatus == "done") {
        // passing the datas to the booking_methods
        res = await BookingMethods().addBookingInfo(
          checkIn: widget.checkInDate,
          checkOut: widget.checkOutDate,
          bookingDate: DateTime.now(),
          bookingDateString: bookingDateToString,
          roomType: widget.roomType,
          person: widget.noOfPerson,
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phoneNumberController.text,
          numberOfRooms: int.parse(_noRoomsController.text),
          totalPrice: calculateTotalPrice(),
          bookingCancel: false,
          uid: userID,
          checkInString: checkInDateToString,
          checkOutString: checkOutDateToString,
          bookingCancelDate: "",
          note: "",
        );
      }

      // send sms after the booking info has been saved to the database.
      if (res == "success") {
        twilioFlutter.sendSMS(
          // hotel owner phone number.
          toNumber: "+9779861963866",
          messageBody:
              "NEW BOOKING \n${_noRoomsController.text}x ${widget.roomType}. Arrival on " +
                  DateFormat.yMMMEd().format(widget.checkInDate) +
                  " by ${_nameController.text.toUpperCase()} \n+977-${widget.phoneNumber}",
        );

        sendEmail(
          context: context,
          name: "",
          phoneNumber: "",
          email: "",
          subject:
              "New Booking for $checkInDate for ${_noRoomsController.text} nights",
          message:
              "Booked by: ${_nameController.text.toUpperCase()} \nNumber Of Rooms: ${_noRoomsController.text}x \nRoom Type: ${widget.roomType}. Arrival on " +
                  DateFormat.yMMMEd().format(widget.checkInDate) +
                  " Phone number: +977-${widget.phoneNumber}",
        );
      }

      // else {
      //   res = "unsuccessful";
      // }
    } else {
      res = "unsuccess";
      showSnackBar(context, "Fill all the fields.");
    }

    // if string returned is success, data has been sucessfully added to the firebase
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });

      // navigate to the home screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const BookingPage(),
      ));

      // successfull message.
      showSnackBar(context, "Booking has been successfull.");
    }
    // else if (res == "unsuccessful") {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   // show the error
    //   showSnackBar(context, "Something went wrong.");
    // }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

      // to get choose room price for calculating totalPrice
      content: Container(
        // height: MediaQuery.of(context).size.height / 1.5,
        width: size.width,
        padding: EdgeInsets.only(top: size.height / 35),
        decoration: BoxDecoration(
          color: const Color(0xFF000000).withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // const Align(
                //   alignment: Alignment.topRight,
                //   child: Icon(
                //     Icons.close,
                //     color: Colors.red,
                //   ),
                // ),

                // Name
                TextFieldInput(
                  textEditingController: _nameController,
                  hintText: "Enter your name",
                  textInputType: TextInputType.name,
                  icon: Icons.person,
                  color: Colors.white,
                ),
                SizedBox(height: size.height / 38),

                // Email
                TextFieldInput(
                  hintText: "Email",
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  icon: Icons.email,
                  color: Colors.white,
                ),
                SizedBox(height: size.height / 38),

                // Phone Number
                TextFieldInput(
                  hintText: "Phone number",
                  textInputType: TextInputType.phone,
                  textEditingController: _phoneNumberController,
                  icon: Icons.phone,
                  color: Colors.white,
                ),
                SizedBox(height: size.height / 38),

                // Number of Rooms
                TextFieldInput(
                  hintText: "Number of Rooms",
                  textInputType: TextInputType.number,
                  textEditingController: _noRoomsController,
                  icon: Icons.format_list_numbered,
                  color: Colors.white,
                ),
                widget.noOfPerson == 4
                    // if number of person is 4.
                    ? _noRoomsController.text == "1"
                        // if number of rooms is 1.
                        ? const Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              "**Only 3 people allowed in 1 Room.**",
                              style: TextStyle(
                                color: Color.fromARGB(255, 234, 29, 15),
                              ),
                            ),
                          )
                        : const Text("")
                    // if number of persons is not 4.
                    : const Text(""),
                // const SizedBox(height: 20),

                // Total Price
                MaterialButton(
                  height: MediaQuery.of(context).size.width / 8.5,
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  disabledColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    "Total Price: \$ ${calculateTotalPrice().toString()}",
                    // "Total Price: \$ ${roomTotalPrice.toString()}",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 22,
                    ),
                  ),
                  onPressed: null,
                  // onPressed: () {
                  //   setState(() {
                  //     roomTotalPrice = calculateTotalPrice(widget.roomPrice);
                  //   });
                  // },
                ),
                SizedBox(height: size.height / 38),

                // Submit
                MaterialButton(
                    height: MediaQuery.of(context).size.width / 8.5,
                    minWidth: MediaQuery.of(context).size.width / 2,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    onPressed: () {
                      // if number of people is 4 and number of rooms is 1 then dont book.
                      if (widget.noOfPerson == 4 &&
                          _noRoomsController.text == "1") {
                        // initilly it will be true
                        setState(() {
                          showSnackBarPopUp = true;
                        });
                        // after 3 seconds it will be false
                        Timer(const Duration(seconds: 3), () {
                          setState(() {
                            showSnackBarPopUp = false;
                          });
                        });
                      } else {
                        addBookingInfo();
                      }
                    }
                    // onPressed: () {},
                    ),
                SizedBox(height: size.height / 38),

                // show this container only if "showSnackBarPopUp" or
                //"deluxeRoomShowSnackBar" or "standardRoomShowSnackBar" is true.
                // hides if false
                if (showSnackBarPopUp ||
                    standardRoomShowSnackBar ||
                    deluxeRoomShowSnackBar)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 57, 55, 55),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      // if 4+ and number of rooms is 1.
                      showSnackBarPopUp == true
                          ? "Only 3 people allowed in 1 room.\nChoose 2 rooms."
                          // if standard rooms not enough.
                          : standardRoomShowSnackBar == true
                              ? "Only $standardRooms Standard rooms left."
                              // if deluxe rooms not enough.
                              : "Only $deluxeRooms Deluxe rooms left.",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
