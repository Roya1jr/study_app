import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:study_app/components/cards.dart';

class CourseContentPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseContentPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(course['title']),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.splitscreen_rounded),
              ),
              Tab(
                icon: Icon(Icons.quiz_outlined),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Flashcards Tab with Carousel of Flip Cards
            CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.7,
                scrollDirection: Axis.vertical,
                autoPlay: false,
                enlargeCenterPage: true,
              ),
              items: course['flash_cards'].map<Widget>((flashCard) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: FlipCard(
                      front: FCard(
                          text: flashCard['question'],
                          color: const Color.fromARGB(255, 227, 236, 242)),
                      back: FCard(
                          text: flashCard['answer'],
                          color: const Color.fromARGB(255, 73, 96, 133))),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: course['quizzes'].length,
                itemBuilder: (context, index) {
                  final quiz = course['quizzes'][index];
                  return Card(
                    child: ListTile(
                      title: Text(quiz['title']),
                      onTap: () {
                        // Handle quiz tap here
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
