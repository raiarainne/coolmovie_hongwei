import 'package:coolmovies/common/color_constants.dart';
import 'package:coolmovies/data/data.dart';

import 'package:coolmovies/model/movie_data.dart';
import 'package:coolmovies/widgets/Progressdialog.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'item_detail_screen.dart';

/*
Title: HomePageScreen
Purpose:HomePageScreen
Created By:Hongwei
*/

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with SingleTickerProviderStateMixin {
  final List<MovieModel> movieList =[];

  final ValueNotifier<Map<String,dynamic>?> _data = ValueNotifier(null);

  Size get _size => MediaQuery.of(context).size;

  double get _movieItemWidth => _size.width / 2 + 48;
  ScrollController _movieScrollController = ScrollController();
  ScrollController _backgroundScrollController = ScrollController();
  double _maxMovieTranslate = 65;
  int _movieIndex = 0;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      this._fetchData();
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: Progressdialog(context, _buildWidget(context), loading));
  }

  @override
  Widget _buildWidget(BuildContext context) {
    _movieScrollController.addListener(
      () {
        _backgroundScrollController.jumpTo(
          _movieScrollController.offset * (_size.width / _movieItemWidth),
        );
      },
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
            _backgroundListView(),
            _movieListView(),
        ],
      ),
    );
  }

  Widget _movieItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          AnimatedBuilder(
            animation: _movieScrollController,
            builder: (ctx, child) {
              double activeOffset = index * _movieItemWidth;

              double translate =
                  _movieTranslate(_movieScrollController.offset, activeOffset);

              return SizedBox(
                height: translate,
              );
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (ctx, a1, a2) => ItemDetailScreen(
                      movie: movieList[_movieIndex],
                      size: _size,
                    ),
                  ),
                );
              },
              child: Image.network(movieList[index].imgUrl,
                width: _size.width / 2,),
            ),
          ),
          SizedBox(
            height: _size.height * .02,
          ),
          AnimatedBuilder(
            animation: _movieScrollController,
            builder: (context, child) {
              double activeOffset = index * _movieItemWidth;
              double opacity = _movieDescriptionOpacity(
                  _movieScrollController.offset, activeOffset);

              return Opacity(
                opacity: opacity / 100,
                child: Column(
                  children: <Widget>[
                    Text(
                      movieList[index].creatordata.name,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: Colors.white,
                            fontSize: _size.width / 18,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(
                      height: _size.height * .01,
                    ),
                    Text(
                      movieList[index].releaseDate,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            color: Colors.white,
                            fontSize: _size.width / 22,
                          ),
                    ),
                    SizedBox(
                      height: _size.height * .005,
                    ),
                    /*AppWidget.starRating(
                      movieList[index].rating,
                    )*/
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  double _movieDescriptionOpacity(double offset, double activeOffset) {
    double opacity;
    if (_movieScrollController.offset + _movieItemWidth <= activeOffset) {
      opacity = 0;
    } else if (_movieScrollController.offset <= activeOffset) {
      opacity =
          ((_movieScrollController.offset - (activeOffset - _movieItemWidth)) /
              _movieItemWidth *
              100);
    } else if (_movieScrollController.offset < activeOffset + _movieItemWidth) {
      opacity = 100 -
          (((_movieScrollController.offset - (activeOffset - _movieItemWidth)) /
                  _movieItemWidth *
                  100) -
              100);
    } else {
      opacity = 0;
    }
    return opacity;
  }

  double _movieTranslate(double offset, double activeOffset) {
    double translate;
    if (_movieScrollController.offset + _movieItemWidth <= activeOffset) {
      translate = _maxMovieTranslate;
    } else if (_movieScrollController.offset <= activeOffset) {
      translate = _maxMovieTranslate -
          ((_movieScrollController.offset - (activeOffset - _movieItemWidth)) /
              _movieItemWidth *
              _maxMovieTranslate);
    } else if (_movieScrollController.offset < activeOffset + _movieItemWidth) {
      translate =
          ((_movieScrollController.offset - (activeOffset - _movieItemWidth)) /
                  _movieItemWidth *
                  _maxMovieTranslate) -
              _maxMovieTranslate;
    } else {
      translate = _maxMovieTranslate;
    }
    return translate;
  }

  Widget _movieListView() {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 700),
      tween: Tween<double>(begin: 600, end: 0),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) {
        return Transform.translate(
          offset: Offset(value as double, 0),
          child: child,
        );
      },
      child: Container(
        height: _size.height * .75,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return true;
          },
          child: ScrollSnapList(
            listController: _movieScrollController,
            onItemFocus: (item) {
              _movieIndex = item;
            },
            itemSize: _movieItemWidth,
            padding: EdgeInsets.zero,
            itemCount: movieList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return _movieItem(index);
            },
          ),
        ),
      ),
    );
  }

  Widget _backgroundListView() {
    return ListView.builder(
      controller: _backgroundScrollController,
      padding: EdgeInsets.zero,
      reverse: true,
      itemCount: movieList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) {
        return Container(
          width: _size.width,
          height: _size.height,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Positioned(
                left: -_size.width / 3,
                right: -_size.width / 3,
                child: Image.network(movieList[index].imgUrl,
                fit: BoxFit.cover,),

              ),
              Container(
                color: Colors.grey.withOpacity(.6),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.9),
                      Colors.black.withOpacity(.3),
                      Colors.black.withOpacity(.95)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.5, 0.9],
                  ),
                ),
              ),
              Container(
                height: _size.height * .35,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 30, right: 30),
                child: Align(
                  alignment: Alignment.center,
                  child:Text(
                    movieList[index].title,
                    style: TextStyle(color: ColorConstants.kWhiteColor, fontSize: 30),
                    textAlign: TextAlign.center,
                  ),

                ),
              ),
            ],
          ),
        );
      },
    );
  }
  //========== Get All Movies============
  void _fetchData() async {
    showProgress();
    var client = GraphQLProvider.of(context).value;
    final QueryResult result = await client.query(
        QueryOptions(
          document: gql("""
          query AllMovies {
            allMovies {
              nodes {
                id
                imgUrl
                movieDirectorId
                userCreatorId
                title
                releaseDate
                nodeId
                userByUserCreatorId {
                  id
                  name
                  nodeId
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
      movieList.addAll(MovieModel.getList(result.data!['allMovies']['nodes']));
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
