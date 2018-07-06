import 'package:flutter/material.dart';

class Credits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CREDITS"),
        centerTitle: true,
      ),
      body: CreditsBody(),
    );
  }
}

class CreditsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 32.0, bottom: 8.0),
          child: Image.asset(
            "images/credits/axys.jpg",
            height: 100.0,
          ),
        ),
        ListTile(
            leading: Image.asset("images/credits/sunera.png"),
            title: Text("K. D. Sunera Avinash Chandrasiri"),
            subtitle: Text("Lead Programmer | CTO")),
        ListTile(
            leading: Image.asset("images/credits/deepana.png"),
            title: Text("Deepana Ishtaweera"),
            subtitle: Text("CTO")),
        ListTile(
            leading: Image.asset("images/credits/ruchin.png"),
            title: Text("Ruchin Amarathunga"),
            subtitle: Text("COO")),
        ListTile(
            leading: Image.asset("images/credits/dinith.png"),
            title: Text("Dinith Subasinshana Herath"),
            subtitle: Text("Product Manager")),
        ListTile(
            leading: Image.asset("images/credits/uvindu.jpg"),
            title: Text("Uvindu Avishka"),
            subtitle: Text("Head of Marketing")),
        ListTile(
            leading: Image.asset("images/credits/ravikula.png"),
            title: Text("Ravikula Silva"),
            subtitle: Text("Head of Creative Design")),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
