import 'package:flutter/material.dart';

class ReviewModel{
  String title;
  String body;
  int rating;

  ReviewModel({
    required this.title,
    required this.body,
    required this.rating,
  });

  factory ReviewModel.fromJSON(Map<String, dynamic> res){
    ReviewModel model = new ReviewModel(
      title : res["title"],
      body : res["body"],
      rating : res["rating"] ,
    );


    return model;
  }

  static List<ReviewModel> getList(List<dynamic> data) {
    List<ReviewModel> allData = [];
    data.forEach((element) {
      allData.add(ReviewModel.fromJSON(element));
    });
    return allData;
  }
}