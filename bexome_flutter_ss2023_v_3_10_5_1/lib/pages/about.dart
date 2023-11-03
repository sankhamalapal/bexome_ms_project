import 'dart:ui';
import '../Translation/translation.dart';
import '../colors.dart';
import 'package:flutter/material.dart';

//Class to build the About page
class About extends StatelessWidget {
  About({Key? key}) : super(key: key);
  Translation translate = Translation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate.getTranslation(context, 'about'),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade200,
                        ),
                        child: Text(
                          translate.getTranslation(context, 'privacy'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                      Center(
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                                translate.getTranslation(context,
                                    'privacy_note'), //get Studie from Admin/Datenbank
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                                textAlign: TextAlign.justify),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //  The list of used packages
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade200,
                        ),
                        child: Text(
                          translate.getTranslation(context, 'credits'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                      Center(
                        child: Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                                translate.getTranslation(
                                    context, 'credits_note'),
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                                textAlign: TextAlign.justify),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 17,
                              vertical: 10,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 2,
                                  color: thirdColor,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 30,
                                    child: Text(translate.getTranslation(
                                        context, 'app_uses_libs')),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("cupertino_icons"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("syncfusion_flutter_charts"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("sqflite"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("path_provider"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("permission_handler"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("health"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("mobile_scanner"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("shared_preferences"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("qr_code_scanner"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("http"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("geolocator"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("geocoding"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("flutter_localization"),
                                    alignment: Alignment.center,
                                  ),
                                  Divider(
                                    color: thirdColor,
                                    indent: 10,
                                    endIndent: 10,
                                    height: 20,
                                    thickness: 1,
                                  ),
                                  Container(
                                    height: 30,
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("weather"),
                                    alignment: Alignment.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
