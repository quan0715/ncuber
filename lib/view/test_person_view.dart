import 'package:flutter/material.dart';
import 'package:ncuber/model/person_model.dart';
import 'package:ncuber/service/server_service.dart';

class TestPersonView extends StatefulWidget {
  const TestPersonView({super.key});

  @override
  State<TestPersonView> createState() => TestPersonViewState();
}

class TestPersonViewState extends State<TestPersonView> {
  final _tffControllers = List.generate(6, (index) {
    final _tffTexts = [
      'Username',
      'phone',
      'stuId',
      'gender',
      'department',
      'grade'
    ];
    return TextEditingController(text: _tffTexts[index]);
  });

  Future<void> _sendPerson() async {
    var personModel = PersonModel(
      name: _tffControllers[0].text,
      phone: _tffControllers[1].text,
      stuId: _tffControllers[2].text,
      gender: (_tffControllers[3].text == '男')
          ? 1
          : (_tffControllers[3].text == '女')
              ? 2
              : 0,
      department: _tffControllers[4].text,
      grade: _tffControllers[5].text,
    );
    await sendPersonModel(personModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      ListView.builder(
        itemCount: _tffControllers.length,
        itemBuilder: (context, index) {
          return TextFormField(
            controller: _tffControllers[index],
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: _tffControllers[index].text,
            ),
          );
        },
      ),
      Center(
        child: ElevatedButton(
          onPressed: () => _sendPerson(),
          child: const Text('送出'),
        ),
      ),
    ]));
  }
}
