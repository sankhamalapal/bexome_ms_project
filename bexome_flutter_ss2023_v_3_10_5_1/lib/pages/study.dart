import '../Translation/translation.dart';
import '../colors.dart';
import 'package:flutter/material.dart';
import '../data_management/user_data.dart';

// creates the study page
class Study extends StatelessWidget {
  Study({Key? key}) : super(key: key);
  Translation translate = Translation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate.getTranslation(context, 'study'),
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
              SizedBox(height: 15),
              Container(
                height: 40,
                width: (MediaQuery.of(context).size.width / 2.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade200,
                ),
                child: Text(
                  translate.getTranslation(context, 'reg_study'),
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                alignment: Alignment.center,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                  ),
                  child: Center(
                      //call the Method below to get StudyID
                      child: Text(getStudyText(context, translate))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//If there is no Study registered show "Keine Studie zugeordnet" otherwise return StudyID
getStudyText(BuildContext context, Translation translate) {
  if (getStudyID() == null) {
    return (translate.getTranslation(context, 'no_reg_study'));
  } else {
    return (getStudyID());
  }
}
