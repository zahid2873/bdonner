import 'package:bdonner/pages/user_information_screen.dart';
import 'package:bdonner/provider/auth_provider.dart';
import 'package:bdonner/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String ? otp;

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider
        .of<AuthProvider>(context, listen: true)
        .isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true ? Center(
          child: CircularProgressIndicator(color: Colors.redAccent,),) :
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                  ),
                  child: Image.asset("assets/image2.png"),
                ),
                SizedBox(height: 20,),
                Text("Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(
                  "Add your phone number. We'll send you a verification code",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                  textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                Pinput(
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.redAccent),
                    ),
                    textStyle: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onCompleted: (value) {
                    setState(() {
                      otp = value;
                    });
                  },
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 50,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: CustomButton(text: "Verify", onPressed: () {
                    if (otp != null) {
                      verifyOtp(context, otp!);
                    } else {
                      showSnackbar(context, "Enter 6-digit otp code");
                    }
                  }),
                ),
                SizedBox(height: 20,),
                Text("Don't receive any code?", style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38),),
                SizedBox(height: 10,),
                Text("Resend New Code?", style: TextStyle(fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyOtp(BuildContext context, String userOtp) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.verifyOtp(context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: () {
      
      authProvider.checkExistingUser().then((value) async{
          if(value==true){

          } else{
            Navigator.push(context, MaterialPageRoute(builder: (context)=>UserInformationScreen()));
          }
      });

        });
  }
}
