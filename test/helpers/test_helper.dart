import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/db/tv_db/database_tv.dart';
import 'package:ditonton/data/datasources/db/tv_db/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/db/tv_db/tv_remote_data_source.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repositories.dart';
import 'package:ditonton/domain/usecases/usecase_tv/search_tv.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  TvRepository,
  TvRemoteDataSource,
  TvLocalDataSource,
  DatabaseHelper,
  DatabaseTv,


], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
