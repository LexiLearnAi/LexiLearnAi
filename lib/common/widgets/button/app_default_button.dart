import 'package:flutter/material.dart';

class AppDefaultButton extends StatelessWidget {
  const AppDefaultButton({super.key, this.onPressed, required this.labelText});
  final void Function()? onPressed;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Theme.of(context).primaryColor,
        disabledBackgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        labelText,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: onPressed == null ? Colors.black : Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 22,
            ),
      ),
    );
  }
}
