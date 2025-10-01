import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:four_diary/widgets/img_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../database_helper.dart';
import '../model/diary_model.dart' show DiaryModel;
import '../util/snackbar.dart';
import '../widgets/select_img.dart';

class WriteScreen extends StatefulWidget {
  final DiaryModel? diaryModel;

  const WriteScreen({super.key, this.diaryModel});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  late ValueNotifier<dynamic> selectedImgTopleft;
  late ValueNotifier<dynamic> selectedImgTopright;
  late ValueNotifier<dynamic> selectedImgBtmleft;
  late ValueNotifier<dynamic> selectedImgBtmright;

  late bool isEdit;

  TextEditingController inputTitleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  int selectedDate = 0;

  @override
  void initState() {
    isEdit = widget.diaryModel == null ? false : true;

    if (isEdit) {
      inputTitleController.text = widget.diaryModel!.title;
      selectedDate = widget.diaryModel!.date;
      selectedImgTopleft = ValueNotifier(widget.diaryModel!.imageTopLeft);
      selectedImgTopright = ValueNotifier(widget.diaryModel!.imageTopRight);
      selectedImgBtmleft = ValueNotifier(widget.diaryModel!.imageBtmLeft);
      selectedImgBtmright = ValueNotifier(widget.diaryModel!.imageBtmRight);
    } else {
      selectedImgTopleft = ValueNotifier(null);
      selectedImgTopright = ValueNotifier(null);
      selectedImgBtmleft = ValueNotifier(null);
      selectedImgBtmright = ValueNotifier(null);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? '네컷일기 수정하기' : '네컷일기 작성하기',
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
            ImgGridView(
              gridViewItem: [
                SelectImage(selectedImage: selectedImgTopleft),
                SelectImage(selectedImage: selectedImgTopright),
                SelectImage(selectedImage: selectedImgBtmleft),
                SelectImage(selectedImage: selectedImgBtmright),
              ],
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
                  validator: (val) => titleValidate(val),
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
                    isEdit ? '수정하기' : '저장하기',
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
    if (val.isEmpty) {
      return '제목을 입력해주세요';
    }
    return null;
  }

  void validateInput() {
    if (formKey.currentState!.validate() &&
        isImgFieldValidate() &&
        isDateValidate()) {
      isEdit ? editData() : saveData();
    }
  }

  void saveData() async {
    DiaryModel diaryModel = DiaryModel(
      title: inputTitleController.text,
      imageTopLeft: await selectedImgTopleft.value!.readAsBytes(),
      imageTopRight: await selectedImgTopright.value!.readAsBytes(),
      imageBtmLeft: await selectedImgBtmleft.value!.readAsBytes(),
      imageBtmRight: await selectedImgBtmright.value!.readAsBytes(),
      date: selectedDate,
    );

    try {
      await DatabaseHelper().initDatabase();
      int id = await DatabaseHelper().insertInfo(diaryModel);
      if (!mounted) return;
      showSnackBar(context, '일기가 저장되었습니다');
      Navigator.pop(context, "COMPLETED_UPDATE");
    } catch (e) {
      print('DB insert 실패: $e');
      if (!mounted) return;
      showSnackBar(context, '일기 저장에 실패했습니다');
    }
  }

  Future<Uint8List> makeReadAsByte(dynamic target) async {
    try {
      return await target.readAsBytes();
    } catch (e) {
      return target;
    }
  }

  void editData() async {
    DiaryModel diaryModel = DiaryModel(
      id: widget.diaryModel!.id,
      title: inputTitleController.text,
      imageTopLeft: await makeReadAsByte(selectedImgTopleft.value),
      imageTopRight: await makeReadAsByte(selectedImgTopright.value),
      imageBtmLeft: await makeReadAsByte(selectedImgBtmleft.value),
      imageBtmRight: await makeReadAsByte(selectedImgBtmright.value),
      date: selectedDate,
    );

    try {
      await DatabaseHelper().initDatabase();
      int id = await DatabaseHelper().updateInfo(diaryModel);
      if (!mounted) return;
      showSnackBar(context, '일기가 수정되었습니다');

      Navigator.pop(context, "COMPLETED_UPDATE");
    } catch (e) {
      print('DB insert 실패: $e');
      showSnackBar(context, '일기 수정에 실패했습니다');
    }
  }

  bool isImgFieldValidate() {
    bool isImgSelected =
        selectedImgTopleft.value != null &&
        selectedImgBtmright.value != null &&
        selectedImgTopright.value != null &&
        selectedImgBtmleft.value != null;

    if (isImgSelected) {
      return true;
    } else {
      showSnackBar(context, '이미지를 선택해주세요');
      return false;
    }
  }

  bool isDateValidate() {
    bool isDateValidate = selectedDate != 0;
    if (isDateValidate) {
      return true;
    } else {
      showSnackBar(context, '날짜를 선택해주세요');
      return false;
    }
  }
}
