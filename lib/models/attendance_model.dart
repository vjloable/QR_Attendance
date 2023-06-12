// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String? id;
  final String? studentId;
  final String? date;
  final String? time;
  final String? status;
  AttendanceModel({
    this.id,
    this.studentId,
    this.date,
    this.time,
    this.status,
  });

  factory AttendanceModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return AttendanceModel(
      id: data?['id'],
      studentId: data?['studentId'],
      date: data?['date'],
      time: data?['time'],
      status: data?['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (studentId != null) "studentId": studentId,
      if (date != null) "date": date,
      if (time != null) "time": time,
      if (status != null) "status": status,
    };
  }

  static AttendanceStatus? fromStringToEnum(dynamic snapshot) {
    switch(snapshot){
      case "ON-TIME":
        return AttendanceStatus.ON_TIME;
      case "LATE":
        return AttendanceStatus.LATE;
      case "ABSENT":
        return AttendanceStatus.ABSENT;
    }
    return null;
  }

}

enum AttendanceStatus {
  ON_TIME,
  LATE,
  ABSENT,
}