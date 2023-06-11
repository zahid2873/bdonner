import 'package:bdonner/pages/otp_screen.dart';
import 'package:bdonner/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:firebase_storage/firebase_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String  ? _uid;
  String get uid => _uid!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential)async{
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error){
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(verificationId: verificationId)));

          },
          codeAutoRetrievalTimeout: (verificationId){});
    }
    on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message.toString());
    }

  }
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  })async{
    _isLoading = true;
    notifyListeners();
    try{
      PhoneAuthCredential creds = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: userOtp);
      User ? user = (await _firebaseAuth.signInWithCredential(creds)).user!;
      if(user != null){
        _uid = user.uid;
        onSuccess();

      }
    }on FirebaseAuthException catch(e){
      showSnackbar(context, e.message.toString());
    }
  }



  Future<bool>checkExistingUser()async{
    DocumentSnapshot snapshot = await _firebaseFirestore.collection("users").doc().get();
    if(snapshot.exists){
      print("User Exists");
      return true;
    }else{
      print("New User");
      return false;
    }
  }

}