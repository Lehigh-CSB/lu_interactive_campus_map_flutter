import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'event_page.dart';

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
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.data.snapshot.value['event_' + index.toString()]
                    != null) {
                  var currentEvent =
                      snapshot.data.snapshot.value['event_' + index.toString()];
                  return _buildRow(currentEvent);
                }
                else {
                  /* placeholder widget that takes up no space --
                     a better approach might be to filter the data first */
                  return SizedBox();
                }
              },
              // each card is separated by a Divider widget
              separatorBuilder: (context, index) => const Divider(),
          );
        }
    );
  }

  // each row consists of a card containing basic data about an event
  Widget _buildRow(LinkedHashMap event) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
              EventPage(event['title'], event['full_description'],
                        event['location']),
            )
          );
        },
        child: ListTile(
          leading: Image.network(event['img_url']),
          title: Text(event['title']),
          subtitle: Text(event['description']),
          isThreeLine: true,
        ),
      ),
    );
  }
}