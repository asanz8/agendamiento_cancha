import 'package:flutter/material.dart';

import 'package:agendamiento_cancha/messages/HomePageMsg.i18n.dart';

final homePageMsg = HomePageMsg();

class EmptyListViewAgenda extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(38, 153, 251, 0.25),
      margin: EdgeInsets.all(24.0),
      padding: EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Icon(Icons.info_outline_rounded, size: 160.0, color: Color.fromRGBO(38, 153, 251, 1),)
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(homePageMsg.empty_list_title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(38, 153, 251, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(homePageMsg.empty_list_subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(38, 153, 251, 1),
                      ),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      )
    );
  }

}