import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ncuber/view_model/user_view_model.dart';

class OuthView extends StatefulWidget {
  const OuthView({Key? key}) : super(key: key);

  @override
  State<OuthView> createState() => _OuthViewState();
}

class _OuthViewState extends State<OuthView> {
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
                              model.login();
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
