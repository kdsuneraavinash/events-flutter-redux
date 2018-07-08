import 'package:flutter/material.dart';

/// Credits Page Scaffold
class Credits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credits"),
      ),
      body: CreditsBody(),
    );
  }
}

/// Credits Page Content
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
            leading: Image.asset("images/credits/sunera.png",
                width: 50.0, fit: BoxFit.fitWidth),
            title: Text("K. D. Sunera Avinash Chandrasiri"),
            subtitle: Text("Lead Programmer | CTO")),
        ListTile(
            leading: Image.asset("images/credits/deepana.png",
                width: 50.0, fit: BoxFit.fitWidth),
            title: Text("Deepana Ishtaweera"),
            subtitle: Text("CEO")),
        ListTile(
          leading: Image.asset("images/credits/ruchin.png",
              width: 50.0, fit: BoxFit.fitWidth),
          title: Text("Ruchin Amarathunga"),
          subtitle: Text("COO"),
        ),
        ListTile(
          leading: Image.asset("images/credits/dinith.png",
              width: 50.0, fit: BoxFit.fitWidth),
          title: Text("Dinith Subasinshana Herath"),
          subtitle: Text("Product Manager"),
        ),
        ListTile(
          leading: Image.asset("images/credits/uvindu.jpg",
              width: 50.0, fit: BoxFit.fitWidth),
          title: Text("Uvindu Avishka"),
          subtitle: Text("Head of Marketing"),
        ),
        ListTile(
          leading: Image.asset("images/credits/ravikula.png",
              width: 50.0, fit: BoxFit.fitWidth),
          title: Text("Ravikula Silva"),
          subtitle: Text("Head of Creative Design"),
        ),
        Divider(),
        AboutListTile(
          icon: Icon(Icons.developer_board),
          applicationName: "MoraEvents",
          applicationVersion: "Prototype",
          applicationLegalese: "Team Axys",
        ),
      ],
    );
  }
}
