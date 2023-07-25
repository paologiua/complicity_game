import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  const ListItem({
    super.key,
    required this.color,
    required this.borderColor,
    required this.text,
    this.onTap,
  });

  final Color color;
  final Color borderColor;
  final String text;
  final void Function()? onTap;

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
          color: widget.borderColor,
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        padding: const EdgeInsets.all(20.0),
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
