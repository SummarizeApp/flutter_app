
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:literate_app/presentations/dictionary_screen/dictionary.dart';
import 'package:literate_app/presentations/home_screen/home_screen.dart';
import 'package:literate_app/presentations/profile_screen/profile_screen.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  _BottomNavigator createState() => _BottomNavigator();
}

class _BottomNavigator extends State<BottomNavigator> {
  int _selectedIndex = 0; 

  // Sayfaların listesi
  final List<Widget> _pages = [
    const HomeScreen(),
    const DictionaryScreen(),
    const ProfileScreen(),
  ];

  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primary, 
           selectedItemColor: Theme.of(context).colorScheme.primaryContainer,
        currentIndex: _selectedIndex, 
        onTap: _onItemTapped, 
        items:  [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: tr('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: tr('summary'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: tr('profile'),
          ),
        ],
      ),
    );
  }
}
