import 'package:flutter/material.dart';

class BotonCancha extends StatelessWidget {
  final String cancha;
  final Function onPress;
  final String canchaSelected;

  BotonCancha({ required this.cancha, required this.onPress, required this.canchaSelected});

  @override
  Widget build(BuildContext context) {
    final selected = cancha == canchaSelected;

    return TextButton(
        onPressed: () => onPress(cancha),
        child: Text(cancha),
        style: TextButton.styleFrom(
          padding: EdgeInsets.only(left: 40, right: 40, top: 18, bottom: 18),
          primary: selected ? Colors.white : Theme.of(context).accentColor,
          backgroundColor: selected ? Theme.of(context).accentColor : Colors.transparent,
          side: BorderSide(color: Theme.of(context).accentColor, width: 2)
        ),
    );
  }

}