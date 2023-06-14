import 'package:attendance/controllers/capture_controller.dart';
import 'package:attendance/models/student_model.dart';
import 'package:flutter/material.dart';

class SMSAlertDialog extends StatefulWidget {
  final bool isSent;
  final CaptureController captureController;
  final StudentModel? studentModel;
  const SMSAlertDialog({
    super.key,
    required this.captureController,
    required this.isSent,
    this.studentModel,
  });

  @override
  State<SMSAlertDialog> createState() => _SMSAlertDialogState();
}

class _SMSAlertDialogState extends State<SMSAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 0.5,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
        ),
        width: MediaQuery.sizeOf(context).width * 0.9,
        height: MediaQuery.sizeOf(context).height * 0.3,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Center(
              child: Icon(
                widget.isSent ? Icons.check_circle_outline_outlined : Icons.error,
                size: 60, color: widget.isSent ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.isSent
                    ? 'SMS has been sent to ${widget.studentModel?.contactNumber.toString()}'
                    : 'SMS has not been sent',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.fitWidth,
                child: Text(
                  widget.isSent
                      ? 'For changes, go to the administrators\' page.'
                      : 'It might be due to invalid phone number,\nor unavailable sim.',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            const Spacer(),
            Center(
              child: SizedBox(
                height: 50,
                width: 100,
                child: TextButton(
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Navigator.pop(context);
                    });
                    Future.delayed(const Duration(milliseconds: 100), () {
                      widget.captureController.flagScanning();
                    });
                  },
                  child: const Text('CLOSE', style: TextStyle(color: Colors.deepOrange, fontSize: 17)),
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
