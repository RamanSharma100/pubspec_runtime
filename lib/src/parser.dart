import 'dart:io';

import 'package:pubspec_runtime/src/dependency.dart';

/// class Parser used to parse the yaml file
class Parser {
  /// Parse the content of a YAML file.
  ///
  /// The [content] parameter is the content of the file to parse.
  /// Returns a map of the parsed content.
  Map<String, dynamic> parse(String content) {
    print("-------------------Parsing-------------------");

    final lines = content.split('\n');
    final result = <String, dynamic>{};
    final stack = <Map<String, dynamic>>[result];
    // final lineNumbersStart

    int currentIndent = -1;

    for (String line in lines) {
      int lineNumber = lines.indexOf(line);
      if (line.trim().isEmpty) {
        (stack.last)["space$lineNumber"] = {"indent": currentIndent};
        continue;
      }

      final indent = line.indexOf(RegExp(r'[^\s]'));
      line = line.trim();

      while (indent <= currentIndent) {
        stack.removeLast();
        currentIndent -= 2;
      }

      if (line.startsWith("#")) {
        (stack.last)["comment$lineNumber"] = {
          "content": line,
          indent: currentIndent
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
              (stack.last)[key] = {value: parseValue(value), line: lineNumber};
            }
          } else {
            (stack.last)[key] = {value: parseValue(value), line: lineNumber};
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
  String mapToYamlString(Map<dynamic, dynamic> yamlMap,
      {int indent = 0, Map<int, dynamic> comments = const {}}) {
    final buffer = StringBuffer();
    final spaces = ' ' * indent;

    yamlMap.forEach((key, value) {
      if (value is Map) {
        buffer.writeln('$spaces$key:');
        if (value.containsKey("isDev")) {
          print("Dependency found in mapToYamlString");
        } else {
          buffer.write(mapToYamlString(value, indent: indent + 2));
        }
      } else if (value is List) {
        buffer.writeln('$spaces$key:');
        for (var item in value) {
          if (item is Map) {
            buffer.writeln('$spaces  -');
            buffer.write(mapToYamlString(item, indent: indent + 4));
          } else {
            buffer.writeln('$spaces  - $item');
          }
        }
      } else {
        buffer.writeln('$spaces$key: $value');
      }
    });

    return buffer.toString();
  }
}
