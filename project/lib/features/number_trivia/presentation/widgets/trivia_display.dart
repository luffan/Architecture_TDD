import 'package:architecture_tdd/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    required this.numberTrivia,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: <Widget>[
          Text(
            numberTrivia.number.toString(),
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  numberTrivia.text,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}