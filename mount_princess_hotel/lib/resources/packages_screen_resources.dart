import 'package:flutter/material.dart';

class PackagesResource extends StatelessWidget {
  final String packageName;
  final String price;
  const PackagesResource(
      {Key? key, required this.packageName, required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 4,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            blurStyle: BlurStyle.normal,
            blurRadius: 18,
            spreadRadius: 6,
            color: Color.fromRGBO(1, 1, 1, .05),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            packageName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Price \$' + price,
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
