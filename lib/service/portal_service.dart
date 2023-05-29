// /// FIXME: still not working
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter_appauth/flutter_appauth.dart';
// import 'package:ncuber/model/person_model.dart';
// import 'package:http/http.dart' as http;
// // import 'package:oauth2/oauth2.dart' as oauth2;

// class PortalService {
//   static const portalAuthEndpoint =
//       "https://portal.ncu.edu.tw/oauth2/authorization";
//   static const portalTokenEndpoint = "https://portal.ncu.edu.tw/oauth2/token";
//   static const clientId = "20230503112113kHUhDzRi9J2r";
//   static const clientSecret =
//       "ktCzbwsJbjQlKX2OgbzpI21ZB6VhLCFZQzyqxrhiBsXiEPRfA3urHrGgJi";
//   static const clientRedirectUri = "com.example.ncuber://login-callback";
//   // static Future<PersonModel> getPortalData() async {
//   static Future<void> getPortalData() async {
//     // final portalAuthEndpoint =
//     //     Uri.parse("https://portal.ncu.edu.tw/oauth2/authorization");
//     // final portalTokenEndpoint =
//     //     Uri.parse("https://portal.ncu.edu.tw/oauth2/token");
//     // final clientId = "20230503112113kHUhDzRi9J2r";
//     // final clientSecret =
//     //     "ktCzbwsJbjQlKX2OgbzpI21ZB6VhLCFZQzyqxrhiBsXiEPRfA3urHrGgJi";
//     // final clientRedirectUri = Uri.parse("com.example.ncuber://login-callback");

//     // var grant = oauth2.AuthorizationCodeGrant(
//     //     clientId, portalAuthEndpoint, portalTokenEndpoint,
//     //     secret: clientSecret);

//     // var portalAuthUrl = grant.getAuthorizationUrl(clientRedirectUri);

//     // await redirect(portalAuthUrl); //TODO.
//     // var respUrl = await listen(redirectUrl); //TODO.

//     // await grant.handleAuthorizationResponse(respUrl.queryParameters);
//     FlutterAppAuth appAuth = const FlutterAppAuth();
//     final AuthorizationTokenResponse? resp =
//         await appAuth.authorizeAndExchangeCode(
//       AuthorizationTokenRequest(
//         clientId, // client id
//         clientRedirectUri, // redirect uri
//         clientSecret: clientSecret,
//         serviceConfiguration: const AuthorizationServiceConfiguration(
//             authorizationEndpoint: portalAuthEndpoint,
//             tokenEndpoint: portalTokenEndpoint),
//         scopes: [
//           'chinese-name', // 中文姓名 (使用者可以決定是否授權)
//           'gender', // 姓別 (使用者可以決定是否授權)
//           'student-id', // 學號 (學生才有, 使用者可以決定是否授權)
//           'academy-records', // 學籍資料 (學生才有, 使用者可以決定是否授權)
//           'mobile-phone' // 行動電話號碼 (使用者有在系統上登記才有, 使用者可以決定是否授權)
//         ],
//       ),
//     );

//     var accessToken = resp?.accessToken;
//     // debugPrint(resp?.scopes.toString());

//     String reqUri = "https://portal.ncu.edu.tw/apis/oauth/v1/info";

//     HttpClient httpClient = HttpClient();
//     HttpClientRequest request = await httpClient.getUrl(Uri.parse(reqUri));
//     request.headers.set('Accept', 'application/json');
//     request.headers.set('Authorization', "Bearer+$accessToken");

//     // debugPrint(jsonBody.toString());
//     // request.add(utf8.encode(jsonEncode(jsonBody)));

//     HttpClientResponse response = await request.close();

//     String reply = await response.transform(utf8.decoder).join();
//     debugPrint(response.headers.toString());
//     debugPrint(reply);
//     httpClient.close();

//     // final req = await http.post(Uri.parse(reqUri), headers: <String, String>{
//     //   'Accept': 'application/json',
//     //   'Authorization': 'Beater$accessToken'
//     // });

//     // debugPrint(req.headers.toString());
//   }
// }
