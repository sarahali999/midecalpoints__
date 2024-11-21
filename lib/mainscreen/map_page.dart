import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MarkerInfo {
  final LatLng point;
  final String name;
  double distance = 0;
  MarkerInfo({required this.point, required this.name});
}

class MapPage extends StatefulWidget {
  final LatLng initialLocation;
  final String locationName;

  const MapPage({
    Key? key,
    required this.initialLocation,
    required this.locationName,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  LatLng currentLocation = const LatLng(0, 0);
  TextEditingController searchController = TextEditingController();
  List<Marker> markers = [];
  List<MarkerInfo> markerInfos = [];
  List<Polyline> polylines = [];
  bool isMarkerListVisible = false;
  MarkerInfo? selectedMarker;
  List<Marker> routePoints = [];
  Marker? userLocationMarker;

  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _zoomAnimationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _zoomAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _locateUser();
    _fetchMarkersFromApi();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _zoomAnimationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _updateRoute(LatLng start, LatLng end) {
    setState(() {
      polylines.clear();
      routePoints.clear();

      List<LatLng> routePointsList = [start, end];

      polylines.add(
        Polyline(
          points: routePointsList,
          color: const Color(0xFf259e9f).withOpacity(0.8),
          strokeWidth: 4.0,
          borderColor: Colors.white.withOpacity(0.5),
          borderStrokeWidth: 2.0,
        ),
      );

      polylines.add(
        Polyline(
          points: routePointsList,
          color: Colors.black.withOpacity(0.2),
          strokeWidth: 6.0,
          borderStrokeWidth: 0,
        ),
      );

      routePoints = routePointsList.map((point) =>
          Marker(
            point: point,
            width: 12.0,
            height: 12.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFf259e9f),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          )
      ).toList();
    });
  }

  Future<void> _fetchMarkersFromApi() async {
    final url = Uri.parse('http://medicalpoint-api.tatwer.tech/api/Mobile/CenterMap');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          markerInfos = data.map((json) {
            final lng = json['lot'] != 0 ? json['lag'] as double? : 0.0;
            final lat = json['lag'] != 0 ? json['lot'] as double? : 0.0;
            final name = json['centerName'] as String?;
            return MarkerInfo(
              point: LatLng(lng ?? 0.0, lat ?? 0.0),
              name: name ?? "",
            );
          }).toList();

          _calculateDistances();

          markers = markerInfos.map((info) =>
              Marker(
                width: 50.0,
                height: 50.0,
                point: info.point,
                child: GestureDetector(
                  onTap: () => _selectMarker(info),
                  child: SvgPicture.asset(
                    'assets/icons/marker.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.red,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              )
          ).toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetching markers: $e");
    }
  }

  void _selectMarker(MarkerInfo info) {
    setState(() {
      selectedMarker = info;
      isMarkerListVisible = false;
      _updateRoute(currentLocation, info.point);
      _smoothAnimateToMarker(info.point);
      _animationController.forward();
    });
  }

  void _calculateDistances() {
    for (var info in markerInfos) {
      info.distance = const Distance().as(
          LengthUnit.Kilometer,
          currentLocation,
          info.point
      );
    }
    markerInfos.sort((a, b) => a.distance.compareTo(b.distance));
  }

  Future<void> _searchAndNavigate() async {
    if (searchController.text.isEmpty) return;
    final query = searchController.text;
    final apiKey = '48b0594741134ba7a54846c836ba8935';
    final url = Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$query&key=$apiKey'
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final lat = data['results'][0]['geometry']['lat'];
        final lng = data['results'][0]['geometry']['lng'];
        final searchLocation = LatLng(lat, lng);

        setState(() {
          markers.add(
            Marker(
              point: searchLocation,
              width: 50.0,
              height: 50.0,
              child: const Icon(Icons.place, color: Colors.red, size: 40),
            ),
          );

          _mapController.move(searchLocation, 15.0);
          _updateRoute(currentLocation, searchLocation);
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _smoothAnimateToMarker(LatLng target) {
    final latTween = Tween<double>(
        begin: _mapController.camera.center.latitude,
        end: target.latitude
    );
    final lngTween = Tween<double>(
        begin: _mapController.camera.center.longitude,
        end: target.longitude
    );
    final zoomTween = Tween<double>(
        begin: _mapController.camera.zoom,
        end: 15.0
    );

    _zoomAnimationController.reset();
    _zoomAnimationController.forward();

    _zoomAnimationController.addListener(() {
      final animatedLatLng = LatLng(
        latTween.evaluate(_zoomAnimationController),
        lngTween.evaluate(_zoomAnimationController),
      );
      final animatedZoom = zoomTween.evaluate(_zoomAnimationController);
      _mapController.move(animatedLatLng, animatedZoom);
    });
  }

  void _updateUserLocationMarker(LatLng location) {
    setState(() {
      userLocationMarker = Marker(
        width: 50.0,
        height: 50.0,
        point: location,
        child: SvgPicture.asset(
          'assets/icons/my-location.svg',
          colorFilter: const ColorFilter.mode(
            Colors.blue,
            BlendMode.srcIn,
          ),
        ),
      );
    });
  }

  Future<void> _locateUser() async {
    try {
      var location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = LatLng(
            userLocation.latitude!,
            userLocation.longitude!
        );
        _mapController.move(currentLocation, 15.0);
        _updateUserLocationMarker(currentLocation);
        _calculateDistances();
      });
    } catch (e) {
      debugPrint("Error in _locateUser: $e");
    }
  }
  void _clearSelection() {
    setState(() {
      selectedMarker = null;
      polylines.clear();
      routePoints.clear();
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildMap(),
          _buildSearchBar(),
          if (isMarkerListVisible) _buildFloatingMarkerList(),
          if (selectedMarker != null) _buildSelectedMarkerInfo(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFf259e9f),
                  Color(0xFf259e9f),
                ],
              ),
            ),
          ),
        ),
      ),
      title: const Text(
        'الخريطة',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: currentLocation,
        initialZoom: 3.0,
        onTap: (_, __) => _clearSelection(),
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c', 'd'],
        ),
        PolylineLayer(polylines: polylines),
        MarkerLayer(markers: [...markers, ...routePoints]),
        MarkerLayer(markers: [
          if (userLocationMarker != null) userLocationMarker!,
          ...markers,
          ...routePoints
        ]),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: kToolbarHeight + MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'ابحث',
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Colors.blue),
              onPressed: _searchAndNavigate,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          onSubmitted: (_) => _searchAndNavigate(),
        ),
      ),
    );
  }

  Widget _buildFloatingMarkerList() {
    return Positioned(
      top: kToolbarHeight + MediaQuery.of(context).padding.top + 70,
      right: 16,
      child: Container(
        width: 220,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Text(
                'المفارز الطبية',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: markerInfos.length,
                itemBuilder: (context, index) {
                  final info = markerInfos[index];
                  return ListTile(
                    title: Text(
                      info.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${info.distance.toStringAsFixed(2)} km',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    leading: const Icon(Icons.location_on, color: Colors.blue),
                    onTap: () => _selectMarker(info),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedMarkerInfo() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _animation.value)),
            child: Opacity(
              opacity: _animation.value,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFf259e9f),
                      Color(0xFf259e9f),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedMarker!.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'المسافة: ${_getFormattedDistance()}',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getFormattedDistance() {
    if (selectedMarker == null) return '';
    double distance = const Distance().as(
        LengthUnit.Kilometer,
        currentLocation,
        selectedMarker!.point
    );
    return '${distance.toStringAsFixed(2)} كم';
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (selectedMarker != null)
          FloatingActionButton(
            onPressed: _clearSelection,
            heroTag: 'clearSelection',
            backgroundColor: Colors.red,
            child: const Icon(Icons.clear, color: Colors.white),
          ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              isMarkerListVisible = !isMarkerListVisible;
            });
          },
          heroTag: 'toggleList',
          backgroundColor: Colors.orange,
          child: Icon(
              isMarkerListVisible ? Icons.list_alt : Icons.list,
              color: Colors.white
          ),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: _locateUser,
          heroTag: 'locateMe',
          backgroundColor: Colors.blue,
          child: const Icon(Icons.my_location, color: Colors.white),
        ),
      ],
    );
  }
}