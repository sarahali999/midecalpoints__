import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import '../languages.dart';

class MarkerInfo {
  final LatLng point;
  final String name;
  double distance = 0;
  MarkerInfo({
    required this.point,
    required this.name,

  });
}


class MapPage extends StatefulWidget {
  final LatLng initialLocation;
  final String locationName;
  final bool openedFromSearch;

  const MapPage({
    Key? key,
    required this.initialLocation,
    required this.locationName,
    this.openedFromSearch = false,

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
  bool _isSearchedLocation = false;
  String _searchedLocationDetails = ''; // New variable for detailed location info

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.openedFromSearch &&
          widget.initialLocation.latitude != 0 &&
          widget.initialLocation.longitude != 0) {
        _initializeMarkerAndMap();
      }

      _locateUser();
      _fetchMarkersFromApi();
    });
  }

  void _initializeMarkerAndMap() {
    setState(() {
      markers.add(
        Marker(
          point: widget.initialLocation,
          width: 50.0,
          height: 50.0,
          child: const Icon(Icons.place, color: Colors.red, size: 40),
        ),
      );

      _mapController.move(widget.initialLocation, 15.0);

      _updateRoute(currentLocation, widget.initialLocation);

      _isSearchedLocation = true;

      _searchAndNavigate(widget.locationName);

    });
  }
  @override
  void dispose() {
    _animationController.dispose();
    _zoomAnimationController.dispose();
    searchController.dispose();
    super.dispose();
  }
  Future<void> _updateRoute(LatLng start, LatLng end) async {
    setState(() {
      polylines.clear();
      routePoints.clear();
    });

    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
            '${start.longitude},${start.latitude};${end.longitude},${end.latitude}'
            '?overview=full&geometries=geojson&steps=true&annotations=true'
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];
          final List<dynamic> steps = data['routes'][0]['legs'][0]['steps'];

          final List<LatLng> routePointsList = coordinates.map((coord) =>
              LatLng(coord[1], coord[0])
          ).toList();

          setState(() {
            polylines.add(
              Polyline(
                points: routePointsList,
                color: const Color(0xFF259e9f).withOpacity(0.8),
                strokeWidth: 4.0,
                borderColor: Colors.white.withOpacity(0.5),
                borderStrokeWidth: 2.0,
              ),
            );
          });

        }
      }
    } catch (e) {
      debugPrint("Error fetching route: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error calculating route: $e'),
            duration: const Duration(seconds: 2),
          )
      );
    }
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

  void _updateSelectedMarkerDistance() {
    if (selectedMarker != null) {
      selectedMarker!.distance = const Distance().as(
          LengthUnit.Kilometer,
          currentLocation,
          selectedMarker!.point
      );
      _animationController.forward();
    }
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
                      'المسافة: ${selectedMarker!.distance.toStringAsFixed(2)} كم',
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

  Future<void> _searchAndNavigate([String? query]) async {
    final searchQuery = query ?? searchController.text;

    if (searchQuery.isEmpty) return;

    final apiKey = '48b0594741134ba7a54846c836ba8935';
    final url = Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$searchQuery&key=$apiKey'
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final lat = data['results'][0]['geometry']['lat'];
        final lng = data['results'][0]['geometry']['lng'];
        final searchLocation = LatLng(lat, lng);

        // Extract more detailed location information
        final formattedAddress = data['results'][0]['formatted'] ?? '';
        final components = data['results'][0]['components'] ?? {};

        setState(() {
          markers.removeWhere((marker) => marker.child is Icon);

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

        selectedMarker = MarkerInfo(
          point: searchLocation,
          name: searchQuery,
        );

        // Calculate and show distance
        _updateSelectedMarkerDistance();

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No location found for: $searchQuery'),
              duration: const Duration(seconds: 2),
            )
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching for location: $e'),
            duration: const Duration(seconds: 2),
          )
      );
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


  Future<void> _locateUser() async {
    try {
      var location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          debugPrint("Service not enabled");
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          debugPrint("Permission not granted");
          return;
        }
      }

      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = LatLng(
          userLocation.latitude!,
          userLocation.longitude!,
        );

        _mapController.move(currentLocation, 15.0);
      });

    } catch (e) {
      debugPrint("Error in locating user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to locate user: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _clearSelection() {
    setState(() {
      selectedMarker = null;
      polylines.clear();
      routePoints.clear();
      _animationController.reverse();

      _isSearchedLocation = false;

      _locateUser();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Languages.isRTL(Get.locale?.languageCode ?? 'en')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            _buildMap(),
            _buildSearchBar(),
            if (isMarkerListVisible) _buildFloatingMarkerList(),
            if (selectedMarker != null) _buildSelectedMarkerInfo(), // Updated to show more details
          ],
        ),
        floatingActionButton: _buildFloatingActionButtons(),
      ),
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
      title:  Text(
        'map_title'.tr,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialZoom: 3.0,
        onTap: (_, __) => _clearSelection(),
        maxZoom: 18.0,
        onMapReady: () {
          _locateUser();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        PolylineLayer(
          polylines: polylines,
        ),
        MarkerLayer(
          markers: markers + [if (userLocationMarker != null) userLocationMarker!],
        ),
        // إضافة موقع المستخدم
        CurrentLocationLayer(
          followOnLocationUpdate: FollowOnLocationUpdate.always,
          turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
          style: LocationMarkerStyle(

            markerSize: const Size(40, 40),
          ),
        ),
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
            hintText: 'search_hintmap'.tr,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF259e9f)),
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
      top: (Get.height - (Get.height * 0.4)) / 2,
      right: 16,
      child: Container(
        width: Get.width * 0.6,
        height: Get.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF259e9f),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'medical_markers'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Get.width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                  Icon(Icons.medical_services_outlined, color: Colors.white, size: Get.width * 0.05),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: markerInfos.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[300],
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final info = markerInfos[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(
                      info.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Get.width * 0.035,
                      ),
                    ),
                    subtitle: Text(
                      '${info.distance.toStringAsFixed(2)} km',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: Get.width * 0.03,
                      ),
                    ),
                    leading: Icon(
                      Icons.location_on,
                      color: Color(0xFF259e9f),
                      size: Get.width * 0.08,
                    ),
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