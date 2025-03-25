import 'dart:io';
import 'package:curl_request_parser/curl_request_parser.dart';

void main() {
  // Print program header
  print('CURL Parser Example');
  print('==================\n');

  // Example 1: Simple GET request
  const simpleCurl = 'curl https://api.example.com/data';
  printExample('Simple GET request', simpleCurl);

  // Example 2: POST request with JSON data
  const jsonCurl = '''
  curl -X POST 'https://api.example.com/users' \\
  -H 'Content-Type: application/json' \\
  -H 'Authorization: Bearer token123' \\
  -d '{"name":"John Doe","email":"john@example.com"}'
  ''';
  printExample('POST request with JSON data', jsonCurl);

  // Example 3: File upload with form data
  const uploadCurl = '''
  curl -X POST 'https://api.example.com/upload' \\
  -F 'profile=@photo.jpg' \\
  -F 'name=John Smith' \\
  -F 'bio=Software developer from New York'
  ''';
  printExample('File upload with form data', uploadCurl);

  // Example 4: Advanced options
  const advancedCurl = '''
  curl -v -X PUT 'https://api.example.com/files/upload' \\
  -H 'Content-Type: application/octet-stream' \\
  -H 'Authorization: Bearer token123' \\
  --connect-timeout 30 \\
  --max-time 60 \\
  --retry 3 \\
  --compressed \\
  -k \\
  -T './data.bin' \\
  -o './response.json'
  ''';
  printExample('Advanced options', advancedCurl);

  // Example 5: Authentication and cookies
  const authCurl = '''
  curl -u 'username:password' \\
  -b 'session=abc123; user=john' \\
  --digest \\
  https://api.example.com/secure
  ''';
  printExample('Authentication and cookies', authCurl);

  // Interactive mode
  promptInteractiveMode();
}

void printExample(String title, String curlCommand) {
  print('\n--- $title ---');
  print('Command: $curlCommand\n');

  try {
    final request = CurlParser.parse(curlCommand);
    print('Parsed request:');
    print(request);

    print('\nGenerated Dart code:');
    print(request.toDartHttpRequest());

    print('\nAs JSON:');
    print(request.toJson());

    print('---\n');
  } catch (e) {
    print('Error parsing curl command: $e');
  }
}

void promptInteractiveMode() {
  print('\n--- Interactive Mode ---');
  print('Enter a curl command to parse (or "exit" to quit):');

  while (true) {
    stdout.write('> ');
    final input = stdin.readLineSync();

    if (input == null || input.toLowerCase() == 'exit') {
      print('Exiting. Goodbye!');
      break;
    }

    try {
      final request = CurlParser.parse(input);
      print('\nParsed request:');
      print(request);

      print('\nGenerate Dart code? (y/n)');
      final generateCode = stdin.readLineSync()?.toLowerCase() == 'y';
      if (generateCode) {
        print('\nGenerated Dart code:');
        print(request.toDartHttpRequest());
      }

      print('\nShow as JSON? (y/n)');
      final showJson = stdin.readLineSync()?.toLowerCase() == 'y';
      if (showJson) {
        print('\nRequest as JSON:');
        print(request.toJson());
      }

      print('\n---');
    } catch (e) {
      print('Error parsing curl command: $e');
    }
  }
}
