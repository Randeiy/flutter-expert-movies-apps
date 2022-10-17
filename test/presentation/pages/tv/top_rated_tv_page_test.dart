import 'package:ditonton/presentation/pages/tv_pages/top_rates_tv_page.dart';
import 'package:ditonton/presentation/provider/provider_tv/tv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/tv/dummy_tv.dart';
import '../../../helpers/test_helper_bloc.dart';


void main() {
  late TopRatedTvBlocHelper topRatedTvBlocHelper;

  setUpAll(() {
    topRatedTvBlocHelper = TopRatedTvBlocHelper();
    registerFallbackValue(TopRatedTvEventHelper());
    registerFallbackValue(TopRatedTvStateHelper());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>(
      create: (_) => topRatedTvBlocHelper,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        when(() => topRatedTvBlocHelper.state).thenReturn(TvLoading());

        final progressFinder = find.byType(CircularProgressIndicator);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

        expect(progressFinder, findsOneWidget);
      });

  testWidgets('Page should display when data is loaded',
          (WidgetTester tester) async {
        when(() => topRatedTvBlocHelper.state)
            .thenAnswer((invocation) => TvLoading());
        when(() => topRatedTvBlocHelper.state).thenReturn(TvHasData(testTvList));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => topRatedTvBlocHelper.state).thenReturn(TvHasError('Error'));

        final textFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

        expect(textFinder, findsOneWidget);
      });
}
