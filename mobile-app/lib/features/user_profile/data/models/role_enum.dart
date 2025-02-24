import 'package:flutter/material.dart';

enum Role{
  coach(color: Colors.red, title: 'Coach'),
  player(color: Colors.blue, title: 'Player');

  const Role({required this.color, required this.title});

  final Color color;
  final String title;
}