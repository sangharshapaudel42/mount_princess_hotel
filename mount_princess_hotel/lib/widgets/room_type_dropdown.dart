import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final List<String> roomTypes;
  String? selectedRoomType;
  DropDown({Key? key, required this.roomTypes, required this.selectedRoomType})
      : super(key: key);

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  // List<String> roomTypes = ['Single Room', 'Standard Room'];
  // String? selectedRoomType = 'Single Room';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: widget.selectedRoomType,
            iconSize: 36,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            isExpanded: true,
            items: widget.roomTypes
                .map((roomType) => DropdownMenuItem<String>(
                      value: roomType,
                      child: Center(
                        child: Text(
                          roomType,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600]),
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (roomType) => setState(() {
              widget.selectedRoomType = roomType;
            }),
          ),
        ),
      ),
    );
  }
}
