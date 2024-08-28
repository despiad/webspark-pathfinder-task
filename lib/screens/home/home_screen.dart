import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webspark_task/resources/strings.dart';
import 'package:webspark_task/screens/widgets/app_scaffold.dart';
import 'package:webspark_task/utils/extensions.dart';
import 'package:webspark_task/utils/validators.dart';
import 'package:webspark_task/screens/home/cubit/home_cubit.dart';
import 'package:webspark_task/screens/process/process_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) =>
          HomeCubit(dataRepository: context.dependencies.dataRepository),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controller =
      TextEditingController(text: 'https://flutter.webspark.dev/flutter/api');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.isError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.error!)));
        }
        if (state.success) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return ProcessScreen(url: _controller.text);
            },
          ));
        }
      },
      child: Form(
        key: _formKey,
        child: AppScaffold(
          appBarTitle: Strings.homeAppBarTitle,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    Strings.homeInputTitle,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.swap_horiz,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            validator: Validators.urlValidator,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: BlocSelector<HomeCubit, HomeState, bool>(
                      selector: (state) {
                        return state.loading;
                      },
                      builder: (context, loading) {
                        return FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            side: BorderSide(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              width: 3,
                            ),
                          ),
                          onPressed: loading
                              ? null
                              : () {
                                  _onButtonPressed(context);
                                },
                          child: const Text(Strings.homeButtonTitle),
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
      ),
    );
  }

  void _onButtonPressed(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<HomeCubit>().homeButtonPressed(_controller.text.trim());
  }
}
