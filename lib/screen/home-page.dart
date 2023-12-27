import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kimiafarma/component/botBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Kimia Farma'),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
                label: Text(
                  'Home',
                  style: TextStyle(
                      color: Colors.blue, fontFamily: 'Poppins-Regular'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.inventory,
                  color: Colors.blue,
                ),
                label: Text(
                  'Inventory',
                  style: TextStyle(
                      color: Colors.blue, fontFamily: 'Poppins-Regular'),
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
              onPressed: _showCreateItemModal,
              tooltip: 'Create',
              child: Icon(Icons.add),
              backgroundColor: Colors.orangeAccent,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: DemoBottomAppBar(onFabPressed: _onFabPressed),
    );
  }

  Future<void> _showCreateItemModal() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController stockController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String? filePath;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Create New Item',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    filePath = result.files.single.path;
                  }
                },
                child: Text('Pick a File'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String name = nameController.text.trim();
                  String stock = stockController.text.trim();
                  String description = descriptionController.text.trim();

                  print('Name: $name, Stock: $stock, Description: $description');
                  if (filePath != null) {
                    print('File Path: $filePath');
                  }

                  Navigator.pop(context);
                },
                child: Text('Create'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onFabPressed() {
    print('FAB pressed');
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
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  child: Card(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Medicine in capacity',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins-Bold',
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '10',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins-Bold',
                              color: Colors.white,
                            ),
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
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    cursorColor: Colors.blue,
                    onChanged: (value) {},
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
    final key = ValueKey<String>(title);

    return ListTile(
      key: key,
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Image.asset(
        imagePath,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.orange),
            onPressed: () {
              print('Edit button pressed for $title');
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              print('Delete button pressed for $title');
            },
          ),
        ],
      ),
    );
  }
}
