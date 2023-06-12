import 'package:attendance/controllers/capture_controller.dart';
import 'package:flutter/material.dart';

class SMSAlertDialog extends StatefulWidget {
  final bool isSent;
  final CaptureController captureController;
  const SMSAlertDialog({super.key, required this.captureController, required this.isSent});

  @override
  State<SMSAlertDialog> createState() => _SMSAlertDialogState();
}

class _SMSAlertDialogState extends State<SMSAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        width: MediaQuery.sizeOf(context).width * 0.8,
        height: MediaQuery.sizeOf(context).width * 0.8 + 100,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.isSent ? Icons.check_circle : Icons.error,
                size: 180, color: widget.isSent ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 10),
              Text(
                widget.isSent ? 'SUCCESS: SMS Sent!' : 'ERROR:\nSMS Not Sent!',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              // Text(
              //   'NOT FOUND!',
              //   style: TextStyle(
              //     color: Colors.white.withOpacity(0.5),
              //     fontSize: 26,
              //     fontWeight: FontWeight.bold,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              const SizedBox(height: 40),
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      elevation: 5,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      child: SizedBox(
                        width: 70,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: IconButton(
                            splashRadius: 30,
                            color: Colors.deepOrange,
                            icon: const Icon(Icons.close, color: Colors.deepOrange),
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
      ),
    );
  }
}
