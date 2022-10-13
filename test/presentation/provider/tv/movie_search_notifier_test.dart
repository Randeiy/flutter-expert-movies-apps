import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv_entity.dart';
import 'package:ditonton/domain/usecases/usecase_tv/search_tv.dart';
import 'package:ditonton/presentation/provider/provider_tv/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_search_notifier_test.mocks.dart';

@GenerateMocks([SearchMoviesTv])
void main() {
  late TvSearchNotifier provider;
  late MockSearchMoviesTv mockSearchMoviesTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchMoviesTv = MockSearchMoviesTv();
    provider = TvSearchNotifier(searchTv: mockSearchMoviesTv)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tMovieModel = TvModel(
    firstAirDate: "2010-10-31",
    originalLanguage: "en",
    backdropPath: "/suopoADq0k8YZr4dQXcU6pToj6s.jpg",
    genreIds: [18, 9648],
    id: 9813,
    originalName: "Game of Thrones",
    overview:
        "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
    popularity: 60.441,
    posterPath: "/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg",
    originCountry: ["US"],
    name: "Game of Thrones",
    voteAverage: 7.38,
    voteCount: 1172,
  );
  final tMovieList = <TvModel>[tMovieModel];
  final tQuery = 'gameofthrones';

  group('search movies', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchMoviesTv.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchMovieSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchMoviesTv.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await provider.fetchMovieSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchMoviesTv.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchMovieSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
