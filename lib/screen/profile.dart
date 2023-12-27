import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  TextEditingController phoneNumberController =
      TextEditingController(text: '0893245561223');
  TextEditingController roleController =
      TextEditingController(text: 'Apoteker');

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(4, 9, 35, 1),
                Color.fromRGBO(39, 105, 171, 1),
              ],
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 73),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'My\nProfile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Center(
                  //   child: CircleAvatar(
                  //     radius: 80,
                  //     backgroundColor: Colors.blue,
                  //     child: Icon(
                  //       Icons.person,
                  //       size: 100,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                  Container(
                    height: height * 0.50,
                    width: width * 1,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double innerHeight = constraints.maxHeight;
                        double innerWidth = constraints.maxWidth;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: innerHeight * 0.78,
                                width: innerWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: innerHeight * 0.20,
                                    ),
                                    Text(
                                      'Joko',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Joko@gmail.com',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Divider(
                                      thickness: 2,
                                    ),
                                    TextField(
                                      controller: phoneNumberController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: 'No Telp',
                                        labelText: 'No Telp',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        enabled: false,
                                        labelStyle: TextStyle(
                                          color: Colors
                                              .black54, // Warna teks label
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black, // Warna teks input
                                      ),
                                    ),
                                    TextField(
                                      controller: roleController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Role',
                                        labelText: 'Role',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        enabled: false,
                                        labelStyle: TextStyle(
                                          color: Colors
                                              .black54, // Warna teks label
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black, // Warna teks input
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: innerHeight * 0.5 - 155,
                              left: innerWidth * 0.5 - 60,
                              child: Center(
                                child: Container(
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      Icons.person,
                                      size: 100,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.14),
                  Container(
                    width: width,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: height * 0.07,
                            width: width * 0.20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Atur sesuai kebutuhan
                              border: Border.all(
                                color: Colors.white, // Warna border
                                width: 2.0, // Lebar border
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Fungsi yang akan dijalankan saat tombol back ditekan
                              },
                              icon: Icon(Icons.arrow_back),
                              color: Colors.white, // Warna ikon back
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: height * 0.07,
                          width: width *  0.70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                              // Lebar border
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Fungsi yang akan dijalankan saat tombol logout ditekan
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                            ),
                            child: Text('LOG OUT'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
        )
      ],
    );
  }
}
