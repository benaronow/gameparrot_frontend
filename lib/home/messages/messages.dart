import 'package:flutter/material.dart';
import 'package:gameparrot/home/home_data_model.dart';
import 'message_area.dart';
import 'message_input.dart';
import 'mobile_header.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final homeData = HomeDataModel.getHomeData(context);

    return Expanded(
      child: Stack(
        children: [
          MessageArea(),
          if (homeData.isMobile) MobileHeader(),
          if (homeData.selectedFriend != null)
            Positioned(left: 0, right: 0, bottom: 0, child: MessageInput()),
        ],
      ),
    );
  }
}
