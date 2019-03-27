import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/animation.dart';

class MainBloc
{
  var _dio = Dio();
  PublishSubject quotePublishObject = PublishSubject();
  String quote = "";

  MainBloc()
  {
    quotePublishObject.listen((str){
      quote = str;
    });
    quotePublishObject.startWith("");
  }

  void requestQuote() {
    _dio.get("https://api.kanye.rest/").then((resp) {
      if (resp.statusCode == 200) {
        Map<String, dynamic> responseData = resp.data;
        quotePublishObject.add(responseData["quote"]);
      }
    });
  }
}