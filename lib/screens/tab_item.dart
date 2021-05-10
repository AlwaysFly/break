import 'package:flutter/material.dart';

// enum TabItem { explore, search, progress, library, settings }
enum TabItem { home, search, progress, library }
// enum TabItem { home, search, create, progress, library }

class TabItemData {
  const TabItemData({
    required this.label,
    @required this.selectedIcon,
    this.isIconPNG = false,
    this.size,
    required this.isTabButton,
    // @required this.unselectedIcon,
  });

  final String label;
  final dynamic selectedIcon;
  final bool isIconPNG;
  final double? size;
  final bool isTabButton;
  // final IconData unselectedIcon;

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.home: TabItemData(
      label: 'Home',
      selectedIcon: Icons.home_rounded,
      isIconPNG: false,
      size: 24,
      isTabButton: false,
      // unselectedIcon: Icons.home_outlined,
    ),
    TabItem.search: TabItemData(
      label: 'Search',
      selectedIcon: Icons.search_rounded,
      isIconPNG: false,
      size: 24,
      isTabButton: false,
      // unselectedIcon: Icons.search_rounded,
    ),
    // TabItem.create: TabItemData(
    //   label: 'Create',
    //   selectedIcon: Icons.add_circle_outline_rounded,
    //   isIconPNG: false,
    //   size: 40,
    //   isTabButton: true,
    //   // unselectedIcon: Icons.bar_chart_outlined,
    // ),
    TabItem.library: TabItemData(
      label: 'Library',
      selectedIcon: 'assets/icons/workout_collection_icon.png',
      isIconPNG: true,
      size: 24,
      isTabButton: false,
      // unselectedIcon: MyFlutterApp.workout_collection_icon_1,
    ),
    TabItem.progress: TabItemData(
      label: 'Progress',
      selectedIcon: Icons.bar_chart_rounded,
      isIconPNG: false,
      size: 24,
      isTabButton: false,
      // unselectedIcon: Icons.bar_chart_outlined,
    ),
    // TabItem.settings: TabItemData(
    //   label: 'Settings',
    //   selectedIcon: Icons.more_horiz_rounded,
    //   isIconPNG: false,
    //   // unselectedIcon: Icons.bar_chart_outlined,
    // ),
  };
}
