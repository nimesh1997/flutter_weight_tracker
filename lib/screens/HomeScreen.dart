import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Track'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
//      child: buildListOfWeight(),
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

//  buildListOfWeight() {
//    return ListView
//  }
}
