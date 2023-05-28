import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:ncuber/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

const String PORTAL_AUTH_CLIENT_ID = "20230503112113kHUhDzRi9J2r";
const String PORTAL_AUTH_CLIENT_SECRET = "ktCzbwsJbjQlKX2OgbzpI21ZB6VhLCFZQzyqxrhiBsXiEPRfA3urHrGgJi";
const String PORTAL_AUTH_REDIRECT_URI = "com.example.ncuber";
const String PORTAL_AUTH_AUTH_ENDPOINT = "https://portal.ncu.edu.tw/oauth2/authorization";
const String PORTAL_AUTH_TOKEN_ENDPOINT = "https://portal.ncu.edu.tw/oauth2/token";

class OuthView extends StatefulWidget {
  OuthView({Key? key}) : super(key: key);

  @override
  State<OuthView> createState() => _OuthViewState();
}

class _OuthViewState extends State<OuthView> {
  Future<Map<String, dynamic>?> reqPortalPersonData() async {
    FlutterAppAuth appAuth = const FlutterAppAuth();
    final AuthorizationTokenResponse? resp = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        PORTAL_AUTH_CLIENT_ID, // client id
        PORTAL_AUTH_REDIRECT_URI, // redirect uri
        clientSecret: PORTAL_AUTH_CLIENT_SECRET,
        serviceConfiguration:
            const AuthorizationServiceConfiguration(authorizationEndpoint: PORTAL_AUTH_AUTH_ENDPOINT, tokenEndpoint: PORTAL_AUTH_TOKEN_ENDPOINT),
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

  final NCUColor = const Color(0XFFF8C460);

  final UberColor = const Color(0XFFF27875);
  final formKey = GlobalKey<FormState>();

  void showLoginsheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChangeNotifierProvider<UserViewModel>(
        create: (context) => UserViewModel(),
        child: Consumer<UserViewModel>(
          builder: (context, model, child) => Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("NCUBER LOGIN", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const Text("輸入你的名字與學號",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                        TextFormField(
                          onChanged: model.onNameChange,
                          validator: model.nameValidator,
                          decoration: const InputDecoration(icon: Icon(Icons.people), label: Text("你的姓名"), border: InputBorder.none),
                        ),
                        TextFormField(
                          onChanged: model.onStudentIdChange,
                          validator: model.studentIdValidator,
                          decoration: const InputDecoration(icon: Icon(Icons.numbers), label: Text("你的學號"), border: InputBorder.none),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // model.login();
                              Navigator.pushNamed(context, '/dashboard', arguments: model);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          icon: Image.asset("assets/images/w_car.png", width: 30),
                          label: const Text(
                            'GO GO !!!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // child: const Text('PORTAL 登入認證'),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          text: 'NCU',
                          style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: NCUColor),
                          children: [TextSpan(text: 'BER', style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: UberColor))])),
                  Text(
                    "中大學生共乘分享平台",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO : 串上 portal OAuth 認證 API 並取得 token
                      // Navigator.pushNamed(context, '/dashboard');
                      showLoginsheet();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    icon: Image.asset("assets/images/w_car.png", width: 30),
                    label: const Text(
                      'LOGIN 登入',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // child: const Text('PORTAL 登入認證'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              left: -170,
              top: -40,
              child: Image.asset(
                "assets/images/r_car.png",
                width: 320,
              )),
          Positioned(right: -190, bottom: 0, child: Image.asset("assets/images/y_car.png", width: 320))
        ]));
  }
}
