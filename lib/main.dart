import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/db/db_provider.dart';
import 'package:agendamiento_cancha/src/models/lista_agenda.dart';
import 'package:agendamiento_cancha/src/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  dbProvider.database = dbProvider.openDb();

  runApp(
      ChangeNotifierProvider(
        create: (context) => ListaAgendaModel(),
        child: App(),
      )
  );
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Agendamiento",
      initialRoute: '/',
      routes: routes,
    );
  }

}