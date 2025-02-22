import 'package:flutter/material.dart';
import 'package:insaaju/domain/entities/info.dart';
import 'package:insaaju/states/info/info_selector.dart';
import 'package:insaaju/ui/screen/widget/info_card.dart';

class CheckScreen extends StatelessWidget {
  final Function(Info)? onSave;
  const CheckScreen({
    this.onSave,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: InfoStateSelector((state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InfoCard(
                  name: state.name!,
                  date: state.date!.toString(),
                  time: state.time!.toString()
                ),
                Spacer(),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if(!state.hasMissingFields()){
                            final info = Info(
                                name: state.name!,
                                date: state.date!,
                                time: state.time!,
                                solarAndLunar: state.solarAndLunar!,
                                sessionId: state.sessionId!,
                                gender: state.gender!
                            );
                            onSave!(info);
                          }


                        },
                        child: Text('저장하기'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}