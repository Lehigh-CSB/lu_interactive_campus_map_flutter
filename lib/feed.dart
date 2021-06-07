import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

// See for formatting help: https://flutter.dev/docs/development/ui/layout
class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return _buildFeed();
  }

  Widget _buildFeed() {
    return StreamBuilder(
        stream: FirebaseDatabase().reference().child('events').onValue,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return  Text('Loading events...');

          return ListView.separated(
              padding: EdgeInsets.all(16.0),
              itemCount: snapshot.data.snapshot.value.length,
              itemBuilder: (context, index) {
                if (snapshot.data.snapshot.value['event_' + index.toString()]
                    != null) {
                  var currentEvent =
                      snapshot.data.snapshot.value['event_' + index.toString()];
                  return _buildRow(currentEvent['title']);
                }
                else
                  return SizedBox(); // better approach is to filter data first
              },
              separatorBuilder: (context, index) => const Divider(),
          );
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