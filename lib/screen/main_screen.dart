import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import '../database_helper.dart';
import '../model/diary_model.dart';
import '../util/snackbar.dart';
import '../widgets/img_grid_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<DiaryModel>> diaryList;

  @override
  void initState() {
    super.initState();
    diaryList = setDiaryData();
  }

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
        color: const Color(0xffFAF9E6),
        child: FutureBuilder(
          future: diaryList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.isEmpty
                  ? emptyListInfoText()
                  : diaryListView(snapshot);
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          var result = await Navigator.of(context).pushNamed('/write');
          if (result != null) {
            updateData(result);
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget emptyListInfoText() {
    return Center(
      child: Text(
        '첫 일기를 작성해주세요',
        style: GoogleFonts.nanumPenScript(
          textStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget diaryListView(AsyncSnapshot<List<DiaryModel>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        DiaryModel diaryModel = snapshot.data![index];
        return Container(
          margin: EdgeInsets.only(top: 24),
          child: Stack(
            alignment: Alignment.center,
            children: [
              fourImg(diaryModel),
              diaryTitleBackground(),
              diaryTitle(diaryModel.title),
              // 날짜
              Positioned(
                bottom: 0,
                right: 0,
                child: diaryDate(diaryModel.date),
              ),
              // 수정하기, 삭제하기
              Positioned(top: 8, right: 8, child: menuButton(diaryModel)),
            ],
          ),
        );
      },
    );
  }

  Widget fourImg(DiaryModel diaryModel) {
    return ImgGridView(
      gridViewItem: [
        Image.memory(diaryModel.imageTopLeft, fit: BoxFit.cover),
        Image.memory(diaryModel.imageTopRight, fit: BoxFit.cover),
        Image.memory(diaryModel.imageBtmLeft, fit: BoxFit.cover),
        Image.memory(diaryModel.imageBtmRight, fit: BoxFit.cover),
      ],
    );
  }

  Widget diaryTitleBackground() {
    return Transform.rotate(
      angle: 60 * math.pi / 180,
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.all(Radius.elliptical(70, 85)),
        ),
      ),
    );
  }

  Widget diaryTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.nanumPenScript(
        textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget diaryDate(int date) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        margin: EdgeInsets.all(8),
        child: Text(
          DateFormat(
            'yyyy.MM.dd',
          ).format(DateTime.fromMillisecondsSinceEpoch(date)),
          style: GoogleFonts.nanumPenScript(
            textStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget menuButton(DiaryModel diaryModel) {
    return PopupMenuButton<String>(
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
        child: Icon(Icons.more_vert, color: Colors.white),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          child: Text('수정하기'),
          onTap: () async {
            var result = await Navigator.of(
              context,
            ).pushNamed('/write', arguments: diaryModel);
            if (result != null) {
              updateData(result);
            }
          },
        ),
        PopupMenuItem<String>(
          child: Text('삭제하기'),
          onTap: () => deleteDiary(diaryModel.id!),
        ),
      ],
    );
  }

  void deleteDiary(int id) async {
    await DatabaseHelper().initDatabase();
    await DatabaseHelper().deleteInfo(id);
    if (!mounted) return;
    showSnackBar(context, '일기가 삭제되었습니다');
    diaryList = setDiaryData();
  }

  void updateData(var result) async {
    if (result == "COMPLETED_UPDATE") {
      diaryList = setDiaryData();
      setState(() {});
    }
  }

  Future<List<DiaryModel>> setDiaryData() async {
    await DatabaseHelper().initDatabase();
    Future<List<DiaryModel>> diaryList = DatabaseHelper().getAllInfo();
    return diaryList;
  }
}
