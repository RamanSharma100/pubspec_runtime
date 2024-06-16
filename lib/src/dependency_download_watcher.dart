part of "pubspec_runtime_base.dart";

bool isDependencyDownloading = false;

/// Run `flutter pub get` command.
Future<ProcessResult> runPubGet() async {
  return Process.run('dart', ['pub', 'get']);
}

void watchForDependencyDownloads() {
  final platformScript = Platform.script;
  final scriptPath = platformScript.toFilePath();
  Directory scriptDir = Directory(scriptPath).parent;
  while (scriptDir.path.isNotEmpty &&
      !scriptDir
          .listSync()
          .any((entity) => entity.path.endsWith('pubspec.yaml'))) {
    scriptDir = scriptDir.parent;
  }
  final directory = Directory(scriptDir.path);

  directory.watch(events: FileSystemEvent.all).listen((event) {
    final path = event.path;
    if (event is FileSystemModifyEvent || event is FileSystemCreateEvent) {
      if (path.endsWith('pubspec.lock') || path.contains('.dart_tool')) {
        if (!isDependencyDownloading) {
          isDependencyDownloading = true;
        }
      }
    } else if (event is FileSystemDeleteEvent) {
      if (path.endsWith('pubspec.lock') || path.contains('.dart_tool')) {
        isDependencyDownloading = false;
      }
    }
  });
}
