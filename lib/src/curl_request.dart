import 'dart:convert';

/// Class to represent a parsed curl request with all its options and parameters.
class CurlRequest {
  /// The target URL for the request
  String url = '';

  /// The HTTP method (GET, POST, PUT, etc.)
  String method = 'GET';

  /// Map of HTTP headers
  Map<String, String> headers = {};

  /// Request body data as string
  String data = '';

  /// Path to file containing request data (from @file syntax)
  String dataFromFile = '';

  /// List of form data entries for multipart/form-data requests
  List<String> formData = [];

  /// Query parameters as a string
  String queryParameters = '';

  /// Cookies to be sent with the request
  String cookies = '';

  /// Path to file where cookies should be stored
  String cookieJar = '';

  /// Authentication credentials in format 'username:password'
  String auth = '';

  /// Whether to follow redirects (-L/--location)
  bool followRedirects = false;

  /// Whether to skip SSL certificate validation (-k/--insecure)
  bool insecure = false;

  // Connection options

  /// Connection timeout in seconds (--connect-timeout)
  int? connectTimeout;

  /// Network interface to use (--interface)
  String? interface;

  /// Maximum time allowed for the transfer (-m/--max-time)
  int? maxTime;

  /// Whether to use only IPv4 (-4/--ipv4)
  bool ipv4Only = false;

  /// Whether to use only IPv6 (-6/--ipv6)
  bool ipv6Only = false;

  /// Whether to request compressed response (--compressed)
  bool compressed = false;

  /// Maximum number of redirects to follow (--max-redirs)
  int? maxRedirs;

  // Output options

  /// Path to output file (-o/--output)
  String outputFile = '';

  /// Whether to use verbose output (-v/--verbose)
  bool verbose = false;

  /// Whether to use silent mode (-s/--silent)
  bool silent = false;

  /// Write-out format string (-w/--write-out)
  String writeOut = '';

  // SSL/TLS options

  /// Path to CA certificate file (--cacert)
  String? caCert;

  /// Path to client certificate file (-E/--cert)
  String? cert;

  /// Path to private key file (--key)
  String? key;

  /// Type of private key (--key-type)
  String? keyType;

  /// SSL ciphers to use (--ciphers)
  String? ciphers;

  /// Whether to use SSLv2 (-2/--sslv2)
  bool? sslv2;

  /// Whether to use SSLv3 (-3/--sslv3)
  bool? sslv3;

  /// Whether to use TLSv1 (-1/--tlsv1)
  bool? tlsv1;

  /// Whether to use TLSv1.0 (--tlsv1.0)
  bool? tlsv10;

  /// Whether to use TLSv1.1 (--tlsv1.1)
  bool? tlsv11;

  /// Whether to use TLSv1.2 (--tlsv1.2)
  bool? tlsv12;

  /// Whether to use TLSv1.3 (--tlsv1.3)
  bool? tlsv13;

  /// Maximum TLS version to use (--tls-max)
  String? tlsMax;

  // Proxy options

  /// Proxy to use (-x/--proxy)
  String proxy = '';

  /// Proxy authentication credentials (-U/--proxy-user)
  String proxyAuth = '';

  /// Whether to skip proxy SSL certificate validation (--proxy-insecure)
  bool proxyInsecure = false;

  /// Whether to tunnel through HTTP proxy (-p/--proxytunnel)
  bool proxytunnel = false;

  // Upload options

  /// Path to file to upload (-T/--upload-file)
  String uploadFile = '';

  /// Whether to append to the target file (-a/--append)
  bool append = false;

  // FTP options

  /// Whether to create remote directories if they don't exist (--ftp-create-dirs)
  bool ftpCreateDirs = false;

  /// Whether to use passive mode for FTP (--ftp-pasv)
  bool ftpPasv = false;

  /// FTP account data (--ftp-account)
  String? ftpAccount;

  /// FTP method to use for transactions (--ftp-method)
  String? ftpMethod;

  // HTTP options

  /// Whether to allow HTTP/0.9 responses (--http0.9)
  bool http09 = false;

  /// Whether to use HTTP/1.0 (-0/--http1.0)
  bool http10 = false;

  /// Whether to use HTTP/1.1 (--http1.1)
  bool http11 = false;

  /// Whether to use HTTP/2 (--http2)
  bool http2 = false;

  /// Whether to use a HEAD request (-I/--head)
  bool head = false;

  /// Range request value (-r/--range)
  String range = '';

  /// Referer URL (-e/--referer)
  String referer = '';

  // Auth options

  /// Whether to use any suitable authentication method (--anyauth)
  bool anyauth = false;

  /// Whether to use HTTP Basic authentication (--basic)
  bool basic = false;

  /// Whether to use HTTP Digest authentication (--digest)
  bool digest = false;

  /// Whether to use HTTP Negotiate/SPNEGO authentication (--negotiate)
  bool negotiate = false;

  /// Whether to use NTLM authentication (--ntlm)
  bool ntlm = false;

  /// OAuth 2.0 Bearer Token (--oauth2-bearer)
  String? oauth2Bearer;

  // Other options

  /// Whether to fail silently on HTTP errors (-f/--fail)
  bool fail = false;

  /// Whether to set the remote file's time on the local output (-R/--remote-time)
  bool remoteTime = false;

  /// Number of retry attempts for transient errors (--retry)
  int? retryCount;

  /// Delay between retries in seconds (--retry-delay)
  int? retryDelay;

  /// Maximum time in seconds for retries (--retry-max-time)
  int? retryMaxTime;

  /// Whether to disable buffering of the output stream (-N/--no-buffer)
  bool noBuffer = false;

  /// List of host:port:address mappings for DNS resolution (--resolve)
  List<String> resolveHosts = [];

  /// Convert the request to a map representation
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'url': url,
      'method': method,
    };

    // Only include non-empty values
    if (headers.isNotEmpty) map['headers'] = headers;
    if (data.isNotEmpty) map['data'] = data;
    if (dataFromFile.isNotEmpty) map['dataFromFile'] = dataFromFile;
    if (formData.isNotEmpty) map['formData'] = formData;
    if (queryParameters.isNotEmpty) map['queryParameters'] = queryParameters;
    if (cookies.isNotEmpty) map['cookies'] = cookies;
    if (cookieJar.isNotEmpty) map['cookieJar'] = cookieJar;
    if (auth.isNotEmpty) map['auth'] = auth;
    if (followRedirects) map['followRedirects'] = followRedirects;
    if (insecure) map['insecure'] = insecure;

    // Connection options
    if (connectTimeout != null) map['connectTimeout'] = connectTimeout;
    if (interface != null) map['interface'] = interface;
    if (maxTime != null) map['maxTime'] = maxTime;
    if (ipv4Only) map['ipv4Only'] = ipv4Only;
    if (ipv6Only) map['ipv6Only'] = ipv6Only;
    if (compressed) map['compressed'] = compressed;
    if (maxRedirs != null) map['maxRedirs'] = maxRedirs;

    // Output options
    if (outputFile.isNotEmpty) map['outputFile'] = outputFile;
    if (verbose) map['verbose'] = verbose;
    if (silent) map['silent'] = silent;
    if (writeOut.isNotEmpty) map['writeOut'] = writeOut;

    // SSL/TLS options
    if (caCert != null) map['caCert'] = caCert;
    if (cert != null) map['cert'] = cert;
    if (key != null) map['key'] = key;
    if (keyType != null) map['keyType'] = keyType;
    if (ciphers != null) map['ciphers'] = ciphers;
    if (sslv2 != null) map['sslv2'] = sslv2;
    if (sslv3 != null) map['sslv3'] = sslv3;
    if (tlsv1 != null) map['tlsv1'] = tlsv1;
    if (tlsv10 != null) map['tlsv10'] = tlsv10;
    if (tlsv11 != null) map['tlsv11'] = tlsv11;
    if (tlsv12 != null) map['tlsv12'] = tlsv12;
    if (tlsv13 != null) map['tlsv13'] = tlsv13;
    if (tlsMax != null) map['tlsMax'] = tlsMax;

    // Proxy options
    if (proxy.isNotEmpty) map['proxy'] = proxy;
    if (proxyAuth.isNotEmpty) map['proxyAuth'] = proxyAuth;
    if (proxyInsecure) map['proxyInsecure'] = proxyInsecure;
    if (proxytunnel) map['proxytunnel'] = proxytunnel;

    // Upload options
    if (uploadFile.isNotEmpty) map['uploadFile'] = uploadFile;
    if (append) map['append'] = append;

    // FTP options
    if (ftpCreateDirs) map['ftpCreateDirs'] = ftpCreateDirs;
    if (ftpPasv) map['ftpPasv'] = ftpPasv;
    if (ftpAccount != null) map['ftpAccount'] = ftpAccount;
    if (ftpMethod != null) map['ftpMethod'] = ftpMethod;

    // HTTP options
    if (http09) map['http09'] = http09;
    if (http10) map['http10'] = http10;
    if (http11) map['http11'] = http11;
    if (http2) map['http2'] = http2;
    if (head) map['head'] = head;
    if (range.isNotEmpty) map['range'] = range;
    if (referer.isNotEmpty) map['referer'] = referer;

    // Auth options
    if (anyauth) map['anyauth'] = anyauth;
    if (basic) map['basic'] = basic;
    if (digest) map['digest'] = digest;
    if (negotiate) map['negotiate'] = negotiate;
    if (ntlm) map['ntlm'] = ntlm;
    if (oauth2Bearer != null) map['oauth2Bearer'] = oauth2Bearer;

    // Other options
    if (fail) map['fail'] = fail;
    if (remoteTime) map['remoteTime'] = remoteTime;
    if (retryCount != null) map['retryCount'] = retryCount;
    if (retryDelay != null) map['retryDelay'] = retryDelay;
    if (retryMaxTime != null) map['retryMaxTime'] = retryMaxTime;
    if (noBuffer) map['noBuffer'] = noBuffer;
    if (resolveHosts.isNotEmpty) map['resolveHosts'] = resolveHosts;

    return map;
  }

  /// Convert the request to a JSON string
  String toJson() {
    return jsonEncode(toMap());
  }

  /// Generate a Dart http package request code
  String toDartHttpRequest() {
    final code = StringBuffer();

    code.writeln("import 'package:http/http.dart' as http;");
    code.writeln("import 'dart:convert';");
    code.writeln("import 'dart:io';");
    code.writeln();
    code.writeln('Future<void> sendRequest() async {');

    // Build URL with query parameters
    if (queryParameters.isNotEmpty) {
      code.writeln(
          "  final uri = Uri.parse('$url').replace(query: '$queryParameters');");
    } else {
      code.writeln("  final uri = Uri.parse('$url');");
    }

    // Build headers
    if (headers.isNotEmpty) {
      code.writeln('  final headers = {');
      headers.forEach((key, value) {
        code.writeln("    '$key': '$value',");
      });
      code.writeln('  };');
    }

    // Add client configuration for SSL/TLS options, proxies, etc.
    if (insecure ||
        followRedirects != false ||
        connectTimeout != null ||
        proxy.isNotEmpty) {
      code.writeln('  // Configure the HTTP client');
      code.writeln('  final client = http.Client();');

      // Security-focused options
      if (insecure) {
        code.writeln('  // WARNING: This disables certificate validation');
        code.writeln('  final httpClient = HttpClient()');
        code.writeln(
            '    ..badCertificateCallback = (cert, host, port) => true;');
        // For IOClient, we would need to implement this properly
        code.writeln(
            "  // You'd need to implement a proper IOClient with the httpClient");
      }

      // Client-specific settings would go here if using IOClient, etc.
      if (connectTimeout != null) {
        code.writeln('  // Set connection timeout');
        code.writeln(
            '  // Note: Implementation would vary based on client type');
      }
    }

    // Handle basic authentication
    if (auth.isNotEmpty) {
      code.writeln('\n  // Add basic authentication');
      code.writeln("  final authParts = '$auth'.split(':');");
      code.writeln('  if (authParts.length == 2) {');
      code.writeln('    final username = authParts[0];');
      code.writeln('    final password = authParts[1];');
      code.writeln(
          "    final basicAuth = 'Basic ' + base64Encode(utf8.encode('\$username:\$password'));");
      code.writeln("    headers['Authorization'] = basicAuth;");
      code.writeln('  }');
    }

    // Handle cookies
    if (cookies.isNotEmpty) {
      code.writeln('\n  // Add cookies');
      code.writeln("  headers['Cookie'] = '$cookies';");
    }

    // For file uploads, use uploadFile
    if (uploadFile.isNotEmpty) {
      code.writeln('\n  // This is a file upload operation');
      code.writeln(
          "  final fileBytes = await File('$uploadFile').readAsBytes();");
      if (method == 'PUT') {
        code.writeln('  final response = await http.put(');
        code.writeln('    uri,');
        code.writeln('    headers: headers,');
        code.writeln('    body: fileBytes,');
        code.writeln('  );');
      } else {
        code.writeln(
            "  final request = http.Request('${method.isEmpty ? 'PUT' : method}', uri);");
        code.writeln('  request.headers.addAll(headers);');
        code.writeln('  request.bodyBytes = fileBytes;');
        code.writeln('  final streamedResponse = await request.send();');
        code.writeln(
            '  final response = await http.Response.fromStream(streamedResponse);');
      }
    } else {
      // Generate the appropriate request based on the method
      switch (method) {
        case 'GET':
          code.writeln(
              "  final response = await http.get(uri${headers.isNotEmpty ? ', headers: headers' : ''});");
          break;
        case 'POST':
          if (formData.isNotEmpty) {
            code.writeln('\n  // This is a multipart/form-data request');
            code.writeln(
                "  final request = http.MultipartRequest('POST', uri);");
            if (headers.isNotEmpty) {
              code.writeln('  request.headers.addAll(headers);');
            }
            for (var form in formData) {
              final parts = form.split('=');
              if (parts.length >= 2) {
                final key = parts[0];
                final value = parts.sublist(1).join('=');
                if (value.startsWith('@')) {
                  // File upload
                  code.writeln(
                      "  request.files.add(await http.MultipartFile.fromPath('$key', '${value.substring(1)}'));");
                } else {
                  code.writeln("  request.fields['$key'] = '$value';");
                }
              }
            }
            code.writeln('  final streamedResponse = await request.send();');
            code.writeln(
                '  final response = await http.Response.fromStream(streamedResponse);');
          } else if (dataFromFile.isNotEmpty) {
            code.writeln('\n  // Reading data from file');
            code.writeln(
                "  final fileData = await File('$dataFromFile').readAsString();");
            code.writeln(
                '  final response = await http.post(uri, headers: headers, body: fileData);');
          } else if (data.isNotEmpty) {
            code.writeln(
                "  final response = await http.post(uri, headers: headers, body: '$data');");
          } else {
            code.writeln(
                "  final response = await http.post(uri${headers.isNotEmpty ? ', headers: headers' : ''});");
          }
          break;
        case 'PUT':
          if (dataFromFile.isNotEmpty) {
            code.writeln('\n  // Reading data from file');
            code.writeln(
                "  final fileData = await File('$dataFromFile').readAsString();");
            code.writeln(
                '  final response = await http.put(uri, headers: headers, body: fileData);');
          } else {
            code.writeln(
                "  final response = await http.put(uri${headers.isNotEmpty ? ', headers: headers' : ''}${data.isNotEmpty ? ", body: '$data'" : ''});");
          }
          break;
        case 'DELETE':
          code.writeln(
              "  final response = await http.delete(uri${headers.isNotEmpty ? ', headers: headers' : ''}${data.isNotEmpty ? ", body: '$data'" : ''});");
          break;
        case 'PATCH':
          if (dataFromFile.isNotEmpty) {
            code.writeln('\n  // Reading data from file');
            code.writeln(
                "  final fileData = await File('$dataFromFile').readAsString();");
            code.writeln(
                '  final response = await http.patch(uri, headers: headers, body: fileData);');
          } else {
            code.writeln(
                "  final response = await http.patch(uri${headers.isNotEmpty ? ', headers: headers' : ''}${data.isNotEmpty ? ", body: '$data'" : ''});");
          }
          break;
        case 'HEAD':
          code.writeln(
              "  final response = await http.head(uri${headers.isNotEmpty ? ', headers: headers' : ''});");
          break;
        default:
          code.writeln('\n  // Custom method requires using a Request object');
          code.writeln("  final request = http.Request('$method', uri);");
          if (headers.isNotEmpty) {
            code.writeln('  request.headers.addAll(headers);');
          }
          if (dataFromFile.isNotEmpty) {
            code.writeln(
                "  final fileData = await File('$dataFromFile').readAsString();");
            code.writeln('  request.body = fileData;');
          } else if (data.isNotEmpty) {
            code.writeln("  request.body = '$data';");
          }
          code.writeln('  final streamedResponse = await request.send();');
          code.writeln(
              '  final response = await http.Response.fromStream(streamedResponse);');
      }
    }

    // Output handling logic
    if (outputFile.isNotEmpty) {
      code.writeln('\n  // Write response to file');
      code.writeln(
          "  await File('$outputFile').writeAsBytes(response.bodyBytes);");
      code.writeln("  print('Response written to $outputFile');");
    } else {
      code.writeln('\n  // Output response details');
      code.writeln("  print('Status code: \${response.statusCode}');");
      code.writeln("  print('Headers: \${response.headers}');");

      // For verbose output, print everything
      if (verbose) {
        code.writeln("  print('Body: \${response.body}');");
      } else {
        code.writeln("  print('Body length: \${response.body.length} bytes');");
        code.writeln('  // Print first 100 characters of response');
        code.writeln(
            "  print('Preview: \${response.body.length > 100 ? response.body.substring(0, 100) + \"...\" : response.body}');");
      }
    }

    // Custom write-out format
    if (writeOut.isNotEmpty) {
      code.writeln('\n  // Custom output format: $writeOut');
      code.writeln('  // Note: Implement custom write-out formatting here');
    }

    code.writeln('}');

    return code.toString();
  }

  @override
  String toString() {
    final sb = StringBuffer();

    // Essential information
    sb.writeln('URL: $url');
    sb.writeln('Method: $method');

    // Headers
    if (headers.isNotEmpty) {
      sb.writeln('Headers:');
      headers.forEach((key, value) {
        sb.writeln('  $key: $value');
      });
    }

    // Data
    if (data.isNotEmpty) sb.writeln('Data: $data');
    if (dataFromFile.isNotEmpty) sb.writeln('Data from file: $dataFromFile');
    if (formData.isNotEmpty) {
      sb.writeln('Form data:');
      for (var item in formData) {
        sb.writeln('  $item');
      }
    }
    if (queryParameters.isNotEmpty) {
      sb.writeln('Query parameters: $queryParameters');
    }

    // Authentication
    if (auth.isNotEmpty) sb.writeln('Auth: $auth');
    if (anyauth) sb.writeln('Any auth: true');
    if (basic) sb.writeln('Basic auth: true');
    if (digest) sb.writeln('Digest auth: true');
    if (negotiate) sb.writeln('Negotiate auth: true');
    if (ntlm) sb.writeln('NTLM auth: true');
    if (oauth2Bearer != null) sb.writeln('OAuth2 Bearer: $oauth2Bearer');

    // Cookies
    if (cookies.isNotEmpty) sb.writeln('Cookies: $cookies');
    if (cookieJar.isNotEmpty) sb.writeln('Cookie jar: $cookieJar');

    // Connection options
    sb.writeln('Follow redirects: $followRedirects');
    if (maxRedirs != null) sb.writeln('Max redirects: $maxRedirs');
    if (connectTimeout != null) {
      sb.writeln('Connect timeout: ${connectTimeout}s');
    }
    if (maxTime != null) sb.writeln('Max time: ${maxTime}s');
    if (interface != null) sb.writeln('Interface: $interface');
    if (ipv4Only) sb.writeln('IPv4 only: true');
    if (ipv6Only) sb.writeln('IPv6 only: true');
    if (compressed) sb.writeln('Compressed: true');

    // HTTP-specific options
    if (http09) sb.writeln('HTTP/0.9: true');
    if (http10) sb.writeln('HTTP/1.0: true');
    if (http11) sb.writeln('HTTP/1.1: true');
    if (http2) sb.writeln('HTTP/2: true');
    if (head) sb.writeln('HEAD request: true');
    if (range.isNotEmpty) sb.writeln('Range: $range');
    if (referer.isNotEmpty) sb.writeln('Referer: $referer');

    // SSL/TLS options
    sb.writeln('Insecure: $insecure');
    if (caCert != null) sb.writeln('CA cert: $caCert');
    if (cert != null) sb.writeln('Client cert: $cert');
    if (key != null) sb.writeln('Private key: $key');
    if (keyType != null) sb.writeln('Key type: $keyType');
    if (ciphers != null) sb.writeln('Ciphers: $ciphers');
    if (sslv2 == true) sb.writeln('SSLv2: true');
    if (sslv3 == true) sb.writeln('SSLv3: true');
    if (tlsv1 == true) sb.writeln('TLSv1: true');
    if (tlsv10 == true) sb.writeln('TLSv1.0: true');
    if (tlsv11 == true) sb.writeln('TLSv1.1: true');
    if (tlsv12 == true) sb.writeln('TLSv1.2: true');
    if (tlsv13 == true) sb.writeln('TLSv1.3: true');
    if (tlsMax != null) sb.writeln('TLS max version: $tlsMax');

    // Proxy options
    if (proxy.isNotEmpty) sb.writeln('Proxy: $proxy');
    if (proxyAuth.isNotEmpty) sb.writeln('Proxy auth: $proxyAuth');
    if (proxyInsecure) sb.writeln('Proxy insecure: true');
    if (proxytunnel) sb.writeln('Proxy tunnel: true');

    // Upload options
    if (uploadFile.isNotEmpty) sb.writeln('Upload file: $uploadFile');
    if (append) sb.writeln('Append: true');

    // FTP options
    if (ftpCreateDirs) sb.writeln('FTP create dirs: true');
    if (ftpPasv) sb.writeln('FTP passive mode: true');
    if (ftpAccount != null) sb.writeln('FTP account: $ftpAccount');
    if (ftpMethod != null) sb.writeln('FTP method: $ftpMethod');

    // Output options
    if (outputFile.isNotEmpty) sb.writeln('Output file: $outputFile');
    if (verbose) sb.writeln('Verbose: true');
    if (silent) sb.writeln('Silent: true');
    if (writeOut.isNotEmpty) sb.writeln('Write-out format: $writeOut');

    // Other options
    if (fail) sb.writeln('Fail on error: true');
    if (remoteTime) sb.writeln('Remote time: true');
    if (retryCount != null) sb.writeln('Retry count: $retryCount');
    if (retryDelay != null) sb.writeln('Retry delay: ${retryDelay}s');
    if (retryMaxTime != null) sb.writeln('Retry max time: ${retryMaxTime}s');
    if (noBuffer) sb.writeln('No buffer: true');

    if (resolveHosts.isNotEmpty) {
      sb.writeln('Resolve hosts:');
      for (var item in resolveHosts) {
        sb.writeln('  $item');
      }
    }

    return sb.toString();
  }
}
