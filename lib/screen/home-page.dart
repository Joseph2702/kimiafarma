import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  final List<String> medicineNames = [
    'Paracetamol',
    'Aspirin',
    'Ibuprofen',
    'Cetirizine',
    'Omeprazole',
    'Amoxicillin',
    'Loratadine',
    'Metformin',
    'Atorvastatin',
    'Losartan',
  ];

  final List<String> medicineTypes = [
    'Pain Reliever',
    'Pain Reliever',
    'Anti-Inflammatory',
    'Antihistamine',
    'Proton Pump Inhibitor',
    'Antibiotic',
    'Antihistamine',
    'Antidiabetic',
    'Statins',
    'Antihypertensive',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromARGB(255, 96, 125, 139),
        // title: Text('Kimia Farma'),
        leading: SvgPicture.asset(
          'assets/kimiafarma.svg',
          height: 20,
          width: double.infinity,
        ),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: Icon(
                  Icons.home,
                  color: Colors.blueGrey,
                ),
                label: Text(
                  'Home',
                  style: TextStyle(
                      color: Colors.blueGrey, fontFamily: 'Poppins-Regular'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.inventory,
                  color: Colors.blueGrey,
                ),
                label: Text(
                  'Inventory',
                  style: TextStyle(
                      color: Colors.blueGrey, fontFamily: 'Poppins-Regular'),
                ),
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
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Welcome, Username',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Bold',
                      color: Colors.black),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: 200,
                  child: Card(
                    color: Colors.blueGrey,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Medicine in capacity',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins-Bold',
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '10',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins-Bold',
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search, color: Colors.blueGrey),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                      ),
                    ),
                    cursorColor: Colors.blueGrey,
                    onChanged: (value) {
                      // Handle search functionality here
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: medicineNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(medicineNames[index]),
                        subtitle: Text(medicineTypes[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: DemoBottomAppBar(),
        );

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
