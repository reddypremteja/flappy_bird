import 'package:flutter/material.dart';

class MyBrarrier extends StatelessWidget {
  final size;
  const MyBrarrier({this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.green[400],
          border: Border.all(
            width: 3,
            color: Color.fromARGB(255, 8, 78, 10),
          )),
    );
  }
}
