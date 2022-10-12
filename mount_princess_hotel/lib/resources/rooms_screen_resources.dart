import 'package:flutter/material.dart';

import 'package:mount_princess_hotel/screens/customer/rooms_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/colors.dart';

class RoomsScreenResources extends StatefulWidget {
  final String? name;
  final String? imgName;
  final String? price;
  final String? roomReferenceId;
  const RoomsScreenResources({
    Key? key,
    required this.name,
    required this.imgName,
    required this.price,
    required this.roomReferenceId,
  }) : super(key: key);

  @override
  State<RoomsScreenResources> createState() => _RoomsScreenResourcesState();
}

class _RoomsScreenResourcesState extends State<RoomsScreenResources> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomDetailPage(
              name: widget.name!,
              roomReferenceId: widget.roomReferenceId!,
            ),
          ),
        );
      },

      // previous design
      child: Container(
        margin: EdgeInsets.only(
          right: size.height / 35,
          left: size.height / 35,
          bottom: size.height / 33,
        ),
        width: size.width,
        height: size.height / 3.5,
        decoration: BoxDecoration(
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
                  opacity: 0.85,
                  child: CachedNetworkImage(
                    imageUrl: widget.imgName.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height / 15,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  gradient: LinearGradient(
                    end: const Alignment(0.0, 0.5),
                    begin: const Alignment(0.0, 0.10),
                    colors: <Color>[
                      const Color(0x8A000000),
                      Colors.black12.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(size.height / 70),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          widget.name!,
                          style: const TextStyle(
                            fontSize: 23,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Price: \$' + widget.price!.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
