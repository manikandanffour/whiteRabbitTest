import 'dart:convert';

import 'package:codetest/DatabaseHandler.dart';
import 'package:codetest/detailspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import 'API.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var users = new List<ResponseModel>();
  DatabaseHandler handler;

  _getUsers() {
    API.getUsers().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) => ResponseModel.fromJson(model)).toList();
      });
      this.handler = DatabaseHandler();
      this.handler.initializeDB().whenComplete(() async {
        await this.addUsers(users);
        setState(() {});
      });
    });
  }
  Widget appBarTitle = new Text(
    "Search Example",
    style: new TextStyle(color: Colors.white),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  List<dynamic> _list;
  bool _isSearching;
  String _searchText = "";
  List searchresult = new List();

  _SearchListExampleState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }
  initState() {
    super.initState();
    _getUsers();
    _isSearching = false;
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User List"),
      ),
      // body: ListView.builder(
      //   itemCount: users.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(title: Text(users[index]?.phone ?? "null"));
      //   },
      // ),

      body: FutureBuilder(
        future: this.retrieveUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<DbUser>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return
                    Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SplashScreenful(
                                  address: snapshot.data[index]?.Address,
                                  companyDetails:
                                      snapshot.data[index]?.CompanyDetails,
                                  email: snapshot.data[index]?.Email,
                                  image: snapshot.data[index]?.ProfileImage,
                                  name: snapshot.data[index]?.Name,
                                  phone: snapshot.data[index]?.Phone,
                                  username: snapshot.data[index]?.UserName,
                                  website: snapshot.data[index]?.WebSite,
                                )),
                      );
                    },
                    contentPadding: EdgeInsets.all(8.0),leading: new Container(
                    width: 100,
                    child: new Image.network(snapshot.data[index].ProfileImage??'http://www.google.de/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'),
                  ),
                    title: Text(snapshot.data[index]?.Name),
                    subtitle:
                        Text(snapshot.data[index]?.CompanyDetails.toString()),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
  Widget buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
              //  onChanged: searchOperation,
              );
             // _handleSearchStart();
            } else {
             // _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }
  Future<int> insertUser(List<DbUser> users) async {
    int result = 0;
    final Database db = await handler.initializeDB();
    for (var user in users) {
      result = await db.insert('users', user.toMap());
      print(result);
    }
    return result;
  }

  Future<List<DbUser>> retrieveUsers() async {
    final Database db = await handler.initializeDB();
    //print()
    final List<Map<String, Object>> queryResult = await db.query('users');
    return queryResult.map((e) => DbUser.fromMap(e)).toList();
  }

  Future<int> addUsers(List<ResponseModel> data) async {
    DbUser firstUser;
    List<DbUser> listOfUsers = [];
    for (var i = 0; i < data.length; i++) {
      firstUser = DbUser(
          Address: data[i]?.address?.city?.toString() ??
              "Empty" + "," + data[i].address.street?.toString() ??
              "Empty",
          CompanyDetails: data[i].company?.name ?? "Empty",
          Email: data[i]?.email ?? "Empty",
          Name: data[i]?.name.toString() ?? "Empty",
          Phone: data[i]?.phone.toString() ?? "Empty",
          ProfileImage: data[i].profileImage.toString() ?? "Empty",
          UserName: data[i]?.username ?? "Empty",
          WebSite: data[i]?.website ?? "Empty");
      listOfUsers.add(firstUser);
      //print(firstUser.toString());
    }
    // User secondUser = User(name: "john", age: 31, country: "United Kingdom");
    print(firstUser.Name);

    print(listOfUsers[0].Name);
    return await this.insertUser(listOfUsers);
  }


}



class DbUser {
  //final int id;
  final String ProfileImage;
  final String Name;
  final String UserName;
  final String Email;
  final String Address;
  final String Phone;
  final String WebSite;
  final String CompanyDetails;

  DbUser(
      {this.ProfileImage,
      this.Name,
      this.UserName,
      this.Email,
      this.Address,
      this.Phone,
      this.WebSite,
      this.CompanyDetails});

  DbUser.fromMap(Map<String, dynamic> res)
      :
        //id = res["id"],
        ProfileImage = res["profileImage"],
        UserName = res["userName"],
        Name = res["name"],
        Email = res["email"],
        Address = res["address"],
        Phone = res["phone"],
        WebSite = res["webSite"],
        CompanyDetails = res["companyDetails"];

  Map<String, Object> toMap() {
    return {
      //  'id': id,
      'name': Name,
      'profileImage': ProfileImage,
      'userName': UserName,
      'email': Email,
      'address': Address,
      'phone': Phone,
      'website': WebSite,
      'companyDetails': CompanyDetails
    };
  }
}

// "CREATE TABLE users(profileImage TEXT NOT NULL,name TEXT NOT NULL,
// userName TEXT NOT NULL,email TEXT NOT NULL,address TEXT NOT NULL,phone TEXT NOT NULL,website TEXT NOT NULL,companyDetails TEXT NOT NULL)",
class ResponseModel {
  int id;
  String name;
  String username;
  String email;
  String profileImage;
  Address address;
  String phone;
  String website;
  Company company;

  ResponseModel(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.profileImage,
      this.address,
      this.phone,
      this.website,
      this.company});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    profileImage = json['profile_image'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    phone = json['phone'];
    website = json['website'];
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['profile_image'] = this.profileImage;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    data['phone'] = this.phone;
    data['website'] = this.website;
    if (this.company != null) {
      data['company'] = this.company.toJson();
    }
    return data;
  }
}

class Address {
  String street;
  String suite;
  String city;
  String zipcode;
  Geo geo;

  Address({this.street, this.suite, this.city, this.zipcode, this.geo});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    suite = json['suite'];
    city = json['city'];
    zipcode = json['zipcode'];
    geo = json['geo'] != null ? new Geo.fromJson(json['geo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['suite'] = this.suite;
    data['city'] = this.city;
    data['zipcode'] = this.zipcode;
    if (this.geo != null) {
      data['geo'] = this.geo.toJson();
    }
    return data;
  }
}

class Geo {
  String lat;
  String lng;

  Geo({this.lat, this.lng});

  Geo.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Company {
  String name;
  String catchPhrase;
  String bs;

  Company({this.name, this.catchPhrase, this.bs});

  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    catchPhrase = json['catchPhrase'];
    bs = json['bs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['catchPhrase'] = this.catchPhrase;
    data['bs'] = this.bs;
    return data;
  }
}
