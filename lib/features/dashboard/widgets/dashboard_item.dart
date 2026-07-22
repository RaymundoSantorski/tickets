import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  const DashboardItem({super.key, required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Card(
        color: Colors.blue,
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            Container(
              width: 70,
              height: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 40, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
