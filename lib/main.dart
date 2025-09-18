import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '네컷일기',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: MainScreen(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/write': (context) => const WriteScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '네컷일기',
          style: GoogleFonts.nanumPenScript(
            textStyle: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Color(0xffFAF9E6),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
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
                  Container(color: Colors.black),
                  Container(color: Colors.white),
                  Container(color: Colors.yellow),
                  Container(color: Colors.blue),
                ],
              ),
            ),
            Transform.rotate(
              angle: 60 * math.pi / 180,
              child: Container(
                width: MediaQuery.of(context).size.width / 4,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.elliptical(70, 85)),
                ),
              ),
            ),
            Text(
              '제목입니다.',
              style: GoogleFonts.nanumPenScript(
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            // 날짜
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Text(
                    '2025.09.16',
                    style: GoogleFonts.nanumPenScript(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // 수정하기, 삭제하기
            Positioned(
              top: 8,
              right: 8,
              child: PopupMenuButton<String>(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Icon(Icons.more_vert, color: Colors.white),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(child: Text('수정하기'), onTap: () {}),
                  PopupMenuItem<String>(child: Text('삭제하기'), onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).pushNamed('/write');
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  late ValueNotifier<dynamic> selectedImgTopleft;
  late ValueNotifier<dynamic> selectedImgTopright;
  late ValueNotifier<dynamic> selectedImgBtmleft;
  late ValueNotifier<dynamic> selectedImgBtmright;

  @override
  void initState() {
    selectedImgTopleft = ValueNotifier(null);
    selectedImgTopright = ValueNotifier(null);
    selectedImgBtmleft = ValueNotifier(null);
    selectedImgBtmright = ValueNotifier(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '네컷일기 작성하기',
          style: GoogleFonts.nanumPenScript(
            textStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
        ),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
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
            SelectImage(selectedImage: selectedImgTopleft),
            SelectImage(selectedImage: selectedImgTopright),
            SelectImage(selectedImage: selectedImgBtmleft),
            SelectImage(selectedImage: selectedImgBtmright),
          ],
        ),
      ),
    );
  }
}

class SelectImage extends StatefulWidget {
  final ValueNotifier<dynamic>? selectedImage;

  const SelectImage({super.key, this.selectedImage});

  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
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
                child: Image.file(
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
      setState(() {});
      return;
    }
  }
}
