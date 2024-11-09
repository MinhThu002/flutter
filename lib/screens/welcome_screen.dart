import 'package:coffee/screens/register_screen.dart';
import 'package:coffee/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:coffee/pages/homepage.dart';
import 'package:sign_in_button/sign_in_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoading = false; // Để hiển thị Spinner khi đang đăng nhập

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // // Phương thức đăng nhập Google
  // Future<User?> signInWithGoogle() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) return null; // Người dùng hủy đăng nhập

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);

  //     return userCredential.user;
  //   } catch (e) {
  //     print('Error signing in with Google: $e');
  //     return null;
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
//--------------------------------------

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      print("User canceled the sign-in process.");
      return;
    }

    GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
    //String? idToken = googleAuth?.idToken;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
    print(userCredential.user?.email);

    if (userCredential.user != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Homepage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Sign in as ${userCredential.user!.displayName!}",
        style: const TextStyle(fontSize: 18.0, color: Colors.white),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(color: Colors.blue),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 200.0),
              child: Image(
                image: AssetImage("images/logo.png"),
                width: 150, // Adjust the width 150
                height: 150, // Adjust the height 150
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Welcome Back',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const RegScreen()));
              },
              child: Container(
                height: 53,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white),
                ),
                child: const Center(
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Nút Sign in with Google
            isLoading
                ? const CircularProgressIndicator() // Hiển thị Loading spinner khi đăng nhập
                : GestureDetector(
                    onTap: () async {
                      final user = await signInWithGoogle();
                      if (user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Sign In with Google Successful!",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ));
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Homepage())); // Trang sau khi đăng nhập thành công
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Failed to sign in with Google.",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ));
                      }
                    },
                    child: Container(
                      child: Container(
                        height: 53,
                        width: 320,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                child: SignInButton(
                              Buttons.google,
                              text: "Sign in with Google",
                              onPressed: () {
                                signInWithGoogle();
                              },
                            )),
                          ],
                        ),
                      ),
                    ),
                    // const Spacer(),

                    // const SizedBox(
                    //   height: 12,
                    // ),
                  ),
          ],
        ),
      ),
    );
  }
}
