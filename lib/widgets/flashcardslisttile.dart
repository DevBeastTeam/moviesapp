import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/appimages.dart';
import '../models/flashCardsModel.dart';

class FlashCardsTileWidget extends StatelessWidget {
  final FlashCardsMovie item;
  final Function() onTap;
  bool isSelected = false;
  FlashCardsTileWidget({
    super.key,
    required this.item,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(item.picture),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(item.label),
          trailing: Image.asset(
            width: 30,
            isSelected ? AppImages.check : AppImages.uncheckradius,
          ),

          onTap: () {
            onTap();
          },
        ),
      ),
    );
  }
}
