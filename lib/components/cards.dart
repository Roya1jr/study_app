import 'package:flutter/material.dart';
import 'package:study_app/components/notifications.dart';
import 'package:study_app/models/models.dart';
import 'package:study_app/views/content.dart';

class FlipFlashCard extends StatelessWidget {
  final String text;
  final Color? color;

  const FlipFlashCard({
    super.key,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: 4,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class NoteListCard extends StatefulWidget {
  final Note note;
  final Function() onRemove;

  const NoteListCard({super.key, required this.note, required this.onRemove});

  @override
  State<NoteListCard> createState() => _NoteListCardState();
}

class _NoteListCardState extends State<NoteListCard> {
  bool isReminderSet = false;
  final notificationService = NotificationService();
  void toggleReminder() async {
    if (mounted) {
      if (isReminderSet) {
        await notificationService.cancelDailyNotifications(widget.note);
        if (mounted) {
          setState(() {
            isReminderSet = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Study reminders turned off."),
            ),
          );
        }
      } else {
        await notificationService.scheduleDailyNotifications(widget.note);
        if (mounted) {
          setState(() {
            isReminderSet = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Study reminders scheduled!"),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(widget.note.imageUrl),
        title: Text(widget.note.title),
        subtitle: Text(widget.note.module),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isReminderSet ? Icons.notifications_off : Icons.notifications,
              ),
              onPressed: toggleReminder,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: widget.onRemove,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteContentPage(note: widget.note),
            ),
          );
        },
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String imageUrl;
  final String noteTitle;
  final String module;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const NoteCard({
    super.key,
    required this.imageUrl,
    required this.noteTitle,
    required this.module,
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
              flex: 5,
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('Image load error')),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 50,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noteTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    module,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  const CustomNoteCard({
    required this.note,
    required this.onEdit,
    required this.onShare,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(note.imageUrl),
        title: Text(note.title),
        subtitle: Text(note.module),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteContentPage(note: note),
            ),
          );
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: onShare,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class ListFlashCard extends StatelessWidget {
  final FlashCard flashCard;
  final VoidCallback onDelete;

  const ListFlashCard(
      {super.key, required this.flashCard, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(flashCard.question),
        subtitle: Text(flashCard.answer),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
