import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:insaaju/exceptions/required_exception.dart';
import 'package:insaaju/routes.dart';
import 'package:insaaju/states/four_pillars_of_destiny/four_pillars_of_destiny_selector.dart';
import 'package:insaaju/ui/screen/home/home_screen.dart';
import 'package:insaaju/ui/screen/widget/app_background.dart';
import 'package:insaaju/ui/screen/widget/app_bar_close_leading_button.dart';

class WuxingScreen extends StatefulWidget {
  const WuxingScreen({super.key});

  @override
  _WuxingScreenState createState() => _WuxingScreenState();
}

class _WuxingScreenState extends State<WuxingScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildAppBackground();
  }

  Widget _buildAppBackground(){
    return AppBackground(
      appBar: AppBar(
        title: Text("오행 분석"),
        leading: AppBarCloseLeadingButton(
          onPressed: (){
            AppNavigator.pop();
          }
        ),
      ),
      child: Column(
        children: [
          _buildWuXingChart()
        ],
      ),
    );
  }
  
   Widget _buildWuXingChart() {
    return FourPillarsOfDestinyStructureSelector((fourPillarsOfDestinyStructure) {
      if(fourPillarsOfDestinyStructure == null){
        throw RequiredException<String>('Four pillars of destiny');
      }

      final Map<String, int> wuXingCounts = {
        '화': fourPillarsOfDestinyStructure.info.wuxing.count.fire,
        '수': fourPillarsOfDestinyStructure.info.wuxing.count.water,
        '목': fourPillarsOfDestinyStructure.info.wuxing.count.wood,
        '금': fourPillarsOfDestinyStructure.info.wuxing.count.metal,
        '토': fourPillarsOfDestinyStructure.info.wuxing.count.earth,
      };

      final Map<String, Color> wuXingColors = {
        '화': Color(int.parse(fourPillarsOfDestinyStructure.info.wuxing.colors.fire.replaceFirst('#','0xFF'))),
        '수': Color(int.parse(fourPillarsOfDestinyStructure.info.wuxing.colors.water.replaceFirst('#','0xFF'))),
        '목': Color(int.parse(fourPillarsOfDestinyStructure.info.wuxing.colors.wood.replaceFirst('#','0xFF'))),
        '금': Color(int.parse(fourPillarsOfDestinyStructure.info.wuxing.colors.metal.replaceFirst('#','0xFF'))),
        '토': Color(int.parse(fourPillarsOfDestinyStructure.info.wuxing.colors.earth.replaceFirst('#','0xFF'))),
      };
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 6,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    final names = wuXingCounts.keys.toList();
                    if (value.toInt() < names.length) {
                      return Text(names[value.toInt()], style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600));
                    } else {
                      return const Text('');
                    }
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: wuXingCounts.entries.map((entry) {
              return BarChartGroupData(
                x: wuXingCounts.keys.toList().indexOf(entry.key),
                barRods: [
                  BarChartRodData(
                    toY: entry.value.toDouble(),
                    color: wuXingColors[entry.key] ?? Colors.blueAccent,
                    width: 16,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      );
    });
    
  }
}
  
