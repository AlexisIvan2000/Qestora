import 'package:flutter/material.dart';
import 'package:front_end/screen/dashboard.dart';
import 'package:front_end/screen/settings.dart';

class NavigateBar extends StatefulWidget {
  const NavigateBar({super.key});

  @override
  State<NavigateBar> createState() => _NavigateBarState();
}

class _NavigateBarState extends State<NavigateBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const DashboardScreen()));
      }
      else if (_selectedIndex == 1) {
        // Navigate to Calendar Screen
      } else if (_selectedIndex == 2) {
        // Navigate to Maps Screen
      } else if (_selectedIndex == 3) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      fixedColor: Theme.of(context).colorScheme.primary,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home), 
          label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map), 
          label: 'Maps'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings'
        ),
      ],
    );
  }
}
