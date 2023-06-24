import 'dart:io';

import 'package:bdonner/provider/auth_provider.dart';
import 'package:bdonner/utils/utils.dart';
import 'package:bdonner/widgets/custom_button.dart';
import 'package:flutter/material.dart';
//import 'package:phoneauth_firebase/model/user_model.dart';
//import 'package:phoneauth_firebase/provider/auth_provider.dart';
//import 'package:phoneauth_firebase/screens/home_screen.dart';
//import 'package:phoneauth_firebase/utils/utils.dart';
//import 'package:phoneauth_firebase/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import 'home_screen.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  var  bloodGroupController ;
  var _bloodGroup = [
    "A(+ve)",
    "B(+ve)",
    "O(+ve)",
    "AB(+ve)",
    "A(-ve)",
    "B(-ve)",
    "O(-ve)",
    "AB(-ve)"
  ];

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    //bloodGroupController.dispose();
  }

  // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

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
            : SingleChildScrollView(
          padding:
          const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
          child: Center(
            child: Column(
              children: [
                InkWell(
                  onTap: () => selectImage(),
                  child: image == null
                      ? const CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 50,
                    child: Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Colors.white,
                    ),
                  )
                      : CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 50,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // name field
                      textFeld(
                        hintText: "Enter your name",
                        icon: Icons.account_circle,
                        inputType: TextInputType.name,
                        maxLines: 1,
                        controller: nameController,
                      ),

                      // email
                      textFeld(
                        hintText: "Enter your email",
                        icon: Icons.email,
                        inputType: TextInputType.emailAddress,
                        maxLines: 1,
                        controller: emailController,
                      ),

                      // bio
                      // textFeld(
                      //   hintText: "Enter your bio here...",
                      //   icon: Icons.edit,
                      //   inputType: TextInputType.name,
                      //   maxLines: 2,
                      //   controller: bloodGroupController,
                      // ),
                      Container(
                        //padding: EdgeInsets.only(left: 10),
                       decoration: BoxDecoration(
                         color: Colors.redAccent.withOpacity(0.5),
                         borderRadius: BorderRadius.circular(10)
                       ),
                        height: 60,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(6),
                        //height: 20,
                        //width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.purple,),
                                child: Icon(Icons.bloodtype,color: Colors.red,size: 20,)),
                            DropdownButton(

                              // Initial Value
                              value: bloodGroupController,
                              hint: Text('Drop your blood group'),

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: _bloodGroup.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items,style: TextStyle(fontSize: 14),),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (newValue) {
                                setState(() {
                                  bloodGroupController = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: CustomButton(
                    text: "Continue",
                    onPressed: () => storeData(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.purple,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.purple,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple.shade50,
          filled: true,
        ),
      ),
    );
  }

  // store user data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      bloodGroup: bloodGroupController,
      profilePic: "",
      createdAt: "",
      phoneNumber: "",
      uid: "",

    );
    if (image != null) {
      ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                  (value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                      (route) => false),
            ),
          );
        },
      );
    } else {
      showSnackbar(context, "Please upload your profile photo");
    }
  }
}
