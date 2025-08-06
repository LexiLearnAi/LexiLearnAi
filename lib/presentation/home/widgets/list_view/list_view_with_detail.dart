import 'package:flutter/material.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';

class ListViewWithDetail extends StatelessWidget {
  const ListViewWithDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
                color: AppColorScheme.lightColorScheme.outline,
                width: 2,
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: const ListTile(
            title: Text('Sun'),
            subtitle: Text('Sun'),
            leading: Icon(Icons.wb_sunny),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        );
      },
    );
  }
}
