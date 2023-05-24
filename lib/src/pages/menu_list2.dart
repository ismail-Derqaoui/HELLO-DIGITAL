import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/FoodItemWidget.dart';
import '../elements/FoodsCarouselWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';

class MenuWidget2 extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MenuWidget2({Key key, this.parentScaffoldKey, this.routeArgument})
      : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget2> {
  RestaurantController _con;
  List<String> selectedCategories;

  _MenuWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.restaurant = widget.routeArgument.param as Restaurant;
    _con.listenForTrendingFoods(_con.restaurant.id);
    _con.listenForCategories(_con.restaurant.id);
    selectedCategories = ['0'];
    _con.listenForFoods(_con.restaurant.id);
    super.initState();
    /* _con.listenForFoods2("1", "1"); */
  }

  void _onCategorySelected(String categoryId) {
    Navigator.of(context).pushNamed(
      '/FoodItems',
      arguments: RouteArgument(
        id: categoryId,
        param: _con.restaurant,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        drawer: DrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon:
                new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pushNamed('/Details',
                arguments: RouteArgument(
                    id: '0', param: _con.restaurant.id, heroTag: 'menu_tab')),
          ),
          title: Text(
            _con.restaurant?.name ?? '',
            overflow: TextOverflow.fade,
            softWrap: false,
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 0)),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).accentColor),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarWidget(),
              ),
              ListTile(
                dense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: Icon(
                  Icons.subject,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  S.of(context).all_categories,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(
                  S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              _con.categories.isEmpty
                  ? SizedBox(height: 90)
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: _con.categories.length,
                        itemBuilder: (context, index) {
                          var _category = _con.categories.elementAt(index);
                          var _selected =
                              this.selectedCategories.contains(_category.id);
                          return InkWell(
                            onTap: () {
                              setState(() {
                                this.selectedCategories.clear();
                                this.selectedCategories.add(_category.id);
                                _con.selectCategory(this.selectedCategories);
                              });
                              _onCategorySelected(_category.id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _selected
                                    ? Theme.of(context).accentColor
                                    : null,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: _selected
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _selected
                                        ? Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.4)
                                        : Colors.transparent,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  (_category.id == '0')
                                      ? Icon(
                                          Icons.apps,
                                          size: 30,
                                          color: _selected
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context).accentColor,
                                        )
                                      : (_category.image.url
                                              .toLowerCase()
                                              .endsWith('.svg')
                                          ? SvgPicture.network(
                                              _category.image.url,
                                              color: _selected
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .accentColor,
                                            )
                                          : CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: _category.image.icon,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                'assets/img/loading.gif',
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              height: 100,
                                              width: 100,
                                            )),
                                  SizedBox(height: 5),
                                  Text(
                                    _category.name,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .merge(
                                          TextStyle(
                                            color: _selected
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context).accentColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ));
  }
}
