import 'package:diaryapp/logic/sentiment.dart';
import 'package:diaryapp/models/sentiment.dart';
import 'package:flutter/material.dart';

class Sentiment extends StatelessWidget {
  const Sentiment(
      {super.key, required this.sentimentPercentage, this.size = 20});

  final double size;
  final int sentimentPercentage;

  @override
  Widget build(BuildContext context) {
    return Icon(
      getSentimentIcon(sentimentPercentage),
      size: size,
    );
  }
}

class Sentiments extends StatelessWidget {
  const Sentiments(
      {super.key, required this.sentimentPercentages, this.size = 20});

  final double size;
  final List<int> sentimentPercentages;

  @override
  Widget build(BuildContext context) {
    List<SentimentAverage> sentimentAverages =
        getSentimentIcons(sentimentPercentages);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...sentimentAverages.map(
          (sentimentAverage) => Column(
            children: [
              Icon(sentimentAverage.icon),
              const SizedBox(height: 8.0),
              Text("${sentimentAverage.average}%"),
            ],
          ),
        ).toList()
      ],
    );
  }
}
