import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/models/note.dart';
import 'package:diaryapp/screens/auth.dart';
import 'package:diaryapp/screens/calandar.dart';
import 'package:diaryapp/screens/profile.dart';
import 'package:diaryapp/screens/login.dart';
import 'package:diaryapp/widgets/add_note_form.dart';
import 'package:diaryapp/widgets/note_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserCredential? _userCredential;
  User? _user;

  List<Note>? _notes;
  var _loggedScreenIndex = 0;
  var _loginScreenCheck = false;
  StreamSubscription<User?>? _authStateChangesListener;

  @override
  void initState() {
    super.initState();

    if (_auth.currentUser != null) {
      setState(() {
        _user = _auth.currentUser;
      });
    }

    _authStateChangesListener = _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
    _fetchMyNotes();
  }

  @override
  void dispose() {
    if (_authStateChangesListener != null) {
      _authStateChangesListener!.cancel();
    }
    super.dispose();
  }

  void _fetchMyNotes() async {
    if (_user == null) {
      setState(() {
        _notes = [];
      });
      return;
    }
    var notesResult = await FirebaseFirestore.instance
        .collection("notes")
        .where("userEmail", isEqualTo: _user!.email)
        .get();

    setState(() {
      _notes = notesResult.docs
          .map((e) => Note(
                id: e.id,
                userEmail: e["userEmail"],
                date: e["date"].toDate(),
                title: e["title"],
                feeling: e["feeling"],
                content: e["content"],
                createdAt: e["createdAt"],
              ))
          .toList();

      _notes!.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void _addNote(Note note) {
    if (_notes != null) {
      setState(() {
        _notes!.add(note);
        _notes!.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  void _deleteNote(Note note) {
    if (_notes != null) {
      setState(() {
        _notes!.remove(note);
        _notes!.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  void addNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return AddNoteForm(user: _user, addNote: _addNote, parentContext: context,);
      },
    );
  }

  void showNoteDetails(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return NoteDetails(
          note: note,
          deleteNote: _deleteNote,
          parendContext: context,
        );
      },
    );
  }

  void checkLogin() {
    setState(() {
      _loginScreenCheck = true;
    });
  }

  void signOut() async {
    setState(() {
      _user = null;
      _userCredential = null;
      _notes = null;
      _loginScreenCheck = false;
      _notes = null;
    });
    await _auth.signOut();
  }

  void _handleProviderSignIn(AuthProvider authProvider) async {
    try {
      final newUserCredentials = await _auth.signInWithProvider(authProvider);
      setState(() {
        _user = _auth.currentUser;
        _userCredential = newUserCredentials;
      });
    _fetchMyNotes();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        backgroundColor: Colors.grey[400],
        centerTitle: true,
        title: const Text("Diary App"),
      ),
      body: !_loginScreenCheck
          ? LoginScreen(checkLogin: checkLogin)
          : _user != null
              ? _loggedScreenIndex == 0
                  ? ProfileScreen(
                      notes: _notes,
                      user: _user!,
                      userCredential: _userCredential,
                      signOut: signOut,
                      addNote: addNote,
                      showNoteDetails: showNoteDetails,
                    )
                  : CalandarScreen(
                    notes: _notes,
                    showNoteDetails: showNoteDetails,
                  )
              : AuthScreen(
                  handleGoogleSignIn: _handleProviderSignIn,
                  handleGitHubSignIn: _handleProviderSignIn,
                ),
      bottomNavigationBar: (!_loginScreenCheck || _user == null)
          ? null
          : Container(
              decoration: const BoxDecoration(
                  border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              )),
              child: BottomNavigationBar(
                backgroundColor: Colors.grey[300],
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today),
                    label: "Calandar",
                  ),
                ],
                currentIndex: _loggedScreenIndex,
                selectedItemColor: Colors.amber[800],
                onTap: (index) {
                  setState(() {
                    _loggedScreenIndex = index;
                  });
                },
              ),
            ),
    );
  }
}
