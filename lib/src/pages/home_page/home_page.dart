import 'package:flutter/material.dart';

import 'package:agendamiento_cancha/src/pages/home_page/list_view_agenda.dart';
import 'package:agendamiento_cancha/messages/HomePageMsg.i18n.dart';

final homePageMsg = HomePageMsg();

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(homePageMsg.appbar_title),
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, '/nueva-agenda'),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: ListViewAgenda(),
    );
  }

}