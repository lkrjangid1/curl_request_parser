import 'curl_request.dart';

/// A utility class to parse curl commands into [CurlRequest] objects.
///
/// Parse all params https://gist.github.com/eneko/dc2d8edd9a4b25c5b0725dd123f98b10
class CurlParser {
  /// Parse a curl command string into a [CurlRequest] object.
  ///
  /// The parser handles most curl options, including but not limited to:
  /// - HTTP methods (`-X`, `--request`)
  /// - Headers (`-H`, `--header`)
  /// - Data options (`-d`, `--data`, `--data-binary`, etc.)
  /// - Form data (`-F`, `--form`)
  /// - Authentication (`-u`, `--user`, `--oauth2-bearer`, etc.)
  /// - SSL/TLS options (`--cacert`, `--cert`, `--key`, etc.)
  /// - Connection options (`--connect-timeout`, `--max-time`, etc.)
  ///
  /// Example:
  /// ```dart
  /// final request = CurlParser.parse('curl -X POST "https://api.example.com" -H "Content-Type: application/json"');
  /// ```
  static CurlRequest parse(String curlCommand) {
    // Initialize the request object
    final request = CurlRequest();

    // Normalize the command by ensuring spaces after options
    var normalizedCommand = curlCommand
        .replaceAll(RegExp(r'-([a-zA-Z])([^ ])'), r'-$1 $2')
        .replaceAll("\n", ' ')
        .replaceAll("\t", ' ');

    // Remove 'curl' command if present at the beginning
    if (normalizedCommand.trim().startsWith('curl')) {
      normalizedCommand = normalizedCommand.trim().substring(4).trim();
    }

    // Split the command into tokens, respecting quotes
    final tokens = _tokenizeCurlCommand(normalizedCommand);

    // Process tokens
    for (var i = 0; i < tokens.length; i++) {
      var token = tokens[i];

      // Process URL (token without a dash prefix and not after an option)
      if (!token.startsWith('-') &&
          (i == 0 || !_isOptionWithArg(tokens[i - 1]))) {
        if (token.startsWith("'") || token.startsWith('"')) {
          token = token.substring(1, token.length - 1);
        }
        request.url = token.replaceAll("\"", '').replaceAll('\'', '');
        continue;
      }

      // Process options
      if (token.startsWith('-')) {
        var option = token;
        String? value;

        // Handle compound options like -X POST
        if (option.length > 2 &&
            option.startsWith('-') &&
            !option.startsWith('--')) {
          option = option.substring(0, 2);
          value = token.substring(2);
          // If there's no immediate value after the option, get the next token
          if (value.isEmpty &&
              i + 1 < tokens.length &&
              !tokens[i + 1].startsWith('-')) {
            value = tokens[++i];
          }
        }
        // Handle options that take a value from the next token
        else if (_isOptionWithArg(option) &&
            i + 1 < tokens.length &&
            !tokens[i + 1].startsWith('-')) {
          value = tokens[++i];
          // Remove quotes if present
          if (value.startsWith("'") || value.startsWith('"')) {
            value = value.substring(1, value.length - 1);
          }
        }

        _processOption(request, option, value);
      }
    }

    return request;
  }

  /// Check if an option expects an argument
  static bool _isOptionWithArg(String option) {
    // List of options that take arguments
    final optionsWithArgs = [
      // Data options
      '-d', '--data', '--data-ascii', '--data-binary', '--data-raw',
      '--data-urlencode',

      // Header and request options
      '-H', '--header', '-X', '--request', '--request-target',

      // Authentication
      '-u', '--user', '--oauth2-bearer', '--aws-sigv4',

      // SSL/Security options
      '--cacert', '--capath', '-E', '--cert', '--cert-type',
      '--ciphers', '--key', '--key-type', '--pass', '--pinnedpubkey',

      // Proxy options
      '-x', '--proxy', '--proxy-cacert', '--proxy-capath', '--proxy-cert',
      '--proxy-cert-type', '--proxy-ciphers', '--proxy-key', '--proxy-key-type',
      '--proxy-pass', '--proxy-service-name', '--proxy-tlsuser', '--proxy-user',
      '--proxy1.0',

      // Connection options
      '--connect-timeout', '--connect-to', '--interface', '--local-port',
      '--max-filesize', '--max-redirs', '-m', '--max-time', '--retry',
      '--retry-delay',
      '--retry-max-time', '--unix-socket',

      // Output options
      '-o', '--output', '-O', '--remote-name', '-J', '--remote-header-name',
      '--trace', '--trace-ascii', '-w', '--write-out',

      // Cookie handling
      '-b', '--cookie', '-c', '--cookie-jar',

      // Redirects and referrer
      '-e', '--referer', '-a', '--append',

      // Form and multipart
      '-F', '--form', '--form-string',

      // FTP options
      '--ftp-account', '--ftp-alternative-to-user', '--ftp-method',
      '--ftp-port', '--ftp-ssl-ccc-mode',

      // Mail options
      '--mail-auth', '--mail-from', '--mail-rcpt',

      // Other options
      '-A', '--user-agent', '--url', '--dns-interface', '--dns-ipv4-addr',
      '--dns-ipv6-addr', '--dns-servers', '--doh-url', '--egd-file', '--engine',
      '--expect100-timeout', '--happy-eyeballs-timeout-ms', '--hostpubmd5',
      '--keepalive-time', '--limit-rate', '--login-options', '--noproxy',
      '--preproxy', '--proto', '--proto-default', '--proto-redir', '--pubkey',
      '-r', '--range', '--resolve', '--sasl-authzid', '-Y', '--speed-limit',
      '-y', '--speed-time', '--tftp-blksize', '-z', '--time-cond',
      '--tls-max', '--tls13-ciphers', '--tlspassword', '--tlsuser',
      '-T', '--upload-file',

      // Config
      '-K', '--config',
    ];

    return optionsWithArgs.contains(option);
  }

  /// Process a specific option and its value
  static void _processOption(
      CurlRequest request, String option, String? value) {
    switch (option) {
      // Request method and URL options
      case '-X':
      case '--request':
        request.method = value ?? 'GET';
        break;

      case '--url':
        if (value != null) request.url = value;
        break;

      case '--request-target':
        // This affects the request line, but we'll ignore it for now
        break;

      // Header options
      case '-H':
      case '--header':
        if (value != null) {
          final headerParts = value.split(':');
          if (headerParts.length >= 2) {
            final headerName = headerParts[0].trim();
            final headerValue = headerParts.sublist(1).join(':').trim();
            request.headers[headerName] = headerValue;
          }
        }
        break;

      // Data options
      case '-d':
      case '--data':
      case '--data-ascii':
      case '--data-raw':
      case '--data-urlencode':
        if (value != null) {
          if (value.startsWith('@')) {
            // This is a file reference
            request.dataFromFile = value.substring(1);
          } else {
            // If we already have data, append with & unless it's binary
            if (request.data.isNotEmpty) {
              request.data += '&$value';
            } else {
              request.data = value;
            }
          }

          // Set content-type if not already set
          if (!request.headers.containsKey('Content-Type')) {
            request.headers['Content-Type'] =
                'application/x-www-form-urlencoded';
          }

          // Ensure method is POST if not explicitly set
          if (request.method == 'GET') {
            request.method = 'POST';
          }
        }
        break;

      case '--data-binary':
        if (value != null) {
          if (value.startsWith('@')) {
            request.dataFromFile = value.substring(1);
          } else {
            request.data = value;
          }

          // Ensure method is POST if not explicitly set
          if (request.method == 'GET') {
            request.method = 'POST';
          }
        }
        break;

      // Form options
      case '-F':
      case '--form':
      case '--form-string':
        if (value != null) {
          request.formData.add(value);
          request.headers['Content-Type'] = 'multipart/form-data';

          // Ensure method is POST
          if (request.method == 'GET') {
            request.method = 'POST';
          }
        }
        break;

      // Cookie options
      case '-b':
      case '--cookie':
        if (value != null) {
          request.cookies = value;
        }
        break;

      case '-c':
      case '--cookie-jar':
        if (value != null) {
          request.cookieJar = value;
        }
        break;

      // User agent
      case '-A':
      case '--user-agent':
        if (value != null) {
          request.headers['User-Agent'] = value;
        }
        break;

      // Referer
      case '-e':
      case '--referer':
        if (value != null) {
          request.headers['Referer'] = value;
          request.referer = value;
        }
        break;

      // Auth options
      case '-u':
      case '--user':
        if (value != null) {
          request.auth = value;
        }
        break;

      case '--oauth2-bearer':
        if (value != null) {
          request.oauth2Bearer = value;
          request.headers['Authorization'] = 'Bearer $value';
        }
        break;

      case '--anyauth':
        request.anyauth = true;
        break;

      case '--basic':
        request.basic = true;
        break;

      case '--digest':
        request.digest = true;
        break;

      case '--negotiate':
        request.negotiate = true;
        break;

      case '--ntlm':
        request.ntlm = true;
        break;

      // Redirect options
      case '-L':
      case '--location':
        request.followRedirects = true;
        break;

      case '--location-trusted':
        request.followRedirects = true;
        // This would also send auth to redirected hosts
        break;

      case '--max-redirs':
        if (value != null) {
          request.maxRedirs = int.tryParse(value);
        }
        break;

      // Method override
      case '-I':
      case '--head':
        request.method = 'HEAD';
        request.head = true;
        break;

      case '-G':
      case '--get':
        request.method = 'GET';
        // Move any data to query parameters
        if (request.data.isNotEmpty) {
          request.queryParameters = request.data;
          request.data = '';
        }
        break;

      // SSL/TLS options
      case '-k':
      case '--insecure':
        request.insecure = true;
        break;

      case '--cacert':
        if (value != null) request.caCert = value;
        break;

      case '-E':
      case '--cert':
        if (value != null) request.cert = value;
        break;

      case '--cert-type':
        // Certificate type (PEM, DER, etc.)
        break;

      case '--key':
        if (value != null) request.key = value;
        break;

      case '--key-type':
        if (value != null) request.keyType = value;
        break;

      case '--ciphers':
        if (value != null) request.ciphers = value;
        break;

      case '-2':
      case '--sslv2':
        request.sslv2 = true;
        break;

      case '-3':
      case '--sslv3':
        request.sslv3 = true;
        break;

      case '-1':
      case '--tlsv1':
        request.tlsv1 = true;
        break;

      case '--tlsv1.0':
        request.tlsv10 = true;
        break;

      case '--tlsv1.1':
        request.tlsv11 = true;
        break;

      case '--tlsv1.2':
        request.tlsv12 = true;
        break;

      case '--tlsv1.3':
        request.tlsv13 = true;
        break;

      case '--tls-max':
        if (value != null) request.tlsMax = value;
        break;

      // Proxy options
      case '-x':
      case '--proxy':
        if (value != null) request.proxy = value;
        break;

      case '-U':
      case '--proxy-user':
        if (value != null) request.proxyAuth = value;
        break;

      case '--proxy-insecure':
        request.proxyInsecure = true;
        break;

      case '-p':
      case '--proxytunnel':
        request.proxytunnel = true;
        break;

      // Connection options
      case '--connect-timeout':
        if (value != null) {
          request.connectTimeout = int.tryParse(value);
        }
        break;

      case '-m':
      case '--max-time':
        if (value != null) {
          request.maxTime = int.tryParse(value);
        }
        break;

      case '--interface':
        if (value != null) request.interface = value;
        break;

      case '-4':
      case '--ipv4':
        request.ipv4Only = true;
        break;

      case '-6':
      case '--ipv6':
        request.ipv6Only = true;
        break;

      case '--compressed':
        request.compressed = true;
        request.headers['Accept-Encoding'] = 'gzip, deflate';
        break;

      // Output options
      case '-o':
      case '--output':
        if (value != null) request.outputFile = value;
        break;

      case '-v':
      case '--verbose':
        request.verbose = true;
        break;

      case '-s':
      case '--silent':
        request.silent = true;
        break;

      case '-w':
      case '--write-out':
        if (value != null) request.writeOut = value;
        break;

      case '-f':
      case '--fail':
        request.fail = true;
        break;

      case '-N':
      case '--no-buffer':
        request.noBuffer = true;
        break;

      // Upload options
      case '-T':
      case '--upload-file':
        if (value != null) {
          request.uploadFile = value;
          // Set method to PUT if not explicitly set
          if (request.method == 'GET') {
            request.method = 'PUT';
          }
        }
        break;

      case '-a':
      case '--append':
        request.append = true;
        break;

      // HTTP specific options
      case '--http0.9':
        request.http09 = true;
        break;

      case '-0':
      case '--http1.0':
        request.http10 = true;
        break;

      case '--http1.1':
        request.http11 = true;
        break;

      case '--http2':
        request.http2 = true;
        break;

      case '-r':
      case '--range':
        if (value != null) {
          request.range = value;
          request.headers['Range'] = 'bytes=$value';
        }
        break;

      // Retry options
      case '--retry':
        if (value != null) request.retryCount = int.tryParse(value);
        break;

      case '--retry-delay':
        if (value != null) request.retryDelay = int.tryParse(value);
        break;

      case '--retry-max-time':
        if (value != null) request.retryMaxTime = int.tryParse(value);
        break;

      // DNS options
      case '--resolve':
        if (value != null) request.resolveHosts.add(value);
        break;

      // FTP options
      case '--ftp-create-dirs':
        request.ftpCreateDirs = true;
        break;

      case '--ftp-pasv':
        request.ftpPasv = true;
        break;

      case '--ftp-account':
        if (value != null) request.ftpAccount = value;
        break;

      case '--ftp-method':
        if (value != null) request.ftpMethod = value;
        break;

      // Remote time
      case '-R':
      case '--remote-time':
        request.remoteTime = true;
        break;
    }
  }

  /// Tokenize the curl command, respecting quotes
  static List<String> _tokenizeCurlCommand(String command) {
    final tokens = <String>[];
    var inSingleQuote = false;
    var inDoubleQuote = false;
    var currentToken = StringBuffer();

    for (var i = 0; i < command.length; i++) {
      final char = command[i];

      if (char == "'" && !inDoubleQuote) {
        inSingleQuote = !inSingleQuote;
        currentToken.write(char);
      } else if (char == '"' && !inSingleQuote) {
        inDoubleQuote = !inDoubleQuote;
        currentToken.write(char);
      } else if (char == ' ' && !inSingleQuote && !inDoubleQuote) {
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken.toString());
          currentToken = StringBuffer();
        }
      } else {
        currentToken.write(char);
      }
    }

    if (currentToken.isNotEmpty) {
      tokens.add(currentToken.toString());
    }

    return tokens.where((token) => token.isNotEmpty).toList();
  }
}
