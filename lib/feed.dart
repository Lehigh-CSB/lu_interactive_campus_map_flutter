import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

// See for formatting help: https://flutter.dev/docs/development/ui/layout
class _FeedState extends State<Feed> {
  final _titles = [];
  @override
  Widget build(BuildContext context) {
    return _buildFeed();
  }

  Widget _buildFeed() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;

          // builds placeholders (real app pulls feed data from Firebase)
          if (index < 8) {
            if (index >= _titles.length) {
              _titles.add('New Row');
            }
            return _buildRow(_titles[index]);
          }
          return new Container(); // empty space
        }
    );
  }

  Widget _buildRow(String title) {
    return Card(
      child: ListTile(
        leading: FlutterLogo(size: 72.0),
        title: Text(title),
        subtitle: Text(
          'A sufficiently long subtitle warrants three lines.'
        ),
        trailing: Icon(Icons.more_vert),
        isThreeLine: true,
      ),
    );
  }
}