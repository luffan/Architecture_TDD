import 'package:architecture_tdd/di/injectable.dart';
import 'package:architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:architecture_tdd/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: BlocProvider(
        create: (_) => getIt<NumberTriviaBloc>(),
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                      numberTrivia: state.trivia,
                    );
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  } else {
                    return MessageDisplay(
                      message: 'Unexpected error',
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
