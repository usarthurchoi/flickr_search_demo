import './flickr_interesting.dart';
import 'package:flutter/material.dart';

import 'favorite_photos.dart';
import 'flickr_recents.dart';
import 'flickr_search.dart';

class FlickrHome extends StatefulWidget {
  FlickrHome({Key key}) : super(key: key);

  @override
  _FlickrHomeState createState() => _FlickrHomeState();
}

class _FlickrHomeState extends State<FlickrHome>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Opacity(
        opacity: 0.8,
        child: Container(
          color: Theme.of(context).primaryColor,
          child: TabBar(
              controller: _tabController,
              unselectedLabelColor: Colors.white,
              labelColor: Colors.amber,
              tabs: [
                Tab(icon: Icon(Icons.featured_video), text: 'Interesting'),
                //Tab(icon: Icon(Icons.watch), text: 'Recent'),
                Tab(icon: Icon(Icons.search), text: 'Search'),
                Tab(
                  icon: GestureDetector(
                    onTap: () {
                      _tabController.index = 2;
                    },
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red[50].withOpacity(0.7),
                    ),
                  ),
                  text: 'Favorites',
                ),
              ]),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Flickr interesting photo home
          FlickrInterestingHome(),
          // Flickr recent photos
          //FlickrRecentHome(),
          // Flickr search by term
          FlickrSearchHome(),
          // My favorite photos saved locally in a sembast database
          FavoritePhotos(),
        ],
      ),
    );
  }
}
