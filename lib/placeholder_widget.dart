// just a temporary widget that works as a placeholder

import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
 final Text text;

 PlaceholderWidget(this.text);

 @override
 Widget build(BuildContext context) {
   return Center(
     child: text,
   );
 }
}