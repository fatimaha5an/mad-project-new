import 'package:flutter/material.dart';
import 'package:spotify/common/helpers/is_dark.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool hidebackbtn;
  final Widget? action;
  final Color? bgColor;
  const BasicAppBar({super.key, this.title, this.hidebackbtn = false,this.action, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:bgColor?? Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title ?? const Text(''),
      actions:[
        action ?? Container()
        ],
      leading: hidebackbtn
          ? null
          : IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? AppColors.primary.withOpacity(0.03)
                      : AppColors.primary.withOpacity(0.03),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: context.isDarkMode
                      ? AppColors.primary
                      : AppColors.primary,
                ),
              ),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
