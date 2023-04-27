import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_book_app/helpers/firestores_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/firebaseauth_helpers.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final GlobalKey<FormState> insertKey = GlobalKey<FormState>();

  TextEditingController authController = TextEditingController();
  TextEditingController bookController = TextEditingController();

  String? authName;
  String? bName;
  Uint8List? imageBytes;

  getImageGallery() async {
    ImagePicker picker = ImagePicker();

    XFile? xFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );
    imageBytes = await xFile!.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffFF5F6D),
                Color(0xffFFC371),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.teal,
        title: Text(
          "Add Book Details",
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuthHelper.firebaseAuthHelper.logOut();

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('login_page', (route) => false);
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add Book Details",
              style:
                  GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: insertKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () async {
                          ImagePicker picker = ImagePicker();

                          XFile? xFile = await picker.pickImage(
                            source: ImageSource.camera,
                            imageQuality: 40,
                          );

                          imageBytes = await xFile!.readAsBytes();
                          setState(() {});
                        },
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.orange.shade100,
                          foregroundImage: (imageBytes != null)
                              ? MemoryImage(imageBytes!)
                              : null,
                          child: const Text(
                            "ADD",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: bookController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter Book Name First.....";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        bName = val;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "Enter Book Name here....",
                        labelText: "Book Name",
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: authController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter Author Name First.....";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          authName = val;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "Enter Author Name here....",
                          labelText: "Author Name",
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (insertKey.currentState!.validate()) {
                              insertKey.currentState!.save();

                              Map<String, dynamic> data = {
                                "book": bName,
                                "author": authName,
                                "image": base64Encode(imageBytes!),
                              };

                              await FirestoreHelper.firestoreHelper
                                  .insertRecords(data: data);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Record Inserted Successfully..."),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );

                              bookController.clear();
                              authController.clear();

                              setState(() {
                                bName = null;
                                authName = null;
                                imageBytes = null;
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.red,
                            ),
                            child: Text(
                              "ADD",
                              style: GoogleFonts.ubuntu(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.redAccent.shade100,
    );
  }
}
