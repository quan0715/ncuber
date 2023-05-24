import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
const String PORTAL_AUTH_CLIENT_ID = "20230503112113kHUhDzRi9J2r";
const String PORTAL_AUTH_CLIENT_SECRET = "ktCzbwsJbjQlKX2OgbzpI21ZB6VhLCFZQzyqxrhiBsXiEPRfA3urHrGgJi";
const String PORTAL_AUTH_REDIRECT_URI = "ncuber://login-callback"; //TODO.
const String PORTAL_AUTH_AUTH_ENDPOINT = "https://portal.ncu.edu.tw/oauth2/authorization";
const String PORTAL_AUTH_TOKEN_ENDPOINT = "https://portal.ncu.edu.tw/oauth2/token";
class OuthView extends StatelessWidget {
  const OuthView({Key? key}) : super(key: key);
  Future<Map<String, dynamic>?> reqPortalPersonData() async {
    FlutterAppAuth appAuth = const FlutterAppAuth();
    final AuthorizationTokenResponse? resp = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        PORTAL_AUTH_CLIENT_ID, // client id
        PORTAL_AUTH_REDIRECT_URI, // redirect uri
        clientSecret: PORTAL_AUTH_CLIENT_SECRET,
        serviceConfiguration:
            const AuthorizationServiceConfiguration(
              authorizationEndpoint: PORTAL_AUTH_AUTH_ENDPOINT, 
              tokenEndpoint: PORTAL_AUTH_TOKEN_ENDPOINT),
        scopes: [
          'chinese-name', // 中文姓名 (使用者可以決定是否授權)
          'gender', // 姓別 (使用者可以決定是否授權)
          'student-id', // 學號 (學生才有, 使用者可以決定是否授權)
          'academy-records', // 學籍資料 (學生才有, 使用者可以決定是否授權)
          'mobile-phone' // 行動電話號碼 (使用者有在系統上登記才有, 使用者可以決定是否授權)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Center(
        child: RichText(
            text: TextSpan(
                text: 'NCU',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                children: <TextSpan>[
              TextSpan(text: 'BER', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary))
            ])),
      ),
      Positioned(
        bottom: MediaQuery.of(context).size.height * 0.2,
        left: MediaQuery.of(context).size.width * 0.32,
        child: ElevatedButton(
          onPressed: () {
            // TODO : 串上 portal OAuth 認證 API 並取得 token
            // reqPortalPersonData();
            Navigator.pushNamed(context, '/dashboard');
          },
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: const Text('PORTAL 登入認證'),
        ),
      )
    ]));
  }
}
