import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
    final Color _btnColor = const Color(0xFF61524D);

  @override
  Widget TopMenu() {
    return Container(
        height: MediaQuery.of(context).size.width/5,
        width: MediaQuery.of(context).size.width/2,
        decoration: BoxDecoration(
          color: _btnColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: ButtonBar(
          children: [
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.home),
            )
          ],
        ),
      );
  }

  Widget PartyButtons() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: 200,
          child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _btnColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text("Nouvelle Partie")
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text("CREER")
                ),
            ),

            SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _btnColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text("REJOINDRE")
                ),
            ),
          ],
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: const Color(0xFFFFDFC8),
      body: SizedBox (
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: MediaQuery.of(context).size.height/5,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10, right: 20),
              alignment: Alignment.topRight,
              child: TopMenu(),
            ),
            Container(
              color: Colors.black45,
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height/2,
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: PartyButtons(),
            ),
          ]
        )
      ),
    );
  }
}