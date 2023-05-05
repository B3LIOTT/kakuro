import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Objects/Player.dart';
import '../Objects/RankingRepo.dart';
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
    final _rankList = Provider.of<List<Player>>(context);
    return Scaffold(
      backgroundColor: UserPreferences.bgColor,
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top:MediaQuery.of(context).padding.top+15, left:20),
              child: Stack(
                children: [
                  returnBtn(),
                  Center(child:Text("Ranking", style: TextStyle(color: UserPreferences.btnColor, fontSize: 30, fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
            Expanded(
              child: RankingRepo.isConnected? ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(10),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      color: UserPreferences.bgBtn,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          (index+1).toString(),
                          style: TextStyle(
                              color: UserPreferences.btnColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _rankList[index].username,
                          style: TextStyle(
                              color: UserPreferences.btnColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _rankList[index].RP.toString(),
                          style: TextStyle(
                              color: UserPreferences.btnColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ));
                },
                itemCount: _rankList.length,
            ) : const Center(child: Text("PA KONEKT")),
            ),
          ])),
    );
  }
}
