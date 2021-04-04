import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseError {
  static String messageFromAuth(
    BuildContext context,
    FirebaseAuthException firebaseAuthError,
  ) {
    final code = firebaseAuthError.code;

    switch (code) {
      case 'email-already-in-use':
        return AppLocalizations.of(context).emailAlreadyInUse;
      case 'invalid-email':
        return AppLocalizations.of(context).invalidEmail;
      case 'weak-password':
        return AppLocalizations.of(context).weakPassword;
      case 'wrong-password':
        return AppLocalizations.of(context).wrongPassword;
      case 'user-not-found':
        return AppLocalizations.of(context).userNotFound;
      case 'too-many-requests':
        return AppLocalizations.of(context).tooManyRequests;
    }

    return firebaseAuthError.message;
  }
}
