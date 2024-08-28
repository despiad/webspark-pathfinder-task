import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webspark_task/screens/list/solution_list_screen.dart';
import 'package:webspark_task/utils/extensions.dart';
import 'package:webspark_task/screens/process/cubit/process_cubit.dart';

import '../../resources/strings.dart';
import '../widgets/app_scaffold.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProcessCubit>(
      create: (context) => ProcessCubit(
        dataRepository: context.dependencies.dataRepository,
      )..getAndProcessGrids(url),
      child: ProcessView(url: url),
    );
  }
}

class ProcessView extends StatelessWidget {
  const ProcessView({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProcessCubit, ProcessState>(
      listener: (context, state) {
        if (state is SuccessSendingResultsState) {
          Navigator.of(context)
            ..pop()
            ..push(MaterialPageRoute(
              builder: (context) {
                return const SolutionListScreen();
              },
            ));
        }
        if (state.error != null) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Something went wrong'),
                content: Text('${state.error!}\nPlease try again from the start.'),
                actions: [
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: AppScaffold(
        appBarTitle: Strings.processAppBarTitle,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Spacer(),
                BlocBuilder<ProcessCubit, ProcessState>(
                  builder: (context, state) {
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            state.statusText,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${state.percents}%',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          SizedBox.square(
                            dimension: 120,
                            child: CircularProgressIndicator(
                              value: state.percents / 100 + 0.01,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                const Spacer(),
                Center(
                  child: BlocBuilder<ProcessCubit, ProcessState>(
                    builder: (context, state) {
                      return FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            width: 3,
                          ),
                        ),
                        onPressed: state.disableButton
                            ? null
                            : () {
                                _onButtonPressed(context, state, url);
                              },
                        child: const Text(Strings.processButtonTitle),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(
    BuildContext context,
    ProcessState state,
    String url,
  ) {
    context.read<ProcessCubit>().sendSolutions(url);
  }
}
