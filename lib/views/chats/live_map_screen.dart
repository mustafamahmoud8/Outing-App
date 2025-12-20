import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:outing/providers/group_provider.dart';
import 'package:outing/theme/app_colors.dart';
import 'package:outing/services/permission_service.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final Set<Marker> _markers = {};
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    
    try {
      // Check and request location permission
      final hasPermission = await PermissionService.requestLocationWithDialog(context);
      
      if (!hasPermission) {
        setState(() => _isLoadingLocation = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission is required'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      // Ensure location services are enabled
      final serviceEnabled = await PermissionService.ensureLocationServiceEnabled(context);
      
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      // Get current position
      final position = await PermissionService.getCurrentLocation();
      
      if (position == null) {
        setState(() => _isLoadingLocation = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to get your location'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }
      
      setState(() {
        _currentPosition = position;
        _addCurrentLocationMarker();
        _isLoadingLocation = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15,
        ),
      );
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _addCurrentLocationMarker() {
    if (_currentPosition == null) return;

    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        infoWindow: const InfoWindow(
          title: 'You',
          snippet: 'Your current location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  void _addMeetingPointMarker(LatLng position) {
    _markers.removeWhere((m) => m.markerId.value == 'meeting_point');
    
    _markers.add(
      Marker(
        markerId: const MarkerId('meeting_point'),
        position: position,
        infoWindow: const InfoWindow(
          title: 'Meeting Point',
          snippet: 'Tap to navigate',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'My Location',
            onPressed: _getCurrentLocation,
          ),
          IconButton(
            icon: const Icon(Icons.place),
            tooltip: 'Set Meeting Point',
            onPressed: () => _showSetMeetingPointDialog(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          _currentPosition == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoadingLocation)
                        const CircularProgressIndicator()
                      else
                        const Icon(Icons.location_off, size: 64, color: AppColors.textSecondary),
                      const SizedBox(height: 16),
                      Text(
                        _isLoadingLocation ? 'Getting your location...' : 'Location not available',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      if (!_isLoadingLocation)
                        ElevatedButton(
                          onPressed: _getCurrentLocation,
                          child: const Text('Enable Location'),
                        ),
                    ],
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    zoom: 15,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onTap: (position) {
                    _addMeetingPointMarker(position);
                  },
                ),

          // Group Members Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Consumer<GroupProvider>(
              builder: (context, groupProvider, child) {
                if (groupProvider.currentGroup == null) {
                  return const SizedBox();
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.group, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            '${groupProvider.currentGroup!.memberNames.length} Members Online',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: groupProvider.currentGroup!.memberNames.length,
                          itemBuilder: (context, index) {
                            final name = groupProvider.currentGroup!.memberNames[index];
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.primary,
                                    child: Text(
                                      name[0].toUpperCase(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    name,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (groupProvider.currentGroup!.meetingPoint != null) ...[
                        const Divider(),
                        Row(
                          children: [
                            const Icon(Icons.place, color: AppColors.success, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Meeting Point: ${groupProvider.currentGroup!.meetingPoint}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSetMeetingPointDialog() {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location first')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Meeting Point'),
        content: const Text('Set current location as meeting point for the group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final groupProvider = Provider.of<GroupProvider>(context, listen: false);
              groupProvider.setMeetingPoint('Current Location');
              
              _addMeetingPointMarker(
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              );
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Meeting point set!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
