import 'package:flutter/material.dart';

import 'custom_textstyle.dart';

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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.indigoAccent,
      selectedLabelStyle: customTextStyle(
        17,
        Colors.indigoAccent,
      ),
      unselectedItemColor: Colors.black,
      unselectedLabelStyle: customTextStyle(17, Colors.black),
    ),
    scaffoldBackgroundColor: Colors.grey[250],
  );
}
