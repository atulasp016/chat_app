import 'package:chat_app/utils/app_images.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_style.dart';

Widget appLogo({
  Color color = const Color(0xff24786D),
  double width = 70,
  double height = 70,
}) {
  return SizedBox(
      width: width,
      height: height,
      child:
          Image.asset(AppImages.IC_APP_LOGO, fit: BoxFit.fill, color: color));
}

Widget appName({
  required TextStyle textStyle,
}) {
  return Text('Chatbox', style: textStyle);
}

Widget googleSignBTN({
  required VoidCallback onTap,
  Color? imageColor,
  required String iconImage,
  Color borderColor = Colors.black,
  Color bgColor = Colors.white,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: borderColor)),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 10, color: bgColor)),
          child: SizedBox(
            width: 28,
            height: 28,
            child: Image.asset(iconImage, color: imageColor, fit: BoxFit.fill),
          ),
        )),
  );
}

Widget outlinedBTN({
  required VoidCallback onTap,
  required String title,
  Color bgColor = Colors.white,
  Color textColor = Colors.white,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Text(
            title,
            style:
                mTextStyle16(mColor: textColor, mFontWeight: FontWeight.bold),
          ),
        )),
  );
}

Widget textBTN({
  required VoidCallback onTap,
  required String title,
  Color textColor = Colors.white,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Center(
      child: Text(
        title,
        style: mTextStyle14(mColor: textColor, mFontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget appDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Flexible(
            child: Divider(
                height: 0.5, color: AppColors.outlineColor, endIndent: 11)),
        Text(
          'OR',
          style: mTextStyle12(
              mColor: AppColors.secondaryTextColor,
              mFontWeight: FontWeight.w500),
        ),
        Flexible(
            child: Divider(
                height: 0.5, color: AppColors.outlineColor, indent: 11)),
      ],
    ),
  );
}

Widget appTextField({
  required String title,
  required String hintText,
  obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  required FormFieldValidator validator,
  required TextEditingController controller,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 21),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: mTextStyle16(
              mFontWeight: FontWeight.w500, mColor: AppColors.primaryColor),
        ),
        TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: const InputDecoration(),
        ),
      ],
    ),
  );
}

List<Map<String, dynamic>> settingsItems = [
  {
    'icon': AppImages.IC_CALLS,
    'title': 'Account',
    'subTitle': 'Privacy, security, change number',
  },
  {
    'icon': AppImages.IC_MESSAGES,
    'title': 'Chat',
    'subTitle': 'Chat history,theme,wallpapers',
  },
  {
    'icon': AppImages.IC_CALLS,
    'title': 'Notifications',
    'subTitle': 'Messages, group and others',
  },
  {
    'icon': AppImages.IC_MESSAGES,
    'title': 'Help',
    'subTitle': 'Help center,contact us, privacy policy',
  },
  {
    'icon': AppImages.IC_CALLS,
    'title': 'Storage and data',
    'subTitle': 'Network usage, storage usage',
  },
  {
    'icon': AppImages.IC_CONTACTS,
    'title': 'Invite a friend',
    'subTitle': '',
  },
];

class CustomAppBar extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  const CustomAppBar({
    super.key,
     required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: mTextStyle22(
                  mFontWeight: FontWeight.bold, mColor: AppColors.whiteColor)),
          GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.secondaryLowBlack,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    AppImages.IC_MORE,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget customListTile({
  required VoidCallback onTap,
  required double minVerticalPadding,
  required String title,
  required String subtitle,
  Widget? trailing,
  Widget? leadingProfileImg,
  Widget? leadingProIcon,
}) {
  return ListTile(
    onTap: onTap,
    minVerticalPadding: minVerticalPadding,
    leading: leadingProfileImg ?? leadingProIcon,
    title: title.isNotEmpty
        ? Text(
            title,
            style: mTextStyle18(
                mFontWeight: FontWeight.bold, mColor: AppColors.mainBlack),
          )
        : null,
    subtitle: subtitle.isNotEmpty
        ? Text(
            subtitle,
            style: mTextStyle14(mColor: AppColors.secondaryTextColor),
          )
        : null,
    trailing: trailing,
  );
}

Widget appCircleIcon(
    {required VoidCallback onTap,
    required String imgIcon,
    Color imgColor = Colors.white}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: AppColors.whiteColor)),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 8, color: AppColors.mainBlack)),
          child: SizedBox(
            width: 25,
            height: 25,
            child: Image.asset(imgIcon, color: imgColor, fit: BoxFit.contain),
          ),
        )),
  );
}
