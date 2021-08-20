import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/helper/theme.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chatrooms.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController = new TextEditingController();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  singUp() async {
    if(isvalidate()) {
      setState(() {
        isLoading = true;
      });

      await authService.signUpWithEmailAndPassword(emailEditingController.text,
          passwordEditingController.text).then((result) {
        if (result != null) {
          Map<String, String> userDataMap = {
            "userName": usernameEditingController.text,
            "userEmail": emailEditingController.text
          };

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              usernameEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text);

          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
      });
    }
  }

  bool isvalidate(){
    String Username = usernameEditingController.text;
    String email = emailEditingController.text;
    String passord = passwordEditingController.text;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

    if(email==null || email.isEmpty){
      PrintToast("Please enter email id");
      return false;
    }else if(Username==null || Username.isEmpty){
      PrintToast("Please enter Username");
      return false;
    }else if(!emailValid){
      PrintToast("Please enter valid email id");
      return false;
    }else if(passord==null || passord.isEmpty){
      PrintToast("Please enter your password");
      return false;
    }else if(passord.length<6){
      PrintToast("Password's length should be more than 6");
      return false;
    }
    return true;
  }

  void PrintToast(String str){
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
      : SingleChildScrollView (
        child:Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 0, top:160, right: 0, bottom:0),
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40.0,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 0, top:10, right: 0, bottom:0),
                padding: EdgeInsets.all(10),
                child: TextFormField(
                    controller: emailEditingController,
                    decoration: _decorate("Enter Email", "Email Id")
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                    controller: usernameEditingController,
                    decoration: _decorate("Enter Username", "username")
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                    obscureText: true,
                    controller: passwordEditingController,
                    decoration: _decorate("Password", "Password")
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  singUp();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ],
                      )),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sign Up",
                    style: biggerTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "have an account? ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggleView();
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decorate(String hintText, String labelText) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      border: new OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.teal)
      ),
      contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
    );
  }
}
