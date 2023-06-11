import 'package:bdonner/provider/auth_provider.dart';
import 'package:bdonner/widgets/custom_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country country = Country(
      phoneCode: "880",
      countryCode: "BD",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Bangladesh",
      example: "Bangladesh",
      displayName: "Bangladesh",
      displayNameNoCountryCode: "BD",
      e164Key: "");
  @override
  Widget build(BuildContext context) {
    phoneController.selection =TextSelection.fromPosition(TextPosition(offset: phoneController.text.length));
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            child: Column(
              children: [
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
                Text("Register",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text("Add your phone number. We'll send you a verification code",style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 18,),
                  onChanged: (value){
                    setState(() {
                      phoneController.text = value;
                    });
                  },

                  controller: phoneController,
                  cursorColor: Colors.redAccent,
                  decoration: InputDecoration(
                    hintText: 'Enter your phone number',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Container(
                      padding: EdgeInsets.all(12),
                      child: InkWell(
                        onTap: (){
                          showCountryPicker(context: context,
                              countryListTheme: CountryListThemeData(
                                bottomSheetHeight: 400,
                              ),
                              onSelect: (value){
                            setState(() {
                              country = value;
                            });
                              },
                          );
                        },
                        child: Text("${country.flagEmoji} + ${country.phoneCode}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
                      ),
                    ),
                    suffixIcon: phoneController.text.length > 9 ? Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.done, color: Colors.white,size: 20,),
                    ):null
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: CustomButton(text: "Login", onPressed: (){
                    sendPhoneNumber();
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void sendPhoneNumber(){
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    authProvider.signInWithPhone(context, "+${country.phoneCode}${phoneNumber}");
  }
}
