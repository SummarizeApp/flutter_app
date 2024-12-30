// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

// class ApiBaseHelper {
//   // Base URL, koşula göre farklı değerler alacak şekilde ayarlanabilir
//   final String _baseUrl = "http://192.168.1.30:3000/api"; // Prod URL örneği

//   // GET isteği gönderme
//   Future<dynamic> get(String url, String? token, [Map<String, String>? params]) async {
//     var responseJson;
//     var headers = {"Content-Type": "application/json"};
//     if (token != null) {
//       headers["Authorization"] = token;
//     }
//     Uri uri = Uri.parse(_baseUrl + url);
//     if (params != null) {
//       uri = Uri(
//         scheme: uri.scheme,
//         host: uri.host,
//         port: uri.port,
//         path: uri.path,
//         queryParameters: params,
//       );
//     }
//     try {
//       final response = await http.get(uri, headers: headers);
//       responseJson = _returnResponse(response);
//     } catch (e) {
//       print("Error: $e");
//       throw FetchDataException('No Internet connection');
//     }
//     return responseJson;
//   }

//   // POST isteği gönderme
//   Future<dynamic> post(String url, dynamic body, String? token) async {
//     var responseJson;
//     var headers = {"Content-Type": "application/json"};
//     if (token != null) {
//       headers["Authorization"] = token;
//     }
//     try {
//       final response = await http.post(
//         Uri.parse(_baseUrl + url),
//         body: jsonEncode(body),
//         headers: headers,
//       );
//       responseJson = _returnResponse(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }
//     return responseJson;
//   }

//   // PUT isteği gönderme
//   Future<dynamic> put(String url, dynamic body, String? token) async {
//     var responseJson;
//     var headers = {"Content-Type": "application/json"};
//     if (token != null) {
//       headers["Authorization"] = token;
//     }
//     try {
//       final response = await http.put(
//         Uri.parse(_baseUrl + url),
//         body: jsonEncode(body),
//         headers: headers,
//       );
//       responseJson = _returnResponse(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }
//     return responseJson;
//   }

//   // DELETE isteği gönderme
//   Future<dynamic> delete(String url, String? token) async {
//     var apiResponse;
//     var headers = {"Content-Type": "application/json"};
//     if (token != null) {
//       headers["Authorization"] = token;
//     }
//     try {
//       final response = await http.delete(
//         Uri.parse(_baseUrl + url),
//         headers: headers,
//       );
//       apiResponse = _returnResponse(response);
//     } on SocketException {
//       throw FetchDataException('No Internet connection');
//     }
//     return apiResponse;
//   }

//   // Multipart dosya gönderme (örneğin bir ses kaydını yüklemek için)
//   // Future<dynamic> multipartRequest({
//   //   required String url,
//   //   String? token,
//   //   required Map<String, dynamic> fields,
//   //   required String filePath,
//   //   required String requestType,
//   // }) async {
//   //   var responseJson;
//   //   var request = http.MultipartRequest(requestType, Uri.parse(_baseUrl + url))
//   //     ..headers["Authorization"] = token ?? ""
//   //     ..fields.addAll(fields)
//   //     ..files.add(await http.MultipartFile.fromPath(
//   //       'file',
//   //       filePath,
//   //       contentType: MediaType('audio', 'aac'),
//   //     ));
//   //   try {
//   //     var streamedResponse = await request.send();
//   //     var response = await http.Response.fromStream(streamedResponse);
//   //     responseJson = _returnResponse(response);
//   //   } on SocketException {
//   //     throw FetchDataException('No Internet connection');
//   //   }
//   //   return responseJson;
//   // }

//   // API yanıtını kontrol etme ve hata yönetimi
//   dynamic _returnResponse(http.Response response) {
//     switch (response.statusCode) {
//       case 200:
//         var responseJson = json.decode(response.body.toString());
//         return responseJson;
//       case 400:
//         throw BadRequestException(response.body.toString());
//       case 401:
//       case 403:
//         throw UnauthorisedException(response.body.toString());
//       case 500:
//       default:
//         throw FetchDataException(
//             'Error occurred while communication with server with statusCode: ${response.statusCode}');
//     }
//   }
// }

// // Hata sınıfları
// class FetchDataException implements Exception {
//   final String message;
//   FetchDataException(this.message);
// }

// class BadRequestException implements Exception {
//   final String message;
//   BadRequestException(this.message);
// }

// class UnauthorisedException implements Exception {
//   final String message;
//   UnauthorisedException(this.message);
// }
