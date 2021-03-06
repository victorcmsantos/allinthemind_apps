import 'package:allinthemind/pages/register_page.dart';
import 'package:allinthemind/utils/as_admin/list_users.dart';
import 'package:allinthemind/utils/as_admin/list_users_api.dart';
import 'package:allinthemind/utils/login/user.dart';
import 'package:allinthemind/utils/nav.dart';
import 'package:allinthemind/widgets/app_menu_bar.dart';
import 'package:allinthemind/widgets/app_button.dart';
import 'package:allinthemind/widgets/lateral_menu.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    Future<User> future = User.get();
    return Scaffold(
      appBar: AppBarWidget(appBar: AppBar()),
      drawer: LateralMenu(),
      body: _body(),
    );
  }

  _body() {
    Future<List<ListUsers>> users = ListUsersApi.getUsers();

    return FutureBuilder(
      future: users,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Nao foi possivel conectar ao servidor",
              style: TextStyle(
                color: Colors.red,
                fontSize: 22,
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<ListUsers> users = snapshot.data;
        return _realbody(users);
      },
    );
  }

  Container _realbody(List<ListUsers> users) {
    return Container(
      //      height: 400,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: AppButton(
              "Registrar Tutor",
              onPressed_f: () => push(context, RegisterPage(), replace: true),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users != null ? users.length : 0,
              itemBuilder: (context, index) {
                ListUsers c = users[index];

                return Card(
                  color: Colors.grey[200],
                  child: Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(c.username),
                        Text(c.email),
                        Text(c.roles.toString()),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
