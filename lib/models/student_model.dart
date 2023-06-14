import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String? address;
  final String? birthDate;
  final String? contactNumber;
  final String? fatherName;
  final String? firstName;
  final String? id;
  final String? lastName;
  final String? middleName;
  final String? motherName;
  final String? qrCode;
  final String? sectionId;
  final String? studentId;

  StudentModel({
      this.address = '',
      this.birthDate = '',
      this.contactNumber = '',
      this.fatherName = '',
      this.firstName = '',
      this.id = '',
      this.lastName = '',
      this.middleName = '',
      this.motherName = '',
      this.qrCode = '',
      this.sectionId = '',
      this.studentId = ''
  });

  factory StudentModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return StudentModel(
      address: data?['address'].toString(),
      birthDate: data?['birthDate'].toString(),
      contactNumber: data?['contactNumber'].toString(),
      fatherName: data?['fatherName'].toString(),
      firstName: data?['firstName'].toString(),
      id: data?['id'].toString(),
      lastName: data?['lastName'].toString(),
      middleName: data?['middleName'].toString(),
      motherName: data?['motherName'].toString(),
      qrCode: data?['qrCode'].toString(),
      sectionId: data?['sectionId'].toString(),
      studentId: data?['studentId'].toString(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (address != null) "address": address,                          //
      if (birthDate != null) "birthDate": birthDate,
      if (contactNumber != null) "contactNumber": contactNumber,
      if (fatherName != null) "fatherName": fatherName,                 //
      if (firstName != null) "firstName": firstName,                    //
      if (id != null) "id": id,
      if (lastName != null) "lastName": lastName,                       //
      if (middleName != null) "middleName": middleName,                 //
      if (motherName != null) "motherName": motherName,                 //
      if (qrCode != null) "qrCode": qrCode,
      if (sectionId != null) "sectionId": sectionId,
      if (studentId != null) "studentId": studentId,
    };
  }
}