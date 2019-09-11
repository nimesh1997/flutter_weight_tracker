import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weight_track/models/TrackWeight.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<TrackWeight> trackWeightList = List();

StreamSubscription weightAdded;
StreamSubscription weightChanged;

TrackWeight trackWeight;

final mainDbReference = FirebaseDatabase.instance.reference();

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState() {
    weightAdded = mainDbReference.child('trackweight').onChildAdded.listen(_onEntryAdded);
    weightChanged = mainDbReference.child('trackweight').onChildChanged.listen(_onEntryChanged);
  }

  @override
  void initState() {
//    getDataList();
  }

  @override
  void dispose() {
    weightChanged.cancel();
    weightAdded.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Track'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            buildListOfWeight(),
          ],
        ),
//        child: buildListOfWeight(),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/weightDetail');
          },
          tooltip: 'Add Weight',
          icon: Icon(Icons.add),
          label: Text('Add')),
    );
  }

  void _onEntryAdded(Event event) {
    print('onEntry Added...');
    setState(() {
      print('event: ' + event.snapshot.key);

      ///adding snapshot data to trackWeightList
      trackWeightList.add(TrackWeight.fromSnapshot(event.snapshot));
      print('list length: ' + trackWeightList.length.toString());
      print('list: ' + trackWeightList.toString());
    });
  }

  void _onEntryChanged(Event event) {
    print('onEntry Changed...');
    print('onEntry Changed key: ' + event.snapshot.key);
    var oldEntry = trackWeightList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      print('event: ' + event.snapshot.toString());
      trackWeightList[trackWeightList.indexOf(oldEntry)] = new TrackWeight.fromSnapshot(event.snapshot);
    });
  }

  buildListOfWeight() {
    return Container(
        child: trackWeightList.length == 0
            ? Center(
                child: Text('Your list is empty!'),
              )
            : ListView.builder(
                itemCount: trackWeightList.length,
                itemBuilder: (BuildContext context, int index) {
                  String dateTime = trackWeightList[index].dateTime;
                  List splitDateTime = dateTime.split(' ');
                  String date = splitDateTime[0];
                  String time = splitDateTime[1];
                  String weight = trackWeightList[index].weight.toString() + ' kg';
                  String diffWeight = getDifferenceWeight(index);
                  return Container(
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    padding: EdgeInsets.only(
                      bottom: 5.0,
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.0),
                    )),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 5.0,
                            left: 8.0,
                          ),
                          child: Container(
                            width: 125.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(date),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  child: Text(time),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 100.0,
                          child: Text(
                            weight,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ),
                        Container(
                            alignment: Alignment.topRight,
                            width: 100.0,
                            child: Text(
                              diffWeight,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                            ))
                      ],
                    ),
                  );
                }));
  }

  String getDifferenceWeight(int index) {
    String diffWeight;
    if (index == 0) {
      diffWeight = '-';
    } else {
      double diff = trackWeightList[index].weight - trackWeightList[index - 1].weight;
      if (diff > 0.0)
        diffWeight = '+' + diff.toString() + 'kg';
      else
        diffWeight = diff.toString() + 'kg';
    }
    return diffWeight;
  }


}
