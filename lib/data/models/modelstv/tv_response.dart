import 'package:ditonton/data/models/modelstv/tv_models.dart';
import 'package:equatable/equatable.dart';

class TvResponse extends Equatable {
  final List<TvModelResponse> TvList;

  TvResponse({required this.TvList});

  factory TvResponse.fromJson(Map<String, dynamic> json) => TvResponse(
        TvList: List<TvModelResponse>.from((json["results"] as List)
            .map((x) => TvModelResponse.fromJson(x))
            .where((element) => element.posterPath != null)),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(TvList.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [TvList];
}
