import 'package:flutter/material.dart';

BoxDecoration meetContainerDecoration(){
  return BoxDecoration(
    color: Colors.black26,
    borderRadius: BorderRadius.circular(15),
    border: const Border(
      top: BorderSide(
          width: 6, color: Colors.indigoAccent),
      bottom: BorderSide(
          width: 6, color: Colors.indigoAccent),
      right: BorderSide(
          width: 6, color: Colors.indigoAccent),
      left: BorderSide(
          width: 6, color: Colors.indigoAccent),
    ),
  );
}