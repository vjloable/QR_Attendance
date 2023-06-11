import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CaptureController extends ChangeNotifier {
  CaptureState state = CaptureState.scanning;
  List<Barcode> _barcodes = [];

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

  List<Barcode> getBarcodes() {
    return _barcodes;
  }

  int lengthBarcode() {
    return _barcodes.length;
  }

}

enum CaptureState {
  scanning,
  scanned,
  captured,
}