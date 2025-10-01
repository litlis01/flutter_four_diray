import 'package:flutter/cupertino.dart';

class ImgGridView extends StatefulWidget {
  final List<Widget> gridViewItem;

  const ImgGridView({super.key, required this.gridViewItem});

  @override
  State<ImgGridView> createState() => _ImgGridViewState();
}

class _ImgGridViewState extends State<ImgGridView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: double.maxFinite,
      height: MediaQuery.of(context).size.width,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: widget.gridViewItem[0],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: widget.gridViewItem[1],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: widget.gridViewItem[2],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: widget.gridViewItem[3],
          ),
        ],
      ),
    );
  }
}
