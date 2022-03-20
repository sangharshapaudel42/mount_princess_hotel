import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/resources/booking_method.dart';
import 'package:mount_princess_hotel/utils/utils.dart';
import 'package:mount_princess_hotel/widgets/text_field_input.dart';

class BuildPopDialog extends StatefulWidget {
  const BuildPopDialog({Key? key}) : super(key: key);

  @override
  State<BuildPopDialog> createState() => _BuildPopDialogState();
}

class _BuildPopDialogState extends State<BuildPopDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _noRoomsController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _noRoomsController.dispose();
  }

  // Add booking Info into the firebase
  void addBookingInfo() {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // NOTE: now the remminging work is to access other widget values in this
    //  widget and pass it to BookingMethods.

    // just for now
    // remove this
    String res = "Sucess";

    // passing the datas to the booking_methos
    // String res = await BookingMethods().addBookingInfo(
    //   name: _nameController.text,
    //   email: _emailController.text,
    //   phoneNumber: _phoneNumberController.text,
    //   numberOfRooms: _noRoomsController.value,
    // );
    // if string returned is sucess, data has been sucessfully added to the firebase
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => const BookingPage()),
      // );
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

                // Phone Number
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
                    "Total Price",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                      fontSize: 25,
                    ),
                  ),
                  onPressed: null,
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
                  // onPressed: addBookingInfo,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
