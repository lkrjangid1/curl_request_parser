# Curl Parser for Dart

A comprehensive Dart package for parsing curl commands into structured request objects and generating Dart HTTP code.

## Features

- Parse curl command strings into structured `CurlRequest` objects
- Support for all major curl options (200+ options)
- Convert parsed requests to JSON for storage or manipulation
- Generate Dart code using the `http` package to reproduce the curl request
- Handle various authentication methods, headers, data formats, and more

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  curl_request_parser: any
```

Then run:

```
dart pub get
```

## Usage

### Basic parsing

```dart
import 'package:curl_request_parser/curl_request_parser.dart';

void main() {
  final curlCommand = 'curl -X POST "https://api.example.com/data" -H "Content-Type: application/json" -d \'{"name":"John"}\'';
  final request = CurlParser.parse(curlCommand);
  
  print('URL: ${request.url}');
  print('Method: ${request.method}');
  print('Headers: ${request.headers}');
  print('Data: ${request.data}');
}
```

### Generate Dart HTTP code

```dart
import 'package:curl_request_parser/curl_request_parser.dart';

void main() {
  final curlCommand = 'curl -X POST "https://api.example.com/data" -H "Content-Type: application/json" -d \'{"name":"John"}\'';
  final request = CurlParser.parse(curlCommand);
  
  // Generate Dart code that reproduces this curl request
  final dartCode = request.toDartHttpRequest();
  print(dartCode);
}
```

### Convert to JSON

```dart
import 'package:curl_request_parser/curl_request_parser.dart';

void main() {
  final curlCommand = 'curl -X POST "https://api.example.com/data" -H "Content-Type: application/json" -d \'{"name":"John"}\'';
  final request = CurlParser.parse(curlCommand);
  
  // Convert to JSON for storage or transmission
  final json = request.toJson();
  print(json);
}
```

## Supported Options

This package supports a comprehensive set of curl options, including:

- HTTP methods (`-X`, `--request`)
- Headers (`-H`, `--header`)
- Data options (`-d`, `--data`, `--data-binary`, etc.)
- Form data (`-F`, `--form`)
- Authentication (`-u`, `--user`, `--oauth2-bearer`, etc.)
- SSL/TLS options (`--cacert`, `--cert`, `--key`, etc.)
- Connection options (`--connect-timeout`, `--max-time`, etc.)
- Proxy options (`-x`, `--proxy`, etc.)
- HTTP protocol options (`--http1.1`, `--http2`, etc.)
- And many more!

For a complete list of supported options, refer to the [API documentation](#).

## Example: Parsing Complex Curl Commands

```dart
final complexCurl = '''
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

final request = CurlParser.parse(complexCurl);
print(request);
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.