import 'dart:developer';

import 'package:clean_calendar/clean_calendar.dart';
import 'package:diaryapp/models/note.dart';
import 'package:diaryapp/widgets/note_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalandarScreen extends StatefulWidget {
  const CalandarScreen(
      {super.key, required this.notes, required this.showNoteDetails});

  final List<Note>? notes;
  final void Function(BuildContext context, Note note) showNoteDetails;

  @override
  State<CalandarScreen> createState() => _CalandarScreenState();
}

class _CalandarScreenState extends State<CalandarScreen> {
  DateTime selectedDate = DateTime.now();

  void onSelectedDates(List<DateTime> dates) {
    if (dates.isNotEmpty) {
      setState(() {
        selectedDate = dates[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Note> filteredNotes = widget.notes!
        .where((note) =>
            note.date.year == selectedDate.year &&
            note.date.month == selectedDate.month &&
            note.date.day == selectedDate.day)
        .toList();

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          CleanCalendar(
            dateSelectionMode: DatePickerSelectionMode.singleOrMultiple,
            onSelectedDates: onSelectedDates,
            selectedDates: [selectedDate],
            selectedDatesProperties: DatesProperties(
              datesDecoration:
                  DatesDecoration(datesBackgroundColor: Colors.orange)
            ),
            currentDateProperties: DatesProperties(
              datesDecoration:
                  DatesDecoration(datesBackgroundColor: Colors.white, datesBorderColor: Colors.orange, datesTextColor: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
                "Notes (${filteredNotes.length}) for ${DateFormat('dd/MM/yyyy').format(selectedDate)}"),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: filteredNotes.isEmpty
                  ? const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                      child: Text("No notes yet for this day"),
                    )
                  : Column(
                      children: [
                        Wrap(
                          runSpacing: 10,
                          children: filteredNotes
                              .map((e) => NoteLine(
                                  note: e,
                                  showNoteDetails: widget.showNoteDetails))
                              .toList(),
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
