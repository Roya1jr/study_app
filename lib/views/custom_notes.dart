import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_app/components/cards.dart';
import 'package:study_app/main.dart';
import 'package:study_app/models/models.dart';
import 'package:study_app/views/creator.dart';

class NoteListPage extends StatelessWidget {
  const NoteListPage({super.key});

  void _editNote(BuildContext context, Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatorPage(note: note),
      ),
    );
  }

  void _shareNote(BuildContext context, Note note) {
    context.read<MyAppState>().shareNote(note);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${note.title} shared!')),
    );
  }

  void _deleteNote(BuildContext context, Note note) {
    context.read<MyAppState>().removeNote(note);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${note.title} deleted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<MyAppState>().customNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        centerTitle: true,
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes created.'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return CustomNoteCard(
                  note: note,
                  onEdit: () => _editNote(context, note),
                  onShare: () => _shareNote(context, note),
                  onDelete: () => _deleteNote(context, note),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatorPage(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: () {
                context.read<MyAppState>().toggleLoginStatus();
                final loginStatus = context.read<MyAppState>().loginstatus
                    ? "logged in"
                    : "logged out";
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You are now $loginStatus!')),
                );
              },
              child: const Icon(Icons.login),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
