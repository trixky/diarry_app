import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/models/note.dart';
import 'package:diaryapp/widgets/sentiment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuidGenerator = Uuid();

class AddNoteForm extends StatefulWidget {
  const AddNoteForm({super.key, required this.user, required this.addNote, required this.parentContext});

  final User? user;
  final void Function(Note note) addNote;
  final BuildContext parentContext;

  @override
  State<AddNoteForm> createState() => _AddNoteFormState();
}

class _AddNoteFormState extends State<AddNoteForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int _rangeValue = 50;
  DateTime _selectedDate = DateTime.now();

  void _uploadNote(Note note, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection("notes").doc(note.id).set({
        "userEmail": note.userEmail,
        "date": note.date,
        "title": note.title,
        "feeling": note.feeling,
        "content": note.content,
        "createdAt": note.createdAt
      });

      widget.addNote(note);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Note added successfully"),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error adding note: ${e.toString()}}"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: Border.all(color: Colors.black, width: 1.0),
      title: const Text('New note'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  if (value.length > 50) {
                    return 'Le titre ne doit pas dépasser 50 caractères';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  SizedBox(
                    width: 105.0,
                    child: Text(
                      'Feeling: $_rangeValue%',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Sentiment(sentimentPercentage: _rangeValue)
                ],
              ),
              Slider(
                activeColor: Colors.orange,
                value: _rangeValue.toDouble(),
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    _rangeValue = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Text('Date:'),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        foregroundColor: Colors.black,
                        side: const BorderSide(
                            width: 1,
                            color: Colors.black,
                            style: BorderStyle.solid),
                      ),
                      child:
                          Text(DateFormat('dd/MM/yyyy').format(_selectedDate))),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final note = Note(
                id: uuidGenerator.v4(),
                userEmail: widget.user!.email!,
                date: _selectedDate,
                title: titleController.text,
                feeling: _rangeValue,
                content: descriptionController.text,
              );
              _uploadNote(note, widget.parentContext);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
