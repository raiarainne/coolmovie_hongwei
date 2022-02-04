import 'package:coolmovies/model/movie_data.dart';
import 'package:coolmovies/model/user_data.dart';

class MovieData_sample{
  List<MovieModel> movieList =[];
  MovieData_sample(){
     movieList =[];
     movieList.add(MovieModel(
         id: '70351289-8756-4101-bf9a-37fc8c7a82cd',
         title: "Rogue One: A Star Wars Story",
         imgUrl: 'https://upload.wikimedia.org/wikipedia/en/d/d4/Rogue_One%2C_A_Star_Wars_Story_poster.png',
         movieDirectorId: 'c103cc08-ed39-4a3c-a1f3-0f431c07539e',
         userCreatorId: '7b4c31df-04b3-452f-a9ee-e9f8836013cc',
         releaseDate: '2016-12-16',
         nodeId: 'WyJtb3ZpZXMiLCI3MDM1MTI4OS04NzU2LTQxMDEtYmY5YS0zN2ZjOGM3YTgyY2QiXQ==',
         creatordata: new UserModel(id: '7b4c31df-04b3-452f-a9ee-e9f8836013cc', name: 'Marle', nodeId: 'WyJ1c2VycyIsIjdiNGMzMWRmLTA0YjMtNDUyZi1hOWVlLWU5Zjg4MzYwMTNjYyJd')));

     movieList.add(MovieModel(
         id: 'b8d93229-e02a-4060-9370-3e073ada86c3',
         title: "Star Wars: A New Hope",
         imgUrl: 'https://images-na.ssl-images-amazon.com/images/I/81aA7hEEykL.jpg',
         movieDirectorId: '7467db60-d506-4f1a-b5b4-7f2620d61669',
         userCreatorId: '5f1e6707-7c3a-4acd-b11f-fd96096abd5a',
         releaseDate: '1977-05-25',
         nodeId: 'WyJtb3ZpZXMiLCJiOGQ5MzIyOS1lMDJhLTQwNjAtOTM3MC0zZTA3M2FkYTg2YzMiXQ==',
         creatordata: new UserModel(id: '5f1e6707-7c3a-4acd-b11f-fd96096abd5a', name: 'Chrono', nodeId: 'WyJ1c2VycyIsIjVmMWU2NzA3LTdjM2EtNGFjZC1iMTFmLWZkOTYwOTZhYmQ1YSJd')));



  }

}