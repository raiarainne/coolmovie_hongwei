import 'dart:ui';
import 'package:coolmovies/common/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'Progressdialog.dart';

class WriteReviewDialogBox extends StatefulWidget {
  final String title, descriptions, text, movieid;
  final Image img;
  late  int rating;



  WriteReviewDialogBox({Key? key, required this.title, required this.descriptions, required this.text, required this.img, required this.rating, required this.movieid }) : super(key: key);

    @override
    _WriteReviewDialogBoxState createState() => _WriteReviewDialogBoxState();
  }

class _WriteReviewDialogBoxState extends State<WriteReviewDialogBox> {

  bool loading = false;
  final etxTitle =  TextEditingController();
  final etxBody =  TextEditingController();

  void _showToast( String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  void initState() {
    super.initState();
    etxTitle.text = widget.title;
    etxBody.text = widget.descriptions;
  }

  bool isValid() {
    if (etxTitle.text.isEmpty){
      _showToast( 'Please enter title');
      return false;
    }

    if (etxBody.text.isEmpty){
      _showToast('Please enter body');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold( backgroundColor: Colors.transparent, body: Progressdialog(context, _buildWidget(context), loading));


  }
  @override
  Widget _buildWidget(BuildContext context) {
    return SingleChildScrollView(child:
      Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    ));
  }
  contentBox(context){

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: padding,top: avatarRadius
              + padding, right: padding,bottom: padding
          ),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: etxTitle,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter Title',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: etxBody,
                  minLines: 1,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter review body',
                  ),
                ),
              ),

              SizedBox(height: 22,),
              RatingBar.builder(
                initialRating: widget.rating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  widget.rating = rating.toInt();
                  print(rating);
                },
              ),
              SizedBox(height: 22,),

              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FlatButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text(widget.text,style: TextStyle(fontSize: 18,),)),

                    ),
                  ),

                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,

                      child: FlatButton(
                          onPressed: (){
                            if(isValid()){
                              saveratingvalue(etxTitle.value.toString(), etxBody.value.toString(), widget.rating);
                              //Navigator.of(context).pop();
                            }

                          },
                          child: Text("Save",style: TextStyle(fontSize: 18, color: Colors.cyan),)),

                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
        Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(avatarRadius)),
                child: widget.img,
            ),
          ),
        ),
      ],
    );
  }

  //========== Get All Movies============
  void saveratingvalue(String Title, String body, int rating) async {
    showProgress();
    var client = GraphQLProvider.of(context).value;
    final QueryResult result = await client.query(
        QueryOptions(
          document: gql("""
          query allMovieReviews {
            allMovieReviews (
              filter: {movieId: {equalTo: \""""+"test"+"""\"}}
            ){
              nodes {
                 title
                  body
                  rating
                  movieByMovieId {
                    title
                  }
              }
            }
          }
        """),
        )
    );

    if (result.hasException) {
      closeProgress();
      _showToast(result.exception.toString());
      print(result.exception.toString());
    }

    if(result.data != null) {
      print(result.data.toString());
      closeProgress();
      Navigator.of(context).pop();
    }
  }

  void showProgress() {
    setState(() {
      loading = true;
    });
  }

  void closeProgress(){
    setState(() {
      loading = false;
    });
  }
}