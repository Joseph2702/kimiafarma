import 'package:flutter/material.dart';

class DemoBottomAppBar extends StatelessWidget {
  final VoidCallback onFabPressed;

  const DemoBottomAppBar({Key? key, required this.onFabPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.blueGrey,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              tooltip: 'Home',
              icon: const Icon(Icons.home),
              onPressed: () {
                // Handle the Home button press
              },
            ),
            IconButton(
              tooltip: 'Profile',
              icon: const Icon(Icons.person),
              onPressed: () {
                // Handle the Profile button press
              },
            ),
          ],
        ),
      ),
    );
  }
}
