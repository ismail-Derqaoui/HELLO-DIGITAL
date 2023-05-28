import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final User user;

  ProfileAvatarWidget({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
//              SizedBox(
//                width: 50,
//                height: 50,
//                child: MaterialButton(
                //elevation: 0,
                //focusElevation: 0,
                //highlightElevation: 0,
//                  padding: EdgeInsets.all(0),
//                  onPressed: () {},
//                  child: Icon(Icons.add, color: Theme.of(context).primaryColor),
//                  color: Theme.of(context).accentColor,
//                  shape: StadiumBorder(),
//                ),
//              ),
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).accentColor,
                    size: 80,
                  ),
                ),
//              SizedBox(
//                width: 50,
//                height: 50,
//                child: MaterialButton(
                //elevation: 0,
                //focusElevation: 0,
                //highlightElevation: 0,
//                  padding: EdgeInsets.all(0),
//                  onPressed: () {},
//                  child: Icon(Icons.chat, color: Theme.of(context).primaryColor),
//                  color: Theme.of(context).accentColor,
//                  shape: StadiumBorder(),
//                ),
//              ),
              ],
            ),
          ),
          Text(
            user.name,
            style: Theme.of(context)
                .textTheme
                .headline5
                .merge(TextStyle(color: Theme.of(context).primaryColor)),
          ),
          if (user.address != null)
            Text(
              user.address,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          if (user.address == null)
            Text(
              'No address',
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .merge(TextStyle(color: Theme.of(context).primaryColor)),
            )
        ],
      ),
    );
  }
}
