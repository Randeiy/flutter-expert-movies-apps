import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/entities/tv/tv_entity.dart';
import 'package:ditonton/common/failure.dart';

abstract class TvRepository {
  Future<Either<Failure, List<TvModel>>> getNowPlayingTv();
  Future<Either<Failure, List<TvModel>>> getPopularTv();
  Future<Either<Failure, List<TvModel>>> getTopRatedTv();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, List<TvModel>>> getTvRecommendations(int id);
  Future<Either<Failure, List<TvModel>>> searchTv(String query);
  Future<Either<Failure, String>> saveWatchlistTv(TvDetail tvmodel);
  Future<Either<Failure, String>> removeWatchlistTv(TvDetail tvmodel);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TvModel>>> getWatchlistTv();
}
