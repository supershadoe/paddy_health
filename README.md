This app demonstrates how to integrate tflite models using `tflite_flutter`
plugin with a Flutter app for image classification.

Uses riverpod to inject the model's interpreter that's cached during startup.

### How to run

Clone repo -> Develop a ML model to classify/use a pre-trained model ->
Run `flutter pub get` -> Use the app

The original model used to test in this app is not uploaded in the repo as the
file is too big. Modify the `classify()` function to fit your needs.

### License

This code is licensed under MIT License. Check the LICENSE file for more details.
