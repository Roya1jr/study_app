import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_app/components/cards.dart';
import 'package:study_app/main.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        scrollDirection: Axis.vertical,
        autoPlay: false,
        enlargeCenterPage: true,
      ),
      items: appState.notes.map((note) {
        return Builder(
          builder: (BuildContext context) {
            final isFavorite = appState.favorites.contains(note);

            return NoteCard(
              imageUrl: note.imageUrl,
              noteTitle: note.title,
              faculty: note.faculty,
              isFavorite: isFavorite,
              onFavoriteToggle: () {
                appState.toggleFavorite(note);
              },
            );
          },
        );
      }).toList(),
    );
  }
}
