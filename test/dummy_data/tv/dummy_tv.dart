import 'package:ditonton/data/models/modelstv/tv_table.dart';
import 'package:ditonton/domain/entities/tv/tv_entity.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/entities/genre.dart';

final testTv = TvModel(
  backdropPath: "/pdfCr8W0wBCpdjbZXSxnKhZtosP.jpg",
  firstAirDate: "2022-09-01",
  genreIds: const [10765, 10759, 18],
  id: 84773,
  name: "The Lord of the Rings: The Rings of Power",
  originCountry: const ["US"],
  originalLanguage: "en",
  originalName: "The Lord of the Rings: The Rings of Power",
  overview:
      "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
  popularity: 4962.027,
  posterPath: "/suyNxglk17Cpk8rCM2kZgqKdftk.jpg",
  voteAverage: 7.6,
  voteCount: 541,
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  adult: false,
  backdropPath: "/pdfCr8W0wBCpdjbZXSxnKhZtosP.jpg",
  episodeRunTime: const [60],
  firstAirDate: DateTime(2022 - 09 - 01),
  genres: [
    Genre(id: 10765, name: "Sci-Fi & Fantasy"),
    Genre(id: 10759, name: "Action & Adventure"),
    Genre(id: 18, name: "Drama")
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

const testTvCache = TvTable(
  id: 84773,
  overview:
      "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
  posterPath: '/suyNxglk17Cpk8rCM2kZgqKdftk.jpg',
  name: 'The Lord of the Rings: The Rings of Power',
);

final testTvCacheMap = {
  "id": 84773,
  "overview":
      "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
  "posterPath": '/suyNxglk17Cpk8rCM2kZgqKdftk.jpg',
  "name": 'The Lord of the Rings: The Rings of Power',
};

final testTvFromCache = TvModel.watchlist(
  id: 84773,
  overview:
      "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
  posterPath: '/suyNxglk17Cpk8rCM2kZgqKdftk.jpg',
  name: 'The Lord of the Rings: The Rings of Power',
);

final testWatchlistTv = TvModel.watchlist(
  id: 84773,
  name: 'The Lord of the Rings: The Rings of Power',
  overview:
      "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
  posterPath: '/suyNxglk17Cpk8rCM2kZgqKdftk.jpg',
);

const testTvTable = TvTable(
  id: 84773,
  name: 'The Lord of the Rings: The Rings of Power',
  overview:
      "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
  posterPath: '/suyNxglk17Cpk8rCM2kZgqKdftk.jpg',
);

final testTvMap = {
  'id': 84773,
  'name': 'The Lord of the Rings: The Rings of Power',
  'overview':
      "Beginning in a time of relative peace, we follow an ensemble cast of characters as they confront the re-emergence of evil to Middle-earth. From the darkest depths of the Misty Mountains, to the majestic forests of Lindon, to the breathtaking island kingdom of Númenor, to the furthest reaches of the map, these kingdoms and characters will carve out legacies that live on long after they are gone.",
  'posterPath': '/suyNxglk17Cpk8rCM2kZgqKdftk.jpg',
};
