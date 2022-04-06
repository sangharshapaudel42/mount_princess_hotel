import 'package:flutter/material.dart';
import 'package:mount_princess_hotel/utils/colors.dart';

class ThemeButton extends StatelessWidget {
  String? label;
  Function onClick;
  Color color;
  Color? highlight;
  Color borderColor;
  Color labelColor;
  double borderWidth;

  ThemeButton(
      {this.label,
      this.labelColor = Colors.white,
      this.color = backgroundColor,
      this.highlight = Colors.white,
      this.borderColor = Colors.transparent,
      this.borderWidth = 4,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Material(
          color: this.color,
          child: InkWell(
            splashColor: this.highlight,
            highlightColor: this.highlight,
            onTap: () {
              this.onClick();
            },
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                      color: this.borderColor, width: this.borderWidth),
                ),
                child: Text(
                  this.label!,
                  style: TextStyle(
                      fontSize: 25,
                      color: this.labelColor,
                      fontWeight: FontWeight.bold),
                )),
          ),
        ),
      ),
    );
  }
}
