import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mount_princess_hotel/models/user.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:mount_princess_hotel/widgets/dropdown.dart';

import 'package:mount_princess_hotel/widgets/navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/widgets/booking_pop_up.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  late Future bookingStatusInfos;

  final _bookingStatusQuery = FirebaseFirestore.instance
      .collection('BookingStatus')
      .doc("booking_status");

  List _allRooms = [];
  double roomPrice = 0.0;

  List<String> roomsValueTypes = ['Standard Room', 'Deluxe Room'];
  String roomsSelectedValueType = 'Standard Room';

  List<String> personsValueTypes = ['1', '2', '3', '4+'];
  String personsSelectedValueType = '1';

  int numberOfPerson = 1;

  String? standardRoomBookingStatus;
  String? deluxRoomBookingStatus;
  int? standardTotalRooms;
  int? deluxeTotalRooms;

  @override
  void initState() {
    super.initState();
    bookingStatusInfos = getBookingStatus();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  // get all the info of 'BookingStatus'
  getBookingStatus() async {
    try {
      var data = await _bookingStatusQuery.get();

      setState(() {
        // data["standardRoomBookedRooms"]
        // data["deluxeRoomBookedRooms"]

        // setting the values of following.
        standardRoomBookingStatus = data["standardRoomStatus"];
        deluxRoomBookingStatus = data["deluxeRoomStatus"];
        standardTotalRooms = data["standardRoomTotalRooms"];
        deluxeTotalRooms = data["deluxeRoomTotalRooms"];

        // if standard room is unbookable then remove standard room from the
        // drop-down list and change "roomsSelectedValueType" to Deluxe Room
        if (data["standardRoomStatus"] == "Un-Bookable") {
          roomsValueTypes = ['Deluxe Room'];
          roomsSelectedValueType = 'Deluxe Room';
        }

        // if deluxe room is unbookable then remove deluxe room from the
        // drop-down list
        if (data["deluxeRoomStatus"] == "Un-Bookable") {
          roomsValueTypes = ['Standard Room'];
        }
      });
    } catch (err) {
      print(err.toString());
    }
  }

  // get text from the date picker
  String getText(String status, String dateType, DateTime? date) {
    // here is date is either _checkInDate or _checkOutDate.
    if (date == null) {
      return status;
    } else {
      print(date);

      // return DateFormat('MM/dd/yyyy').format(date);
      // return DateFormat.yMMMd().format(date);
      return DateFormat.yMMMMEEEEd().format(date);
    }
  }

  // pick date
  Future pickDate(BuildContext context, String dateType) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateType == "check-in"
          ? _checkInDate ?? initialDate
          : _checkOutDate ?? _checkInDate!,

      // first date check-in is the today's date.
      // first date of check-out is the date of check-in or after that.
      firstDate: dateType == "check-in" ? initialDate : _checkInDate!,
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate == null) return;

    setState(() {
      // if check-in then assign the new date to _checkInDate
      if (dateType == "check-in") {
        _checkInDate = newDate;
      } else if (dateType == "check-out") {
        _checkOutDate = newDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // current user uid.
    final user = FirebaseAuth.instance.currentUser!;
    final userId = user.uid;

    var size = MediaQuery.of(context).size;

    return Scaffold(
      // if we want the navbar to be in the right side 'endDrawer'
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Booking'),
        centerTitle: true,
      ),
      body: standardRoomBookingStatus != "Bookable" &&
              deluxRoomBookingStatus != "Bookable" &&
              standardTotalRooms == 0 &&
              deluxeTotalRooms == 0
          // if all the rooms are packed or disabled.
          ? Center(
              child: Text(
                "No Rooms available.\n\nPlease Contact us for any queries.\n\n011-490616 / 011-490627 / 980-8258214 \n\nmntprincess@gmail.com",
                style: TextStyle(color: Colors.grey[600], fontSize: 20),
              ),
            )
          : Container(
              height: size.height,
              width: size.width,
              margin: EdgeInsets.only(
                  left: size.width / 40,
                  right: size.width / 40,
                  top: size.width / 20,
                  bottom: size.width / 40),
              padding: EdgeInsets.only(
                  left: size.width / 40, right: size.width / 40),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //////////////// Check In ////////////////
                    SizedBox(height: size.height / 38),
                    Padding(
                      padding: EdgeInsets.only(right: size.width / 1.55),
                      child: const Text(
                        "Check In",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: size.height / 68),
                    // widget for "Check In"

                    // check-in button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(size.height / 16),
                        primary: Colors.white,
                      ),
                      child: FittedBox(
                        child: Text(
                          getText("Select Date", "check-in", _checkInDate),
                          style:
                              TextStyle(fontSize: 22, color: Colors.grey[600]),
                        ),
                      ),
                      onPressed: () => pickDate(context, "check-in"),
                    ),

                    // DatePickerWidget(status: "Select Date", dateType: "check-in"),
                    //////////////// Check In ////////////////

                    //////////////// Check Out ////////////////
                    SizedBox(height: size.height / 38),
                    Padding(
                      padding: EdgeInsets.only(right: size.width / 1.7),
                      child: const Text(
                        "Check Out",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: size.height / 68),

                    // check-out button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(size.height / 16),
                        primary: Colors.white,
                      ),
                      child: FittedBox(
                        child: Text(
                          getText("Select Date", "check-out", _checkOutDate),
                          style:
                              TextStyle(fontSize: 22, color: Colors.grey[600]),
                        ),
                      ),
                      onPressed: () => pickDate(context, "check-out"),
                    ),

                    // widget for "Check Out"
                    // DatePickerWidget(status: "Select Date", dateType: "check-out"),
                    //////////////// Check Out ////////////////

                    //////////////// Room Type ////////////////
                    SizedBox(height: size.height / 38),

                    Padding(
                      padding: EdgeInsets.only(right: size.width / 1.8),
                      child: const Text(
                        "Room Type",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: size.height / 68),

                    // dropDown(context, const ['Standard Room', 'Deluxe Room'],
                    //     'Standard Room', "room-type"),

                    // rooms dropdown button
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 16,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: roomsSelectedValueType,
                            iconSize: 36,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                            isExpanded: true,
                            items: roomsValueTypes
                                .map((valueType) => DropdownMenuItem<String>(
                                      value: valueType,
                                      child: Center(
                                        child: Text(
                                          valueType,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (valueType) => setState(() {
                              roomsSelectedValueType = valueType!;
                            }),
                          ),
                        ),
                      ),
                    ),

                    // widget for "RoomType"
                    // DropDown(
                    //     valueTypes: const ['Single Room', 'Standard Room'],
                    //     selectedValueType: 'Single Room',
                    //     dropDownType: "room-type"),
                    //////////////// Room Type ////////////////

                    //////////////// Persons ////////////////
                    SizedBox(height: size.height / 38),

                    Padding(
                      padding: EdgeInsets.only(right: size.width / 1.5),
                      child: const Text(
                        "Person",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: size.height / 68),

                    // drop down menu for persons
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 16,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: personsSelectedValueType,
                            iconSize: 36,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                            isExpanded: true,
                            items: personsValueTypes
                                .map((valueType) => DropdownMenuItem<String>(
                                      value: valueType,
                                      child: Center(
                                        child: Text(
                                          valueType,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (valueType) => setState(() {
                              personsSelectedValueType = valueType!;
                            }),
                          ),
                        ),
                      ),
                    ),

                    // dropDown(context, const ['1', '2', '3', '4+'], '1', "persons"),
                    //////////////// Persons ////////////////

                    //////////////// Reserve ////////////////
                    SizedBox(height: size.height / 24),

                    MaterialButton(
                      // height: 50,
                      height: size.height / 15,
                      minWidth: MediaQuery.of(context).size.width / 2,
                      color: const Color(0xff024DB8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Text(
                        "Reserve",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      onPressed: () async {
                        try {
                          if (_checkInDate != null && _checkOutDate != null) {
                            // access current user documents
                            // passing user's name, email and phone number.
                            DocumentSnapshot doc = await FirebaseFirestore
                                .instance
                                .collection('Users')
                                .doc(userId)
                                .get();

                            // get all rooms
                            var data = await FirebaseFirestore.instance
                                .collection("Rooms")
                                .get();

                            // access it's documents
                            _allRooms = data.docs;

                            // compare the user defined room with all rooms and get
                            // it's price
                            if (_allRooms.isNotEmpty) {
                              for (var roomsSnapshot in _allRooms) {
                                // converting the room name to lowercase
                                String snapshotRoomName = roomsSnapshot["Name"];
                                snapshotRoomName =
                                    snapshotRoomName.toLowerCase();

                                if (roomsSelectedValueType.toLowerCase() ==
                                    snapshotRoomName) {
                                  roomPrice = double.parse(
                                      roomsSnapshot["Price"].toString());
                                  break;
                                } else {
                                  roomPrice = 25.0;
                                }
                              }
                            }

                            // if "personsSelectedValueType" is not empty
                            if (personsSelectedValueType.isNotEmpty) {
                              if (personsSelectedValueType == "4+") {
                                numberOfPerson = 4;
                              } else {
                                numberOfPerson =
                                    int.parse(personsSelectedValueType);
                              }
                              // if empty then numberOfPerson = 1
                            } else {
                              numberOfPerson = 1;
                            }

                            showDialog(
                              context: context,
                              builder: (BuildContext context) => BuildPopDialog(
                                checkInDate: _checkInDate!,
                                checkOutDate: _checkOutDate!,
                                roomType: roomsSelectedValueType,
                                noOfPerson: numberOfPerson,
                                roomPrice: roomPrice,
                                name: doc["name"],
                                email: doc["email"],
                                phoneNumber: doc["phoneNumber"],
                              ),
                            );
                          } else {
                            showSnackBar(context, "Fill all the fields.");
                          }
                        } catch (err) {
                          print(err.toString());
                        }
                      },
                    ),
                    SizedBox(height: size.height / 68),
                  ],
                ),
              ),
            ),
    );
  }
}
