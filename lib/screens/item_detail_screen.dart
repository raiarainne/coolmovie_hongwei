import 'dart:ui';

import 'package:coolmovies/common/color_constants.dart';
import 'package:coolmovies/model/movie_data.dart';
import 'package:coolmovies/model/review_data.dart';
import 'package:coolmovies/widgets/Progressdialog.dart';
import 'package:coolmovies/widgets/app_widget.dart';
import 'package:coolmovies/widgets/custom_dialog_box.dart';
import 'package:coolmovies/widgets/text_button_widget.dart';
import 'package:coolmovies/widgets/write_review_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:rubber/rubber.dart';
import 'package:video_player/video_player.dart';


class ItemDetailScreen extends StatefulWidget {
  final MovieModel movie;
  final Size size;

  ItemDetailScreen({
    required this.movie,
    required this.size,
  });

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

 bool loading = false;



class _ItemDetailScreenState extends State<ItemDetailScreen>
    with TickerProviderStateMixin {
  Size get _size => MediaQuery.of(context).size;
  late RubberAnimationController _rubberSheetAnimationController;
  late ScrollController _rubberSheetScrollController;

  late VideoPlayerController _moviePlayerController;
  late VideoPlayerController _reflectionPlayerController;

  @override
  void initState() {
    super.initState();

    _rubberSheetScrollController = ScrollController();
    _rubberSheetAnimationController = RubberAnimationController(
      vsync: this,
      lowerBoundValue:
          AnimationControllerValue(pixel: widget.size.height * .75),
      dismissable: false,
      upperBoundValue: AnimationControllerValue(percentage: .9),
      duration: Duration(milliseconds: 300),
      springDescription: SpringDescription.withDampingRatio(
        mass: 1,
        stiffness: Stiffness.LOW,
        ratio: DampingRatio.LOW_BOUNCY,
      ),
    );

    Future.delayed(Duration.zero, () {
      this._fetchreviewData();
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: Progressdialog(context, _buildWidget(context), loading));
  }

  @override
  Widget _buildWidget(BuildContext context) {
    print(widget.movie.imgUrl);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[

          _background(widget.movie.imgUrl),
          _rubberSheet(),
          _buyButton(context),
          _backButton(context)
        ],
      ),
    );
  }

  Positioned _backButton(BuildContext context) {
    return Positioned(
      left: 16,
      top: MediaQuery.of(context).padding.top + 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buyButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: _size.width * .9,
        height: _size.height * .08,
        margin: EdgeInsets.symmetric(vertical: _size.width * .05),
      ),
    );
  }

  Widget _rubberSheet() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 250),
      tween: Tween<double>(begin: _size.height / 2, end: 0),
      builder: (_, value, child) {
        return Transform.translate(
          offset: Offset(0, value as double),
          child: child,
        );
      },
      child: RubberBottomSheet(
        scrollController: _rubberSheetScrollController,
        animationController: _rubberSheetAnimationController,
        lowerLayer: Container(
          color: Colors.transparent,
        ),
        upperLayer: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.movie.title,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.kOrangeColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(24),
                    controller: _rubberSheetScrollController,
                    children: <Widget>[
                      Text(
                        "Created By "+widget.movie.creatordata.name,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      SizedBox(
                        height:12,
                      ),
                      TextButtonWidget(
                        btnTxt: "Write Review",
                        btnBackColor: ColorConstants.kBlackColor,
                        textColor: ColorConstants.kPrimaryColor,
                        btnOnTap: () {
                          showWritereviewdialog(-1);
                        },
                      ),SizedBox(
                        height:22,
                      ),
                      Text(
                        'Reviews('+ ColorConstants.movie_reviews.length.toString()+')',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      _cast(),
                      SizedBox(
                        height: 68,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cast() {
    return Container(
      width: _size.width,     
      height: 360,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: ColorConstants.movie_reviews.length,
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 0.0,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: ListTile(
                  onTap: (){
                    showRatingdialog(index);
                  },
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                  title: Text(
                    ColorConstants.movie_reviews[index].title,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppWidget.starRating_leftalign( ColorConstants.movie_reviews[index].rating),
                      Text(
                          ColorConstants.movie_reviews[index].body.substring(0, 35)+"...",
                          style: TextStyle(color: Colors.white)
                      ),
                    ],
                  ),
                  trailing:
                  Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)
              ),
            ),
          );
        },
      ),
    );
  }

  void showRatingdialog(int index){
    showDialog(context: context,
        builder: (BuildContext context){
          return CustomDialogBox(
            title: ColorConstants.movie_reviews[index].title,
            descriptions: ColorConstants.movie_reviews[index].body,
            text: "Close", img: Image.asset("assets/image/cast/liu.jpg"),
            rating: ColorConstants.movie_reviews[index].rating,
          );
        }
    );
  }

  void showWritereviewdialog(int index){
    showDialog(context: context,
        builder: (BuildContext context){
          return WriteReviewDialogBox(
            title: index == -1 ? "" : ColorConstants.movie_reviews[index].title,
            descriptions: index == -1 ? "" : ColorConstants.movie_reviews[index].body,
            text: "Close", img: Image.asset("assets/image/cast/liu.jpg"),
            rating: index == -1 ? 4 : ColorConstants.movie_reviews[index].rating,
            movieid: widget.movie.id,
          );
        }
    );
  }


  Widget _background(String background) {
    return Positioned(
      top: -48,
      bottom: 0,
      child: TweenAnimationBuilder(
        duration: Duration(milliseconds: 250),
        tween: Tween<double>(begin: .25, end: 1),
        builder: (_, value, child) {
          return Transform.scale(
            scale: value as double,
            child: child,
          );
        },
        child: Image.network(background,
          fit: BoxFit.cover,
          width: _size.width,
          height: _size.height,),
      ),
    );
  }



  //========== Get All Movies============
  void _fetchreviewData() async {
    showProgress();
    var client = GraphQLProvider.of(context).value;
    final QueryResult result = await client.query(
        QueryOptions(
          document: gql("""
          query allMovieReviews {
            allMovieReviews (
              filter: {movieId: {equalTo: \""""+widget.movie.id+"""\"}}
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
      print(result.exception.toString());
    }

    if(result.data != null) {
      print(result.data.toString());
      ColorConstants.movie_reviews = [];
      ColorConstants.movie_reviews.addAll(ReviewModel.getList(result.data!['allMovieReviews']['nodes']));
      closeProgress();
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
