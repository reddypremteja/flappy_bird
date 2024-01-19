import 'package:flutter/material.dart';

class BirdGif extends StatelessWidget {
  const BirdGif({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        width: 100,
        child: Image.asset(
          "assets/images/brid_wbg.gif",
          fit: BoxFit.fill,
        ));
  }
}
