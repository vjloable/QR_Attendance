import 'package:attendance/controllers/capture_controller.dart';
import 'package:attendance/views/captured_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRViewPage extends StatefulWidget {
  const QRViewPage({super.key});

  @override
  State<QRViewPage> createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {
  Color isScanned = Colors.deepOrange;
  FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
  CaptureController captureController = CaptureController();

  @override
  void initState() {
    captureController.flagScanning();
    super.initState();
  }

  @override
  void dispose() {
    captureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: captureController,
        builder: (context, child) {
          switch (captureController.state) {
            case CaptureState.scanning:
              MobileScannerController cameraController = MobileScannerController(
                  autoStart: true,
                  torchEnabled: false,
                  facing: CameraFacing.back,
                  detectionSpeed: DetectionSpeed.normal,
                  detectionTimeoutMs: 1500,
              );
              return Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    child: MobileScanner(
                      controller: cameraController,
                      fit: BoxFit.cover,
                      onDetect: (capture) async {
                        final List<Barcode> barcodes = capture.barcodes;
                        captureController.flagScanned();
                        Future.delayed(const Duration(milliseconds: 1000), () async {
                          captureController.flagCaptured(barcodes: barcodes);
                          cameraController.dispose();
                        });
                      },
                    ),
                  ),
                  Positioned(
                    top: ((MediaQuery.sizeOf(context).height / 2) - (MediaQuery.sizeOf(context).width * 0.8) / 2 - 70),
                    child: Material(
                      color: Colors.deepOrange.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(color: Colors.deepOrange.withOpacity(0.2), width: 4)),
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        height: MediaQuery.sizeOf(context).width * 0.8,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    child: Material(
                      elevation: 10,
                      color: Colors.deepOrange,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                      child: SizedBox(
                        width: 140,
                        height: 65,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: IconButton(
                                splashRadius: 30,
                                color: Colors.white,
                                icon: ValueListenableBuilder(
                                  valueListenable: cameraController.torchState,
                                  builder: (context, state, child) {
                                    switch (state) {
                                      case TorchState.off:
                                        return const Icon(Icons.flash_on_outlined,
                                            color: Colors.white);
                                      case TorchState.on:
                                        return const Icon(Icons.flash_off_outlined,
                                            color: Colors.black);
                                    }
                                  },
                                ),
                                iconSize: 32.0,
                                onPressed: () => cameraController.toggleTorch(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            case CaptureState.scanned:
              return Container(
                color: Colors.white,
                child: const Center(
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      color: Colors.deepOrange,
                      strokeWidth: 5,
                      value: null,
                    ),
                  ),
                ),
              );
            case CaptureState.captured:
              return CapturedView(
                barcodeData: captureController.getBarcodes().first.rawValue.toString(),
                captureController: captureController,
              );
          }
        },
      ),
    );
  }
}
