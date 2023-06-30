import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final Map<String, dynamic> results;
  const SimpleBarChart({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> yVal = results['yVal'];
    final List<dynamic> xVal = results['xVal'];

    final int last = yVal.last;
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SizedBox(
        height: MediaQuery.of(context).size.width / 1.5,
        width: MediaQuery.of(context).size.width / 1.3,
        child: BarChart(
          BarChartData(
            maxY: last.toDouble(),
            barGroups: xVal
                .map(
                  (i) => BarChartGroupData(
                    x: i.toInt(),
                    barRods: [
                      BarChartRodData(
                        toY: i.toDouble() / 10, // The height of the bar
                        color: Colors.blue, // The color of the bar
                      ),
                    ],
                  ),
                )
                .toList(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
