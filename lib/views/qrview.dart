import 'package:attendance/controllers/sms_controller.dart';
import 'package:attendance/views/settings_subview.dart';
import 'package:flutter/material.dart';
import 'package:attendance/controllers/capture_controller.dart';
import 'package:attendance/views/captured_view.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';

class QRViewPage extends StatefulWidget {
  const QRViewPage({super.key});

  @override
  State<QRViewPage> createState() => _QRViewPageState();
}

class _QRViewPageState extends State<QRViewPage> {
  Color isScanned = Colors.deepOrange;
  CaptureController captureController = CaptureController();
  ValueNotifier<bool> statusOnTime = ValueNotifier<bool>(true);
  SMSController smsController = SMSController();

  @override
  void initState() {
    smsController.getSharedPreferences();
    captureController.flagScanning();
    super.initState();
  }

  @override
  void dispose() {
    captureController.dispose();
    statusOnTime.dispose();
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
                  detectionTimeoutMs: 1000,
              );
              return Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    child: MobileScanner(
                      controller: cameraController,
                      fit: BoxFit.cover,
                      placeholderBuilder: (p0, p1) => Container(),
                      errorBuilder: (p0, p1, p2) => Container(),
                      onDetect: (capture) async {
                        final List<Barcode> barcodes = capture.barcodes;
                        captureController.flagScanned();
                        Future.delayed(const Duration(milliseconds: 700), () async {
                          captureController.flagCaptured(barcodes: barcodes);
                          captureController.setStatus(statusOnTime.value);
                          captureController.recordTimestamp();
                          cameraController.dispose();
                        });
                      },
                    ),
                  ),
                  Positioned(
                    top: 45,
                    left: 10,
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // SMSController.defaultSim = smsController.getDefaultSim();
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SettingsSubview(smsController: smsController);
                              },
                          );
                          // smsController.setDefaultSim(SMSController.defaultSim!);
                        },
                        iconSize: 35.0,
                        splashRadius: 40,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    child: Material(
                      color: Colors.deepOrange,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      child: SizedBox(
                        width: 100,
                        height: 40,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TimerBuilder.periodic(const Duration(seconds: 1), builder: (context) {
                                return Row(
                                  children: [
                                    Text(
                                      DateFormat("hh").format(DateTime.now()).toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 0),
                                      child: Text(
                                        ' : ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      DateFormat("mm").format(DateTime.now()).toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(width: 2),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        DateFormat("a").format(DateTime.now()).toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        )
                      ),
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
                        width: 200,
                        height: 65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: ValueListenableBuilder(
                                  valueListenable: statusOnTime,
                                  builder: (context, value, child) {
                                    return IconButton(
                                      icon: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(value
                                                ? Icons.timer
                                                : Icons.timer_off_outlined,
                                              color: value
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              value ? 'ON-TIME' : 'LATE',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: value
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onPressed: () => statusOnTime.value = !value,
                                      iconSize: 25.0,
                                      splashRadius: 30,
                                    );
                                  },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: VerticalDivider(width: 2, color: Colors.white.withOpacity(0.5)),
                            ),
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: IconButton(
                                splashRadius: 30,
                                color: Colors.white,
                                icon: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: ValueListenableBuilder(
                                    valueListenable: cameraController.torchState,
                                    builder: (context, state, child) {
                                      switch (state) {
                                        case TorchState.off:
                                          return const Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.flash_on_outlined,
                                                color: Colors.white,
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                'FLASH ON',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          );
                                        case TorchState.on:
                                          return const Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.flash_off_outlined,
                                                color: Colors.black,
                                              ),
                                              SizedBox(height: 3),
                                              Text(
                                                'FLASH OFF',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          );
                                      }
                                    },
                                  ),
                                ),
                                iconSize: 25.0,
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
                      strokeWidth: 10,
                      value: null,
                    ),
                  ),
                ),
              );
            case CaptureState.captured:
              return CapturedView(
                captureController: captureController,
              );
            case CaptureState.error:
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepOrange, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.deepOrange,
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  height: MediaQuery.sizeOf(context).width * 0.8 + 100,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 180, color: Colors.white),
                        const SizedBox(height: 10),
                        Text(
                          'STUDENT DATA',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'NOT FOUND!',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                elevation: 5,
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                                child: SizedBox(
                                  width: 70,
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: IconButton(
                                      splashRadius: 30,
                                      color: Colors.deepOrange,
                                      icon: const Icon(Icons.close, color: Colors.deepOrange),
                                      iconSize: 32.0,
                                      onPressed: () async {
                                        captureController.flagScanning();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
