import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:ncuber/constants/api_key.dart';
import 'dart:convert';

// /// Reference: https://pjchender.dev/internet/note-oauth2/
// String generateAuthBasicToken() {
//   var key = PORTAL_APP_CLIENT_ID;
//   var secret = PORTAL_APP_CLIENT_SECRET;
//   var token = "$key:$secret";
//   var bytes = utf8.encode(token);
//   var base64Encoded = base64.encode(bytes);

//   return base64Encoded;
// }

Future<Map<String, dynamic>> reqPortalPersonData(
    String studentId, String password) async {
  FlutterAppAuth appAuth = new FlutterAppAuth();
  final AuthorizationTokenResponse? resp =
      await appAuth.authorizeAndExchangeCode(
    AuthorizationTokenRequest(
      PORTAL_AUTH_CLIENT_ID,
      PORTAL_AUTH_REDIRECT_URI,
      clientSecret: PORTAL_AUTH_CLIENT_SECRET,
      serviceConfiguration: const AuthorizationServiceConfiguration(
          authorizationEndpoint: PORTAL_AUTH_AUTH_ENDPOINT,
          tokenEndpoint: PORTAL_AUTH_TOKEN_ENDPOINT),
      scopes: [
        'chinese-name',     // 中文姓名 (使用者可以決定是否授權)
        'gender',           // 姓別 (使用者可以決定是否授權)
        'student-id',       // 學號 (學生才有, 使用者可以決定是否授權)
        'academy-records',  // 學籍資料 (學生才有, 使用者可以決定是否授權)
        'mobile-phone'      // 行動電話號碼 (使用者有在系統上登記才有, 使用者可以決定是否授權)
      ], // TODO.
    ),
  );

  
}

/// Reference: https://medium.com/nexl-engineering/oauth-authentication-in-flutter-app-and-set-up-graphql-with-authentication-token-d2b3f65fee2e
// class OAuthIdToken {

// }


// class PortalAuthService {
//   static final PortalAuthService instance = PortalAuthService._internal();
//   factory PortalAuthService() => instance;
//   PortalAuthService._internal();

//   final FlutterAppAuth appAuth = const FlutterAppAuth();
//   final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

//   OAuthIdToken? idToken; // FIXME.
//   String? oAuthAccessToken;

//   Future<bool> init() async {
//     final storedRefreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);

//     if (storedRefreshToken == null) {
//       return false;
//     }

//     try {
//       final TokenResponse? result = await appAuth.token(TokenRequest(
//           PORTAL_APP_CLIENT_ID, PORTAL_REDIRECT_URI,
//           issuer: PORTAL_AUTH_ENDPOINT, refreshToken: storedRefreshToken));
//       final String setResult = await _setLocalVariables(result);
//       return setResult == 'Success';
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<String> login() async {
//     try {
//       final authorizationTokenRequest = AuthorizationTokenRequest(
//           PORTAL_APP_CLIENT_ID, PORTAL_REDIRECT_URI,
//           issuer: PORTAL_AUTH_ENDPOINT,
//           clientSecret: PORTAL_APP_CLIENT_SECRET,
//           scopes: [/*TODO*/]);
//       final AuthorizationTokenResponse? result =
//           await appAuth.authorizeAndExchangeCode(
//         authorizationTokenRequest,
//       );

//       return await _setLocalVariables(result);
//     } on PlatformException catch (e) {
//       debugPrint("User has cancelled or no internet!");
//       return "User has cancelled or no internet!";
//     } catch (e) {
//       return 'Unknown Error!';
//     }
//   }

//   OAuthIdToken parseIdToken(String idToken) {
//     final parts = idToken.split(r'.');
//     assert(parts.length == 3);
//     final Map<String, dynamic> json = jsonDecode(
//       utf8.decode(
//         base64Url.decode(
//           base64Url.normalize(parts[1]),
//         ),
//       ),
//     );
//     return OAuthIdToken.fromJson(json);
//   }

//   Future<String> _setLocalVariables(result) async {
//     final bool isValidResult =
//         result != null && result.accessToken != null && result.idToken != null;
//     if (isValidResult) {
//       oAuthAccessToken = result.accessToken;
//       idToken = parseIdToken(result.idToken!);
//       await secureStorage.write(
//         key: ACCESS_TOKEN_KEY,
//         value: result.accessToken,
//       );
//       if (result.refreshToken != null) {
//         await secureStorage.write(
//           key: REFRESH_TOKEN_KEY,
//           value: result.refreshToken,
//         );
//       }
//       return 'Success';
//     } else {
//       return 'Something is Wrong!';
//     }
//   }
// }
