import 'package:flutter/material.dart';
import 'package:kimiafarma/component/botBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onHomePressed() {
    print('Home button pressed');
  }

  void _onInventoryPressed() {
    print('Inventory button pressed');
  }

  void _onProfilePressed() {
    print('Profile button pressed');
  }

  void _onFabPressed() {
    print('FAB pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text('Kimia Farma'),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                label: Text('Inventory'),
              ),
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            child: Center(
              child: _getPage(_selectedIndex),
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: _onFabPressed,
              tooltip: 'Create',
              child: Icon(Icons.add),
              backgroundColor: Colors.orangeAccent,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: DemoBottomAppBar(onFabPressed: _onFabPressed),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return Text('Home Page');
      case 1:
        return _buildInventoryPage();
      case 2:
        return Text('Profile Page');
      default:
        return Text('Invalid Page');
    }
  }

  Widget _buildInventoryPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {},
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _buildInventoryItem(
                  'Item 1', 'Description for Item 1', 'assets/item1.jpg'),
              _buildInventoryItem(
                  'Item 2', 'Description for Item 2', 'assets/item2.jpg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryItem(String title, String subtitle, String imagePath) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Image.asset(
        imagePath,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
      ),
    );
  }
}
