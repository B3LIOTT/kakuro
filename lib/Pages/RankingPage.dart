import 'package:flutter/material.dart';
import '../Objects/UserPreferences.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {

  Widget returnBtn() {
    return Container(
      decoration: BoxDecoration(
        color: UserPreferences.bgBtn,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: UserPreferences.btnColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UserPreferences.bgColor,
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top:MediaQuery.of(context).padding.top+15, left:20),
              child: returnBtn(),
            ),

          ])),
    );
  }
}
