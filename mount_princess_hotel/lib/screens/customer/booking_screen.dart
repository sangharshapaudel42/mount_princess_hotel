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
  String _roomTypeDropDown = "Standard Room";
  String _personsDropDown = "1";

  List _allRooms = [];
  double roomPrice = 0.0;

  final List<String> roomsValueTypes = ['Standard Room', 'Deluxe Room'];
  String? roomsSelectedValueType = 'Standard Room';

  final List<String> personsValueTypes = ['1', '2', '3', '4+'];
  String? personsSelectedValueType = '1';

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  // get text from the date picker
  String getText(String status, String dateType, DateTime? date) {
    // here is date is either _checkInDate or _checkOutDate.
    if (date == null) {
      return status;
    } else {
      print(date);

      return DateFormat('MM/dd/yyyy').format(date);
    }
  }

  // pick date
  Future pickDate(BuildContext context, String dateType) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateType == "check-in"
          ? _checkInDate ?? initialDate
          : _checkOutDate ?? initialDate,
      // firstDate: DateTime(DateTime.now().year),
      firstDate: initialDate,
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

  // widget for drop down menu
  // Widget dropDown(
  //   BuildContext context,
  //   final List<String> valueTypes,
  //   String? selectedValueType,
  //   String? dropDownType,
  // ) {
  //   return Center(
  //     child: Container(
  //       height: MediaQuery.of(context).size.height / 14,
  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(5),
  //         color: Colors.white,
  //       ),
  //       child: DropdownButtonHideUnderline(
  //         child: DropdownButton<String>(
  //           value: selectedValueType,
  //           iconSize: 36,
  //           icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
  //           isExpanded: true,
  //           items: valueTypes
  //               .map((valueType) => DropdownMenuItem<String>(
  //                     value: valueType,
  //                     child: Center(
  //                       child: Text(
  //                         valueType,
  //                         style: TextStyle(
  //                             fontSize: 25,
  //                             fontWeight: FontWeight.w600,
  //                             color: Colors.grey[600]),
  //                       ),
  //                     ),
  //                   ))
  //               .toList(),
  //           onChanged: (valueType) => setState(() {
  //             selectedValueType = valueType;
  //             if (dropDownType == "room-type") {
  //               _roomTypeDropDown = valueType!;
  //             } else if (dropDownType == "persons") {
  //               _personsDropDown = valueType!;
  //             }
  //           }),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
      body: Container(
        height: size.height,
        width: size.width,
        margin: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //////////////// Check In ////////////////
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(right: size.width / 1.55),
                child: const Text(
                  "Check In",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              // widget for "Check In"

              // check-in button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(size.height / 14),
                  primary: Colors.white,
                ),
                child: FittedBox(
                  child: Text(
                    getText("Select Date", "check-in", _checkInDate),
                    style: TextStyle(fontSize: 25, color: Colors.grey[600]),
                  ),
                ),
                onPressed: () => pickDate(context, "check-in"),
              ),

              // DatePickerWidget(status: "Select Date", dateType: "check-in"),
              //////////////// Check In ////////////////

              //////////////// Check Out ////////////////
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(right: size.width / 1.7),
                child: const Text(
                  "Check Out",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              // check-out button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(size.height / 14),
                  primary: Colors.white,
                ),
                child: FittedBox(
                  child: Text(
                    getText("Select Date", "check-out", _checkOutDate),
                    style: TextStyle(fontSize: 25, color: Colors.grey[600]),
                  ),
                ),
                onPressed: () => pickDate(context, "check-out"),
              ),

              // widget for "Check Out"
              // DatePickerWidget(status: "Select Date", dateType: "check-out"),
              //////////////// Check Out ////////////////

              //////////////// Room Type ////////////////
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(right: size.width / 1.8),
                child: const Text(
                  "Room Type",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              // dropDown(context, const ['Standard Room', 'Deluxe Room'],
              //     'Standard Room', "room-type"),

              // rooms dropdown button
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 14,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600]),
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (valueType) => setState(() {
                        roomsSelectedValueType = valueType;
                        _roomTypeDropDown = valueType!;
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
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(right: size.width / 1.5),
                child: const Text(
                  "Person",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              // drop down menu for persons
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 14,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[600]),
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (valueType) => setState(() {
                        personsSelectedValueType = valueType;
                        if (valueType == "4+") {
                          _personsDropDown = "4";
                        } else {
                          _personsDropDown = valueType!;
                        }
                      }),
                    ),
                  ),
                ),
              ),

              // dropDown(context, const ['1', '2', '3', '4+'], '1', "persons"),
              //////////////// Persons ////////////////

              //////////////// Reserve ////////////////
              const SizedBox(height: 30),

              MaterialButton(
                // height: 50,
                height: size.height / 13,
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
                    fontSize: 25,
                  ),
                ),
                onPressed: () async {
                  try {
                    if (_checkInDate != null && _checkOutDate != null) {
                      // access current user documents
                      // passing user's name, email and phone number.
                      DocumentSnapshot doc = await FirebaseFirestore.instance
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
                          if (_roomTypeDropDown == roomsSnapshot["Name"]) {
                            roomPrice =
                                double.parse(roomsSnapshot["Price"].toString());
                          } else {
                            roomPrice = 25.0;
                          }
                        }
                      }

                      showDialog(
                        context: context,
                        builder: (BuildContext context) => BuildPopDialog(
                          checInDate: _checkInDate!,
                          checOutDate: _checkOutDate!,
                          roomType: _roomTypeDropDown,
                          noOfPerson: int.parse(_personsDropDown),
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
