import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

String name = '';
String email = '';
String image = '';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  nextPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const DetailsScreen()));
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      setState(() {
        name = user!.displayName.toString();
        email = user.email.toString();
        image = user.photoURL.toString();
      });
      nextPage();
      if (kDebugMode) {
        print("Signed in as ${user?.displayName}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error signing in with Google: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOGLE SIGNIN'),
      ),
      body: Center(
        child: SizedBox(
          height: 60,
          width: 300,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: _signInWithGoogle,
            child: const Text('LOGIN WITH GOOGLE',style: TextStyle(fontSize: 20),),
          ),
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GOOGLE SIGNIN Details'.toUpperCase()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(image),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(name),
            const SizedBox(
              height: 10,
            ),
            Text(email),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
