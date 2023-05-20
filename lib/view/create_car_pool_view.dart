import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';

class CreateCarpoolView extends StatefulWidget {
  const CreateCarpoolView({super.key});

  @override
  _CreateCarpoolViewState createState() => _CreateCarpoolViewState();
}

class _CreateCarpoolViewState extends State<CreateCarpoolView> {
  @override
  Widget build(BuildContext context) {
    // create new car pool view
    // with form
    // 1. Title (Text)
    // 2. start time (DateTime) time picker
    // 3. start loc(Text)
    // 4. end time (DateTime) time picker
    // 5. end loc(Text)
    // person number limit (number)
    // total except cost (number)
    // gender limit (male / female /none)
    // rating standard (number slider: float)
    return Scaffold(
      appBar: AppBar(
        title: const Text('發起拼車'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const Text('發起拼車'),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '標題',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '集合地點',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '目的地',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '人數上限',
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
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '備註',
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '性別限制',
                      ),
                    ),
                    ElevatedButton(
                        onPressed: (){
                          // final places = GoogleMapsPlaces(
                          //     apiKey:
                          //         "AIzaSyC4vGfQQlBs3BLelaaghVkaIccn6xS-GTk");
                          // PlacesSearchResponse response =
                          //     await places.searchByText("國立中央大學");
                          // final lat = response.results.first.geometry!.location.lat;
                          // final lng = response.results.first.geometry!.location.lng;
                          // MapUiPage();
                          MapLocationPicker(
                            apiKey: "AIzaSyC4vGfQQlBs3BLelaaghVkaIccn6xS-GTk",
                            onNext: (GeocodingResult? result) {
                              debugPrint('test');
                            },
                          );
                        },
                        child: const Text("選地點測試"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
