import 'package:pubspec_runtime/pubspec_runtime.dart';

void main() async {
  final pubspecEditor = PubspecEditor();

  print("Dependencies:");
  print(pubspecEditor.dependencies.list);

  print("Dev Dependencies:");
  print(pubspecEditor.devDependencies.list);

  print("Adding a dependency...");
  pubspecEditor.dependencies
      .add(Dependency(name: 'http', version: '^0.13.3', isDev: false));

  print("Adding a dev dependency...");

  pubspecEditor.devDependencies
      .add(Dependency(name: 'http', version: '^0.13.3', isDev: true));

  print("Add a key value pair to the `pubspec.yaml` file.");
  pubspecEditor.add("author", "John Doe");

  print("Get the value of a key from the `pubspec.yaml` file.");
  print(pubspecEditor.get("author"));

  print("Remove a key value pair from the `pubspec.yaml` file.");
  pubspecEditor.remove("author");

  print("Updated Dependencies:");
  print(pubspecEditor.dependencies.list);

  print("Saving changes...");
  pubspecEditor.save();

  print("Changes saved successfully!");

  print("Running pub get...");
  runPubGet()
      .then((value) => print(
          "Pub get executed successfully with exit code: ${value.exitCode}"))
      .catchError(
          (error) => print("Error occurred while executing pub get: $error"));
}
