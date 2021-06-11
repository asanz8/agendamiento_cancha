import 'package:flutter/material.dart';

import 'package:agendamiento_cancha/messages/CommonMsg.i18n.dart';

final commonMsg = CommonMsg();

class PronosticoTag extends StatelessWidget {

  final double probLluvia;

  PronosticoTag({ required this.probLluvia });

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = [];

    if(probLluvia < -1.0) {
      return SizedBox();
    }
    else if(probLluvia.isNegative) {
      list.add(Icon(Icons.info_outline_rounded, color: Theme.of(context).errorColor));
      list.add(Text(commonMsg.no_available, style: TextStyle(color: Theme.of(context).errorColor)));
    }
    else {
      list.add(Text('${(probLluvia*100).ceil()}%', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Theme.of(context).accentColor)));
    }

    return Padding(
      padding: EdgeInsets.only(right: 20, left: 20, top: 10),
      child: Card(
        elevation: 6.0,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(Icons.wb_cloudy, color: Theme.of(context).accentColor),
                  SizedBox(width: 5),
                  Text(commonMsg.prob_lluvia, style: TextStyle(color: Theme.of(context).accentColor))
                ],
              ),
              Row(
                children: list,
              )
            ],
          ),
        )
      ),
    );

  }

}