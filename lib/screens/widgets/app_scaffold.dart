import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String appBarTitle;

  final Widget body;

  const AppScaffold({super.key, required this.appBarTitle, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(appBarTitle),
      ),
      body: body,
    );
  }
}
