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
      address: data?['address'],
      birthDate: data?['birthDate'],
      contactNumber: data?['contactNumber'],
      fatherName: data?['fatherName'],
      firstName: data?['firstName'],
      id: data?['id'],
      lastName: data?['lastName'],
      middleName: data?['middleName'],
      motherName: data?['motherName'],
      qrCode: data?['qrCode'],
      sectionId: data?['sectionId'],
      studentId: data?['studentId'],
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