import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:mount_princess_hotel/models/booking_data_from_widget.dart'
    as model;

class DropDown extends StatefulWidget {
  final List<String> valueTypes;
  String? selectedValueType;
  String? dropDownType;
  DropDown(
      {Key? key,
      required this.valueTypes,
      required this.selectedValueType,
      required this.dropDownType})
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
            value: widget.selectedValueType,
            iconSize: 36,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            isExpanded: true,
            items: widget.valueTypes
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
              widget.selectedValueType = valueType;
              if (widget.dropDownType == "room-type") {
                model.DataBookingWidget(roomType: valueType);
              } else if (widget.dropDownType == "adults") {
                model.DataBookingWidget(adults: int.parse(valueType!));
              } else if (widget.dropDownType == "childrens") {
                model.DataBookingWidget(childrens: int.parse(valueType!));
              }
            }),
          ),
        ),
      ),
    );
  }
}
