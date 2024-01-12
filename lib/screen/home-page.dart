import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kimiafarma/component/botBar.dart';
import 'package:kimiafarma/component/theme.dart';
import 'package:kimiafarma/component/karyawan_model.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPickingFile = false;
  int _selectedIndex = 0;
  String searchItem = '';

  String userName = "";
  final KaryawanService _karyawanService = KaryawanService();
  User? user = FirebaseAuth.instance.currentUser;

  List<String> medicineNames = [];
  List<String> medicineTypes = [];
  List<String> medDevNames = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userData =
            await FirebaseFirestore.instance
                .collection('admin')
                .doc(user!.uid)
                .get();

        if (userData.exists) {
          String nama = userData['nama'];

          setState(() {
            userName = nama;
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  // Future<String?> _uploadImage(File file) async {
  //   try {
  //     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     Reference storageReference =
  //         FirebaseStorage.instance.ref().child('inventory_images/$fileName');
  //     UploadTask uploadTask = storageReference.putFile(file);
  //     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
  //     String downloadURL = await taskSnapshot.ref.getDownloadURL();
  //     return downloadURL;
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     return null;
  //   }
  // }

  // final List<String> medicineNames = [
  //   'Paracetamol',
  //   'Aspirin',
  //   'Ibuprofen',
  //   'Cetirizine',
  //   'Omeprazole',
  //   'Amoxicillin',
  //   'Loratadine',
  //   'Metformin',
  //   'Atorvastatin',
  //   'Losartan',
  // ];

  // final List<String> medicineTypes = [
  //   'Pain Reliever',
  //   'Pain Reliever',
  //   'Anti-Inflammatory',
  //   'Antihistamine',
  //   'Proton Pump Inhibitor',
  //   'Antibiotic',
  //   'Antihistamine',
  //   'Antidiabetic',
  //   'Statins',
  //   'Antihypertensive',
  // ];
  FloatingActionButton _buildCreateItemFAB() {
    return FloatingActionButton(
      onPressed: () async {
        await _showCreateItemModal(null);
      },
      tooltip: 'Create Item',
      child: Icon(Icons.add),
      backgroundColor: Colors.blue, // Ganti dengan warna yang diinginkan
    );
  }

  FloatingActionButton _buildCreateMedicalFAB() {
    return FloatingActionButton(
      onPressed: () async {
        await _showCreateMedicalItemModal(null);
      },
      tooltip: 'Create Medical Item',
      child: Icon(Icons.add),
      backgroundColor:
          Colors.orangeAccent, // Ganti dengan warna yang diinginkan
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBlueBase,
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
                  color: colorBlueBase,
                ),
                label: Text(
                  'Home',
                  style: TextStyle(
                      color: colorBlueBase, fontFamily: 'Poppins-Regular'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.inventory,
                  color: colorBlueBase,
                ),
                label: Text(
                  'Inventory',
                  style: TextStyle(
                      color: colorBlueBase, fontFamily: 'Poppins-Regular'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.work,
                  color: colorBlueBase,
                ),
                label: Text(
                  'Employee',
                  style: TextStyle(
                      color: colorBlueBase, fontFamily: 'Poppins-Regular'),
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.local_hospital,
                  color: colorBlueBase,
                ),
                label: Text(
                  'Medical Devices',
                  style: TextStyle(
                      color: colorBlueBase, fontFamily: 'Poppins-Regular'),
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
            child: Container(
              child: _getPage(_selectedIndex),
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? _buildCreateItemFAB()
          : _selectedIndex == 3
              ? _buildCreateMedicalFAB()
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: DemoBottomAppBar(onFabPressed: _onFabPressed),
    );
  }

  Future<void> _showCreateItemModal(String? documentId) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController stockController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    File? filePath;

    if (documentId != null) {
      // Fetch the existing item details from Firestore
      DocumentSnapshot<Map<String, dynamic>> itemData = await FirebaseFirestore
          .instance
          .collection('obat')
          .doc(documentId)
          .get();

      // Set the initial values in the controllers
      nameController.text = itemData['nama_obat'];
      stockController.text = itemData['stok'].toString();
      typeController.text = itemData['jenis'];
      priceController.text = itemData['harga'].toString();
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      documentId == null ? 'Create New Item' : 'Edit Item',
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
                      controller: typeController,
                      decoration: InputDecoration(labelText: 'Type'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(labelText: 'Price'),
                    ),
                    SizedBox(height: 16),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     try {
                    //       final ImagePicker picker = ImagePicker();
                    //       final XFile? result = await picker.pickImage(
                    //         source: ImageSource.gallery,
                    //       );

                    //       setState(() {
                    //         if (result != null) {
                    //           isPickingFile = false;
                    //           filePath = File(result.path);
                    //         } else {
                    //           // Handle the case where the user cancels the image picker
                    //           isPickingFile = false;
                    //         }
                    //       });
                    //     } catch (e) {
                    //       print('Error picking file: $e');
                    //       setState(() {
                    //         isPickingFile = false;
                    //       });
                    //     }
                    //   },
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: [
                    //       Text(
                    //         isPickingFile ? 'Picking File...' : 'Pick a File',
                    //         style: TextStyle(
                    //           color: isPickingFile ? null : Colors.white,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // if (filePath != null) {
                        //   String? imageUrl = await _uploadImage(filePath!);

                        //   if (imageUrl != null) {
                        String name = nameController.text.trim();
                        String stock = stockController.text.trim();
                        String type = typeController.text.trim();
                        String price = priceController.text.trim();

                        Map<String, dynamic> itemObat = {
                          'nama_obat': name,
                          'stok': int.parse(stock),
                          'jenis': type,
                          'harga': int.parse(price),
                          // 'gambar': imageUrl,
                        };

                        // Add the new item to the 'items' collection in Firestore
                        if (documentId == null) {
                          // Add the new item to the 'items' collection in Firestore
                          await FirebaseFirestore.instance
                              .collection('obat')
                              .add(itemObat);
                        } else {
                          // If documentId is not null, it means we are editing an existing item
                          // Update the existing item in Firestore
                          await FirebaseFirestore.instance
                              .collection('obat')
                              .doc(documentId)
                              .update(itemObat);
                        }

                        print(
                            'Name: $name, Stock: $stock, Description: $type, Price: $price');
                        // if (filePath != null) {
                        //   print('File Path: $filePath');
                        // }

                        Navigator.of(context).pop();
                        //   }
                        // }
                      },
                      child: Text(documentId == null ? 'Create' : 'Update'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showCreateMedicalItemModal(String? documentId) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController stockController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    if (documentId != null) {
      // Fetch the existing item details from Firestore
      DocumentSnapshot<Map<String, dynamic>> itemData = await FirebaseFirestore
          .instance
          .collection('alat')
          .doc(documentId)
          .get();

      // Set the initial values in the controllers
      nameController.text = itemData['nama_alat'];
      stockController.text = itemData['stok'].toString();
      priceController.text = itemData['harga'].toString();
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      documentId == null ? 'Create New Medical Device Item' : 'Edit Item',
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
                      controller: priceController,
                      decoration: InputDecoration(labelText: 'Price'),
                    ),
                    SizedBox(height: 16),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        String name = nameController.text.trim();
                        String stock = stockController.text.trim();
                        String price = priceController.text.trim();

                        Map<String, dynamic> itemAlat = {
                          'nama_alat': name,
                          'stok': int.parse(stock),
                          'harga': int.parse(price),
                        };

                        // Add the new item to the 'items' collection in Firestore
                        if (documentId == null) {
                          // Add the new item to the 'items' collection in Firestore
                          await FirebaseFirestore.instance
                              .collection('alat')
                              .add(itemAlat);
                        } else {
                          // If documentId is not null, it means we are editing an existing item
                          // Update the existing item in Firestore
                          await FirebaseFirestore.instance
                              .collection('alat')
                              .doc(documentId)
                              .update(itemAlat);
                        }

                        print('Name: $name, Stock: $stock, Price: $price');
                        // if (filePath != null) {
                        //   print('File Path: $filePath');
                        // }

                        Navigator.of(context).pop();
                        //   }
                        // }
                      },
                      child: Text(documentId == null ? 'Create' : 'Update'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<int> getDataCount() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('obat').get();

      int documentCount = querySnapshot.size;

      return documentCount;
    } catch (e) {
      print('Error reading data: $e');
      return 0;
    }
  }

  List<String> filteredMedicineNames = [];
  List<String> filteredMedicineTypes = [];
  List<String> filteredMedDeviceNames = [];

  void filterMedDev() {
    filteredMedDeviceNames.clear();

    for (int i = 0; i < medDevNames.length; i++) {
      if (medDevNames[i].toLowerCase().contains(searchItem)) {
        filteredMedDeviceNames.add(medDevNames[i]);
      }
    }
  }

  void filterData() {
    filteredMedicineNames.clear();
    filteredMedicineTypes.clear();

    for (int i = 0; i < medicineNames.length; i++) {
      if (medicineNames[i].toLowerCase().contains(searchItem)) {
        filteredMedicineNames.add(medicineNames[i]);
        filteredMedicineTypes.add(medicineTypes[i]);
      }
    }
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
                  'Welcome, $userName',
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
                    color: colorBlueBase,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.center,
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
                          FutureBuilder<int>(
                            future: getDataCount(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                int itemCount = snapshot.data ?? 0;
                                return Text(
                                  '$itemCount',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins-Bold',
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
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
                    onChanged: (value) {
                      setState(() {
                        searchItem = value.toLowerCase();
                        filterData();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('obat')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      var data = snapshot.data!.docs;
                      medicineNames = [];
                      medicineTypes = [];

                      for (var document in data) {
                        medicineNames.add(document['nama_obat']);
                        medicineTypes.add(document['jenis']);
                      }

                      filterData();

                      return ListView.builder(
                        itemCount: filteredMedicineNames.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(filteredMedicineNames[index]),
                            subtitle: Text(filteredMedicineTypes[index]),
                          );
                        },
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
        return _buildEmployeePage();
      case 3:
        return _buildMedicalDevicePage();
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
            onChanged: (value) {
              setState(() {
                searchItem = value.toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('obat').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              var data = snapshot.data!.docs;

              var filteredData = data.where((item) {
                return item['nama_obat'].toLowerCase().contains(searchItem) ||
                    item['jenis'].toLowerCase().contains(searchItem);
              }).toList();

              return ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  var item = filteredData[index];
                  return _buildInventoryItem(
                      item['nama_obat'], item['jenis'], item.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryItem(String title, String subtitle, String documentId) {
    final key = ValueKey<String>(title);

    return ListTile(
      key: key,
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Image.asset(
        'assets/item1.jpg', // Default image path if no image URL
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
              _showCreateItemModal(documentId);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              print('Delete button pressed for $title');

              bool confirmDelete = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete $title?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              // If the user confirms the delete, proceed with deletion
              if (confirmDelete == true) {
                await _deleteInventoryItem(documentId);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteInventoryItem(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('obat')
          .doc(documentId)
          .delete();
      print('Item deleted successfully');
    } catch (e) {
      print('Error deleting item: $e');
      // Handle error appropriately
    }
  }

  Widget _buildMedicalDevicePage() {
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
            onChanged: (value) {
              setState(() {
                searchItem = value.toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('alat').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              var data = snapshot.data!.docs;

              var filteredData = data.where((item) {
                return item['nama_alat'].toLowerCase().contains(searchItem) ||
                    item['stok'].toLowerCase().contains(searchItem);
              }).toList();

              return ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  var item = filteredData[index];
                  return _buildMedicalItem(
                      item['nama_alat'], item['stok'], item.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalItem(String title, int subtitle, String documentId) {
    final key = ValueKey<String>(title);

    return ListTile(
      key: key,
      title: Text(title),
      subtitle: Text(subtitle.toString()),
      leading: const Icon(
        Icons.local_hospital,
        size: 48,
        color: Colors.grey,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.orange),
            onPressed: () {
              print('Edit button pressed for $title');
              _showCreateMedicalItemModal(documentId);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              print('Delete button pressed for $title');

              bool confirmDelete = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete $title?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              // If the user confirms the delete, proceed with deletion
              if (confirmDelete == true) {
                await _deleteMedicalItem(documentId);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMedicalItem(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('alat')
          .doc(documentId)
          .delete();
      print('Item deleted successfully');
    } catch (e) {
      print('Error deleting item: $e');
      // Handle error appropriately
    }
  }

  Widget _buildEmployeePage() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('karyawan')
          .orderBy('nopekerja')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<DocumentSnapshot> documents = snapshot.data!.docs;
        List<DataRow> rows = [];
        for (var document in documents) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          DataRow row = DataRow(cells: [
            DataCell(Text(data['nopekerja']?.toString() ?? '')),
            DataCell(Text(data['nama'] ?? '')),
            DataCell(Text(data['cabang'] ?? '')),
            DataCell(Text(data['alamatToko'] ?? '')),
            DataCell(IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  // _bootcampService.deleteBootcamp(document.id);
                  _showDeleteConfirmationDialog(
                      context, document.id, data['nama']);
                })),
          ]);
          rows.add(row);
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                    height:
                        8.0), // Adjust the spacing between search and upload
                Container(
                  child: IconButton(
                    alignment: AlignmentDirectional.centerEnd,
                    visualDensity: VisualDensity.standard,
                    icon: Icon(
                      Icons.file_upload,
                      color: colorBlueBase,
                      size: 30,
                    ), // Upload icon
                    onPressed: () {
                      _karyawanService.importKaryawanfromCSV(context);
                    },
                  ),
                ),
                SizedBox(height: 0.0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('NoPekerja')),
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Cabang')),
                      DataColumn(label: Text('Alamat Toko')),
                      DataColumn(label: Text('Aksi')),
                    ],
                    rows: rows,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String documentId, String nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus data '$nama'?"),
          actions: <Widget>[
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Hapus"),
              onPressed: () {
                _karyawanService.deleteKaryawan(documentId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
