import 'package:flutter/material.dart';

const kHintTextStyle = TextStyle(
  color: Color.fromARGB(178, 13, 13, 19),
  fontFamily: 'OpenSans',
);

const kLabelStyle = TextStyle(
  color: Color.fromARGB(255, 31, 33, 133),
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: const Color.fromARGB(255, 175, 192, 212),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

class CustomButton extends StatelessWidget {
  final IconData leftIcon;
  final String text;
  final IconData rightIcon;
  final VoidCallback onPressed;
  final Color kBgColor;
  final Color kTxtColor;
  final Widget route;
  const CustomButton({
    super.key,
    required this.leftIcon,
    required this.text,
    required this.rightIcon,
    required this.onPressed,
    required this.kBgColor,
    required this.kTxtColor,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              color: kTxtColor,
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(
                color: kTxtColor,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(width: 8.0),
            Icon(
              Icons.chevron_right_rounded,
              color: kTxtColor,
              size: 24.0,
            ),
          ],
        ),
      ),
    );
  }
}

// appbar
// const kAppBarBackgroundColor = Color.fromARGB(255, 31, 33, 133);

// class CustomAppBar extends StatelessWidget {
//   final IconData icon;
//   final String title;

//   const CustomAppBar({
//     super.key,
//     required this.icon,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: kAppBarBackgroundColor,
//       title: Row(
//         children: [
//           Icon(icon),
//           const SizedBox(width: 8.0),
//           Text(title),
//         ],
//       ),
//     );
//   }

//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
