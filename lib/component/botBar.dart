import 'package:flutter/material.dart';
import 'package:kimiafarma/component/theme.dart';

class DemoBottomAppBar extends StatelessWidget {
  final VoidCallback onFabPressed;

  const DemoBottomAppBar({Key? unikey, required this.onFabPressed})
      : super(key: unikey);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: colorBlueBase,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              tooltip: 'Home',
              icon: const Icon(Icons.home),
              onPressed: () {
                 Navigator.pushNamed(context, 'home_page');
              },
            ),
            IconButton(
              tooltip: 'Profile',
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, 'profile_page');
              },
            ),
          ],
        ),
      ),
    );
  }
}
