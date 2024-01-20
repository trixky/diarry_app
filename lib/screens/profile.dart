import 'package:diaryapp/models/note.dart';
import 'package:diaryapp/widgets/note_line.dart';
import 'package:diaryapp/widgets/profile_header.dart';
import 'package:diaryapp/widgets/sentiment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key,
      required this.notes,
      required this.user,
      required this.userCredential,
      required this.signOut,
      required this.addNote,
      required this.showNoteDetails});

  final List<Note>? notes;
  final User user;
  final UserCredential? userCredential;
  final void Function() signOut;
  final void Function(BuildContext context) addNote;
  final void Function(BuildContext context, Note note) showNoteDetails;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    List<Note> filteredNotes = widget.notes == null ? [] : [...widget.notes!];
    filteredNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final filteredFilteredNotes = filteredNotes.take(2);

    final totalNotes = widget.notes == null ? 0 : widget.notes!.length;

    final List<int> notesFeelings = widget.notes == null
        ? []
        : widget.notes!.map((note) => note.feeling).toList();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ProfileHeader(
                user: widget.user,
                signOut: widget.signOut,
                addNote: widget.addNote),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      widget.notes == null
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 32),
                              child: CircularProgressIndicator(
                                  color: Colors.orange),
                            )
                          : widget.notes!.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 32),
                                  child:
                                      Text("Empty list, add a note to start !"),
                                )
                              : Column(
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16.0),
                                      child: Text("Your last notes"),
                                    ),
                                    Wrap(
                                      runSpacing: 10,
                                      children: filteredFilteredNotes
                                          .map((e) => NoteLine(
                                              note: e,
                                              showNoteDetails:
                                                  widget.showNoteDetails))
                                          .toList(),
                                    ),
                                  ],
                                ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                            "Your feel for your ${totalNotes.toString()} notes"),
                      ),
                      Sentiments(sentimentPercentages: notesFeelings)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
