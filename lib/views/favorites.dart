import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_app/main.dart';
import 'package:study_app/components/cards.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final courses = appState.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Favorites")),
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseListCard(
              course: course,
              onRemove: () {
                appState.toggleFavorite(course);
              });
        },
      ),
    );
  }
}
