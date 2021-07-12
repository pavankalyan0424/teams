import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    primarySwatch: Colors.indigo,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.indigoAccent,
        size: 25,
      ),
    ),
    scaffoldBackgroundColor: Colors.grey[250],
  );
}
