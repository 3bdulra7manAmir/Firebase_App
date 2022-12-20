import 'package:firebase/Screens/User_Information_Screen.dart';
import 'package:firebase/Widgets/CustomButton.dart';
import 'package:firebase/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
        body: SafeArea(
            child: isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  )
                : Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 30),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.arrow_back),
                            ),
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purple.shade50),
                            child: Image.asset("assets/images/image2.png"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("Verification",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Enter the OTP that have been sent to your Phone Number",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black38,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Pinput(
                            length: 6,
                            showCursor: true,
                            defaultPinTheme: PinTheme(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.purple.shade200)),
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                            onCompleted: (value) {
                              setState(() {
                                otpCode = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: CustomButton(
                                  text: ("Verifiy"),
                                  onPressed: () {
                                    if (otpCode != null) {
                                      verifiyOtp(context, otpCode!);
                                    } else {
                                      showSnakBar(
                                          context, "Enter 6-Digit code");
                                    }
                                  })),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Didn't receive any code?",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Resend new code?",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                        ])))));
  }

//verifiy OTP
  void verifiyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () {
        //checking whether user exits in the db
        ap.checkExistingUser().then((value) async {
          if (value == true) {
            //user exists on our app
          } else {
            //new user
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserInformationScreen()),
                (route) => false);
          }
        });
      },
    );
  }
}
