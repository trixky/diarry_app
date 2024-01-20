import 'package:diaryapp/models/note.dart';
import 'package:diaryapp/widgets/sentiment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteLine extends StatelessWidget {
  const NoteLine(
      {super.key, required this.note, required this.showNoteDetails});

  final Note note;
  final void Function(BuildContext context, Note note) showNoteDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showNoteDetails(context, note);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(6),
        child: SizedBox(
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: TextStyle(),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    note.content,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[500],
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 14,
            ),
            Sentiment(sentimentPercentage: note.feeling),
            const SizedBox(
              width: 14,
            ),
            SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('EEEE').format(note.date)),
                  Text(DateFormat.yMd().format(note.date)),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
