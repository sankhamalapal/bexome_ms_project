import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QR_Scanner extends StatefulWidget {
  const QR_Scanner({Key? key}) : super(key: key);

  @override
  State<QR_Scanner> createState() => _QR_ScannerState();
}

class _QR_ScannerState extends State<QR_Scanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    // TODO: implement reassemble
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Center(
            child: buildQRView(context),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            child: buildResult(),
          ),
          Positioned(
            top: 10,
            child: buildButtons(),
          )
        ]),
      ),
    );
  }

  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () async {
              await controller?.flipCamera();
              setState(() {});
            },
            icon: FutureBuilder(
              future: controller?.getCameraInfo(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Icon(Icons.switch_camera, color: Colors.white);
                } else {
                  return Container();
                }
              },
            ),
            // icon: Icon(Icons.switch_camera, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
            icon: FutureBuilder(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                return Icon(
                    (snapshot.data != null)
                        ? (snapshot.data == true
                            ? Icons.flash_on
                            : Icons.flash_off)
                        : Icons.flash_off,
                    color: Colors.white);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
          ),
        ],
      );

  Widget buildResult() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              barcode != null ? 'Result: ${barcode!.code}' : 'Scan a code',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                barcode = null;
              });
            },
            label: const Text('Clear',
                style: TextStyle(fontSize: 10, color: Colors.white)),
            icon: const Icon(Icons.clear, size: 15, color: Colors.white),
            backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
          ),
        ],
      );
  Widget buildQRView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
      });
    });
  }
}
