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
        margin: const EdgeInsets.only(right: 15, left: 15, bottom: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3,
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
                height: MediaQuery.of(context).size.height / 13,
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
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          widget.name!,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Price: \$' + widget.price!.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
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
