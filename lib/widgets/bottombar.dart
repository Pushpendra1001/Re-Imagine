import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:reimagine/Common/color.dart';
import 'package:reimagine/Pages/ChatScreen.dart';
import 'package:reimagine/Pages/ExplorePage.dart';
import 'package:reimagine/Pages/HomePage.dart';

import 'package:reimagine/Pages/view360page.dart';

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({super.key});

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const ExplorePage(),
    View360Page(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Container(
          color: Colors.transparent.withOpacity(0.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: color1,
            ),
            child: GNav(
              gap: 8,
              activeColor: Colors.white,
              tabBackgroundColor: color1,
              tabs: const [
                GButton(icon: Icons.home, iconColor: Colors.teal, text: "Home"),
                GButton(
                  icon: CupertinoIcons.eye,
                  iconColor: Colors.teal,
                  text: "Explore",
                ),
                GButton(
                  icon: CupertinoIcons.globe,
                  iconColor: Colors.teal,
                  text: "360°",
                ),
                GButton(
                  icon: Icons.electric_bolt,
                  iconColor: Colors.teal,
                  text: "360°",
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
