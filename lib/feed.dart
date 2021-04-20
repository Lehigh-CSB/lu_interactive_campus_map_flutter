import 'package:flutter/cupertino.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final _messages = ['hello', 'there'];
  @override
  Widget build(BuildContext context) {
    return Text('Hello!');
  }
}