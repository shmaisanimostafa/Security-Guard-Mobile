import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart'; // Import the chart package

class ConfidenceBarChart extends StatelessWidget {
  final Map<String, double> confidenceScores;

  const ConfidenceBarChart({super.key, required this.confidenceScores});

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> barGroups = confidenceScores.entries.map((entry) {
      final index = confidenceScores.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.blue,
            width: 20,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final label = confidenceScores.keys.toList()[value.toInt()];
                return Text(label, style: const TextStyle(fontSize: 12));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.2,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(value.toStringAsFixed(1));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
      ),
    );
  }
}