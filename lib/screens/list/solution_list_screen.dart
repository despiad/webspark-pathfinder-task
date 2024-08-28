import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webspark_task/screens/list/cubit/solution_list_cubit.dart';
import 'package:webspark_task/screens/preview/preview_screen.dart';
import 'package:webspark_task/screens/widgets/app_scaffold.dart';
import 'package:webspark_task/utils/extensions.dart';
import 'package:webspark_task/utils/utils.dart';

import '../../resources/strings.dart';

class SolutionListScreen extends StatelessWidget {
  const SolutionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SolutionListCubit(
        dataRepository: context.dependencies.dataRepository,
      )..getSolutions(),
      child: const SolutionListView(),
    );
  }
}

class SolutionListView extends StatelessWidget {
  const SolutionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: Strings.solutionListAppBarTitle,
      body: Center(
        child: BlocBuilder<SolutionListCubit, SolutionListState>(
          builder: (context, state) {
            if (state.solutions == null) {
              return const Text('Loading');
            }
            if (state.solutions!.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<SolutionListCubit>().reload();
                },
                child: ListView(children: [
                  const Text('No solutions found locally'),
                ]),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<SolutionListCubit>().reload();
              },
              child: ListView.separated(
                itemCount: state.solutions!.length,
                itemBuilder: (context, index) {
                  final s = state.solutions![index];
                  return ListTile(
                    title: Center(
                      child: Text(
                        Utils.formatPath(s.path),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return PreviewScreen(solution: s);
                        },
                      ));
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1,
                    height: 1,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
