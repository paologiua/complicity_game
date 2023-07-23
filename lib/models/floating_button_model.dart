import 'package:flutter/material.dart';

class FloatingButtonModel {
  const FloatingButtonModel({
    required this.icon,
    required this.action,
  });

  final IconData icon;
  final void Function() action;
}