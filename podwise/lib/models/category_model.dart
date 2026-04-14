import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData? iconData;
  final Color? iconColor;
  final String subtitle;

  Category({
    required this.id,
    required this.name,
    this.iconData,
    this.iconColor,
    this.subtitle = "",
  });
}