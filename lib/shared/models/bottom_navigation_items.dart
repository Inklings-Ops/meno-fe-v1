import 'package:flutter/widgets.dart' show BottomNavigationBarItem, Icon;
import 'package:meno_design_system/meno_design_system.dart';

const List<BottomNavigationBarItem> bottomNavigationItemList = [
  BottomNavigationBarItem(icon: Icon(MIcons.home_04), label: "Home"),
  BottomNavigationBarItem(icon: Icon(MIcons.compass), label: "Discover"),
  BottomNavigationBarItem(icon: Icon(MIcons.file), label: "Notes"),
  BottomNavigationBarItem(icon: Icon(MIcons.user_circle), label: "Profile"),
];
