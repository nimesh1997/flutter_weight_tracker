import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_weight_track/models/TrackWeight.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

class WeightDetailScreen extends StatefulWidget {
  @override
  _WeightDetailScreenState createState() => _WeightDetailScreenState();
}

//DatePicker Constants
const String MIN_DATE = '2019-01-01';
const String MAX_DATE = '2050-01-01';

//TimePicker Constants
const String MIN_DATETIME = '2019-01-01 00:00:00';
const String MAX_DATETIME = '2050-01-01 23:59:59';

String initDate = '';
String initDateTime = '';
DateTime dateTime;

String format = 'yyyy-MM-dd';
String dateTimeFormat = 'yyyy-MM-dd hh:mm:ss';
String dateFormat = 'dd-MMMM-yyyy';

String date;
String time;
double selectedWeight;
String detail;
int timeStamp;

TrackWeight trackWeight;

final mainDbReference = FirebaseDatabase.instance.reference();

class _WeightDetailScreenState extends State<WeightDetailScreen> {
  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
    initDate = DateFormat(format).format(dateTime).toString();
    initDateTime = DateFormat(dateTimeFormat).format(dateTime).toString();
    print('initDate: ' + DateFormat(format).format(dateTime).toString());
    print('initDateTime: ' + initDateTime);

    date = DateFormat(dateFormat).format(dateTime).toString();
    setState(() {
      time = DateFormat('hh:mm:ss a').format(dateTime).toString();
      timeStamp = dateTime.millisecondsSinceEpoch;
    });
    selectedWeight = 65.0;
  }

/*  @override
  void dispose() {
    weightChanged.cancel();
    weightAdded.cancel();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
          title: Text('Weight Form'),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    buildCard(),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                buildSaveButton()
              ],
            )
//      child: Center(
//        child: Text('Currently working on it'),
//      ),
            ));
  }

  buildCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 350.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(spreadRadius: 2.0, color: Colors.grey.withOpacity(0.6), blurRadius: 4.0, offset: Offset(0.0, 2.0))],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: <Widget>[
            buidFirstRow(context),
            buildSecondRow(context),
            buildThirdRow(),
          ],
        ),
      ),
    );
  }

  buidFirstRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: Container(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                openDatePicker(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                    ),
                    onPressed: () {
                      openDatePicker(context);
                    },
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Container(height: 48.0, child: Center(child: Text(date))),
                  SizedBox(
                    width: 50.0,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                openTimePicker(context);
              },
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Container(
                  height: 48.0,
                  child: Center(
                    child: Text(
                      time,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildSecondRow(BuildContext context) {
    return InkWell(
      onTap: () {
        openWeightPicker(context);
      },
      child: Container(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.directions_walk,
              ),
              onPressed: () {},
            ),
            SizedBox(
              width: 5.0,
            ),
            Container(height: 45.0, child: Center(child: Text(selectedWeight.toString() + ' Kg'))),
          ],
        ),
      ),
    );
  }

  buildThirdRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          padding: EdgeInsets.all(0.0),
          icon: Icon(
            Icons.note_add,
          ),
          onPressed: () {},
        ),
        SizedBox(
          width: 5.0,
        ),
        Container(
          width: 250.0,
          child: TextField(
            onChanged: (value) {
              setState(() {
                detail = value;
                print('detail: ' + detail);
              });
            },
            decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0), enabledBorder: UnderlineInputBorder()),
            maxLines: 1,
          ),
        )
      ],
    );
  }

  buildSaveButton() {
    return Center(
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: () {
          saveDataToFirebase();
        },
        child: Text(
          'Save',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.blue,
      ),
    );
  }

  void openDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      pickerMode: DateTimePickerMode.date,
      pickerTheme: DateTimePickerTheme(
        cancel: Text('Cancel', style: TextStyle(color: Colors.cyan)),
        confirm: Text('Done', style: TextStyle(color: Colors.red)),
      ),
      minDateTime: DateTime.parse(MIN_DATE),
      maxDateTime: DateTime.parse(MAX_DATE),
      initialDateTime: DateTime.parse(MIN_DATE),
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      dateFormat: dateFormat,
      onChange: (dateTime, List<int> index) {
        setState(() {
//          date = dateTime.toString();
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          String formattedDate = DateFormat('dd-MMMM-yyyy').format(dateTime).toString();
          print(formattedDate);
          date = formattedDate;
        });
      },
    );
  }

  void openTimePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: DateTime.parse(initDateTime),
      pickerMode: DateTimePickerMode.time,
      pickerTheme: DateTimePickerTheme(
        cancel: Text(
          'Cancel',
          style: TextStyle(color: Colors.cyan),
        ),
        confirm: Text(
          'Done',
          style: TextStyle(color: Colors.red),
        ),
      ),
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          print('time: ' + DateFormat('hh:mm:ss a').format(dateTime).toString());
//          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          String formattedTime = DateFormat('hh:mm:ss a').format(dateTime).toString();
          time = formattedTime;
          timeStamp = dateTime.millisecondsSinceEpoch;
          print('timeStamp: ' + timeStamp.toString());
        });
      },
    );
  }

  Future<void> openWeightPicker(BuildContext context) async {
    await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return NumberPickerDialog.decimal(title: Text('Select your weight:'), minValue: 10, maxValue: 300, initialDoubleValue: 50.5);
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedWeight = value;
          print('selected weight: ' + value.toString());
        });
      }
    }).catchError((onError) {
      print('openWeightPicker catchError: ' + onError.toString());
    });
  }

  void saveDataToFirebase() {
    print('saveDataToFirebase called...');
    var dbReference = mainDbReference;
    trackWeight = TrackWeight(selectedWeight, date + ' ' + time, detail, timeStamp);
    print('trackWeight: ' + trackWeight.toString());
    dbReference.child('trackweight').push().set(trackWeight.toJson());
    setState(() {
      Navigator.pop(context);
      print('successfully pushed in db');
    });
  }
}
