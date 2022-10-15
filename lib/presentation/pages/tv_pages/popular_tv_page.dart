import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/provider_tv/popular_tv_notifier.dart';
import 'package:ditonton/presentation/provider/provider_tv/tv_bloc.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PopularTvBloc>().add(FetchPopularTv()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvBloc, TvState>(builder: (context, state) {
          if (state is TvLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
              key: const Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Text('Data is empty');
          }
        }),
      ),
    );
  }
}
