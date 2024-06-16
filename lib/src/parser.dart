import 'package:pubspec_runtime/src/dependency.dart';

/// class Parser used to parse the yaml file
class Parser {
  /// Parse the content of a YAML file.
  ///
  /// The [content] parameter is the content of the file to parse.
  /// Returns a map of the parsed content.
  Map<String, dynamic> parse(String content) {
    final lines = content.split('\n');
    final result = <String, dynamic>{};
    final stack = <Map<String, dynamic>>[result];
    // final lineNumbersStart

    int currentIndent = -1;

    for (String line in lines) {
      int lineNumber = lines.indexOf(line);
      final indent = line.indexOf(RegExp(r'[^\s]'));
      line = line.trim();

      if (line.trim().isEmpty) {
        (stack.last)["space$lineNumber"] = {
          "indent": currentIndent,
          "line": lineNumber
        };
        continue;
      }

      while (indent <= currentIndent) {
        stack.removeLast();
        currentIndent -= 2;
      }

      if (line.startsWith("#")) {
        (stack.last)["comment$lineNumber"] = {
          "content": line,
          "indent": currentIndent,
          "line": lineNumber
        };
        continue;
      }

      if (line.startsWith("- ")) {
        String value = line.substring(2).trim();

        if (stack.last.isEmpty && stack.last.values.last is! List) {
          stack.last[stack.last.keys.last] = [];
        }

        if (stack.last.values.last is List) {
          (stack.last.values.last as List).add(parseValue(value));
        }
      } else {
        final parts = line.split(":");
        final key = parts[0].trim();
        final value = parts.length > 1 ? parts.sublist(1).join(':').trim() : '';

        if (value.isNotEmpty) {
          if (stack.first.isNotEmpty) {
            String lastKey = stack.first.keys.toList().last;
            if (lastKey == "dependencies" || lastKey == "dev_dependencies") {
              String version = parseValue(value);

              if (lastKey == "dependencies") {
                List dependencies = [];
                if (stack.last.isEmpty) {
                  stack.last["list"] = [];
                }
                dependencies = stack.last["list"];
                dependencies.add(
                    Dependency(name: key, version: version, isDev: false)
                        .toMap());
                stack.last["list"] = dependencies;
              }

              if (lastKey == "dev_dependencies") {
                List devDependencies = [];
                if (stack.last.isEmpty) {
                  stack.last["list"] = [];
                }
                devDependencies = stack.last["list"];
                devDependencies.add(
                    Dependency(name: key, version: version, isDev: true)
                        .toMap());
                stack.last["list"] = devDependencies;
              }
            } else {
              (stack.last)[key] = {
                "value": parseValue(value),
                "line": lineNumber,
                "indent": currentIndent,
              };
            }
          } else {
            (stack.last)[key] = {
              "value": parseValue(value),
              "line": lineNumber,
              "indent": currentIndent,
            };
          }
        } else {
          final newMap = <String, dynamic>{};
          (stack.last)[key] = newMap;
          stack.add(newMap);
          currentIndent = indent;
        }
      }
    }

    return result;
  }

  dynamic parseValue(String value) {
    if (value == "null") return null;
    if (value == 'true') return true;
    if (value == 'false') return false;
    if (double.tryParse(value) != null) return double.parse(value);
    return value;
  }

  /// Convert a map to a YAML string.
  ///
  /// The [map] parameter is the map to convert.
  String mapToYamlString(Map<dynamic, dynamic> yamlMap, {int indent = 0}) {
    final buffer = StringBuffer();
    final spaces = ' ' * indent;

    yamlMap.forEach((key, value) {
      if (key.contains(RegExp(r'^space[0-9]+$'))) {
        buffer.writeln(spaces);
      } else if (key.contains(RegExp(r'^comment[0-9]+$'))) {
        buffer.writeln(spaces + value["content"]);
      } else if (value is Map) {
        if (key == "dependencies" || key == "dev_dependencies") {
          buffer.writeln("$key:");
          buffer.writeln(
            _mapDependenciesToYamlString(value, indent: indent + 2),
          );
        } else {
          if (value.containsKey("value")) {
            buffer.writeln("$spaces$key: ${value["value"]}");
          } else {
            buffer.writeln("$spaces$key:");
            buffer.writeln(
              mapToYamlString(value, indent: indent + 2),
            );
          }
        }
      } else {
        buffer.writeln("$spaces$key:");
        buffer.writeln(
          mapToYamlString(value, indent: indent + 2),
        );
      }
    });

    return buffer.toString();
  }

  String _mapDependenciesToYamlString(Map<dynamic, dynamic> yamlMap,
      {int indent = 0}) {
    final buffer = StringBuffer();
    final spaces = ' ' * indent;

    List<dynamic> dependencies =
        yamlMap.containsKey("list") ? yamlMap["list"] : [];

    for (Map<String, dynamic> dependency in dependencies) {
      buffer.writeln("$spaces${dependency["name"]}: ${dependency["version"]}");
    }

    if (dependencies.isNotEmpty) {
      yamlMap.remove("list");
    }

    yamlMap.forEach((key, value) {
      if (key.contains(RegExp(r'^space[0-9]+$'))) {
        buffer.writeln(spaces);
      } else if (key.contains(RegExp(r'^comment[0-9]+$'))) {
        buffer.writeln(spaces + value["content"]);
      }
    });

    return buffer.toString();
  }
}
