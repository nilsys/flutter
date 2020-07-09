import 'dart:ui';

import 'package:flutter/material.dart';
import 'MainBody.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("KMBPJ"),
      ),
      body: MainBody(),
    ));
  }
}
