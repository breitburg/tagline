import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

void main() => runApp(TaglineApp());

class TaglineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MacosApp(
      debugShowCheckedModeBanner: false,
      theme: MacosThemeData.dark(),
      title: 'Tagline',
      home: HomeScreen(),
    );
  }
}

class Film {
  final String path;

  Film({required this.path});
}

class DetailedFilm extends Film {
  final String title, artwork;
  final DateTime releaseDate;

  DetailedFilm({
    required this.title,
    required this.releaseDate,
    required this.artwork,
  }) : super(path: '');
}

class HomeScreen extends StatelessWidget {
  List<Film> films = [
    DetailedFilm(
      title: 'Objectified',
      artwork:
          'https://is1-ssl.mzstatic.com/image/thumb/Video118/v4/a9/dd/fd/a9ddfda4-8edd-d502-cfaa-4c151c262943/source/600x600bb.jpg',
      releaseDate: DateTime(2009),
    ),
    DetailedFilm(
      title: 'Helvetica',
      artwork:
          'https://is3-ssl.mzstatic.com/image/thumb/Video127/v4/25/e7/a8/25e7a86b-4f4e-2aec-1022-79d2298ddd91/source/600x600bb.jpg',
      releaseDate: DateTime(2007),
    ),
    DetailedFilm(
      title: 'Seven Pounds',
      artwork:
          'https://is5-ssl.mzstatic.com/image/thumb/Video2/v4/d1/f6/84/d1f68493-a193-7355-9a4e-46b430f17fea/source/600x600bb.jpg',
      releaseDate: DateTime(2008),
    ),
    Film(path: 'BBT_S1E8.mp4'),
  ];

  @override
  Widget build(BuildContext context) {
    var firstFilm = (films.first as DetailedFilm);

    return MacosScaffold(
      titleBar: TitleBar(
        child: Text('Tagline'),
      ),
      children: [
        ContentArea(
          builder: (BuildContext context, ScrollController controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: controller,
                    itemCount: films.length,
                    padding: const EdgeInsets.all(15),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 15,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      var film = films.elementAt(index);

                      if (film.runtimeType == DetailedFilm)
                        return VideoTile.fromFilm(film as DetailedFilm);

                      return VideoTile.unknown(film.path, searching: false);
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: MacosTheme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: MacosIconButton(
                    icon: Icon(CupertinoIcons.add),
                    backgroundColor:
                        MacosColors.alternatingContentBackgroundColor,
                    onPressed: () => null,
                  ),
                ),
              ],
            );
          },
        ),
        ResizablePane(
          builder: (BuildContext context, ScrollController controller) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: MacosTextField(
                    placeholder: 'Search',
                    prefix: Icon(CupertinoIcons.search, size: 16),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: (() async =>
                        await Future.delayed(Duration(seconds: 3)))(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(
                          child: ProgressCircle(value: null),
                        );
                      }

                      return ListView.separated(
                        itemCount: 10,
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            color: MacosTheme.of(context).dividerColor,
                            height: 1,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              if (index == 3)
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child:
                                      Icon(CupertinoIcons.check_mark, size: 16),
                                ),
                              Image.network(
                                (films.first as DetailedFilm).artwork,
                                height: 50,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Objectified'),
                                    SizedBox(height: 5),
                                    Opacity(
                                      opacity: .5,
                                      child: Text(
                                        '2009',
                                        style: MacosTheme.of(context)
                                            .typography
                                            .caption1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
          maxWidth: 400,
          startWidth: 300,
          minWidth: 200,
          resizableSide: ResizableSide.left,
        )
      ],
    );
  }
}

class VideoTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget artwork;

  const VideoTile({
    Key? key,
    required this.title,
    required this.artwork,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: artwork),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 5),
          child: Text(title),
        ),
        Opacity(
          opacity: .5,
          child: Text(
            subtitle ?? '',
            style: MacosTheme.of(context).typography.caption1,
          ),
        ),
      ],
    );
  }

  factory VideoTile.networkArtwork({
    required String title,
    required String artworkUrl,
    String? subtitle,
  }) {
    return VideoTile(
      title: title,
      subtitle: subtitle,
      artwork: Image.network(artworkUrl),
    );
  }

  factory VideoTile.fromFilm(DetailedFilm film) {
    return VideoTile.networkArtwork(
      title: film.title,
      subtitle: film.releaseDate.year.toString(),
      artworkUrl: film.artwork,
    );
  }

  factory VideoTile.unknown(String title, {bool searching = false}) {
    return VideoTile(
      title: title,
      artwork: AspectRatio(
        aspectRatio: 2 / 3,
        child: ColoredBox(
          color: MacosColors.systemGrayColor,
          child: searching
              ? ProgressCircle(value: null)
              : Icon(CupertinoIcons.film, color: MacosColors.black),
        ),
      ),
    );
  }
}
