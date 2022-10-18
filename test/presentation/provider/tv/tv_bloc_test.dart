import 'package:bloc_test/bloc_test.dart';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/modelstv/tv_models.dart';
import 'package:ditonton/domain/entities/tv/tv_entity.dart';
import 'package:ditonton/domain/usecases/usecase_tv/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/usecase_tv/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/usecase_tv/get_top_rated_tv.dart';
import 'package:ditonton/domain/usecases/usecase_tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/usecase_tv/get_tv_recomendations.dart';
import 'package:ditonton/domain/usecases/usecase_tv/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/usecase_tv/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/usecase_tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/usecase_tv/save_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/provider_tv/tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
//testcommit

import '../../../dummy_data/tv/dummy_tv.dart';

import 'tv_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetNowPlayingTv,
  GetTopRatedTv,
  GetPopularTv,
  GetWatchlistTv,
  GetWatchListStatusTv,
  RemoveWatchlistTv,
  SaveWatchlistTv,
])
void main() {
  late NowPlayingTvBloc onTheAirNowBloc;
  late PopularTvBloc popularTvBloc;
  late TopRatedTvBloc topRatedTvBloc;
  late TvDetailBloc detailTvBloc;
  late RecommendationsTvBloc recommendationTvBloc;
  late WatchlistTvBloc watchlistTvBloc;

  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecomendation;
  late MockGetNowPlayingTv mockGetOnTheAirTv;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetWatchlistTv mockGetWatchListTv;
  late MockGetWatchListStatusTv mockGetWatchListTvStatus;
  late MockRemoveWatchlistTv mockRemoveTvWatchlist;
  late MockSaveWatchlistTv mockSaveTvWatchlist;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecomendation = MockGetTvRecommendations();
    mockGetOnTheAirTv = MockGetNowPlayingTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    mockGetPopularTv = MockGetPopularTv();
    mockGetWatchListTv = MockGetWatchlistTv();
    mockGetWatchListTvStatus = MockGetWatchListStatusTv();
    mockRemoveTvWatchlist = MockRemoveWatchlistTv();
    mockSaveTvWatchlist = MockSaveWatchlistTv();

    onTheAirNowBloc = NowPlayingTvBloc(mockGetOnTheAirTv);
    popularTvBloc = PopularTvBloc(mockGetPopularTv);
    topRatedTvBloc = TopRatedTvBloc(mockGetTopRatedTv);

    watchlistTvBloc = WatchlistTvBloc(
      mockGetWatchListTv,
      mockGetWatchListTvStatus,
      mockSaveTvWatchlist,
      mockRemoveTvWatchlist,
    );
    recommendationTvBloc = RecommendationsTvBloc(mockGetTvRecomendation);
    detailTvBloc = TvDetailBloc(
      mockGetTvDetail,
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

  final tTvList = <TvModel>[tTv];
  final tId = 1;

  group('Get now playing movies', () {
    test('initial state must be empty', () {
      expect(onTheAirNowBloc.state, TvLoading());
    });

    blocTest(
      'should emit[loading, movieHasData] when data is gotten succesfully',
      build: () {
        when(mockGetOnTheAirTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return onTheAirNowBloc;
      },
      act: (NowPlayingTvBloc bloc) => bloc.add(FetchNowplayingTv()),
      wait: Duration(milliseconds: 500),
      expect: () => [TvLoading(), TvHasData(tTvList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetOnTheAirTv.execute()).thenAnswer(
                (realInvocation) async => Left(ServerFailure('Server Failure')));
        return onTheAirNowBloc;
      },
      act: (NowPlayingTvBloc bloc) => bloc.add(FetchNowplayingTv()),
      wait: Duration(milliseconds: 500),
      expect: () => [
        TvLoading(),
        TvHasError('Server Failure'),
      ],
      verify: (NowPlayingTvBloc bloc) => verify(mockGetOnTheAirTv.execute()),
    );
  });

  group('Get Popular movies', () {
    test('initial state must be empty', () {
      expect(popularTvBloc.state, TvLoading());
    });

    blocTest(
      'should emit[loading, movieHasData] when data is gotten succesfully',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return popularTvBloc;
      },
      act: (PopularTvBloc bloc) => bloc.add(FetchPopularTv()),
      wait: Duration(milliseconds: 500),
      expect: () => [TvLoading(), TvHasData(tTvList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetPopularTv.execute()).thenAnswer(
                (realInvocation) async => Left(ServerFailure('Server Failure')));
        return popularTvBloc;
      },
      act: (PopularTvBloc bloc) => bloc.add(FetchPopularTv()),
      wait: Duration(milliseconds: 500),
      expect: () => [
        TvLoading(),
        const TvHasError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetPopularTv.execute()),
    );
  });

  group('Get Top Rated movies', () {
    test('initial state must be empty', () {
      expect(topRatedTvBloc.state, TvLoading());
    });

    blocTest(
      'should emit[loading, movieHasData] when data is gotten succesfully',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return topRatedTvBloc;
      },
      act: (TopRatedTvBloc bloc) => bloc.add(FetchTopRatedTv()),
      wait: const Duration(milliseconds: 500),
      expect: () => [TvLoading(), TvHasData(tTvList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetTopRatedTv.execute()).thenAnswer(
                (realInvocation) async => Left(ServerFailure('Server Failure')));
        return topRatedTvBloc;
      },
      act: (TopRatedTvBloc bloc) => bloc.add(FetchTopRatedTv()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvLoading(),
        const TvHasError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTopRatedTv.execute()),
    );
  });

  group('Get Recommended movies', () {
    test('initial state must be empty', () {
      expect(recommendationTvBloc.state, TvEmpty());
    });

    blocTest(
      'should emit[loading, movieHasData] when data is gotten succesfully',
      build: () {
        when(mockGetTvRecomendation.execute(tId))
            .thenAnswer((_) async => Right(tTvList));
        return recommendationTvBloc;
      },
      act: (RecommendationsTvBloc bloc) => bloc.add(FetchTvRecommendation(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [TvLoading(), TvHasData(tTvList)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetTvRecomendation.execute(tId)).thenAnswer(
                (realInvocation) async => Left(ServerFailure('Server Failure')));
        return recommendationTvBloc;
      },
      act: (RecommendationsTvBloc bloc) => bloc.add(FetchTvRecommendation(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvLoading(),
        const TvHasError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTvRecomendation.execute(tId)),
    );
  });

  group('Get Details movies', () {
    test('initial state must be empty', () {
      expect(detailTvBloc.state, TvLoading());
    });

    blocTest(
      'should emit[loading, movieHasData] when data is gotten succesfully',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        return detailTvBloc;
      },
      act: (TvDetailBloc bloc) => bloc.add(FetchTvDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [TvLoading(), TvDetailHasData(testTvDetail)],
    );

    blocTest(
      'Should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(mockGetTvDetail.execute(tId)).thenAnswer(
                (realInvocation) async => Left(ServerFailure('Server Failure')));
        return detailTvBloc;
      },
      act: (TvDetailBloc bloc) => bloc.add(FetchTvDetail(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        TvLoading(),
        const TvHasError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTvDetail.execute(tId)),
    );
  });

  group('Get Watchlist movies', () {
    test('initial state must be empty', () {
      expect(watchlistTvBloc.state, TvEmpty());
    });

    group('Watchlist Movie', () {
      test('initial state should be empty', () {
        expect(watchlistTvBloc.state, TvEmpty());
      });

      group('Fetch Watchlist Movie', () {
        blocTest(
          'Should emit [Loading, HasData] when data is gotten successfully',
          build: () {
            when(mockGetWatchListTv.execute())
                .thenAnswer((_) async => Right(tTvList));
            return watchlistTvBloc;
          },
          act: (WatchlistTvBloc bloc) => bloc.add(FetchWatchListTv()),
          wait: const Duration(milliseconds: 500),
          expect: () => [
            TvLoading(),
            WatchlistTvHasData(tTvList),
          ],
          verify: (bloc) => verify(mockGetWatchListTv.execute()),
        );

        blocTest(
          'Should emit [Loading, Error] when get search is unsuccessful',
          build: () {
            when(mockGetWatchListTv.execute())
                .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
            return watchlistTvBloc;
          },
          act: (WatchlistTvBloc bloc) => bloc.add(FetchWatchListTv()),
          wait: const Duration(milliseconds: 500),
          expect: () => [
            TvLoading(),
            const TvHasError('Server Failure'),
          ],
          verify: (bloc) => verify(mockGetWatchListTv.execute()),
        );
      });

      group('Load Watchlist Movie', () {
        blocTest(
          'Should emit [Loading, HasData] when data is gotten successfully',
          build: () {
            when(mockGetWatchListTvStatus.execute(tId))
                .thenAnswer((_) async => true);
            return watchlistTvBloc;
          },
          act: (WatchlistTvBloc bloc) => bloc.add(LoadWatchlistTvStatus(tId)),
          wait: const Duration(milliseconds: 500),
          expect: () => [
            TvLoading(),
            LoadWatchlistTvData(true),
          ],
          verify: (bloc) => verify(mockGetWatchListTvStatus.execute(tId)),
        );

        blocTest(
          'Should emit [Loading, Error] when get search is unsuccessful',
          build: () {
            when(mockGetWatchListTvStatus.execute(tId))
                .thenAnswer((_) async => false);
            return watchlistTvBloc;
          },
          act: (WatchlistTvBloc bloc) => bloc.add(LoadWatchlistTvStatus(tId)),
          wait: Duration(milliseconds: 500),
          expect: () => [
            TvLoading(),
            LoadWatchlistTvData(false),
          ],
          verify: (bloc) => verify(mockGetWatchListTvStatus.execute(tId)),
        );
      });

      group('Save Watchlist Movie', () {
        blocTest(
          'Should emit [Loading, HasData] when data is gotten successfully',
          build: () {
            when(mockSaveTvWatchlist.execute(testTvDetail)).thenAnswer(
                    (_) async => Right(WatchlistTvBloc.watchlistAddSuccessMessage));
            return watchlistTvBloc;
          },
          act: (WatchlistTvBloc bloc) =>
              bloc.add(SaveWatchlistTvSeries(testTvDetail)),
          wait: Duration(milliseconds: 500),
          expect: () => [
            TvLoading(),
            WatchlistTvMessage(WatchlistTvBloc.watchlistAddSuccessMessage),
          ],
          verify: (bloc) => verify(mockSaveTvWatchlist.execute(testTvDetail)),
        );

        blocTest(
          'Should emit [Loading, Error] when get search is unsuccessful',
          build: () {
            when(mockSaveTvWatchlist.execute(testTvDetail))
                .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
            return watchlistTvBloc;
          },
          act: (WatchlistTvBloc bloc) =>
              bloc.add(SaveWatchlistTvSeries(testTvDetail)),
          wait: Duration(milliseconds: 500),
          expect: () => [
            TvLoading(),
            TvHasError('Server Failure'),
          ],
          verify: (bloc) => verify(mockSaveTvWatchlist.execute(testTvDetail)),
        );
      });

      group('Remove Watchlist Movie', () {
        blocTest(
          'Should emit [Loading, HasData] when data is gotten successfully',
          build: () {
            when(mockRemoveTvWatchlist.execute(testTvDetail)).thenAnswer(
                    (_) async => Right(WatchlistTvBloc.watchlistAddSuccessMessage));
            return watchlistTvBloc;
          },
          act: (WatchlistTvBloc bloc) =>
              bloc.add(RemoveWatchlistTvSeries(testTvDetail)),
          wait: Duration(milliseconds: 500),
          expect: () => [
            TvLoading(),
            WatchlistTvMessage(WatchlistTvBloc.watchlistAddSuccessMessage),
          ],
          verify: (bloc) => verify(mockRemoveTvWatchlist.execute(testTvDetail)),
        );

        blocTest(
          'Should emit [Loading, Error] when get search is unsuccessful',
          build: () {
            when(mockRemoveTvWatchlist.execute(testTvDetail))
                .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
            return watchlistTvBloc;
          },
          act: (WatchlistTvBloc bloc) =>
              bloc.add(RemoveWatchlistTvSeries(testTvDetail)),
          wait: Duration(milliseconds: 500),
          expect: () => [
            TvLoading(),
            TvHasError('Server Failure'),
          ],
          verify: (bloc) => verify(mockRemoveTvWatchlist.execute(testTvDetail)),
        );
      });
    });
  });
}
