import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class QRViewPage extends StatefulWidget {
  const QRViewPage({super.key});

  @override
  State<QRViewPage> createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  Color isScanned = Colors.deepOrange;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: double.infinity,
                  color: Colors.deepOrange,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height  * 0.9,
                  width: double.infinity,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      QRView(
                        overlay: QrScannerOverlayShape(
                            borderWidth: 20,
                            borderRadius: 20,
                            borderColor: isScanned,
                        ),
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height  * 0.2,
                        child: Center(
                          child: (result != null)
                              ? Text('${result!.code}', style: const TextStyle(color: Colors.white))
                              : const Text('Scan a code', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Opacity(
                          opacity: 0.7,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.deepOrange,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Text(
                              'SHOW DETAILS',
                              style: TextStyle(fontSize: 18), textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if(scanData.code!.length >= 9){
        await controller.pauseCamera();
      }
      setState(() {
        result = scanData;
        isScanned = Colors.lightGreenAccent;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}