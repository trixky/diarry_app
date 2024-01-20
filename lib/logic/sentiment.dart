import 'package:diaryapp/models/sentiment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const _sentimentVeryDissatisfied = 25;
const _sentimentDissatisfied = 50;
const _sentimentNeutral = 75;
const _sentimentSatisfied = 100;

IconData getSentimentIcon(int percentage) {
  if (percentage <= _sentimentVeryDissatisfied) {
    return Icons.sentiment_very_dissatisfied_rounded;
  } else if (percentage <= _sentimentDissatisfied) {
    return Icons.sentiment_dissatisfied;
  } else if (percentage <= _sentimentNeutral) {
    return Icons.sentiment_neutral;
  } else {
    return Icons.sentiment_satisfied;
  }
}

List<SentimentAverage> getSentimentIcons(List<int> percentages) {
  double sentimentVeryDissatisfiedTotal = 0;
  double sentimentDissatisfiedTotal = 0;
  double sentimentNeutralTotal = 0;
  double sentimentSatisfiedTotal = 0;

  for (final percentage in percentages) {
    if (percentage < _sentimentVeryDissatisfied) {
      sentimentVeryDissatisfiedTotal++;
    } else if (percentage < _sentimentDissatisfied) {
      sentimentDissatisfiedTotal++;
    } else if (percentage < _sentimentNeutral) {
      sentimentNeutralTotal++;
    } else {
      sentimentSatisfiedTotal++;
    }
  }

  final double total = sentimentVeryDissatisfiedTotal +
      sentimentDissatisfiedTotal +
      sentimentNeutralTotal +
      sentimentSatisfiedTotal;

  return <SentimentAverage>[
    SentimentAverage(
        icon: getSentimentIcon(_sentimentVeryDissatisfied),
        average: sentimentVeryDissatisfiedTotal <= 0 ? 0 : ((sentimentVeryDissatisfiedTotal / total) * 100).toInt()),
    SentimentAverage(
        icon: getSentimentIcon(_sentimentDissatisfied),
        average: sentimentDissatisfiedTotal <= 0 ? 0 : ((sentimentDissatisfiedTotal / total) * 100).toInt()),
    SentimentAverage(
        icon: getSentimentIcon(_sentimentNeutral),
        average: sentimentNeutralTotal <= 0 ? 0 : ((sentimentNeutralTotal / total) * 100).toInt()),
    SentimentAverage(
        icon: getSentimentIcon(_sentimentSatisfied),
        average: sentimentSatisfiedTotal <= 0 ? 0 : ((sentimentSatisfiedTotal / total) * 100).toInt()),
  ];
}
