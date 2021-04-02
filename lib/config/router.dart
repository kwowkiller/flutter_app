import 'package:flutter/material.dart';

class _Tab {
  final String label;
  final Widget icon;

  const _Tab({
    required this.label,
    required this.icon,
  });
}

const Tabs = [
  _Tab(
    label: '首页',
    icon: Icon(Icons.home),
  ),
  _Tab(
    label: '大厅',
    icon: Icon(Icons.widgets),
  ),
  _Tab(
    label: '股权',
    icon: Icon(Icons.account_tree),
  ),
  _Tab(
    label: '领地',
    icon: Icon(Icons.account_balance),
  ),
  _Tab(
    label: '我的',
    icon: Icon(Icons.account_circle),
  )
];
