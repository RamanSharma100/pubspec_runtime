import 'package:pubspec_runtime/pubspec_runtime.dart';
import 'package:test/expect.dart';
import 'package:test/test.dart';

void main() {
  group("Change Dependencies at runtime", () {
    final pubspecEditor = PubspecEditor();

    test("Add a dependency", () {
      final dependency =
          Dependency(name: 'http', version: '^0.13.3', isDev: false);
      pubspecEditor.dependencies.add(dependency);

      expect(pubspecEditor.dependencies.list, anyElement(dependency.toMap()));
    });

    test("Save changes", () {
      final dependency =
          Dependency(name: 'http', version: '^0.13.3', isDev: false);
      pubspecEditor.dependencies.add(dependency);
      pubspecEditor.save();

      // Create a new instance to simulate loading from the saved state
      final pubspecEditor2 = PubspecEditor();

      // Validate dependency is persisted
      expect(pubspecEditor2.dependencies.list, anyElement(dependency.toMap()));
    });
  });

  group("Change Dev Dependencies at runtime", () {
    final pubspecEditor = PubspecEditor();

    test("Add a dev dependency", () {
      final dependency =
          Dependency(name: 'http', version: '^0.13.3', isDev: true);
      pubspecEditor.devDependencies.add(dependency);
      pubspecEditor.save();

      expect(
          pubspecEditor.devDependencies.list, anyElement(dependency.toMap()));
    });

    test("Save changes", () {
      final dependency =
          Dependency(name: 'http', version: '^0.13.3', isDev: true);
      pubspecEditor.devDependencies.add(dependency);
      pubspecEditor.save();

      // Create a new instance to simulate loading from the saved state
      final pubspecEditor2 = PubspecEditor();

      // Validate dev dependency is persisted
      expect(
          pubspecEditor2.devDependencies.list, anyElement(dependency.toMap()));
    });
  });
}
