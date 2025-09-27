import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
              height: MediaQuery
                  .of(context)
                  .size
                  .width,
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 4,
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
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<String>>[
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

  TextEditingController inputTitleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  int selectedDate = 0;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 선택 위젯
            Container(
              margin: EdgeInsets.all(8),
              width: double.maxFinite,
              height: MediaQuery
                  .of(context)
                  .size
                  .width,
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
            // 텍스트 작성 필드
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '한 줄 일기',
                style: GoogleFonts.nanumPenScript(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: formKey,
                child: TextFormField(
                  validator: (val) => titleValidate(val) ,
                  decoration: InputDecoration(
                    hintText: '한 줄 일기를 작성해주세요(최대 8글자)',
                    hintStyle: GoogleFonts.nanumPenScript(fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffE1E1E1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  maxLength: 8,
                  controller: inputTitleController,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '날짜',
                style: GoogleFonts.nanumPenScript(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            // 날짜 선택 버튼
            GestureDetector(
              onTap: () => _selectedDate(context),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                alignment: Alignment.centerLeft,
                width: double.maxFinite,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffE1E1E1)),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  child: selectedDate == 0
                      ? Text(
                    '날짜를 선택해주세요',
                    style: GoogleFonts.nanumPenScript(
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xffACACAC),
                      ),
                    ),
                  )
                      : Text(
                    DateFormat('yyyy.MM.dd').format(
                      DateTime.fromMillisecondsSinceEpoch(selectedDate),
                    ),
                    style: GoogleFonts.nanumPenScript(
                      textStyle: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: ElevatedButton(
                onPressed: () => validateInput(),
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Text(
                    '저장하기',
                    style: GoogleFonts.nanumPenScript(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _selectedDate(BuildContext context) async {
    // 날짜를 선택하는 함수
    final DateTime? selected = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (selected != null) {
      selectedDate = selected.millisecondsSinceEpoch;
      setState(() {});
    }
  }

  dynamic titleValidate(val) {
    if(val.isEmpty){
      return '제목을 입력해주세요';
    }
    return null;
  }

  void validateInput() {
    if (formKey.currentState!.validate() && isImgFieldValidate() &&
        isDateValidate()){
      // savedDate();
    }
  }

  bool isImgFieldValidate() {
    bool isImgSelected = selectedImgTopleft.value != null &&
        selectedImgBtmright.value != null &&
        selectedImgTopright.value != null && selectedImgBtmleft.value != null;

    if (isImgSelected) {
      return true;
    } else {
      final snackBar = SnackBar(
        content: Text('이미지를 선택해주세요'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  bool isDateValidate() {
    bool isDateValidate = selectedDate != 0;
    if (isDateValidate) {
      return true;
    } else {
      final snackBar = SnackBar(
        content: Text('날짜를 선택해주세요'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
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
          height: MediaQuery
              .of(context)
              .size
              .width,
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
