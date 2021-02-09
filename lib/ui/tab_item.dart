import 'package:flutter/material.dart';

enum TabItem { home, myFriends, calendar, favorites }

class TabItemData {
  const TabItemData({
    @required this.label,
    @required this.icon,
    @required this.activeIcon,
  });
  final String label;
  final IconData icon;
  final IconData activeIcon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.home: TabItemData(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    TabItem.myFriends: TabItemData(
      label: 'My Friends',
      icon: Icons.people_alt_outlined,
      activeIcon: Icons.people_alt,
    ),
    TabItem.calendar: TabItemData(
      label: 'Calendar',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
    ),
    TabItem.favorites: TabItemData(
      label: 'Favorites',
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite,
    ),
  };
}
