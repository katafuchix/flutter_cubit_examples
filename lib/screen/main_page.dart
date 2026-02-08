import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    const edgeInsets = EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20);
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text('Flutter Qubit Example'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
            child: ListView(padding: const EdgeInsets.all(2.0), children: [
          // Counter Example
          _buildListItem(
            context: context,
            title: 'Counter',
            subtitle: 'counter example',
            routePath: '/counter',
          ),
          // User API Example
          _buildListItem(
            context: context,
            title: 'Users',
            subtitle: 'Fetching API\'s with Cubits in Flutter',
            routePath: '/user',
          ),
        ])));
  }

  Widget _buildListItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String routePath,
  }) {
    const edgeInsets = EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20);
    return Container(
      margin: edgeInsets,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => context.push(routePath),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
