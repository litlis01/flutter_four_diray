import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImage extends StatefulWidget {
  final ValueNotifier<dynamic>? selectedImage;

  const SelectImage({super.key, this.selectedImage});

  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  bool isNewSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Color(0xffF4F4F4),
        ),
        child: widget.selectedImage?.value == null
        // 선택된 이미지가 없으면
            ? Icon(Icons.image, color: Color(0xff868686))
        // 선택된 이미지가 있으면
            : Container(
          height: MediaQuery.of(context).size.width,
          child: isNewSelected
              ? Image.file(widget.selectedImage!.value, fit: BoxFit.cover)
              : Image.memory(
            widget.selectedImage!.value,
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTap: () => getGalleryImage(),
    );
  }

  void getGalleryImage() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (image != null) {
      widget.selectedImage?.value = File(image.path);
      isNewSelected = true;
      setState(() {});
      return;
    }
  }
}
