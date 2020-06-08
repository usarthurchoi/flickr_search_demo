import 'package:flickr_demo/blocs/favorite_photo_bloc/favorite_photo_bloc.dart';
import 'package:flickr_demo/database/favorite_photos_dao.dart';
import 'package:flickr_demo/models/flickr_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.zoomBackground],
              title: Text('Favorites'),
              background: Image.asset('assets/flickr.jpg', fit: BoxFit.cover),
            ),
          ),
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
                  print('passing $url');
                  if (await canLaunch(url)) {
                    await launch(url);
                  }
                },
              ),
            ),
            // DO Not allow delete from here
            // Align(
            //   alignment: Alignment.topRight,
            //   child: InkWell(
            //     //GestureDetector same
            //     onTap: () {
            //       BlocProvider.of<FavoritePhotoBloc>(context)
            //           .add(DeleteFavoritePhoto(photo: photo));
            //     },
            //     child: Icon(
            //       Icons.delete,
            //       color: Colors.deepOrange.withOpacity(0.8),
            //     ),
            //   ),
            // ),
          ],
        );
      },
      childCount: photos.length,
    ),
  );
}
