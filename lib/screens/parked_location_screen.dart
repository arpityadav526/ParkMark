import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parking_location.dart';
import '../services/maps_service.dart';
import '../utils/constants.dart';
import '../widgets/action_button.dart';

class ParkedLocationScreen extends StatelessWidget {
  final ParkingLocation location;

  const ParkedLocationScreen({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final mapsService = MapsService();
    final formattedTime =
        DateFormat('dd MMM yyyy, hh:mm a').format(location.savedAt);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Your Parked Vehicle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved Parking Details',
                    style: AppTextStyles.cardTitle,
                  ),
                  const SizedBox(height: 16),
                  _DetailRow(
                    icon: Icons.place_rounded,
                    title: 'Address',
                    value: location.address,
                  ),
                  const SizedBox(height: 14),
                  _DetailRow(
                    icon: Icons.my_location_rounded,
                    title: 'Latitude',
                    value: location.latitude.toStringAsFixed(6),
                  ),
                  const SizedBox(height: 14),
                  _DetailRow(
                    icon: Icons.explore_rounded,
                    title: 'Longitude',
                    value: location.longitude.toStringAsFixed(6),
                  ),
                  const SizedBox(height: 14),
                  _DetailRow(
                    icon: Icons.access_time_rounded,
                    title: 'Saved At',
                    value: formattedTime,
                  ),
                ],
              ),
            ),
            const Spacer(),
            ActionButton(
              label: 'Open in Google Maps',
              icon: Icons.map_rounded,
              backgroundColor: AppColors.success,
              onPressed: () async {
                try {
                  await mapsService.openInGoogleMaps(
                    latitude: location.latitude,
                    longitude: location.longitude,
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceFirst('Exception: ', ''),
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            ActionButton(
              label: 'Back',
              icon: Icons.arrow_back_rounded,
              backgroundColor: AppColors.secondaryButton,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.detailLabel),
              const SizedBox(height: 4),
              Text(value, style: AppTextStyles.detailValue),
            ],
          ),
        ),
      ],
    );
  }
}