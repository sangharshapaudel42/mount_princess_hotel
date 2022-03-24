import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mount_princess_hotel/widgets/navigation_drawer_widget.dart';
import 'package:mount_princess_hotel/widgets/booking_pop_up.dart';
import 'package:mount_princess_hotel/utils/colors.dart';
import 'package:mount_princess_hotel/widgets/date_picker_widget.dart';
import 'package:mount_princess_hotel/widgets/dropdown.dart';

import 'package:mount_princess_hotel/models/booking_data_from_widget.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // if we want the navbar to be in the right side 'endDrawer'
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('Booking'),
          centerTitle: true,
          // title: SvgPicture.asset(
          //   "assets/images/logo.svg",
          //   width: MediaQuery.of(context).size.width * 0.75,
          // ),
          // toolbarHeight: MediaQuery.of(context).size.height * 0.20,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin:
              const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
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
                const Padding(
                  padding: EdgeInsets.only(right: 270),
                  child: Text(
                    "Check In",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                // widget for "Check In"

                const DatePickerWidget(
                    status: "Select Date", dateType: "check-in"),
                //////////////// Check In ////////////////

                //////////////// Check Out ////////////////
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(right: 250),
                  child: Text(
                    "Check Out",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                // widget for "Check Out"
                const DatePickerWidget(
                    status: "Select Date", dateType: "check-out"),
                //////////////// Check Out ////////////////

                //////////////// Room Type ////////////////
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(right: 236),
                  child: Text(
                    "Room Type",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                // widget for "RoomType"
                DropDown(
                    valueTypes: const ['Single Room', 'Standard Room'],
                    selectedValueType: 'Single Room',
                    dropDownType: "room-type"),
                //////////////// Room Type ////////////////

                //////////////// Adults ////////////////
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(right: 280),
                  child: Text(
                    "Adults",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                // widget for "Adults"
                DropDown(
                    valueTypes: const ['1', '2', '3', '4+'],
                    selectedValueType: '1',
                    dropDownType: "adults"),
                //////////////// Adults ////////////////

                //////////////// Childrens ////////////////
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(right: 250),
                  child: Text(
                    "Childrens",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                // widget for "Childrens"
                DropDown(
                    valueTypes: const ['0', '1', '2', '3+'],
                    selectedValueType: '0',
                    dropDownType: "childrens"),
                //////////////// CHildrens ////////////////

                //////////////// Reserve ////////////////
                const SizedBox(height: 20),

                MaterialButton(
                  height: 50,
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
                  onPressed: () {
                    // model.DataBookingWidget _data =
                    //     const model.DataBookingWidget();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => BuildPopDialog());
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
}
