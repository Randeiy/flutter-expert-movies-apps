import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/entities/tv/tv_entity.dart';
import 'package:ditonton/presentation/provider/provider_tv/tv_bloc.dart';
import 'package:ditonton/presentation/provider/provider_tv/tv_detail_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPage createState() => _TvDetailPage();
}

class _TvDetailPage extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>().add(FetchTvDetail(widget.id));
      context
          .read<RecommendationsTvBloc>()
          .add(FetchTvRecommendation(widget.id));
      context.read<WatchlistTvBloc>().add(LoadWatchlistTvStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final recommendedTv =
    context.select<RecommendationsTvBloc, List<TvModel>>((value) {
      if (value.state is TvHasData) {
        return (value.state as TvHasData).tvs;
      } else {
        return [];
      }
    });

    var isAddedToWatchlist = context.select<WatchlistTvBloc, bool>((value) {
      var state = value.state;
      if (state is LoadWatchlistTvData) {
        return state.status;
      }
      return false;
    });

    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvState>(
        builder: (context, state) {
          if (state is TvLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailHasData) {
            final tv = state.tv;
            return SafeArea(
              child: DetailContent(tv, recommendedTv, isAddedToWatchlist),
            );
          } else if (state is TvHasError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text('Cannot load data'),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tvmodel;
  final List<TvModel> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.tvmodel, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tvmodel.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvmodel.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<WatchlistTvBloc>()
                                      .add(SaveWatchlistTvSeries(tvmodel));
                                } else {
                                  context
                                      .read<WatchlistTvBloc>()
                                      .add(RemoveWatchlistTvSeries(tvmodel));
                                }

                                String message = '';

                                final state =
                                    BlocProvider.of<WatchlistTvBloc>(context)
                                        .state;
                                if (state is LoadWatchlistTvData) {
                                  message = isAddedWatchlist
                                      ? WatchlistTvBloc
                                      .watchlistRemoveSuccessMessage
                                      : WatchlistTvBloc
                                      .watchlistAddSuccessMessage;
                                } else {
                                  message = isAddedWatchlist == false
                                      ? WatchlistTvBloc
                                      .watchlistAddSuccessMessage
                                      : WatchlistTvBloc
                                      .watchlistRemoveSuccessMessage;
                                }

                                if (message ==
                                    WatchlistTvBloc
                                        .watchlistAddSuccessMessage ||
                                    message ==
                                        WatchlistTvBloc
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: Duration(milliseconds: 500),
                                          content: Text(message)));
                                  // Load new status
                                  BlocProvider.of<WatchlistTvBloc>(context)
                                      .add(LoadWatchlistTvStatus(tvmodel.id));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tvmodel.genres),
                            ),
                            Text(
                              (tvmodel.name),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tvmodel.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tvmodel.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvmodel.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final movie = recommendations[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          TvDetailPage.ROUTE_NAME,
                                          arguments: movie.id,
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                          placeholder: (context, url) =>
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: recommendations.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
