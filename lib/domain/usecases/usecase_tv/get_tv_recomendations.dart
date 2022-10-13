import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv/tv_entity.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/tv_repositories.dart';

class GetTvRecommendations {
  final TvRepository repository;

  GetTvRecommendations(this.repository);

  Future<Either<Failure, List<TvModel>>> execute(id) {
    return repository.getTvRecommendations(id);
  }
}
