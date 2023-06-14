import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CaptureController extends ChangeNotifier {
  CaptureState state = CaptureState.scanning;
  List<Barcode> _barcodes = [];
  StudentState status = StudentState.absent;
  String time = "";
  String date = "";
  String timeFull = "";

  void flagCaptured({required List<Barcode> barcodes}) {
    state = CaptureState.captured;
    _barcodes = barcodes;
    notifyListeners();
  }

  void flagScanning() {
    state = CaptureState.scanning;
    notifyListeners();
  }

  void flagScanned() {
    state = CaptureState.scanned;
    notifyListeners();
  }

  void flagError() {
    state = CaptureState.error;
    notifyListeners();
  }

  List<Barcode> getBarcodes() {
    return _barcodes;
  }

  int lengthBarcode() {
    return _barcodes.length;
  }

  void setStatus(bool state) {
    switch(state) {
      case true:
        status = StudentState.onTime;
        break;
      case false:
        status = StudentState.late;
        break;
    }
  }

  String getStatus() {
    switch(status) {
      case StudentState.late:
        return "LATE";
      case StudentState.onTime:
        return "ON-TIME";
      case StudentState.absent:
        return "ABSENT";
    }
  }

  Color getStatusColor() {
    switch(status) {
      case StudentState.late:
        return Colors.red;
      case StudentState.onTime:
        return Colors.green;
      case StudentState.absent:
        return Colors.grey;
    }
  }

  IconData getStatusIconData() {
    switch(status) {
      case StudentState.late:
        return Icons.timer_off_outlined;
      case StudentState.onTime:
        return Icons.timer;
      case StudentState.absent:
        return Icons.hourglass_empty;
    }
  }

  void recordTimestamp() {
    DateTime now = DateTime.now();
    date = DateFormat("yyyy-MM-dd").format(now).toString();
    time = DateFormat("HH:mm:ss").format(now).toString();
    timeFull = DateFormat("HH:mm a").format(now).toString();
  }
}

enum CaptureState {
  scanning,
  scanned,
  captured,
  error,
}

enum StudentState {
  late,
  onTime,
  absent,
}