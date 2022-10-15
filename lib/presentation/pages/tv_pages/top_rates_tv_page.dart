import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/provider_tv/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/provider/provider_tv/tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  @override
  _TopRatedTvPageState createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
            () => context.read<TopRatedTvBloc>().add(FetchTopRatedTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:BlocBuilder<TopRatedTvBloc, TvState>(builder: (context, state) {
          if (state is TvLoading) {
            return const CircularProgressIndicator();
          } else if (state is TvHasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.tvs[index];
                return TvCard(tv);
              },
              itemCount: state.tvs.length,
            );
          } else if (state is TvHasError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Text('Data is Empty');
          }
        }),
      ),
    );
  }
}
