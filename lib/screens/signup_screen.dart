import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await authMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    print(res);

    if (res != 'success') {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
    else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 38.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              //svg image
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              //circular cutout to show selected profile pic from gallery
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 50.0,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                              'https://bugreader.com/i/avatar.jpg'),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 60,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_circle_rounded,
                            color: Colors.white70,
                          ))),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              //text field input for email
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Type your email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24.0,
              ),
              //text field input for password
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Type your new Password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 24.0,
              ),
              //text field for username
              TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'Type your username',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 24.0,
              ),
              //text field for bio
              TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'About yourself',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 24.0,
              ),
              //login button
              InkWell(
                onTap: signUpUser,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : Container(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 9),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            color: Colors.blueAccent),
                      ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
              //button to signup screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 9.0),
                      child: Text(
                        "Don't have an account?",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 9.0),
                      child: Text(
                        'Log In.',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
