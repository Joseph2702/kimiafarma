import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  String errorMessage = ''; // Menyimpan pesan kesalahan

  // Function untuk menangani ketika "Forgot Password?" ditekan
  void _handleForgotPassword() {
    // Logika untuk menghandle lupa password
    print('Forgot Password tapped');
    // Misalnya, tampilkan dialog reset password atau navigasi ke halaman reset password.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color.fromARGB(255, 209, 208, 208),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color.fromARGB(255, 1, 3, 110),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 145, 144, 144).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar Gudang
              Image.asset(
                'assets/obat.png',
                width: 200.0,
                height: 200.0,
              ),

              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 201, 120, 0).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                        errorText:
                            errorMessage.isNotEmpty ? errorMessage : null,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        errorText:
                            errorMessage.isNotEmpty ? errorMessage : null,
                      ),
                      obscureText: !isPasswordVisible,
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: _handleForgotPassword,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Logika autentikasi
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();

                  // Validasi email dan password (tambahkan validasi sesuai kebutuhan)
                  if (email == 'user@example.com' && password == 'password') {
                    // Tambahkan logika autentikasi di sini
                    // Misalnya, panggil metode login(email, password)
                    // Jika berhasil, pindah ke halaman beranda
                    // Jika gagal, tampilkan pesan kesalahan
                    setState(() {
                      errorMessage =
                          ''; // Reset pesan kesalahan jika login berhasil
                    });
                    print('Login successful');
                  } else {
                    // Tampilkan pesan kesalahan jika email atau password salah
                    setState(() {
                      errorMessage = 'Email or password is incorrect';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 201, 120, 0),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Masuk',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
