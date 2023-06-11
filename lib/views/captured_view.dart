import 'dart:async';
import 'dart:convert';

import 'package:attendance/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:attendance/controllers/capture_controller.dart';
import 'package:attendance/models/qr_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';

class CapturedView extends StatefulWidget {
  final CaptureController captureController;
  const CapturedView({
    Key? key,
    required this.captureController,
  }) : super(key: key);

  @override
  State<CapturedView> createState() => _CapturedViewState();
}

class _CapturedViewState extends State<CapturedView> {
  late Map<String, dynamic> studentMap;
  QRModel studentQR = QRModel('', '');
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future<bool> _isPermissionGranted() async => await Permission.sms.status.isGranted;
  Future<bool?> get _supportCustomSim async => await BackgroundSms.isSupportCustomSim;

  void _getPermission() async {
    await [
      Permission.sms,
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
      studentMap = jsonDecode(widget.captureController.getBarcodes().first.rawValue.toString());
      studentQR = QRModel.fromJson(studentMap);
    } on FormatException {
      debugPrint('Error: Wrong QR details to be parsed!');
      widget.captureController.flagError();
    }
  }

  Future<StudentModel?> readDataStore() async {
    final sectionRef = firebaseFirestore.collection("sections").doc(studentQR.sectionID.toString());
    final check = await sectionRef.get().then((value) => value.exists);
    if (!check) {
      widget.captureController.flagError();
    }
    final studentRef = sectionRef.collection("students").doc(studentQR.studentID.toString());
    final recheck = await studentRef.get().then((value) => value.exists);
    if (!recheck) {
      widget.captureController.flagError();
    }
    final completeStudentRef = studentRef.withConverter(
        fromFirestore: StudentModel.fromFirestore,
        toFirestore: (StudentModel student, _) => student.toFirestore());
    final studentSnap = await completeStudentRef.get();
    final student = studentSnap.data();
    return student;
  }

  @override
  void initState() {
    _initStudentDetails();
    readDataStore();
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  FutureBuilder(
                    initialData: null,
                    future: readDataStore(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                      ? snapshot.data != null
                          ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey.shade100,
                            ),
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(child: Icon(Icons.info_outline, size: 100, color: Colors.grey.shade700)),
                                    const SizedBox(height: 10),
                                    const Center(
                                      child: Text(
                                        'STUDENT INFORMATION',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 11),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 3),
                                      child: Divider(color: Colors.black.withOpacity(0.3), thickness: 1),
                                    ),
                                    const SizedBox(height: 11),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Name:         ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${snapshot.data?.firstName.toString()} ${snapshot.data?.middleName.toString()} ${snapshot.data?.lastName.toString()}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'ID Number:',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${snapshot.data?.studentId.toString()}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Birthdate:   ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${snapshot.data?.birthDate.toString()}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Section ID: ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${snapshot.data?.sectionId.toString()}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 3),
                                      child: Divider(color: Colors.black.withOpacity(0.3), thickness: 1),
                                    ),
                                    const SizedBox(height: 11),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Parents:',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '    ${snapshot.data?.fatherName.toString()}  &  ${snapshot.data?.motherName.toString()}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Contact #:  ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${snapshot.data?.contactNumber.toString()}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    Row(
                                      children: [
                                        const Text(
                                          'Address:     ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${snapshot.data?.address.toString()}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 11),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 3),
                                      child: Divider(color: Colors.black.withOpacity(0.3), thickness: 1),
                                    ),
                                    const SizedBox(height: 11),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'STATUS:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          Icon(widget.captureController.getStatusIconData(), size: 40, color: widget.captureController.getStatusColor()),
                                          Text(
                                            widget.captureController.getStatus(),
                                            style: TextStyle(
                                              color: widget.captureController.getStatusColor(),
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    SizedBox(
                                      height: 60,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Material(
                                            elevation: 5,
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            color: Colors.deepOrange,
                                            child: SizedBox(
                                              width: 90,
                                              child: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: IconButton(
                                                  splashRadius: 30,
                                                  color: Colors.white,
                                                  icon: const Icon(Icons.keyboard_return, color: Colors.white),
                                                  iconSize: 32.0,
                                                  onPressed: () async {
                                                    widget.captureController.flagScanning();
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
                          )
                          : Container()
                      : Container(
                          height: 300,
                          color: Colors.transparent,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  color: Colors.deepOrange,
                                  strokeWidth: 5,
                                  value: null,
                                ),
                              ),
                            ],
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*const SizedBox(height: 100),
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
                                    icon: const Icon(Icons.document_scanner_rounded, color: Colors.deepOrange),
                                    iconSize: 32.0,
                                    onPressed: () async {
                                      readDataStore();
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
                            ),*/