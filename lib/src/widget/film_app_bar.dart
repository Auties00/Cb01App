import 'package:flutter/material.dart';

class FilmAppBar extends StatelessWidget {
  final Function onTap;
  FilmAppBar({
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () => {},
          icon: Icon(
              Icons.menu
          ),
        ),


        IconButton(
          onPressed: onTap,
          icon: Icon(
              Icons.search
          ),
        ),
      ],
    );
  }
}
