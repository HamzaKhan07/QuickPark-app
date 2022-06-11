import 'package:flutter/material.dart';
import 'package:quick_park/constants/constants.dart';

class ParkBlock extends StatelessWidget {
  final Color colorBack;
  final Color colorFore;
  final String number;

  const ParkBlock(
      {Key? key,
      required this.colorBack,
      required this.colorFore,
      required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Center(
          child: Text(
            number,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: colorFore),
          ),
        ),
        decoration: BoxDecoration(
          color: colorBack,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      ),
    );
  }
}
