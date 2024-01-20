import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/models/note.dart';
import 'package:diaryapp/widgets/sentiment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteDetails extends StatelessWidget {
  const NoteDetails(
      {super.key,
      required this.note,
      required this.deleteNote,
      required this.parendContext});

  final Note note;
  final void Function(Note note) deleteNote;
  final BuildContext parendContext;

  void _deleteNote(BuildContext context, Note note) async {
    try {
      await FirebaseFirestore.instance
          .collection("notes")
          .doc(note.id)
          .delete();
      deleteNote(note);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Note deleted successfully"),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error deleting note: ${e.toString()}}"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: Border.all(color: Colors.black, width: 1.0),
      title: Text(note.title),
      content: SingleChildScrollView(
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.content),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  SizedBox(
                    width: 105.0,
                    child: Text(
                      'Feeling: ${note.feeling}%',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Sentiment(sentimentPercentage: note.feeling)
                ],
              ),
              const SizedBox(height: 8.0),
              Text(DateFormat('dd/MM/yyyy').format(note.date))
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
          onPressed: () async {
            _deleteNote(parendContext, note);
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
