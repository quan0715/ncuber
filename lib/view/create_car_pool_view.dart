import 'package:flutter/material.dart';

class CreateCarpoolView extends StatefulWidget {
  const CreateCarpoolView({super.key});

  @override
  _CreateCarpoolViewState createState() => _CreateCarpoolViewState();
}

class _CreateCarpoolViewState extends State<CreateCarpoolView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('建立共乘'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.cancel),
        ),
      ),
    );
  }
}
