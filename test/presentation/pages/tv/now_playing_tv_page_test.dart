import 'package:ditonton/presentation/pages/tv_pages/now_playing_tv.dart';
import 'package:ditonton/presentation/pages/tv_pages/popular_tv_page.dart';
import 'package:ditonton/presentation/provider/provider_tv/tv_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dummy_data/tv/dummy_tv.dart';
import '../../../helpers/test_helper_bloc.dart';

void main() {
  late OnAirNowBlocHelper onAirNowBlocHelper;
  setUpAll(() {
    onAirNowBlocHelper = OnAirNowBlocHelper();
    registerFallbackValue(OnAirNowStateHelper());
    registerFallbackValue(OnAirNowEventHelper());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingTvBloc>(
      create: (_) => onAirNowBlocHelper,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  tearDown(() {
    onAirNowBlocHelper.close();
  });

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => onAirNowBlocHelper.state).thenReturn(TvLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);

        await tester.pumpWidget(_makeTestableWidget(NowPlayingTvPage()));

        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => onAirNowBlocHelper.state).thenReturn(TvLoading());
        when(() => onAirNowBlocHelper.state).thenReturn(TvHasData(testTvList));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(NowPlayingTvPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => onAirNowBlocHelper.state)
            .thenReturn(TvHasError('Error message'));

        final textFinder = find.byKey(const Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(NowPlayingTvPage()));

        expect(textFinder, findsOneWidget);
      });
}
