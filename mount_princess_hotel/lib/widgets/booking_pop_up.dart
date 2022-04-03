import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/resources/booking_method.dart';
import 'package:mount_princess_hotel/screens/customer/booking_screen.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:mount_princess_hotel/widgets/text_field_input.dart';

class BuildPopDialog extends StatefulWidget {
  final DateTime checInDate;
  final DateTime checOutDate;
  final String roomType;
  final int noOfPerson;
  final double roomPrice;
  final String name;
  final String email;
  final String phoneNumber;

  const BuildPopDialog({
    Key? key,
    required this.checInDate,
    required this.checOutDate,
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

  @override
  void initState() {
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

    // difference between checkInDate and checkOutDate
    // difference = widget.checOutDate.difference(widget.checInDate).inDays

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
      totalPrice = totalPrice * int.parse(_noRoomsController.text);
    }
    return totalPrice;
  }

  // Add booking Info into the firebase
  void addBookingInfo() async {
    String res = "fuck you";
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // first convert the dateTime to string
    String checkInDateToString =
        DateFormat('MM-dd-yyyy').format(widget.checInDate);
    String checkOutDateToString =
        DateFormat('MM-dd-yyyy').format(widget.checOutDate);

    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _noRoomsController.text.isNotEmpty) {
      // passing the datas to the booking_methos
      // res = await BookingMethods().addBookingInfo(
      //   checkIn: checkInDateToString,
      //   checkOut: checkOutDateToString,
      //   roomType: widget.roomType,
      //   person: widget.noOfPerson,
      //   name: _nameController.text,
      //   email: _emailController.text,
      //   phoneNumber: _phoneNumberController.text,
      //   numberOfRooms: int.parse(_noRoomsController.text),
      //   totalPrice: calculateTotalPrice(),
      // );
    } else {
      res = "unsuccess";
      showSnackBar(context, "Fill all the fields.");
    }
    // if string returned is sucess, data has been sucessfully added to the firebase
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pop();
      showSnackBar(context, "Booking has been sucessfull.");
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

      // to get choose room price for calculating totalPrice
      content: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 25),
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
                const SizedBox(height: 20),

                // Email
                TextFieldInput(
                  hintText: "Email",
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  icon: Icons.email,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),

                // Phone Number
                TextFieldInput(
                  hintText: "Phone number",
                  textInputType: TextInputType.phone,
                  textEditingController: _phoneNumberController,
                  icon: Icons.phone,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),

                // Number of Rooms
                TextFieldInput(
                  hintText: "Number of Rooms",
                  textInputType: TextInputType.number,
                  textEditingController: _noRoomsController,
                  icon: Icons.format_list_numbered,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),

                // Total Price
                MaterialButton(
                  height: 50,
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
                      fontSize: 25,
                    ),
                  ),
                  onPressed: null,
                  // onPressed: () {
                  //   setState(() {
                  //     roomTotalPrice = calculateTotalPrice(widget.roomPrice);
                  //   });
                  // },
                ),
                const SizedBox(height: 20),

                // Submit
                MaterialButton(
                  height: 50,
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
                      fontSize: 25,
                    ),
                  ),
                  onPressed: () => addBookingInfo(),
                  // onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
