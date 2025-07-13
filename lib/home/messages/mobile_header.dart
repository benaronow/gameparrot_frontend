import 'package:flutter/material.dart';
import 'package:gameparrot/home/home_data_model.dart';
import 'package:gameparrot/providers/home_provider.dart';
import 'package:gameparrot/theme.dart';
import 'package:provider/provider.dart';
import '../../widgets/widgets.dart';

class MobileHeader extends StatelessWidget {
  const MobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final homeData = HomeDataModel.getHomeData(context);

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 30, left: 16, right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.shadow.withValues(alpha: .8),
            AppColors.shadow.withValues(alpha: .4),
            Colors.white.withValues(alpha: 0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SizedBox(
        height: 50, // Set explicit height to prevent expansion
        child: Stack(
          children: [
            // Back button positioned on the left
            Align(
              alignment: Alignment.centerLeft,
              child: StyledIconButton(
                icon: Icons.arrow_back,
                iconColor: Colors.white,
                size: 40,
                onPressed: () => Provider.of<HomeProvider>(
                  context,
                  listen: false,
                ).setSelectedId(null),
              ),
            ),
            // Email centered in the entire component
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                ), // Account for button space
                child: Text(
                  homeData.selectedFriend?.email ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
