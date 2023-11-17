import '../Translation/translation.dart';
import '../scaff.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
import '../data_management/user_data.dart';

class MyAccount extends StatefulWidget {
  @override
  State<MyAccount> createState() => _MyAccountState();
}

// creates the form page
class _MyAccountState extends State<MyAccount> {
  Translation translate = Translation();

  final List<String> genderItems = ['männlich', 'weiblich', 'divers'];
  final List<String> genderItemsEN = ['male', 'female', 'diverse'];

  bool topText = false;

  //all the stored values
  String? gender;
  String? age;
  String? weight;
  String? streetNr;
  String? postalcode;
  String? town;
  String? workStreet;
  String? workPostalCode;
  String? workTown;

  final _formKey = GlobalKey<FormState>();
  void setCurrentUser() {
    setState(() {
      usernow = getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Inside myaccount.dart - build() ...");
    // UserData userData = getCurrentUser();
    setCurrentUser();
    //setCurrentUser(userData);

    print("Current user set");

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate.getTranslation(context, 'profile'),
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

                    // Button to save the stored Data

                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: black.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          // setState(() {
                          //   usernow = getCurrentUser();
                          // });
                          // Validator checks if all the entries are correct
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // calls Function to store saved Data in data_management in the user_data class
                            updateUserData(
                                gender!,
                                age!,
                                weight!,
                                streetNr!,
                                postalcode!,
                                town!,
                                workStreet!,
                                workPostalCode!,
                                workTown!);
                            RootApp.instance.page = 0;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RootApp()));
                          }
                        },
                        child: Center(
                          child: Icon(Icons.save),
                        ),
                      ),
                    ),
                  ],
                ),

                //
                // First section with the personal Data
                //

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),

                        Container(
                          child: Text(
                            translate.getTranslation(
                                context, 'personal_detail'),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          height: 30,
                          indent: 30,
                          endIndent: 30,
                        ),

                        Center(
                          //DropdownMenu to chose gender
                          child: DropdownButtonFormField(
                            dropdownColor: Colors.grey.shade200,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              isDense: false,
                              hintText: usernow.gender,
                              contentPadding: EdgeInsets.all(8),
                              labelStyle: TextStyle(),
                              label: topText
                                  ? Text(
                                      translate.getTranslation(
                                          context, 'gender'),
                                      style: TextStyle(fontSize: 20),
                                    )
                                  : null,
                            ),
                            elevation: 0,
                            hint:
                                (usernow.gender != null && usernow.gender != "")
                                    ? Text(usernow.gender!)
                                    : Text(
                                        translate.getTranslation(
                                            context, 'choose_gender'),
                                        style: TextStyle(fontSize: 16),
                                      ),
                            isExpanded: true,
                            items:
                                ((translate.getTranslation(context, 'lang') ==
                                            "DE")
                                        ? genderItems
                                        : genderItemsEN)
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                            onChanged: (String? value) {
                              setState(() {
                                topText = true;
                                gender = value.toString();
                              });
                            },
                            // if no valid value is chosen then print the Text
                            validator: (value) {
                              if (value == null) {
                                return translate.getTranslation(
                                    context, 'select_gender');
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 15),

                        // TextFormField to enter the Age

                        TextFormField(
                          initialValue: usernow.age,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: (usernow.age != null && usernow.age != "")
                                ? usernow.age
                                : translate.getTranslation(
                                    context, 'enter_age'),
                            label: Text(
                              translate.getTranslation(context, 'age'),
                              style: TextStyle(fontSize: 16),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          // if no valid value is chosen then print the Text
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate.getTranslation(
                                  context, 'pls_enter_age');
                            }
                            return null;
                          },
                          onSaved: (value) {
                            age = value.toString();
                          },
                        ),

                        const SizedBox(height: 15),

                        // TextFormField to enter the weight

                        TextFormField(
                          initialValue: usernow.weight,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText:
                                (usernow.weight != null && usernow.weight != "")
                                    ? usernow.weight
                                    : translate.getTranslation(
                                        context, 'enter_weight_kg'),
                            label: Text(
                              translate.getTranslation(context, 'weight_kg'),
                              style: TextStyle(fontSize: 16),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          // if no valid value is chosen then print the Text
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate.getTranslation(
                                  context, 'pls_enter_weight');
                            }
                            return null;
                          },
                          onSaved: (value) {
                            weight = value.toString();
                          },
                        ),

                        const SizedBox(height: 30),

                        //
                        // Second section with the residential address
                        //

                        Container(
                          child: Text(
                            translate.getTranslation(context, 'res_address'),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          height: 30,
                          indent: 30,
                          endIndent: 30,
                        ),

                        // TextFormField to enter the residential address

                        TextFormField(
                          initialValue: usernow.streetNr,
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: (usernow.streetNr != null &&
                                    usernow.streetNr != "")
                                ? usernow.streetNr
                                : translate.getTranslation(
                                    context, 'enter_address'),
                            label: Text(
                              translate.getTranslation(context, 'st_no') + "*",
                              style: TextStyle(fontSize: 16),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate.getTranslation(
                                  context, 'pls_enter_address');
                            }
                            return null;
                          },
                          onSaved: (value) {
                            streetNr = value.toString();
                          },
                        ),
                        const SizedBox(height: 15),

                        // TextFormField to enter the postal code

                        TextFormField(
                          initialValue: usernow.postalcode,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: (usernow.postalcode != null &&
                                    usernow.postalcode != "")
                                ? usernow.postalcode
                                : translate.getTranslation(
                                        context, 'enter_zip_code') +
                                    "*",
                            label: Text(
                              translate.getTranslation(context, 'postal_code') +
                                  "*",
                              style: TextStyle(fontSize: 16),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate.getTranslation(
                                  context, 'pls_enter_zip_code');
                            }
                            return null;
                          },
                          onChanged: (value) {
                            //Do something when changing the item if you want.
                          },
                          onSaved: (value) {
                            postalcode = value.toString();
                          },
                        ),
                        const SizedBox(height: 15),

                        // TextFormField to enter the city

                        TextFormField(
                          initialValue: usernow.town,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText:
                                (usernow.town != null && usernow.town != "")
                                    ? usernow.town
                                    : translate.getTranslation(
                                            context, 'enter_city') +
                                        "*",
                            label: Text(
                              translate.getTranslation(context, 'city') + "*",
                              style: TextStyle(fontSize: 16),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate.getTranslation(
                                  context, 'pls_enter_city');
                            }
                            return null;
                          },
                          onSaved: (value) {
                            town = value.toString();
                          },
                        ),

                        //
                        // Second section with the work address
                        //

                        const SizedBox(height: 30),
                        Container(
                          child: Text(
                            translate.getTranslation(context, 'work_address'),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          height: 30,
                          indent: 30,
                          endIndent: 30,
                        ),

                        // TextFormField to enter the work address

                        TextFormField(
                          initialValue: usernow.workStreet,
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: (usernow.workStreet != null &&
                                    usernow.workStreet != "")
                                ? usernow.workStreet
                                : translate.getTranslation(
                                    context, 'enter_work_address'),
                            label: Text(
                              translate.getTranslation(context, 'st_no'),
                              style: TextStyle(fontSize: 16),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onSaved: (value) {
                            workStreet = value.toString();
                          },
                        ),

                        const SizedBox(height: 15),

                        // TextFormField to enter the working postal code

                        TextFormField(
                          initialValue: usernow.workPostalCode,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: (usernow.workPostalCode != null &&
                                    usernow.workPostalCode != "")
                                ? usernow.workPostalCode
                                : translate.getTranslation(
                                    context, 'enter_zip_code'),
                            label: Text(
                              translate.getTranslation(context, 'postal_code'),
                              style: TextStyle(fontSize: 16),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onSaved: (value) {
                            workPostalCode = value.toString();
                          },
                        ),
                        const SizedBox(height: 15),

                        // TextFormField to enter the residential city

                        TextFormField(
                          initialValue: usernow.workTown,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: (usernow.workTown != null &&
                                    usernow.workTown != "")
                                ? usernow.workTown
                                : translate.getTranslation(
                                    context, 'enter_city'),
                            label: Text(
                              translate.getTranslation(context, 'city'),
                              style: TextStyle(fontSize: 16),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onSaved: (value) {
                            workTown = value.toString();
                          },
                        ),
                      ],
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
