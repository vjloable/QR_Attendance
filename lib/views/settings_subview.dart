import 'package:attendance/controllers/sms_controller.dart';
import 'package:flutter/material.dart';

class SettingsSubview extends StatefulWidget {
  final SMSController smsController;
  const SettingsSubview({super.key, required this.smsController});

  @override
  State<SettingsSubview> createState() => _SettingsSubviewState();
}

class _SettingsSubviewState extends State<SettingsSubview> {
  String? defaultSim;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Colors.deepOrange,
            height: 50,
            width: MediaQuery.sizeOf(context).width,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    const Text('Default Sim:', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 50,
                              child: Radio(
                                activeColor: Colors.white,
                                fillColor: const MaterialStatePropertyAll(Colors.white),
                                value: "Sim 1",
                                groupValue: defaultSim,
                                onChanged: (value) {
                                  setState(() {
                                    defaultSim = value.toString();
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text('Sim 1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyan,
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 50,
                              child: Radio(
                                activeColor: Colors.white,
                                fillColor: const MaterialStatePropertyAll(Colors.white),
                                value: "Sim 2",
                                groupValue: defaultSim,
                                onChanged: (value) {
                                  setState(() {
                                    defaultSim = value.toString();
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text('Sim 2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
