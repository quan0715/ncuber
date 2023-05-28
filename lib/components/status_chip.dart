import 'package:flutter/material.dart';
import 'package:ncuber/model/car_model.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});
  final CarStatus status;

  @override
  Widget build(BuildContext context) {
    Color color = Color(status.statusColor);
    return Chip(
        visualDensity: VisualDensity.compact,
        backgroundColor: color.withOpacity(0.15),
        avatar: CircleAvatar(
          backgroundColor: color,
          radius: 5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        side: BorderSide(color: color.withOpacity(0.2), width: 0),
        labelStyle: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold, color: color),
        label: Text(status.statusName));
  }
}
