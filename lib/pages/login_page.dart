import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../utils/helper_functions.dart';
import 'launcher_page.dart';


class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errMsg = '';
  bool obscureText = true;
  bool isLogin = true;

  @override
  void initState() {
    passController.text = '123456';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon( CupertinoIcons.mail_solid),
                              hintText: 'Your Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide:
                                  const BorderSide(color: Colors.blue, width: 1))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          obscureText: obscureText,
                          controller: passController,
                          decoration: InputDecoration(
                              prefixIcon: const Icon( CupertinoIcons.lock_fill),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                icon: Icon(obscureText ? CupertinoIcons.eye_slash_fill :  CupertinoIcons.eye_fill),
                              ),
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide:
                                  const BorderSide(color: Colors.blue, width: 1))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          isLogin = true;
                          _authenticate();
                        },
                        child: const Text('Login'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('New User? '),
                          const SizedBox(
                            width: 15,
                          ),
                          TextButton(
                            onPressed: () {
                              isLogin = false;
                              _authenticate();
                            },
                            child: const Text('Register here'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        errMsg,
                        style: const TextStyle(fontSize: 18),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _authenticate() async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    if(_formKey.currentState!.validate()) {
      final email = emailController.text;
      final pass = passController.text;
      final user = await provider.getUserByEmail(email);
      if(isLogin) {
        //login btn is clicked
        if(user == null) {
          _setErrorMsg('User does not exist');
        } else {
          //check password
          if(pass == user.password) {
            await setLoginStatus(true);
            await setUserId(user.userId!);
            if(mounted) Navigator.pushReplacementNamed(context, LauncherPage.routeName);
          } else {
            //password did not match
            _setErrorMsg('Wrong password');
          }
        }
      } else {
        //register btn is clicked
        if(user != null) {
          //email already exists in table
          _setErrorMsg('User already exists');
        } else {
          //insert new user
          final user = UserModel(
            email: email,
            password: pass,
            isAdmin: false,
          );
          final rowId = await provider.insertUser(user);
          await setLoginStatus(true);
          await setUserId(rowId);
          if(mounted) Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        }
      }
    }
  }

  _setErrorMsg(String msg) {
    setState(() {
      errMsg = msg;
    });
  }

}
