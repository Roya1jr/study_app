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

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        String? email;
        String? password;

        return AlertDialog(
          title: const Text("Login or Register"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) => email = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onSaved: (value) => password = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registered successfully!')),
                  );
                }
              },
              child: const Text("Register"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  context.read<MyAppState>().toggleLoginStatus();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged in successfully!')),
                  );
                }
              },
              child: const Text("Login"),
            ),
          ],
        );
      },
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
      body: Stack(
        children: [
          notes.isEmpty
              ? const Center(child: Text('No notes created.'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
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
          Positioned(
            bottom: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: "create",
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
                  const SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton(
                    heroTag: "login",
                    onPressed: () => _showLoginDialog(context),
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(Icons.login),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
