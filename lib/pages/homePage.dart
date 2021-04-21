import 'dart:io';

import 'package:flutter/material.dart';
import 'package:band_names/model/banda.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'CP', votes: 3),
    Band(id: '2', name: 'Cartel', votes: 5),
    Band(id: '3', name: 'Mob', votes: 4),
    Band(id: '4', name: 'Rv', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bandas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (BuildContext context, int index) =>
              _bandTile(bands[index])),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: addNewBand),
    );
  }

  _bandTile(Band band) {
    return Dismissible(
      key:Key(band.id),
      direction: DismissDirection.startToEnd,
     
      background:Container(
        color: Colors.red[400], 
        padding:EdgeInsets.only(left : 8.0),
        child: Align(alignment: Alignment.centerLeft,child: Text('Borrar la banda',style: TextStyle(color: Colors.white),),),) ,
          child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[200],
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('new band name :'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  child: Text('Add'),
                  elevation: 5,
                  onPressed: () => addBandList(textController.text ),
                )
              ],
            );
          });
    }
  }

  void addBandList(String name) {
    print(name);
    if (name.length > 1) {
      this
          .bands
          .add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
//podemos agregar

    }
    Navigator.pop(context);
  }
}
