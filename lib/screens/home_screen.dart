import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parking_location.dart';
import '../services/location_service.dart';
import '../services/maps_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../widgets/action_button.dart';
import 'parked_location_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  final LocationService _locationService = LocationService();
  final MapsService _mapsService = MapsService();

  ParkingLocation? _savedLocation;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  Future<void> _loadSavedLocation() async {
    setState(() => _isLoading = true);

    final location = await _storageService.getSavedParkingLocation();

    if (!mounted) return;

    setState(() {
      _savedLocation = location;
      _isLoading = false;
    });
  }

  Future<void> _saveParkingLocation() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final location = await _locationService.getCurrentParkingLocation();
      await _storageService.saveParkingLocation(location);

      if (!mounted) return;

      setState(() {
        _savedLocation = location;
      });

      _showMessage(AppConstants.locationSavedSuccess);
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  Future<void> _clearSavedLocation() async {
    final confirmed = await _showClearConfirmationDialog();
    if (!confirmed) return;

    await _storageService.clearSavedParkingLocation();

    if (!mounted) return;

    setState(() {
      _savedLocation = null;
    });

    _showMessage(AppConstants.locationClearedSuccess);
  }

  void _openDetailsScreen() {
    if (_savedLocation == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ParkedLocationScreen(location: _savedLocation!),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<bool> _showClearConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear saved location?'),
          content: const Text(
            'This will remove the currently saved parked vehicle location from your device.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _showErrorDialog({required String message}) async {
    final bool showSettingsAction =
        message == AppConstants.locationPermissionDeniedForever ||
            message == AppConstants.locationPermissionDenied ||
            message == AppConstants.locationServiceDisabled;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Unable to save location'),
          content: Text(message),
          actions: [
            if (showSettingsAction && message == AppConstants.locationServiceDisabled)
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await _mapsService.openLocationSettings();
                  } catch (e) {
                    if (!mounted) return;
                    _showMessage(
                      e.toString().replaceFirst('Exception: ', ''),
                    );
                  }
                },
                child: const Text('Open Location Settings'),
              ),
            if (showSettingsAction &&
                message != AppConstants.locationServiceDisabled)
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await _mapsService.openAppSettings();
                  } catch (e) {
                    if (!mounted) return;
                    _showMessage(
                      e.toString().replaceFirst('Exception: ', ''),
                    );
                  }
                },
                child: const Text('Open App Settings'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSavedLocation = _savedLocation != null;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildHeader(),
                    const SizedBox(height: 26),
                    _buildMainCard(hasSavedLocation),
                    const SizedBox(height: 28),
                    SlideToSaveControl(
                      isSaved: hasSavedLocation,
                      isLoading: _isSaving,
                      onCompleted: _saveParkingLocation,
                    ),
                    const SizedBox(height: 18),
                    if (hasSavedLocation) ...[
                      ActionButton(
                        label: 'View Saved Location',
                        icon: Icons.visibility_rounded,
                        backgroundColor: AppColors.success,
                        onPressed: _openDetailsScreen,
                      ),
                      const SizedBox(height: 12),
                      ActionButton(
                        label: 'Clear Saved Location',
                        icon: Icons.delete_outline_rounded,
                        backgroundColor: AppColors.danger,
                        onPressed: _clearSavedLocation,
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Icon(
          Icons.location_pin,
          color: AppColors.accent,
          size: 34,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.brandPlate,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            'PARK MARK',
            style: AppTextStyles.brandTitle,
          ),
        ),
      ],
    );
  }

  Widget _buildMainCard(bool hasSavedLocation) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSavedLocation
                  ? Icons.verified_rounded
                  : Icons.local_parking_rounded,
              size: 115,
              color: AppColors.cardIcon,
            ),
            const SizedBox(height: 24),
            Text(
              hasSavedLocation
                  ? 'VEHICLE LOCATION SAVED'
                  : 'NO PARKED VEHICLE LOCATION SAVED',
              style: AppTextStyles.cardTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              hasSavedLocation
                  ? _savedLocation!.address
                  : 'Slide below to save your current parked vehicle location.',
              style: AppTextStyles.cardBody,
              textAlign: TextAlign.center,
              maxLines: hasSavedLocation ? 3 : 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (hasSavedLocation) ...[
              const SizedBox(height: 14),
              Text(
                'Saved on ${DateFormat('dd MMM yyyy, hh:mm a').format(_savedLocation!.savedAt)}',
                style: AppTextStyles.savedTime,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SlideToSaveControl extends StatefulWidget {
  final bool isSaved;
  final bool isLoading;
  final Future<void> Function() onCompleted;

  const SlideToSaveControl({
    super.key,
    required this.isSaved,
    required this.isLoading,
    required this.onCompleted,
  });

  @override
  State<SlideToSaveControl> createState() => _SlideToSaveControlState();
}

class _SlideToSaveControlState extends State<SlideToSaveControl> {
  double _dragX = 0;
  double _maxDrag = 0;

  @override
  void didUpdateWidget(covariant SlideToSaveControl oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSaved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _dragX = _maxDrag;
        });
      });
    } else if (!widget.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _dragX = 0;
        });
      });
    }
  }

  Future<void> _handleDragEnd() async {
    if (widget.isSaved) {
      setState(() => _dragX = _maxDrag);
      return;
    }

    final threshold = _maxDrag * 0.82;

    if (_dragX >= threshold) {
      setState(() => _dragX = _maxDrag);
      await widget.onCompleted();

      if (!mounted) return;

      if (!widget.isSaved) {
        setState(() => _dragX = 0);
      }
    } else {
      setState(() => _dragX = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const knobSize = 58.0;
        const horizontalPadding = 6.0;
        _maxDrag = constraints.maxWidth - knobSize - (horizontalPadding * 2);

        final displayText = widget.isLoading
            ? 'SAVING LOCATION...'
            : widget.isSaved
                ? 'LOCATION SAVED'
                : 'SAVE LOCATION';

        final icon =
            widget.isSaved ? Icons.check_rounded : Icons.chevron_right_rounded;

        return Container(
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.sliderTrack,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.18)),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: widget.isLoading ? 0.9 : 1,
                  child: Text(
                    displayText,
                    style: AppTextStyles.sliderText,
                  ),
                ),
              ),
              if (widget.isLoading)
                const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.3,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (!widget.isLoading)
                Positioned(
                  left: horizontalPadding + _dragX,
                  child: GestureDetector(
                    onHorizontalDragUpdate: widget.isSaved
                        ? null
                        : (details) {
                            setState(() {
                              _dragX += details.delta.dx;
                              if (_dragX < 0) _dragX = 0;
                              if (_dragX > _maxDrag) _dragX = _maxDrag;
                            });
                          },
                    onHorizontalDragEnd:
                        widget.isSaved ? null : (_) => _handleDragEnd(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: knobSize,
                          height: knobSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: Colors.white.withOpacity(0.23),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.30),
                              width: 1.2,
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}