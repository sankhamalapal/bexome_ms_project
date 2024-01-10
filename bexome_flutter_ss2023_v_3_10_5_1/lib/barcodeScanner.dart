import 'colors.dart';
import 'dbhelper/food_db_helper.dart';
import 'specifyNutrition.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qr_overlay.dart';

class BarcodeScanner extends StatefulWidget {
  String clickedFood = '';
  bool clickedWater = false;
  double calories = 0;
  double protein = 0;
  DateTime dateTime_food = DateTime.now();
  double fat = 0;
  double carbo = 0;
  bool saved = false;

  BarcodeScanner({Key? key, required this.dateTime_food});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  MobileScannerController cameraController = MobileScannerController();

  var code = "";

  bool flag = false;
  String clickedFood = '';
  static bool clickedWater = false;
  static String foodId = '';
  static double calories = 0;
  static double protein = 0;
  DateTime dateTime_food = DateTime.now();
  double fat = 0;
  double carbo = 0;
  double portion = 100;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    //get values from outside of the Stateclass (widget.)
    clickedFood = widget.clickedFood;
    clickedWater = widget.clickedWater;
    calories = widget.calories;
    protein = widget.protein;
    dateTime_food = widget.dateTime_food;
    fat = widget.fat;
    carbo = widget.carbo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: fourthColor);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 40.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(
                      Icons.camera_front,
                      color: fourthColor,
                    );
                  case CameraFacing.back:
                    return const Icon(
                      Icons.camera_rear,
                      color: fourthColor,
                    );
                }
              },
            ),
            iconSize: 40.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(children: [
        MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: (barcode, args) async {
              if (barcode.rawValue == null) {
                debugPrint('Failed to scan Barcode');
              } else {
                //reset if user pressed back button
                clickedFood = '';
                clickedWater = false;
                flag = false;
                calories = 0;
                protein = 0;
                fat = 0;
                carbo = 0;
                portion = 100;
                try {
                  //code = double.parse(barcode.rawValue!);
                  code = (barcode.rawValue!).toString();
                } catch (e) {}
                try {
                  //get name of the food
                  clickedFood = (Food_db_helper.codefoodMapMap[code]
                          ["product_name"])
                      .toString();
                } catch (e) {
                  clickedFood = '';
                  clickedWater = false;
                  setState(() {
                    //no name found --> try again
                    flag = true;
                  });

                  print(e);
                }

                //inner method
                void updateFood_Water() {
                  flag = false;
                  try {
                    clickedFood = (Food_db_helper.codefoodMapMap[code]
                            ["product_name"])
                        .toString();
                    flag = false;
                  } catch (e) {
                    setState(() {
                      //no name found --> try again
                      flag = true;
                    });
                    clickedFood = '';
                    clickedWater = false;
                    print(e);
                  }
                  clickedWater = false;
                }

                //decision if food or water
                clickedFood.toLowerCase().contains("wasser")
                    ? clickedWater = true
                    : updateFood_Water();

                if (!clickedWater) {
                  //get data from database-class
                  try {
                    foodId = code;
                    calories = (Food_db_helper.codefoodMapMap[code]["energy"])
                        .toDouble();
                    protein = (Food_db_helper.codefoodMapMap[code]["proteins"])
                            .toDouble() *
                        1000;

                    fat = (double.parse(
                            Food_db_helper.codefoodMapMap[code]["fat"])) *
                        1000;

                    carbo = (Food_db_helper.codefoodMapMap[code]
                                ["carbohydrates"])
                            .toDouble() *
                        1000;

                    portion = (Food_db_helper.codefoodMapMap[code]
                                ["serving_quantity"] ==
                            null)
                        ? 100
                        : Food_db_helper.codefoodMapMap[code]
                                ["serving_quantity"]
                            .toDouble();

                    saved = true;
                  } catch (e) {
                    print(e);

                    setState(() {});
                    calories = 0;
                    protein = 0;
                    fat = 0;
                    carbo = 0;
                    portion = 100;
                    saved = false;
                  }
                }

                debugPrint('Barcode found! $code');

                if (flag) {
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SpecifyNutrition(
                              foodId: foodId,
                              food: clickedFood,
                              water: clickedWater,
                              cal: calories,
                              prot: protein,
                              foodTime: widget.dateTime_food,
                              fats: fat,
                              carbohydrates: carbo,
                              port: portion,
                              saved: saved,
                            )),
                  );
                }
              }
            }),
        QRScannerOverlay(
          overlayColour: Colors.black.withOpacity(0.5),
          textTrue: flag,
        ),
      ]),
    );
  }
}
