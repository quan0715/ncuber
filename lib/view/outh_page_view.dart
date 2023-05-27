import 'package:flutter/material.dart';
import 'package:ncuber/model/person_model.dart';
import 'package:ncuber/service/portal_service.dart';

class OuthView extends StatelessWidget {
  const OuthView({Key? key}) : super(key: key);

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
            await PortalService.getPortalData();
            // Navigator.pushNamed(context, '/dashboard');
          },
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: const Text('PORTAL 登入認證'),
        ),
      )
    ]));
  }
}
