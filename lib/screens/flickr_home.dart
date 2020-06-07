import 'package:flutter/material.dart';

import 'flickr_recents.dart';
import 'flickr_search.dart';

class FlickrHome extends StatefulWidget {
  FlickrHome({Key key}) : super(key: key);

  @override
  _FlickrHomeState createState() => _FlickrHomeState();
}

class _FlickrHomeState extends State<FlickrHome> {
  int _photoCount = 0;

  void _updateTotalPhotoCount(int count) {
    setState(() {
      _photoCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flickr - $_photoCount photos'),
          bottom: TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: Colors.amber,
              tabs: [
                Tab(icon: Icon(Icons.watch), text: 'Recent Upload'),
                Tab(icon: Icon(Icons.search), text: 'Search'),
              ]),
        ),
        body: TabBarView(
          children: [
            FlickrRecentHome(photoCountCallback: _updateTotalPhotoCount,),
            FlickrSearchHome(photoCountCallback: _updateTotalPhotoCount,),
          ],
        ),
      ),
    );
  }
}
