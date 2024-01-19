import 'package:acount_manager/dashboard.dart';
import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: dashboard(),
    debugShowCheckedModeBanner: false,
  ));
}

class account extends StatefulWidget {
  static SharedPreferences? prefs;

  @override
  State<account> createState() => _accountState();
}

class _accountState extends State<account> {

  @override
  void initState() {
    super.initState();
    get();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return dashboard();
    },));
  }

  get() async {
    account.prefs = await SharedPreferences.getInstance();
  }

  String pin = "";
  PinTheme pinTheme = PinTheme(
    keysColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(-15398133),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 35.0,
                vertical: 35.0,
              ),
              child: Text(
                "Enter PIN",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Please enter your pin to continue",
              style: TextStyle(
                // color: Colors.white,
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 4; i++)
                  PinCodeField(
                    key: Key('pinField$i'),
                    pin: pin,
                    pinCodeFieldIndex: i,
                    theme: pinTheme,
                  ),
              ],
            ),
            const SizedBox(height: 80),
            CustomKeyBoard(
              pinTheme: pinTheme,
              onChanged: (v) {
                if (kDebugMode) {
                  pin = v;
                  setState(() {});
                }
              },
              maxLength: 4,
            ),
          ],
        ),
      ),
    );
  }
}

/// PinCodeField
class PinCodeField extends StatelessWidget {
  const PinCodeField({
    Key? key,
    required this.pin,
    required this.pinCodeFieldIndex,
    required this.theme,
  }) : super(key: key);

  /// The pin code
  final String pin;

  /// The the index of the pin code field
  final PinTheme theme;

  /// The index of the pin code field
  final int pinCodeFieldIndex;

  Color get getFillColorFromIndex {
    return Color(-1116861428);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 50,
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: getFillColorFromIndex,
        borderRadius: BorderRadius.zero,
        shape: BoxShape.rectangle,
        border: Border.all(
          color: getFillColorFromIndex,
          width: 2,
        ),
      ),
      duration: const Duration(microseconds: 40000),
      child: pin.length > pinCodeFieldIndex
          ? const Icon(
              Icons.circle,
              color: Colors.white,
              size: 12,
            )
          : const SizedBox(),
    );
  }
}
