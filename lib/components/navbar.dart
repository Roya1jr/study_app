import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:study_app/views/custom_notes.dart';
import 'package:study_app/views/notes.dart';
import 'package:study_app/views/favorites.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  Widget _child = const FavoritesPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: AnimatedSwitcher(
          duration: const Duration(microseconds: 300),
          child: _child,
          transitionBuilder: (Widget child, Animation<double> animation) {
            final offset =
                Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                    .animate(animation);
            return SlideTransition(position: offset, child: child);
          },
        ),
        bottomNavigationBar: FluidNavBar(
          icons: [
            FluidNavBarIcon(
                icon: Icons.favorite,
                backgroundColor: const Color.fromARGB(255, 29, 58, 103),
                extras: {"label": "favorites"}),
            FluidNavBarIcon(
                icon: Icons.bookmarks_outlined,
                backgroundColor: const Color.fromARGB(255, 29, 58, 103),
                extras: {"label": "notes"}),
            FluidNavBarIcon(
                icon: Icons.bookmark_add_outlined,
                backgroundColor: const Color.fromARGB(255, 29, 58, 103),
                extras: {"label": "create"}),
          ],
          onChange: _handleNav,
          style: const FluidNavBarStyle(
            barBackgroundColor: Color.fromARGB(255, 29, 58, 103),
            iconSelectedForegroundColor: Colors.white,
            iconUnselectedForegroundColor: Color.fromARGB(255, 227, 236, 242),
          ),
          animationFactor: 0.5,
          scaleFactor: 1.8,
          itemBuilder: (icon, item) =>
              Semantics(label: icon.extras!["label"], child: item),
        ));
  }

  void _handleNav(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = const FavoritesPage();
          break;
        case 1:
          _child = const NotesPage();
          break;
        case 2:
          _child = const NoteListPage();
          break;
      }
    });
  }
}
