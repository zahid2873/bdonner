import 'package:bdonner/pages/register_screen.dart';
import 'package:bdonner/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/bdo.png")),
              ),
            ),
            SizedBox(height: 40,),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: CustomButton(text: "Get Started", onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
              }),
            ),

          ],
        ),
      ),
    );
  }
}
