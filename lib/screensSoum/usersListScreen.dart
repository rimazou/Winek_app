import 'package:flutter/material.dart';
import 'package:winek/dataBaseSoum.dart';
import 'package:provider/provider.dart';
import '../classes.dart';
import 'friendsList.dart';

var _controller = TextEditingController();

// ignore: must_be_immutable
class UsersListScreen extends StatefulWidget {
  static String id = 'UsersListScreen';

  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  TextEditingController controller = new TextEditingController();
  String filter;
  int count;

  @override
  // ignore: must_call_super
  initState() {
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<String>>.value(
      value: Database().users,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white30,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black54,
            ),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                ),
                Center(
                  child: Container(
                    height: 43,
                    width: 321,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color.fromRGBO(59, 70, 107, 0.3),
                          blurRadius: 7.0,
                          offset: Offset(0.0, 0.75),
                        )
                      ],
                    ),
                    child: TextField(
                      onTap: () {},
                      controller: controller,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Recherche ',
                        prefixIcon: Icon(Icons.search),
                        hintStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff707070),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff389490),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Liste utilisateurs',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  height: 450.0,
                  width: 350.0,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFD0D8E2),
                  ),
                  child: UsersList(filter),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
