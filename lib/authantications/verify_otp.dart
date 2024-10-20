import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../home_screen.dart';

class VerifyOtp extends StatefulWidget {
  final String verifycationId;

  const VerifyOtp({super.key, required this.verifycationId});

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  TextEditingController pinputController = TextEditingController();
  List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back_ios, color: Colors.orange),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Image.asset("assets/images/Sign-up2.png"),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Enter Verification Code",
              style: TextStyle(fontSize: 16, color: Colors.brown),
            ),
            SizedBox(height: 5),
            Text(
              "We have sent SMS to:",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              "Your phone number", // You can update this dynamically
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return _buildOTPField(context, otpControllers[index]);
              }),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                String otp = otpControllers.map((e) => e.text).join(); // Join all OTP parts
                if (otp.length == 6) {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: widget.verifycationId,
                    smsCode: otp,
                  );
                  verifyOtp(credential);
                } else {
                  Fluttertoast.showToast(msg: "Please enter a valid 6-digit OTP.");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text(
                "Sign Up",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPField(BuildContext context, TextEditingController controller) {
    return Container(
      width: 40,
      height: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future<void> verifyOtp(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        Fluttertoast.showToast(msg: "OTP Verified successfully!");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to verify OTP. Try again.");
    }
  }
}
