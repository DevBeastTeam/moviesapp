import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/boxes.dart';
import '../widgets/ui/primary_button.dart';

class ApiHelper {
  // static const String _baseUrl = 'https://dev.play.e-dutainment.com';
  static const String _baseUrl = 'https://terminator.e-dutainment.com';
  // static const String _baseUrl = 'https://play.e-dutainment.com';
  static const String _basePath = '/api/1.0';
  late Dio _dio;
  static final ApiHelper _instance = ApiHelper._internal();
  final navigatorKey = GlobalKey<NavigatorState>();

  factory ApiHelper() => _instance;

  ApiHelper._internal() {
    initDio();
  }

  void initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl + _basePath,
      headers: {
        'x-auth-type': 'jwt',
      },
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        print(options.uri);
        // print(options.headers[HttpHeaders.authorizationHeader]);
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        return handler.next(response);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) {
        return handler.next(e);
      },
    ));
  }

  Future fillHeaders() async {
    var token = await userBox.get('token');
    // debugPrint("👉 token: $token");
    _dio.options.headers[HttpHeaders.authorizationHeader] = 'JWT $token';
  }

  Future<dynamic> get(String url, ctx, {dynamic body}) async {
    await fillHeaders();
    dynamic responseJson;
    try {
      var response = await _dio.get(url, queryParameters: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      // print('No net');
      // throw FetchDataException('No Internet connection');
    } on DioException catch (e) {
      print(e);
      if (ctx == null) {
        return Future.error(
            'Une erreur est survenue, veuillez réessayer ulterierement ou contacter le support si le problème persiste.');
      }
      await AwesomeDialog(
          context: ctx,
          dialogType: DialogType.error,
          title: 'Error',
          desc:
              'Une erreur est survenue, veuillez réessayer ulterierement ou contacter le support si le problème persiste.',
          btnOkOnPress: () {},
          btnOk: PrimaryButton(
            onPressed: () => Navigator.of(ctx).pop(),
            text: 'Close',
          )).show();
    }
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body, ctx,
      [responseType = ResponseType.json]) async {
    await fillHeaders();
    dynamic responseJson;
    print(url);
    try {
      _dio.options.responseType = responseType;
      var response = await _dio.post(url, data: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      // print('No net');
      // print('No Internet connection');
    } on PlatformException {
      // print(PlatformException);
    } on DioException {
      if (ctx == null) {
        return Future.error(
            'Une erreur est survenue, veuillez réessayer ulterierement ou contacter le support si le problème persiste.');
      }

      await AwesomeDialog(
          context: ctx,
          dialogType: DialogType.error,
          title: 'Error',
          desc:
              'Une erreur est survenue, veuillez réessayer ulterierement ou contacter le support si le problème persiste.',
          btnOkOnPress: () {},
          btnOk: PrimaryButton(
            onPressed: () => Navigator.of(ctx).pop(),
            text: 'Close',
          )).show();
    }
    // print('api post.');
    return responseJson;
  }
}

dynamic _returnResponse(dynamic response) {
  return response.data;
}
