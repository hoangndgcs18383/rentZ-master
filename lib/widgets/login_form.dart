import 'package:apartment_project/models/apartments.dart';
import 'package:apartment_project/models/user.dart';
import 'package:apartment_project/screens/home_page.dart';
import 'package:apartment_project/shares/custom_color.dart';
import 'package:apartment_project/shares/vadidator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/dashboard_screen.dart';
import 'custom_form_field.dart';



class LoginForm extends StatefulWidget {
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;

  const LoginForm({
    Key? key,
    required this.passwordFocusNode,
    required this.usernameFocusNode,
  }) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _uidController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final UserData user = UserData();
  final _loginInFormKey = GlobalKey<FormState>();
  @override

  void initState() {
    _uidController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override

  void dispose(){
    _uidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    return Form(
      key: _loginInFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 24.0,
            ),
            child: Column(
              children: [
                CustomFormField(
                  controller: _uidController,
                  focusNode: widget.usernameFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validateEmail(
                    email: value,
                  ),
                  label: 'Username',
                  hint: 'Enter your username',
                ),
                SizedBox(height: 24.0,),
                CustomFormField(
                  controller: _passwordController,
                  focusNode: widget.passwordFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validatePassword(
                    password: value,
                  ),
                  label: 'Password',
                  hint: 'Enter your password',
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0.0, right: 0.0),
            child: Container(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    CustomColors.firebaseOrange,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: ()  async {
                  widget.usernameFocusNode.unfocus();
                  widget.passwordFocusNode.unfocus();
                  if (_loginInFormKey.currentState!.validate()) {
                    dynamic result = await user.signWithEmailAndPassword(_uidController, _passwordController);
                    if(result == null){
                      print("error");
                    }
                    else{
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(),
                        ),
                      );
                    }
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.firebaseBlack,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}