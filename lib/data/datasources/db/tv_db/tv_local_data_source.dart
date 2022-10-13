import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/tv_db/database_tv.dart';
import 'package:ditonton/data/models/modelstv/tv_table.dart';

abstract class TvLocalDataSource {
  Future<String> insertWatchlistTv(TvTable tvmodel);
  Future<String> removeWatchlistTv(TvTable tvmodel);
  Future<TvTable?> getTvById(int id);
  Future<List<TvTable>> getWatchlistTv();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseTv databaseTv;

  TvLocalDataSourceImpl({required this.databaseTv});

  @override
  Future<String> insertWatchlistTv(TvTable tvmodel) async {
    try {
      await databaseTv.insertWatchlistTv(tvmodel);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistTv(TvTable tvmodel) async {
    try {
      await databaseTv.removeWatchlistTv(tvmodel);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseTv.getTvById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTv() async {
    final result = await databaseTv.getWatchlistTv();
    return result.map((data) => TvTable.fromMap(data)).toList();
  }
}
