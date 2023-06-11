import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CaptureController extends ChangeNotifier {
  CaptureState state = CaptureState.scanning;
  List<Barcode> _barcodes = [];
  StudentState status = StudentState.unmarked;

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
      case StudentState.unmarked:
        return "UNMARKED";
    }
  }

  Color getStatusColor() {
    switch(status) {
      case StudentState.late:
        return Colors.red;
      case StudentState.onTime:
        return Colors.green;
      case StudentState.unmarked:
        return Colors.grey;
    }
  }

  IconData getStatusIconData() {
    switch(status) {
      case StudentState.late:
        return Icons.timer_off_outlined;
      case StudentState.onTime:
        return Icons.timer;
      case StudentState.unmarked:
        return Icons.hourglass_empty;
    }
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
  unmarked,
}