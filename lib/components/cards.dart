import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_app/utils/tools.dart';
import 'package:study_app/main.dart';
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
  List<List<int>> reminderTimes = [];
  final reminderService = ReminderService();

  void toggleReminder() async {
    if (mounted) {
      if (isReminderSet) {
        await reminderService.toggleReminder(widget.note, false, reminderTimes);
        setState(() {
          isReminderSet = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Study reminders turned off."),
          ),
        );
      } else {
        if (reminderTimes.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please select a reminder time first."),
            ),
          );
        } else {
          await reminderService.toggleReminder(
              widget.note, true, reminderTimes);
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

  Future<void> selectReminderTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final int hour = selectedTime.hour;
      final int minute = selectedTime.minute;

      setState(() {
        reminderTimes.add([hour, minute]);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Reminder set for $hour:${minute.toString().padLeft(2, '0')}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: Image.network(widget.note.imageUrl),
            title: Text(widget.note.title),
            subtitle: Text(widget.note.module),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteContentPage(note: widget.note),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.alarm_add),
                onPressed: selectReminderTime,
              ),
              IconButton(
                icon: Icon(
                  !isReminderSet
                      ? Icons.notifications_off
                      : Icons.notifications,
                ),
                onPressed: toggleReminder,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: widget.onRemove,
              ),
            ],
          ),
        ],
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
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('Image load error')),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.red[100],
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

class CustomNoteCard extends StatefulWidget {
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
  State<CustomNoteCard> createState() => _CustomNoteCardState();
}

class _CustomNoteCardState extends State<CustomNoteCard> {
  bool isReminderSet = false;
  List<List<int>> reminderTimes = [];
  final reminderService = ReminderService();
  final notificationService = NotificationService();

  void toggleReminder() async {
    if (mounted) {
      if (isReminderSet) {
        await reminderService.toggleReminder(widget.note, false, reminderTimes);
        setState(() {
          isReminderSet = false;
        });
      } else {
        if (reminderTimes.isEmpty) {
        } else {
          await reminderService.toggleReminder(
              widget.note, true, reminderTimes);
          setState(() {
            isReminderSet = true;
          });
        }
      }
    }
  }

  Future<void> selectReminderTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final int hour = selectedTime.hour;
      final int minute = selectedTime.minute;

      setState(() {
        reminderTimes.add([hour, minute]);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Reminder set for $hour:${minute.toString().padLeft(2, '0')}"),
        ),
      );

      toggleReminder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<MyAppState>().loginstatus;
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: Image.network(widget.note.imageUrl),
            title: Text(widget.note.title),
            subtitle: Text(widget.note.module),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteContentPage(note: widget.note),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: widget.onEdit,
              ),
              if (status)
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: widget.onShare,
                ),
              IconButton(
                icon: Icon(
                  isReminderSet ? Icons.notifications_off : Icons.notifications,
                ),
                onPressed: toggleReminder,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: widget.onDelete,
              ),
            ],
          ),
          !isReminderSet
              ? TextButton(
                  onPressed: selectReminderTime,
                  child: const Text('Set Reminder Time'),
                )
              : Text(""),
        ],
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
