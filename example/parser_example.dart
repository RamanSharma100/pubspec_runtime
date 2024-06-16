import "package:pubspec_runtime/pubspec_runtime.dart";

void main() {
  final Parser parser = Parser();

  final String filePath =
      "/media/fullyworldwebtutorials/Projects/dart_libs/runtime_yaml/pubspec.yaml";

  final Map<String, dynamic> content = parser.parseFile(filePath);

  print(content);
}
