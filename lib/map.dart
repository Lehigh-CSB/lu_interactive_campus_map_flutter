import 'package:flutter/material.dart';
import 'package:lu_interactive_campus_map_flutter/app_icons.dart';
import 'placeholder_widget.dart';

var colorGryphonGold = "FBDE40";
var colorLehighBrown = "653818";
var colorPackerPatina = "6BBBAE";
var colorBetterThanMaroonRed = "F9423A";

class Map extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapState();
  }
}

class _MapState extends State<Map> {
  int _currentIndex = 1;
  String _currentTitle = 'Map';
  final List<Widget> _children = [
    PlaceholderWidget(Text('Feed')),
    PlaceholderWidget(Text('Map')),
    PlaceholderWidget(Text('Discover')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(
            child: Text(
          _currentTitle,
          style: TextStyle(color: Colors.black),
        )),
        backgroundColor: Colors.white,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Color(int.parse("0xFF$colorGryphonGold")),
        unselectedItemColor: Color(int.parse("0xFF$colorPackerPatina")),
        items: [
          BottomNavigationBarItem(
            icon: new Icon(AppIcons.feed_icon),
            title: new Text('Feed'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(AppIcons.map_icon),
            title: new Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(AppIcons.discover_icon),
            title: new Text('Discover'),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          {
            _currentTitle = 'Feed';
          }
          break;
        case 1:
          {
            _currentTitle = 'Map';
          }
          break;
        case 2:
          {
            _currentTitle = 'Discover';
          }
          break;
      }
    });
  }
}
