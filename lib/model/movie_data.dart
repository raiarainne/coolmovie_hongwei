import 'package:coolmovies/model/user_data.dart';
import 'package:flutter/material.dart';

class MovieModel {
  String id ;
  String imgUrl ;
  String movieDirectorId;
  String userCreatorId;
  String title;
  String releaseDate;
  String nodeId;
  UserModel creatordata;
  List<MovieCastModel> castList = [];

  MovieModel({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.movieDirectorId,
    required this.userCreatorId,
    required this.releaseDate,
    required this.nodeId,
    required this.creatordata,

    //required this.castList,
  });

  factory MovieModel.fromJSON(Map<String, dynamic> res){
    MovieModel model = new MovieModel(
        id : res["id"],
        title : res["title"],
        imgUrl : res["imgUrl"],
        movieDirectorId : res["movieDirectorId"],
        userCreatorId : res["userCreatorId"],
        releaseDate : res["releaseDate"],
        nodeId : res["nodeId"],
        creatordata : UserModel.fromJSON(res['userByUserCreatorId']),
    );


    return model;
  }

  static List<MovieModel> getList(List<dynamic> data) {
    List<MovieModel> allData = [];
    data.forEach((element) {
      allData.add(MovieModel.fromJSON(element));
    });
    return allData;
  }
}

class MovieCastModel {
  String name;
  Image photo;

  MovieCastModel({
    required this.name,
    required this.photo,
  });
}

class MovieData {
  List<MovieModel> movieList = [];

}
