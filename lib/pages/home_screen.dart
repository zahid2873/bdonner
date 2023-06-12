import 'package:bdonner/pages/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(title: Text("home"),
      actions: [
        IconButton(onPressed: (){
          ap.userSignOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>WelcomeScreen()));
        }, icon: Icon(Icons.logout_outlined))
      ],
      ),
    );
  }
}
