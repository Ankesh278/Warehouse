import 'dart:async';
import 'package:Lisofy/Warehouse/User/getuserlocation.dart';
import 'package:Lisofy/Warehouse/User/userverifyotp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthUserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isResending => _isResending;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setResending(bool value) {
    _isResending = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setLoading(false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', user.email ?? '');
        await prefs.setString('Name', user.displayName ?? '');
        await prefs.setBool('isUserLoggedIn', true);

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const GetUserLocation()),
                (route) => false,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Signed in successfully with ${user.email}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setErrorMessage('Something went wrong. Please try again.');
    } finally {
      if (context.mounted) {
        setLoading(false);
      }
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber, BuildContext context) async {
    setLoading(true);
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          setLoading(false);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (kDebugMode) {
            print("Error occurred here${e.message}");
          }
          setErrorMessage("Some error occurred here");
          setLoading(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          String newPhone = phoneNumber;
          if (newPhone.startsWith("+91")) {
            newPhone = newPhone.replaceFirst("+91", "");
          }setLoading(false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserVerifyOtp.userVerifyOtp(
                verificationId: verificationId,
                phoneNumber: newPhone,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setLoading(false);
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      setErrorMessage('Failed to verify phone number. Please try again.');
      setLoading(false);
    }
  }
}

