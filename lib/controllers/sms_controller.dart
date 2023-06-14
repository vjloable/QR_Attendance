import 'package:attendance/models/student_model.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SMSController {
  Future<bool> isSMSPermissionGranted() async => await Permission.sms.status.isGranted;
  Future<bool?> get supportCustomSim async => await BackgroundSms.isSupportCustomSim;
  late SharedPreferences prefs;

  void getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setDefaultSim(String sim) async {
    await prefs.setString('defaultsim', sim);
  }

  String? getDefaultSim() {
    return prefs.getString('defaultsim');
  }

  void getSMSPermission() async {
    await [
      Permission.sms,
    ].request();
  }

  Future<bool> sendMessage(String phoneNumber, String message, {int? simSlot}) async {
    SmsStatus value = SmsStatus.failed;
    value = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: simSlot);
    print("sendMessage: $value");
    return value == SmsStatus.sent;
  }

  String message(StudentModel student, String time, String date, String status) {
    String header = "Attendance [$date]:\n";
    String body = "Student: ${student.firstName}\nTime arrival: $time\nMark: $status\n";
    String footer = "\nSent via SMS Blast\n(Do not reply)";
    return "$header$body$footer";
  }

  int getSimNumerical() {
    int returnable = 1;
    switch(prefs.getString('defaultsim')) {
      case 'Sim 1':
        returnable = 1;
        break;
      case 'Sim 2':
        returnable = 2;
    }
    return returnable;
  }
}