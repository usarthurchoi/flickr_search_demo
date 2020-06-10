import 'dart:math';

import 'package:flutter/material.dart';

import '../models/flickr_photo.dart';
import 'consts.dart';
import 'search_result_grid.dart';

class SearchHistory extends StatelessWidget {
  final Map<String, List<FlickrPhoto>> previousSearches;
  SearchHistory({Key key, this.previousSearches = EmptyMap}) : super(key: key);

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    final keyList = previousSearches.keys.toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _appBarSliver(),
          _previousSearchListSliver(keyList),
        ],
      ),
    );
  }

  SliverList _previousSearchListSliver(List<String> keyList) {
    return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final key = keyList[index];
              final photos = previousSearches[key];
              // pick one random photo
              final photo = photos[random.nextInt(photos.length - 1)];
              return Card(
                child: ListTile(
                  leading: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(photo.imageThumbnail,
                          fit: BoxFit.cover)),
                  //trailing: Placeholder(),
                  title: Text('$key  - ${photos.length} photos'),
                  subtitle: Text(
                    '${photo.title ?? "no title"}',
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchResultSliverGrid(
                        searchTerm: key,
                        photos: photos,
                        thumbnailSize: ThumbnailSize.size100,
                      ),
                    ));
                  },
                ),
              );
            },
            // Or, uncomment the following line:
            childCount: keyList.length,
          ),
        );
  }

  SliverAppBar _appBarSliver() {
    return SliverAppBar(
          expandedHeight: MAX_APPBAR_EXPANDED_HEIGHT,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [StretchMode.zoomBackground],
            //title: Image.asset('assets/flickr.jpg', fit: BoxFit.cover),
            background: Image.asset(MAIN_APPBAR_BACKGROUND, fit: BoxFit.cover,),
          ),
        );
  }
}
