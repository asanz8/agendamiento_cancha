import 'package:flutter/material.dart';

import 'package:agendamiento_cancha/messages/CommonMsg.i18n.dart';

final commonMsg = CommonMsg();

class ClimaTag extends StatelessWidget {

  final double probLluvia;

  ClimaTag({ required this.probLluvia });

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = [];

    if(probLluvia.isNegative) {
      list.add(Text(commonMsg.prob_lluvia, style: TextStyle(color: Colors.blueGrey, fontSize: 12)));
      list.add(Icon(Icons.info_outline_rounded, color: Theme.of(context).errorColor, size: 12));
      list.add(Text(commonMsg.no_available, style: TextStyle(color: Theme.of(context).errorColor, fontSize: 12)));
    }
    else {
      list.addAll(_textClima(probLluvia));
    }

    return Row(
      children: list
    );
  }

  List<Widget> _textClima(double probLluvia) {
    final porcentajeLluvia = (probLluvia*100).ceil();
    final List<Widget> list = [];

    if(porcentajeLluvia == 0){
      list.add(Icon(Icons.wb_sunny, color: Colors.blueGrey));
      list.add(Text(commonMsg.dia_soleado, style: TextStyle(color: Colors.blueGrey, fontSize: 12)));
    }
    else if(porcentajeLluvia < 50){
      list.add(Icon(Icons.wb_cloudy, color: Colors.blueGrey));
      list.add(Text(commonMsg.dia_nublado, style: TextStyle(color: Colors.blueGrey, fontSize: 12)));
    }
    else {
      list.add(Icon(Icons.water, color: Colors.blueGrey));
      list.add(Text(commonMsg.dia_lluvioso, style: TextStyle(color: Colors.blueGrey, fontSize: 12)));
    }

    return list;
  }

}