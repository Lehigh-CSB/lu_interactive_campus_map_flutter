import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  final String _title;
  final String _fullDescription;
  final String _location;

  // constructor
  EventPage (this._title, this._fullDescription, this._location);

  @override
  _EventPage createState() => _EventPage();
}

// TODO: format page
class _EventPage extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Text(widget._fullDescription),
    );
  }
}