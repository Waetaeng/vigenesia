import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vigenesia/Constant/Const.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'MainScreens.dart';
import 'Register.dart';
import 'package:flutter/gestures.dart';
import 'package:vigenesia/Models/Login_Model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? iduser;
  String? nama;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Future<LoginModels> postLogin(String email, String password) async {
    var dio = Dio();
    String baseurl = url;

    Map<String, dynamic> data = {"email": email, "password": password};

    try {
      final response = await dio.post(
        "$baseurl/api/login/",
        data: data,
        options: Options(headers: {'Content-type': 'application/json'}),
      );

      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        final loginModel = LoginModels.fromJson(response.data);

        return loginModel;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
    return LoginModels();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: SingleChildScrollView(
        // <-- Berfungsi Untuk  Bisa Scroll
        child: SafeArea(
          // < -- Biar Gak Keluar Area Screen HP
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/home.json',
                  width: 400,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 80),
                Text(
                  "Login Page",
                  style: GoogleFonts.quicksand(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50), // <-- Kasih Jarak Tinggi : 50px
                Center(
                  child: Form(
                    key: _fbKey,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            name: "Email",
                            controller: emailController,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                border: OutlineInputBorder(),
                                labelText: "Masukkan Email"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FormBuilderTextField(
                            obscureText:
                                true, // <-- Buat bikin setiap inputan jadi bintang " * "
                            name: "password",
                            controller: passwordController,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                border: OutlineInputBorder(),
                                labelText: "Masukkan Password"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Belum Punya Akun ? ',
                                  style: GoogleFonts.quicksand(
                                      color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Daftar',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const Register(),
                                        ),
                                      );
                                    },
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20),
                              ),
                              onPressed: () async {
                                await postLogin(emailController.text,
                                        passwordController.text)
                                    .then((value) => {
                                          if (value.data != null)
                                            {
                                              setState(() {
                                                nama = value.data!.nama!;
                                                iduser = value.data!.iduser!;
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        MainScreens(
                                                      nama: nama!,
                                                      iduser: iduser!,
                                                    ),
                                                  ),
                                                );
                                              })
                                            }
                                          else if (value.data == null)
                                            {
                                              Flushbar(
                                                title: "Failed :",
                                                message:
                                                    "Please check your email or password!",
                                                duration:
                                                    const Duration(seconds: 5),
                                                backgroundColor: Colors.red,
                                                flushbarPosition:
                                                    FlushbarPosition.TOP,
                                              ).show(context)
                                            }
                                        });
                              },
                              child: Text(
                                "MASUK",
                                style: GoogleFonts.quicksand(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
