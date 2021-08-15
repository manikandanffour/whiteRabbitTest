import 'package:codetest/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(SplashScreen());
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreenful(title: 'Details'),
    );
  }
}

class SplashScreenful extends StatefulWidget {
  SplashScreenful(
      {Key key,
      this.title,
      this.name,
      this.website,
      this.username,
      this.phone,
      this.email,
      this.address,
      this.companyDetails,
      this.image})
      : super(key: key);

  final String title;
  final String image;
  final String name;
  final String username;
  final String email;
  final String address;
  final String phone;
  final String website;
  final String companyDetails;

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreenful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(actions: [
       new InkWell(child:  new Container(
         child: new Text("back"),
       ),
       onTap: (){
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => MyApp()),
         );
       },
       ),
      ],),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              //width: 100,
              child: new Image.network(widget.image??'http://www.google.de/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'),
            ),
            new Container(
              child: Text(widget.companyDetails??"Empty"),
              // width: double.infinity,
              // height: appConfig.rH(35),
            ),
            new Container(
              child: Text(widget.address??"Empty"),
              // width: double.infinity,
              // height: appConfig.rH(35),
            ),
            new Container(
              child: Text(widget.email??"Empty"),
              // width: double.infinity,
              // height: appConfig.rH(35),
            ),
            new Container(
              child: Text(widget.phone??"Empty"),
              // width: double.infinity,
              // height: appConfig.rH(35),
            ),
            new Container(
              child: Text(widget.username??"Empty"),
              // width: double.infinity,
              // height: appConfig.rH(35),
            ),
            new Container(
              child: Text(widget.website??"Empty"),
              // width: double.infinity,
              // height: appConfig.rH(35),
            ),
            new Container(
              child: Text(widget.image.toString()??"Empty"),
              // width: double.infinity,
              // height: appConfig.rH(35),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {

    print(widget.image.toString());
//
  }
}
