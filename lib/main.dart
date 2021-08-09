import 'dart:ui';

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
  Metadata? metadata;

  Film({required this.path, this.metadata});
}

class Metadata {
  final String title, artwork;
  final DateTime releaseDate;

  Metadata({
    required this.title,
    required this.releaseDate,
    required this.artwork,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Film> films = [
    Film(
      path: '',
      metadata: Metadata(
        title: 'Objectified',
        artwork:
            'https://is1-ssl.mzstatic.com/image/thumb/Video118/v4/a9/dd/fd/a9ddfda4-8edd-d502-cfaa-4c151c262943/source/600x600bb.jpg',
        releaseDate: DateTime(2009),
      ),
    ),
    Film(
      path: '',
      metadata: Metadata(
        title: 'Helvetica',
        artwork:
            'https://is3-ssl.mzstatic.com/image/thumb/Video127/v4/25/e7/a8/25e7a86b-4f4e-2aec-1022-79d2298ddd91/source/600x600bb.jpg',
        releaseDate: DateTime(2007),
      ),
    ),
    Film(
      path: '',
      metadata: Metadata(
        title: 'Seven Pounds',
        artwork:
            'https://is5-ssl.mzstatic.com/image/thumb/Video2/v4/d1/f6/84/d1f68493-a193-7355-9a4e-46b430f17fea/source/600x600bb.jpg',
        releaseDate: DateTime(2008),
      ),
    ),
    Film(
      path: '',
      metadata: Metadata(
        title: 'The Social Network',
        artwork:
            'https://is2-ssl.mzstatic.com/image/thumb/Video41/v4/68/39/cc/6839cc4b-be77-31e4-9b58-19519a21e533/source/600x600bb.jpg',
        releaseDate: DateTime(2010),
      ),
    ),
    Film(
      path: '',
      metadata: Metadata(
        title: 'Jobs',
        artwork:
            'https://is4-ssl.mzstatic.com/image/thumb/Video5/v4/f5/7c/52/f57c5262-b8aa-1de5-0ba5-07fdeb17c8b1/source/600x600bb.jpg',
        releaseDate: DateTime(2013),
      ),
    ),
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    var firstFilm = films.first;

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

                      if (film.metadata != null)
                        return VideoTile.fromMetadata(
                          film.metadata!,
                          selected: index == selected,
                          onTap: () {
                            searchController.text = films
                                .elementAt(index)
                                .path
                                .replaceAll('.', ' ');
                            selected = index;
                            setState(() => null);
                          },
                        );

                      return VideoTile.unknown(film.path, searching: true);
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
                    controller: searchController,
                    prefix: Icon(CupertinoIcons.search, size: 16),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: (() async =>
                        await Future.delayed(Duration(milliseconds: 500)))(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(
                          child: ProgressCircle(value: null),
                        );
                      }
                      var selectedMetadata =
                          films.elementAt(selected).metadata!;

                      return ListView.separated(
                        itemCount: 1,
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
                              if (index == 0)
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child:
                                      Icon(CupertinoIcons.check_mark, size: 16),
                                ),
                              Image.network(
                                selectedMetadata.artwork,
                                height: 50,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(selectedMetadata.title),
                                    SizedBox(height: 5),
                                    Opacity(
                                      opacity: .5,
                                      child: Text(
                                        selectedMetadata.releaseDate.year
                                            .toString(),
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
  final bool selected;
  final VoidCallback? onTap;

  const VideoTile({
    Key? key,
    required this.title,
    required this.artwork,
    this.subtitle,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                AnimatedOpacity(
                  curve: Curves.easeOutCubic,
                  duration: const Duration(milliseconds: 500),
                  opacity: selected ? 1 : 0,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 50,
                      sigmaY: 50,
                      tileMode: TileMode.decal,
                    ),
                    child: artwork,
                  ),
                ),
                artwork,
              ],
            ),
          ),
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
      ),
    );
  }

  factory VideoTile.fromMetadata(Metadata data,
      {bool selected = false, onTap}) {
    return VideoTile(
      title: data.title,
      subtitle: data.releaseDate.year.toString(),
      artwork: Image.network(data.artwork),
      selected: selected,
      onTap: onTap,
    );
  }

  factory VideoTile.unknown(String title,
      {bool searching = false, bool selected = false}) {
    return VideoTile(
      title: title,
      selected: selected,
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
