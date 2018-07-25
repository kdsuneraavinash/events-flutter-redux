import 'package:flutter/material.dart';

/**
 * MoraEvents App
 * ==============
 * 
 * Project MoraEvents
 * 
 * Programmed By K. D. Sunera Avinash Chandrasiri
 * kdsuneraavinash@gmail.com
 * (c) 2018
 * 
 * On behalf of teamaxys
 * University of Moratuwa
 */

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
        _buildCreditsTile("images/credits/sunera.png",
            "K. D. Sunera Avinash Chandrasiri", "Lead Programmer | CTO"),
        _buildCreditsTile(
            "images/credits/deepana.png", "Deepana Ishtaweera", "CEO"),
        _buildCreditsTile("images/credits/ruchin.png",
            "K. D. Sunera Avinash Chandrasiri", "Lead Programmer | CTO"),
        _buildCreditsTile("images/credits/dinith.png",
            "Dinith Subasinshana Herath", "Product Manager"),
        _buildCreditsTile("images/credits/uvindu.jpg", "Uvindu Avishka",
            "LHead of Marketing"),
        _buildCreditsTile("images/credits/ravikula.png", "Ravikula Silva",
            "Head of Creative Design"),
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

  Widget _buildCreditsTile(String image, String title, String subtitle) {
    return ListTile(
      leading: ClipOval(
        child: Image.asset(image, width: 50.0, fit: BoxFit.fitWidth),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
