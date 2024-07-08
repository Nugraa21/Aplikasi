import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

class HomeScreenState extends State<HomeScreen> {
  List<LatLng> _locations = [
    LatLng(-7.820680, 110.426558), // Ludang
    LatLng(-5.512911, 122.595906), // Fadrian
    LatLng(-7.818056, 110.392439), // Rohmat
    LatLng(-2.461111, 106.131780), // Yoga
    LatLng(-7.793475, 110.408455), // Riski
    LatLng(-7.793663, 110.400068), // Trio
    LatLng(-7.792784062515026, 110.4083096326256), // UTDI
  ];

  List<String> _names = [
    "Rumah Ludang (Pembuat Aplikasi)",
    "Rumah Muhammad Fadrian .S",
    "Rumah Rohmat Cahyo .S",
    "Rumah Yoga Saputra",
    "Rumah Riski",
    "Rumah Trio",
    "UTDI"
  ];

  List<String> _imagePaths = [
    'assets/ludang.jpg',
    'assets/fadrian.jpg',
    'assets/rohmat.jpg',
    'assets/yoga.jpg',
    'assets/riski.jpg',
    'assets/trio.jpg',
    'assets/utdi.jpg',
  ];

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
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _onLocationButtonPressed(int index) {
    setState(() {
      _currentLocation = _locations[index];
      _mapController.move(_currentLocation!,
          15.0); // Pindah ke lokasi yang dipilih dengan zoom 15.0
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
              Text('Ini rumah $name'),
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
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                          borderRadius: BorderRadius.circular(20),
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
                              index); // Panggil fungsi ketika marker diklik
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
                  TextSourceAttribution('OpenStreetMap contributors'),
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
                color: Colors.blue,
              ),
              child: Text(
                'Lokasi',
                style: TextStyle(
                  color: Colors.white,
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
