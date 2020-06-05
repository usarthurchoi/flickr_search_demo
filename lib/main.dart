import './screens/flickr_search.dart';
import './services/flickr_search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './blocs/flickr_bloc/flickr_bloc.dart';
import './blocs/simple_bloc_delegate.dart';
import 'screens/flickr_favorites.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (context) =>
              FlickrBloc(flickrSearchService: FlickrSearchService())
          // ..add(SearchFlickr(
          //   term: 'apple',
          //   page: 1,
          //   per_page: 40,
          // )),
          ),
    ],
    child: MaterialApp(
      title: 'Flickr Demo',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: FlickrHome(),
    ),
  ));
}

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
    _tabController = new TabController(length: 2, vsync: this);
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
      appBar: AppBar(
        title: Text('Flickr'),
        bottom: TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.favorite)),
              Tab(icon: Icon(Icons.search)),
            ]),
      ),
      body: TabBarView(
        children: [
          FlickrRecentHome(),
          FlickrSearchHome(),
        ],
        controller: _tabController,
      ),
    );
  }
}
