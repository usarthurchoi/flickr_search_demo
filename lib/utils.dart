import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as Io;
import 'dart:ui';
import 'package:meta/meta.dart';
import 'package:image/image.dart' as img;

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

Future<String> get applicationDocumentDirectoryPath async {
  final appDir = await getApplicationDocumentsDirectory();
  return appDir.path;
}

Future<Io.File> getImageFromNetwork(String url) async {
  var cacheManager = DefaultCacheManager();
  Io.File file = await cacheManager.getSingleFile(url);
  return file;
}

Future<Io.File> saveImage(String url) async {
  final file = await getImageFromNetwork(url);
  final uri = Uri.tryParse(url);
  if (uri == null) {
    throw 'Invalid URL $url';
  }

  final path =
      join(await applicationDocumentDirectoryPath, uri.pathSegments.last);
  print('path $path');

  img.Image image = img.decodeImage(file.readAsBytesSync());

  img.Image thumbnail = img.copyResize(image, width: 120, height: 120);

  // Save the thumbnail as a PNG.
  return new Io.File('$path')
    ..writeAsBytesSync(encodeJpg(thumbnail));
}


// List<int> processPersonProfilePhoto(File file) {
//   var rawPhoto = file.readAsBytesSync();
//   var jpg = Image.decodeJpg(rawPhoto);
//   jpg = Image.copyResize(jpg, 512);
//   return Image.encodeJpg(jpg, quality: 70);
// }
// I am running the method above on a separated isolate, via:

// var jpgByteArray = await compute(processPersonProfilePhoto, file);
// 


//https://www.woolha.com/tutorials/dart-spawn-kill-send-message-to-isolate
///In this first example, we spawn some isolates with String message. 
///The entryPoint function (runSomething) prints the message first, 
///then call an API and print the response. If you run the script, 
///you'll see that the isolates run in parallel (the argument on all 
///isolates will be printed first before any isolate gets the response).
///
//  import 'dart:convert';
//   import 'dart:io';
//   import 'dart:isolate';
  
//   List<Isolate> isolates;
  
//   void start() async {
//     isolates = new List();
  
//     isolates.add(await Isolate.spawn(runSomething, 'first'));
//     isolates.add(await Isolate.spawn(runSomething, 'second'));
//     isolates.add(await Isolate.spawn(runSomething, 'third'));
//   }
  
//   void runSomething(String arg) async {
//     print('arg: $arg');
//     var request = await HttpClient().getUrl(Uri.parse('https://swapi.co/api/people/1'));
//     var response = await request.close();
  
//     await for (var contents in response.transform(Utf8Decoder())) {
//       print(contents);
//     }
//   }
  
//   void stop() {
//     for (Isolate i in isolates) {
//       if (i != null) {
//         i.kill(priority: Isolate.immediate);
//         i = null;
//         print('Killed');
//       }
//     }
//   }
  
//   void main() async {
//     await start();
  
//     print('Press enter to exit');
//     await stdin.first;
  
//     stop();
//     exit(0);
//   }



///In the second example, we want to collect the result of each isolate. 
///To do so, we can create an instance of ReceivePort. It has sendPort property
/// of type SendPort, which allows messages to be sent to the receive port. 
/// he receive port needs to listen for data using listen method whose 
/// parameter is a function. To send a message to the receive port, 
/// use send method of SendPort.
/// 
//  import 'dart:convert';
//   import 'dart:io';
//   import 'dart:isolate';
  
//   List<Isolate> isolates;
  
//   void start() async {
//     isolates = new List();
//     ReceivePort receivePort= ReceivePort();
  
//     isolates.add(await Isolate.spawn(runSomething, receivePort.sendPort));
//     isolates.add(await Isolate.spawn(runSomething, receivePort.sendPort));
//     isolates.add(await Isolate.spawn(runSomething, receivePort.sendPort));
  
//     receivePort.listen((data) {
//       print('Data: $data');
//     });
//   }
  
//   void runSomething(SendPort sendPort) async {
//     var request = await HttpClient().getUrl(Uri.parse('https://swapi.co/api/people/1'));
//     var response = await request.close();
  
//     await for (var contents in response.transform(Utf8Decoder())) {
//       sendPort.send(contents);
//     }
//   }
  
//   void stop() {
//     for (Isolate i in isolates) {
//       if (i != null) {
//         i.kill(priority: Isolate.immediate);
//         i = null;
//         print('Killed');
//       }
//     }
//   }
  
//   void main() async {
//     await start();
  
//     print('Press enter to exit');
//     await stdin.first;
  
//     stop();
//     exit(0);
//   }



//
///The third example is a combination of the first and second examples. 
///We want to both send message to the created isolates and listen to 
///the response of the isolates. The spawn method only has one parameter 
///for message but it can be any type. So, we can create a custom class 
///that contains both SendPort and the message, as exemplified below.
///
// import 'dart:convert';
//   import 'dart:io';
//   import 'dart:isolate';
  
//   List<Isolate> isolates;
  
//   class CustomObject {
//     String message;
//     SendPort sendPort;
  
//     CustomObject(this.message, this.sendPort);
//   }
  
//   void start() async {
//     isolates = new List();
//     ReceivePort receivePort= ReceivePort();
  
//     CustomObject object1 = new CustomObject('1', receivePort.sendPort);
//     CustomObject object2 = new CustomObject('2', receivePort.sendPort);
//     CustomObject object3 = new CustomObject('3', receivePort.sendPort);
  
//     isolates.add(await Isolate.spawn(runSomething, object1));
//     isolates.add(await Isolate.spawn(runSomething, object2));
//     isolates.add(await Isolate.spawn(runSomething, object3));
  
//     receivePort.listen((data) {
//       print('Data: $data');
//     });
//   }
  
//   void runSomething(CustomObject object) async {
//     print('https://swapi.co/api/people/${object.message}');
//     var request = await HttpClient().getUrl(Uri.parse('https://swapi.co/api/people/${object.message}'));
//     var response = await request.close();
  
//     await for (var contents in response.transform(Utf8Decoder())) {
//       object.sendPort.send(contents);
//     }
//   }
  
//   void stop() {
//     for (Isolate i in isolates) {
//       if (i != null) {
//         i.kill(priority: Isolate.immediate);
//         i = null;
//         print('Killed');
//       }
//     }
//   }
  
//   void main() async {
//     await start();
  
//     print('Press enter to exit');
//     await stdin.first;
  
//     stop();
//     exit(0);
//   }

//https://flutter.dev/docs/cookbook/networking/background-parsing#4-move-this-work-to-a-separate-isolate
// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future<List<Photo>> fetchPhotos(http.Client client) async {
//   final response =
//       await client.get('https://jsonplaceholder.typicode.com/photos');

//   // Use the compute function to run parsePhotos in a separate isolate.
//   return compute(parsePhotos, response.body);
// }

// // A function that converts a response body into a List<Photo>.
// List<Photo> parsePhotos(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

//   return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
// }

// class Photo {
//   final int albumId;
//   final int id;
//   final String title;
//   final String url;
//   final String thumbnailUrl;

//   Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

//   factory Photo.fromJson(Map<String, dynamic> json) {
//     return Photo(
//       albumId: json['albumId'] as int,
//       id: json['id'] as int,
//       title: json['title'] as String,
//       url: json['url'] as String,
//       thumbnailUrl: json['thumbnailUrl'] as String,
//     );
//   }
// }
