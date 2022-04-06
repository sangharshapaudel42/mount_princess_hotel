import 'package:flutter/material.dart';

class PackagesResource extends StatelessWidget {
  final String packageName;
  final String packageDescription;
  final dynamic price;
  const PackagesResource(
      {Key? key,
      required this.packageName,
      required this.packageDescription,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 4,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 15),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(20),
        // boxShadow: const [
        //   BoxShadow(
        //     blurStyle: BlurStyle.normal,
        //     blurRadius: 25,
        //     spreadRadius: 6,
        //     color: Color.fromRGBO(1, 1, 1, .07),
        //   )
        // ],
      ),
      child: Column(
        children: [
          Text(
            packageName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          packageDescription == ""
              ? const SizedBox(
                  height: 0,
                )
              : Text(
                  packageDescription,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Price: \$' + '$price',
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
