import 'package:flutter/material.dart';
import 'package:ncuber/ViewModel/create_carpool_view_model.dart';
import 'package:provider/provider.dart';

class CreateCarpoolView extends StatefulWidget {
  const CreateCarpoolView({super.key});

  @override
  _CreateCarpoolViewState createState() => _CreateCarpoolViewState();
}

class _CreateCarpoolViewState extends State<CreateCarpoolView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateCarPoolViewModel>(
      create: (context) => CreateCarPoolViewModel(),
      child: Consumer<CreateCarPoolViewModel>(
        builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              '發起拼車',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: '標題',
                          ),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            model.updateStartLoc(value);
                          },
                          decoration: const InputDecoration(
                            labelText: '集合地點',
                          ),
                        ),
                        TextFormField(
                          onChanged: (value) {
                            model.updateEndLoc(value);
                          },
                          decoration: const InputDecoration(
                            labelText: '目的地',
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: '出發時間',
                          ),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: '預期到達時間',
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              // debugPrint("${model.startLoc}, ${model.endLoc}");
                              Navigator.pushNamed(context, '/map',
                                  arguments: [model.startLoc, model.endLoc]);
                            },
                            child: const Text("選地點測試")),
                        ElevatedButton(
                            onPressed: () {
                              Future<TimeOfDay?> selectedTime = showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                              );
                            },
                            child: Text("${model.startTime}"))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
