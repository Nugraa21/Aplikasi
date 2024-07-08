// # ------------------------------ #//
// #       Pembuat Proyek           #//
// #   > Ludang prasetyo .N         #//
// #   > Teknik Komputer S1         #//
// #   > 225510017                  #//
// #                                #//
// # ------------------------------ #//
// --------------------
// Import Paket
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// Import fils Data lokasi
import 'locations/ludang.dart';
import 'locations/fadrian.dart';
import 'locations/rohmat.dart';
import 'locations/yoga.dart';
import 'locations/riski.dart';
import 'locations/trio.dart';
import 'locations/utdi.dart';

// --------------------
// Membuat Apps
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

// -------------------- Mengambil Kordinat lokasi

class HomeScreenState extends State<HomeScreen> {
  final List<LatLng> _locations = [
    ludangLocation,
    fadrianLocation,
    rohmatLocation,
    yogaLocation,
    riskiLocation,
    trioLocation,
    utdiLocation,
  ];

// -------------------- Mengambil Nama

  final List<String> _names = [
    ludangName,
    fadrianName,
    rohmatName,
    yogaName,
    riskiName,
    trioName,
    utdiName,
  ];

// -------------------- Mengambil Image foto

  final List<String> _imagePaths = [
    ludangImagePath,
    fadrianImagePath,
    rohmatImagePath,
    yogaImagePath,
    riskiImagePath,
    trioImagePath,
    utdiImagePath,
  ];

// --------------------

  LatLng? _currentLocation;
  File? _image;
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _onLocationButtonPressed(int index) {
    setState(() {
      _currentLocation = _locations[index];
      _mapController.move(
          _currentLocation!, 15.0); // memindahkan lokasi sesuwai tujuan
    });
    _showPopup(context, _names[index], _imagePaths[index]);
  }

  void _showPopup(BuildContext context, String name, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath),
              SizedBox(height: 10),
              Text('Lokasi $name'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAllLocations() {
    setState(() {
      _currentLocation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyek UAS " LUDANG PRASETYO NUGROHO ( 225510017 )"'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? LatLng(-7.815000, 110.420000),
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png', //
                userAgentPackageName: 'com.example.app',
              ),
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          int index = _locations.indexOf(_currentLocation!);
                          _showPopup(
                              context, _names[index], _imagePaths[index]);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image(
                              image: AssetImage(_imagePaths[
                                  _locations.indexOf(_currentLocation!)])),
                        ),
                      ),
                    ),
                  ],
                ),
              if (_currentLocation == null)
                MarkerLayer(
                  markers: _locations.map((location) {
                    int index = _locations.indexOf(location);
                    return Marker(
                      point: location,
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          _onLocationButtonPressed(
                              index); // Call function when marker is clicked
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(image: AssetImage(_imagePaths[index])),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'), //
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: _pickImage,
              child: Icon(Icons.add_a_photo),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 71, 2, 0),
              ),
              child: Text(
                'Ludang ( 225510017 )',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 24,
                ),
              ),
            ),
            for (int i = 0; i < _names.length; i++)
              ListTile(
                title: Text(_names[i]),
                onTap: () {
                  Navigator.pop(context);
                  _onLocationButtonPressed(i);
                },
              ),
            ListTile(
              title: Text('Tampilkan Semua Lokasi'),
              onTap: () {
                Navigator.pop(context);
                _showAllLocations();
              },
            ),
          ],
        ),
      ),
    );
  }
}
// # ------------------------------ #//
// #       Pembuat Proyek           #//
// #   > Ludang prasetyo .N         #//
// #   > Teknik Komputer S1         #//
// #   > 225510017                  #//
// #                                #//
// # ------------------------------ #//
// -------------------- End
//
//    CODE DI BAWAH UNTUK DATABES 
//
// -------------------- Start 

// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:mysql1/mysql1.dart';

// // Model untuk data lokasi
// class LocationData {
//   final String name;
//   final double latitude;
//   final double longitude;
//   final String imagePath;

//   LocationData({
//     required this.name,
//     required this.latitude,
//     required this.longitude,
//     required this.imagePath,
//   });
// }

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => HomeScreenState();
// }

// class HomeScreenState extends State<HomeScreen> {
//   final List<LatLng> _locations = [
//     LatLng(-7.815000, 110.420000), // dummy data, Anda bisa mengganti dengan data aktual dari database
//     // tambahkan koordinat lokasi lainnya di sini
//   ];

//   final List<String> _names = [
//     'Ludang',
//     // tambahkan nama lokasi lainnya sesuai dengan urutan koordinat di atas
//   ];

//   final List<String> _imagePaths = [
//     'assets/ludang.jpg', // path untuk gambar, bisa diganti dengan path dari database
//     // tambahkan path gambar lainnya sesuai dengan urutan lokasi di atas
//   ];

//   LatLng? _currentLocation;
//   File? _image;
//   late MapController _mapController;

//   @override
//   void initState() {
//     super.initState();
//     _mapController = MapController();
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   Future<MySqlConnection> getConnection() async {
//     final conn = await MySqlConnection.connect(ConnectionSettings(
//       host: 'your_host',
//       port: 3306,
//       user: 'your_username',
//       password: 'your_password',
//       db: 'your_database_name',
//     ));
//     return conn;
//   }

//   Future<void> saveLocationToDatabase(String name, double latitude, double longitude, String imagePath) async {
//     try {
//       final conn = await getConnection();
//       await conn.query(
//         'INSERT INTO locations (name, latitude, longitude, image_path) VALUES (?, ?, ?, ?)',
//         [name, latitude, longitude, imagePath],
//       );
//       await conn.close();
//     } catch (e) {
//       print('Error saving location: $e');
//     }
//   }

//   Future<List<LocationData>> getAllLocationsFromDatabase() async {
//     List<LocationData> locations = [];
//     try {
//       final conn = await getConnection();
//       var results = await conn.query('SELECT * FROM locations');
//       for (var row in results) {
//         locations.add(LocationData(
//           name: row['name'],
//           latitude: row['latitude'],
//           longitude: row['longitude'],
//           imagePath: row['image_path'],
//         ));
//       }
//       await conn.close();
//     } catch (e) {
//       print('Error fetching locations: $e');
//     }
//     return locations;
//   }

//   void _onLocationButtonPressed(int index) {
//     setState(() {
//       _currentLocation = _locations[index];
//       _mapController.move(_currentLocation!, 15.0);
//     });
//     _showPopup(context, _names[index], _imagePaths[index]);
//   }

//   void _showPopup(BuildContext context, String name, String imagePath) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(name),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset(imagePath),
//               SizedBox(height: 10),
//               Text('Lokasi $name'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showAllLocations() {
//     setState(() {
//       _currentLocation = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Proyek UAS " LUDANG PRASETYO NUGROHO ( 225510017 )"'),
//       ),
//       body: Stack(
//         children: [
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               initialCenter: _currentLocation ?? LatLng(-7.815000, 110.420000),
//               initialZoom: 15.0,
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                 userAgentPackageName: 'com.example.app',
//               ),
//               if (_currentLocation != null)
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       point: _currentLocation!,
//                       width: 50,
//                       height: 50,
//                       child: GestureDetector(
//                         onTap: () {
//                           int index = _locations.indexOf(_currentLocation!);
//                           _showPopup(context, _names[index], _imagePaths[index]);
//                         },
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(5),
//                           child: Image(
//                             image: AssetImage(_imagePaths[_locations.indexOf(_currentLocation!)]),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               if (_currentLocation == null)
//                 MarkerLayer(
//                   markers: _locations.asMap().entries.map((entry) {
//                     int index = entry.key;
//                     LatLng location = entry.value;
//                     return Marker(
//                       point: location,
//                       width: 50,
//                       height: 50,
//                       child: GestureDetector(
//                         onTap: () {
//                           _onLocationButtonPressed(index);
//                         },
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: Image(
//                             image: AssetImage(_imagePaths[index]),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               RichAttributionWidget(
//                 attributions: [
//                   TextSourceAttribution('OpenStreetMap contributors'),
//                 ],
//               ),
//             ],
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: FloatingActionButton(
//               onPressed: _pickImage,
//               child: Icon(Icons.add_a_photo),
//             ),
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Color.fromARGB(255, 71, 2, 0),
//               ),
//               child: Text(
//                 'Ludang ( 225510017 )',
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 255, 255, 255),
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             for (int i = 0; i < _names.length; i++)
//               ListTile(
//                 title: Text(_names[i]),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _onLocationButtonPressed(i);
//                 },
//               ),
//             ListTile(
//               title: Text('Tampilkan Semua Lokasi'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _showAllLocations();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
