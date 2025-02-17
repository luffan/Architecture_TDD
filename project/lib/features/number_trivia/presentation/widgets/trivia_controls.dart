import 'package:architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String? inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            _dispatchConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: _dispatchConcrete,
                child: Text('Search'),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _dispatchRandom,
                child: Text('Get random trivia'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _dispatchConcrete() {
    controller.clear();
    context
        .read<NumberTriviaBloc>()
        .add(GetTriviaForConcreteNumber(inputStr ?? ''));
  }

  void _dispatchRandom() {
    controller.clear();
    context.read<NumberTriviaBloc>().add(GetTriviaForRandomNumber());
  }
}
