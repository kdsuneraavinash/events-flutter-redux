import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;

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
        _buildCreditsTile("100013401603485", "K. D. Sunera Avinash Chandrasiri",
            "Lead Programmer | CTO"),
        _buildCreditsTile("100005312113806", "Deepana Ishtaweera", "CEO"),
        _buildCreditsTile("100002491783271", "Ruchin Amarathunga", "COO"),
        _buildCreditsTile(
            "100001810054702", "Dinith Subasinshana Herath", "Product Manager"),
        _buildCreditsTile(
            "100013403053394", "Uvindu Avishka", "Head of Marketing"),
        _buildCreditsTile(
            "100003695970038", "Ravikula Silva", "Head of Creative Design"),
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

  Widget _buildCreditsTile(String facebookID, String title, String subtitle) {
    return ListTile(
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl:
              "https://graph.facebook.com/$facebookID/picture?type=large",
          fit: BoxFit.cover,
          width: 50.0,
          height: 50.0,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
