import 'package:edutainment/main.dart';
import 'package:flutter/material.dart';

class ScreenSize {
  static var width = MediaQuery.of(globalKey.currentState!.context).size.width;
  static var height = MediaQuery.of(globalKey.currentState!.context).size.height;
}