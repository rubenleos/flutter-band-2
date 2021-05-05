import 'dart:io';

import 'package:band_names/services/socket_service.dart';

import 'package:flutter/material.dart';
import 'package:band_names/model/banda.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];
  /* List<Band> bands = [
    Band(id: '1', name: 'CP', votes: 3),
    Band(id: '2', name: 'Cartel', votes: 5),
    Band(id: '3', name: 'Mob', votes: 4),
    Band(id: '4', name: 'Rv', votes: 5),
  ];*/

  @override
  void initState() {
    final socket = Provider.of<SocketService>(context, listen: false);

    socket.socket.on('active-bands', _handleAcvtiveBands);
    // TODO: implement initState
    super.initState();
  }

  _handleAcvtiveBands(dynamic payload) {
    this.bands = (payload as List).map((band) => Band.froMap(band)).toList();
    setState(() {});
  }

  /* @override
  void dispose() {
    final socket = Provider.of<SocketService>(context, listen: false);
    socket.socket.off('active-bands');
    super.dispose();

    // TODO: implement dispose
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    final socket = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bandas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: (socket.serverStatus == ServerStatus.Online)
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    )
                  : Icon(
                      Icons.adjust_sharp,
                      color: Colors.red,
                    ))
        ],
      ),
      body: Column(
        children: [
          showGrap(),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (BuildContext context, int index) =>
                    _bandTile(bands[index])),
          )
        ],
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: addNewBand),
    );
  }

  _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        socketService.socket.emit('delete-band', {"id": band.id});
      },
      background: Container(
        color: Colors.red[400],
        padding: EdgeInsets.only(left: 8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Borrar la banda',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
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
          socketService.socket.emit('vote-band', {'id': band.id});
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    if (kIsWeb || Platform.isAndroid) {
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
                  onPressed: () => addBandList(textController.text),
                )
              ],
            );
          });
    }
  }

  Widget showGrap() {
    Map<String, double> dataMap = new Map();
    {
      //  "Flutter": 5,
      bands.forEach((band) {
        dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
      });
    }
    ;
    return Container(
        width: double.infinity, height: 200, child: PieChart(dataMap: dataMap));
  }

  void addBandList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    Band band;
    print(name);
    if (name.length > 1) {
      return socketService.socket.emit('add-bands', {'name': name});
      //

//podemos agregar

    }
    Navigator.pop(context);
  }
}
