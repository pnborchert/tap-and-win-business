import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:tw_business_app/screen/home/profile/dashboard.dart';
import 'package:tw_business_app/screen/home/profile/profile_widget.dart';
import 'package:tw_business_app/screen/home/twpage.dart';

final TWPage pageProfile = new TWPage(
  title: Text("Profile", style: TextStyle(color: Colors.black)),
  content: TabBarView(children: [
    // first tab
    UserProfilePage(),
    // second tab
    DashboardPage(),
  ]),
  bottom: TabBar(
    tabs: [
      Tab(
        icon: Icon(Icons.person),
        child: Text("Profile"),
      ),
      Tab(
        icon: Icon(Icons.trending_up),
        child: Text("Dashboard"),
      ),
    ],
  ),
  tabs: 2,
);
