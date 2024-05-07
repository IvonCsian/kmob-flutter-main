import 'package:flutter/material.dart';
import 'package:html/parser.dart';

String _parseHtmlString(String htmlString) {

var document = parse(htmlString);

String parsedString = parse(document.body.text).documentElement.text;

return parsedString;
}

class K3PGService {
  IconData image;
  Color color;
  String title;
  String mode;

  K3PGService({this.image, this.title, this.color,this.mode});
}

class Promo {
  String id;
  String title;
  String content;
  String image;
  String button;

  Promo({this.image, this.title, this.content, this.button, id});

  factory Promo.fromJson(Map<String, dynamic> json) {
    return new Promo(
      id: json['id'],
      title: json['title']!=null?json['title']:'',
      content: json['content']!=null?_parseHtmlString(json['content']):'',
      image: json['image_path']!=null?json['image_path']:'',
      button: 'Selengkapnya',
    );
  }
}
