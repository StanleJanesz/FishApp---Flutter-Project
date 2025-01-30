
import 'package:fish_app/Classes/fish.dart';
import 'package:fish_app/Classes/bait.dart';
import 'package:flutter/material.dart';
import 'package:fish_app/Classes/weather.dart';


class FishDetailsCard extends StatelessWidget {
  final Fish fish;
  final WeatherLocal? weather;
  final Bait? bait;
  final FishType? fishType;
  const FishDetailsCard({
    super.key,
    required this.fish,
    required this.weather,
    required this.bait,
    required this.fishType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fish #${fish.id}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetail('Size', '${fish.size} cm'),
            if (fishType != null) _buildDetail('Bait', fishType?.type ?? ''),
            _buildDetail('Date',
                '${fish.date.day}/${fish.date.month}/${fish.date.year}'),
            if (bait != null) _buildDetail('Bait', bait?.name ?? ''),
            if (weather != null)
              _buildDetail('Weather',
                  '${weather?.temperature.round()}°C, ${weather?.description}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
}
