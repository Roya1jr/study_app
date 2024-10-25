import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      items: appState.courses.map((course) {
        return Builder(
          builder: (BuildContext context) {
            final isFavorite = appState.favorites.contains(course);

            return CourseCard(
              imageUrl: course['image']!,
              courseTitle: course['title']!,
              faculty: course['faculty']!,
              isFavorite: isFavorite,
              onFavoriteToggle: () {
                appState.toggleFavorite(course);
              },
            );
          },
        );
      }).toList(),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String imageUrl;
  final String courseTitle;
  final String faculty;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CourseCard({
    super.key,
    required this.imageUrl,
    required this.courseTitle,
    required this.faculty,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 5),
          ),
        ],
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        size: 50,
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseTitle,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      faculty,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
