import 'package:flutter/material.dart';

/// A Petit Bac category shown during play (id matches answer map keys).
class Category {
  final String id;
  final String name;
  final IconData icon;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
  });
}
