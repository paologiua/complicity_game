import 'package:flutter/material.dart';

class FloatingButtonModel {
  const FloatingButtonModel({
    required this.key,
    required this.icon,
    required this.action,
  });

  final dynamic key;
  final IconData icon;
  final void Function() action;
}