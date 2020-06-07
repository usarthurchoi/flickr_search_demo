import 'dart:math';

import 'package:flutter/material.dart';

import '../models/flickr_photo.dart';
import 'search_result_grid.dart';

const Map<String, List<FlickrPhoto>> EmptyMap = <String, List<FlickrPhoto>>{};

class SearchHistory extends StatelessWidget {
  final Map<String, List<FlickrPhoto>> previousSearches;
  SearchHistory({Key key, this.previousSearches = EmptyMap})
      : super(key: key);

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    final keyList = previousSearches.keys.toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.zoomBackground],
              //title: Image.asset('assets/flickr.jpg', fit: BoxFit.cover),
              background: Image.asset('assets/flickr.jpg', fit: BoxFit.cover),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final key = keyList[index];
                final photos = previousSearches[key];
                final photo = photos[random.nextInt(photos.length-1)];
                return Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 70,
                      height: 70,
                      child: Image.network(photo.imageThumbnail, fit: BoxFit.cover)),
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
                        ),
                      ));
                    },
                  ),
                );
              },
              // Or, uncomment the following line:
              childCount: keyList.length,
            ),
          ),
        ],
      ),
    );
  }
}
