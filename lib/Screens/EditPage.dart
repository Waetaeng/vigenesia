import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vigenesia/Constant/Const.dart';
import '/Models/Motivasi_Model.dart';
import '/Screens/MainScreens.dart';

class EditPage extends StatefulWidget {
  final String? id;
  final String? isi_motivasi;

  const EditPage({
    Key? key,
    this.id,
    this.isi_motivasi,
  }) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String baseurl = url;

  var dio = Dio();
  Future<dynamic> putPost(String isi_motivasi, String ids) async {
    Map<String, dynamic> data = {"isi_motivasi": isi_motivasi, "id": ids};
    var response = await dio.put(
      '$baseurl/api/dev/PUTmotivasi',
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    print("---> ${response.data} + ${response.statusCode}");

    return response.data;
  }

  TextEditingController isiMotivasiC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          'Edit Data',
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 300,
                    child: Card(
                      elevation: 10,
                      child: Center(
                        child: Text(
                          "Motivasi: ${widget.isi_motivasi}",
                          style: GoogleFonts.quicksand(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: FormBuilderTextField(
                      name: "isi_motivasi",
                      controller: isiMotivasiC,
                      decoration: InputDecoration(
                        labelText: "Masukkan Motivasi Baru",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      putPost(isiMotivasiC.text, widget.id!).then((value) => {
                            if (value != null)
                              {
                                Navigator.pop(context),
                                Flushbar(
                                  title: "Success :",
                                  message:
                                      "Perubahan disimpan. Silahkan refresh",
                                  duration: const Duration(seconds: 5),
                                  backgroundColor: Colors.green,
                                  flushbarPosition: FlushbarPosition.TOP,
                                ).show(context)
                              }
                          });
                    },
                    child: Text(
                      "Simpan",
                      style: GoogleFonts.quicksand(fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
