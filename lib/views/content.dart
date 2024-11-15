import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:study_app/components/cards.dart';
import 'package:study_app/models/models.dart';
import 'package:study_app/views/quiz.dart';

class NoteContentPage extends StatelessWidget {
  final Note note;

  const NoteContentPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(note.title),
          centerTitle: true,
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
            CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.7,
                scrollDirection: Axis.vertical,
                autoPlay: false,
                enlargeCenterPage: true,
              ),
              items: note.flashCards.map<Widget>((flashCard) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: FlipCard(
                      front: FlipFlashCard(
                          text: flashCard.question,
                          color: const Color.fromARGB(255, 227, 236, 242)),
                      back: FlipFlashCard(
                          text: flashCard.answer,
                          color: const Color.fromARGB(255, 73, 96, 133))),
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: note.quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = note.quizzes[index];
                  return Card(
                    child: ListTile(
                      title: Text(quiz.title),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(quiz: quiz),
                          ),
                        );
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
