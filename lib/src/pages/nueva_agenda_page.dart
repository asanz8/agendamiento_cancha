import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:agendamiento_cancha/src/models/lista_agenda.dart';
import 'package:agendamiento_cancha/src/db/data/agenda_data.dart';
import 'package:agendamiento_cancha/src/common/util.dart';

class NuevaAgendaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NuevaAgendaPageState();
}

class _NuevaAgendaPageState extends State {
  String canchaSelected = '';
  int fecha = -1;
  String usuario = '';
  double probLluvia = -1.0;
  String weatherIcon = '';

  final _formKey = GlobalKey<FormState>();

  TextEditingController datePickerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva agenda'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _crearTextFieldUsuario(),
              _crearDatePicker(),
              _crearRowCanchas(),
              _crearPronostico(),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () => _crearAgenda(),
                    child: Text('Crear agenda')
                ),
              )
            ],
          ),
        )
      )
    );
  }

  void _crearAgenda() async {
    if(_formKey.currentState!.validate()){
      if(canchaSelected.isNotEmpty){
        var listaAgenda = context.read<ListaAgendaModel>();
        final disponible = await listaAgenda.validate(fecha, canchaSelected);

        if(disponible){
          final id = DateTime.now().millisecondsSinceEpoch;

          final newAgenda = Agenda(
            id: id,
            cancha: canchaSelected,
            usuario: usuario,
            fecha: fecha,
            probLluvia: probLluvia,
          );

          listaAgenda.add(newAgenda);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Agenda creada')));
          Navigator.pop(context);
        } // if disponible
        else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Cancha llena, seleccione otra cancha o fecha')));
        }
      } // if canchaSelected.isNotEmpty
      else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Seleccione una cancha')));
      }
    }
  }

  Widget _crearTextFieldUsuario() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor introduzca un nombre';
          }
          return null;
        },
        decoration: InputDecoration(
            hintText: '¿Quién agenda?',
            suffixIcon: Icon(Icons.person)
        ),
        onChanged: (text) {
          setState(() => usuario = text);
        },
      )
    );
  }

  Widget _crearDatePicker() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor introduzca una fecha';
          }
          return null;
        },
        enableInteractiveSelection: false,
        controller: datePickerController,
        decoration: InputDecoration(
            hintText: '¿Cuándo?',
            suffixIcon: Icon(Icons.calendar_today)
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _selectFecha();
        },
      ),
    );
  }

  void _selectFecha() async {

    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1)
    );

    if(picked != null) {
      setState(() => fecha = picked.millisecondsSinceEpoch);
      datePickerController.text = '${picked.day}-${picked.month}-${picked.year}';
      
      final sevenDays = DateTime.fromMillisecondsSinceEpoch(util.formatDateMilliStart(DateTime.now())).add(Duration(days: 7));
      if(fecha <= sevenDays.millisecondsSinceEpoch){
        _checkClima();
      }
      else {
        probLluvia = -1.0;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('El pronóstico esta disponible solo en los próximos 7 días')));
        setState(() {});
      }
    }
  }

  Widget _crearRowCanchas() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text('Seleccione una cancha'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _crearBotonCancha('A'),
              _crearBotonCancha('B'),
              _crearBotonCancha('C'),
            ],
          )
        ],
      ),
    );
  }

  Widget _crearBotonCancha(String cancha) {
    final selected = cancha == canchaSelected;

    return TextButton(
        onPressed: () => setState(() => canchaSelected = cancha),
        child: Text(cancha),
        style: TextButton.styleFrom(
            primary: selected ? Colors.white : Colors.blue,
            backgroundColor: selected ? Colors.blue : Colors.transparent,
            textStyle: TextStyle(fontSize: 24.0)
        )
    );
  }

  Widget _crearPronostico() {
    if(probLluvia.isNegative){
      return SizedBox();
    }
    else {
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text('Prob. Lluvia:', style: TextStyle(fontSize: 18.0)),
                Text('${(probLluvia*100).ceil()}%', style: TextStyle(fontSize: 20.0))
              ],
            ),
            FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: 'https://openweathermap.org/img/w/$weatherIcon.png',
            ),
          ],
        )
      );
    }
  }

  _checkClima() async {
    try {
      final response = await Dio().get('https://api.openweathermap.org/data/2.5/onecall?lat=40.714&lon=-74.006&exclude=minutely,hourly,alerts&appid=6088a3cb558b2566bd71c87c982af244');
      final List pronostico = response.data['daily'];

      for(int i=0; i<=pronostico.length-1; i++){
        final fechaPronostico = util.formatDateMilliStart(DateTime.fromMillisecondsSinceEpoch(pronostico[i]['dt'] * 1000));
        if(fecha == fechaPronostico){
          probLluvia = pronostico[i]['pop'] is int ? pronostico[i]['pop'].toDouble() : pronostico[i]['pop'];
          weatherIcon = pronostico[i]['weather'][0]['icon'];
          break;
        }
      }
      setState(() {});
    }
    catch(e) {
      probLluvia = -1.0;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ha ocurrido un problema al consultar el pronóstico')));
      setState(() {});
    }
  }

}