import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/screens/customer/rooms_detail.dart';

class RoomsScreenResources extends StatelessWidget {
  final String name;
  final String imgName;
  const RoomsScreenResources({
    Key? key,
    required this.name,
    required this.imgName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomDetailPage(),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 15,
                  spreadRadius: 5,
                  color: Color.fromRGBO(0, 0, 0, .05))
            ],
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      imgName,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    gradient: LinearGradient(
                      end: const Alignment(0.0, 0.1),
                      begin: const Alignment(0.0, 0.15),
                      colors: <Color>[
                        const Color(0x8A000000),
                        Colors.black12.withOpacity(0.15),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
