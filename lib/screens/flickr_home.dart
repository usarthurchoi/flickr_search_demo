import 'package:flutter/material.dart';

import 'flickr_recents.dart';
import 'flickr_search.dart';

class FlickrHome extends StatefulWidget {
  FlickrHome({Key key}) : super(key: key);

  @override
  _FlickrHomeState createState() => _FlickrHomeState();
}

class _FlickrHomeState extends State<FlickrHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: Opacity(
          opacity: 0.9,
          child: Container(
            color: Theme.of(context).primaryColor,
            child: TabBar(
                unselectedLabelColor: Colors.white,
                labelColor: Colors.amber,
                tabs: [
                  Tab(icon: Icon(Icons.watch), text: 'Recent'),
                  Tab(icon: Icon(Icons.search), text: 'Search'),
                ]),
          ),
        ),
        body: TabBarView(
          children: [
            FlickrRecentHome(),
            FlickrSearchHome(),
          ],
        ),
      ),
    );
  }
}
