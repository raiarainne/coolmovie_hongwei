import 'package:flutter/material.dart';

class UserModel {
  String id;
  String name;
  String nodeId;

  UserModel({
    required this.id,
    required this.name,
    required this.nodeId,
  });

  factory UserModel.fromJSON(Map<String, dynamic> res){
    UserModel model = new UserModel(
      id : res["id"],
      name :  res["name"],
      nodeId :res["nodeId"],
    );
    return model;
  }
}