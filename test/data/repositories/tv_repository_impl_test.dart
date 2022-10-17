import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/modelstv/tv_detail.dart';
import 'package:ditonton/data/models/modelstv/tv_models.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/entities/tv/tv_entity.dart';

import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


import '../../dummy_data/tv/dummy_tv.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockTvRemoteDataSource;
  late MockTvLocalDataSource mockTvLocalDataSource;

  setUp(() {
    mockTvLocalDataSource = MockTvLocalDataSource();
    mockTvRemoteDataSource = MockTvRemoteDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockTvRemoteDataSource,
      localDataSource: mockTvLocalDataSource,
    );
  });

  final tTvModel = TvModelResponse(
    backdropPath: '/backdropPath',
    firstAirDate: '2021-01-01',
    genreIds: const [1, 2],
    id: 1,
    name: 'name',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: '/posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTv = TvModel(
    backdropPath: '/backdropPath',
    firstAirDate: '2021-01-01',
    genreIds: const [1, 2],
    id: 1,
    name: 'name',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: '/posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvModelList = <TvModelResponse>[tTvModel];
  final tTvList = <TvModel>[tTv];

  group('On The Air', () {
    test('shoud return remote data', () async {
      when(mockTvRemoteDataSource.getNowPlayingTv())
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getNowPlayingTv();

      verify(mockTvRemoteDataSource.getNowPlayingTv());

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });
    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getNowPlayingTv())
              .thenAnswer((_) => throw ServerFailure(''));
          // act
          final result = await repository.getNowPlayingTv();
          // assert
          verify(mockTvRemoteDataSource.getNowPlayingTv());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getNowPlayingTv())
              .thenThrow(ConnectionFailure('Failed to connect to the network'));
          // act
          final result = await repository.getNowPlayingTv();
          // assert
          verify(mockTvRemoteDataSource.getNowPlayingTv());
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Popular Tv', () {
    test('shoud return remote data', () async {
      when(mockTvRemoteDataSource.getPopularTv())
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getPopularTv();

      verify(mockTvRemoteDataSource.getPopularTv());

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getPopularTv()).thenThrow(ServerFailure(''));
          // act
          final result = await repository.getPopularTv();
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return connection failure when device is not connected to the internet',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getPopularTv())
              .thenThrow(ConnectionFailure('Failed to connect to the network'));
          // act
          final result = await repository.getPopularTv();
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Top Rated Tv', () {
    test('shoud return remote data', () async {
      when(mockTvRemoteDataSource.getTopRatedTv())
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getTopRatedTv();

      verify(mockTvRemoteDataSource.getTopRatedTv());

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getTopRatedTv())
              .thenAnswer((_) => throw ServerFailure(''));
          // act
          final result = await repository.getTopRatedTv();
          // assert
          verify(mockTvRemoteDataSource.getTopRatedTv());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getTopRatedTv())
              .thenThrow(ConnectionFailure('Failed to connect to the network'));
          // act
          final result = await repository.getTopRatedTv();
          // assert
          expect(
              result, Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Get Tv Detail', () {
    const tId = 1;
    final tTvDetail = TvDetailResponse(
      adult: false,
      backdropPath: "/pdfCr8W0wBCpdjbZXSxnKhZtosP.jpg",
      episodeRunTime: const [60],
      firstAirDate: DateTime(2022 - 09 - 01),
      genres: [
        GenreModel(id: 10765, name: "Sci-Fi & Fantasy"),
        GenreModel(id: 10759, name: "Action & Adventure"),
        GenreModel(id: 18, name: "Drama")
      ],
      homepage: "https://www.amazon.com/dp/B09QHC2LZM",
      id: 84773,
      inProduction: false,
      languages: const ["en"],
      lastAirDate: DateTime(2022 - 09 - 08),
      name: "The Lord of the Rings: The Rings of Power",
      numberOfEpisodes: 8,
      numberOfSeasons: 1,
      originCountry: const ["US"],
      originalLanguage: "en",
      originalName: "The Lord of the Rings: The Rings of Power",
      overview:
      "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
      popularity: 4962.027,
      posterPath: "/suyNxglk17Cpk8rCM2kZgqKdftk.jpg",
      status: "Returning Series",
      tagline: "Journey to Middle-earth.",
      type: "Scripted",
      voteAverage: 7.554,
      voteCount: 555,
    );
    test(
        'should return Movie data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getTvDetail(tId))
              .thenAnswer((_) async => tTvDetail);
          // act
          final result = await repository.getTvDetail(tId);
          // assert
          verify(mockTvRemoteDataSource.getTvDetail(tId));
          expect(result, equals(Right<Failure, TvDetail>(testTvDetail)));
        });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getTvDetail(tId))
              .thenThrow(ServerFailure(''));
          // act
          final result = await repository.getTvDetail(tId);
          // assert
          verify(mockTvRemoteDataSource.getTvDetail(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getTvDetail(tId))
              .thenThrow(ConnectionFailure('Failed to connect to the network'));
          // act
          final result = await repository.getTvDetail(tId);
          // assert
          verify(mockTvRemoteDataSource.getTvDetail(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Get Tv Recommendations', () {
    final tTvList = <TvModelResponse>[];
    const tId = 1;

    test('should return data (movie list) when the call is successful',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getTvRecommendations(tId))
              .thenAnswer((_) async => tTvList);
          // act
          final result = await repository.getTvRecommendations(tId);
          // assert
          verify(mockTvRemoteDataSource.getTvRecommendations(tId));
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tTvList));
        });

    test(
        'should return server failure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getTvRecommendations(tId))
              .thenThrow(ServerFailure(''));
          // act
          final result = await repository.getTvRecommendations(tId);
          // assertbuild runner
          verify(mockTvRemoteDataSource.getTvRecommendations(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to the internet',
            () async {
          // arrange
          when(mockTvRemoteDataSource.getTvRecommendations(tId))
              .thenThrow(ConnectionFailure('Failed to connect to the network'));
          // act
          final result = await repository.getTvRecommendations(tId);
          // assert
          verify(mockTvRemoteDataSource.getTvRecommendations(tId));
          expect(result,
              equals(Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockTvLocalDataSource.insertWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistTv(testTvDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockTvLocalDataSource.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistTv(testTvDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockTvLocalDataSource.removeWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistTv(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(mockTvLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist Tv', () {
    test('should return list of Tv', () async {
      // arrange
      when(mockTvLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchlistTv();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}
