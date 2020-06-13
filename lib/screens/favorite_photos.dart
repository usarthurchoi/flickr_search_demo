import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/favorite_photo_bloc/favorite_photo_bloc.dart';
import '../models/flickr_photo.dart';
import 'consts.dart';

class FavoritePhotos extends StatefulWidget {
  const FavoritePhotos({Key key}) : super(key: key);

  @override
  _FavoritePhotosState createState() => _FavoritePhotosState();
}

class _FavoritePhotosState extends State<FavoritePhotos> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoritePhotoBloc()..add(GetFavoritePhotos()),
      child: CustomScrollView(
        slivers: [
          _appBarSliver(),
          BlocBuilder<FavoritePhotoBloc, FavoritePhotoState>(
            builder: (context, state) {
              if (state is FavoritePhotoLoaded) {
                return _buildGrid(state.photos);
              } else {
                return SliverFillRemaining(
                  child: Container(),
                );
              }
            },
          )
        ],
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
        title: Text('Favorites', style: defaultTitleStyle),
        background: Image.asset(MAIN_APPBAR_BACKGROUND, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildGrid(List<FlickrPhoto> photos) {
    return SliverGrid(
      gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 1.0,
      ),
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final photo = photos[index];
          return Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  child: Image.network(
                    photo.imageSmallSquare100,
                    fit: BoxFit.cover,
                  ),
                  onTap: () async {
                    final url = photo.originalImage;
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                ),
              ),
            ],
          );
        },
        childCount: photos.length,
      ),
    );
  }
}
