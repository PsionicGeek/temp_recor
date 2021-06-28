import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
const Color themeColor=  Color(0xFF2196F3) ;
ThemeData themeData= ThemeData(
  primarySwatch:Colors.blue ,
);