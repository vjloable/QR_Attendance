import 'dart:convert';

import 'package:attendance/controllers/capture_controller.dart';
import 'package:attendance/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';

class CapturedView extends StatefulWidget {
  final String barcodeData;
  final CaptureController captureController;
  const CapturedView({
    Key? key,
    required this.barcodeData,
    required this.captureController,
  }) : super(key: key);

  @override
  State<CapturedView> createState() => _CapturedViewState();
}

class _CapturedViewState extends State<CapturedView> {
  late Map<String, dynamic> studentMap;
  StudentModel student = StudentModel('', '');
  Future<bool> _isPermissionGranted() async => await Permission.sms.status.isGranted;
  Future<bool?> get _supportCustomSim async => await BackgroundSms.isSupportCustomSim;

  void _getPermission() async {
    await [
      Permission.sms,
      Permission.camera,
    ].request();
  }

  void _sendMessage(String phoneNumber, String message, {int? simSlot}) async {
    var result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: simSlot);
    if (result == SmsStatus.sent) {
      print("Sent");
    } else {
      print("Failed");
    }
  }

  void _initStudentDetails() {
    try {
      studentMap = jsonDecode(widget.barcodeData);
      student = StudentModel.fromJson(studentMap);
    } on FormatException {
      debugPrint('Error: Wrong QR details to be parsed!');
    }
  }

  @override
  void initState() {
    _initStudentDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.shade100,
                  ),
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  height: 450,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student ID: ${student.studentID}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'Section ID: ${student.sectionID}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: IconButton(
                                splashRadius: 30,
                                color: Colors.white,
                                icon: const Icon(Icons.sms, color: Colors.deepOrange),
                                iconSize: 32.0,
                                onPressed: () async {
                                  if (await _isPermissionGranted()) {
                                    if ((await _supportCustomSim)!){
                                      _sendMessage('09682667442', 'Automated message:\nSend testing sim 2', simSlot: 2);
                                    } else {
                                      _sendMessage('09682667442', 'Automated message:\nSend testing default sim');
                                    }
                                  } else{
                                    _getPermission();
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: IconButton(
                                splashRadius: 30,
                                color: Colors.white,
                                icon: const Icon(Icons.keyboard_return, color: Colors.deepOrange),
                                iconSize: 32.0,
                                onPressed: () async {
                                  widget.captureController.flagScanning();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
