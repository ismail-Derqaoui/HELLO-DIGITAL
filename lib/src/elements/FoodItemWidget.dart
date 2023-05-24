import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../controllers/food_controller.dart';
import '../helpers/helper.dart';
import '../models/food.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';
import 'AddToCartAlertDialog.dart';

class FoodItemWidget extends StatefulWidget {
  final String heroTag;
  final Food food;
  final FoodController foodController;
  final VoidCallback onCartChanged;
  const FoodItemWidget({
    Key key,
    @required this.heroTag,
    @required this.food,
    @required this.foodController,
    this.onCartChanged,
  }) : super(key: key);

  @override
  _FoodItemWidgetState createState() => _FoodItemWidgetState();
}

class _FoodItemWidgetState extends State<FoodItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed(
          '/Food',
          arguments: RouteArgument(id: widget.food.id, heroTag: widget.heroTag),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: widget.heroTag + widget.food.id,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  imageUrl: widget.food.image.thumb,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.food.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        /* Row(
                          children: Helper.getStarsList(food.getRate()),
                        ), */
                        Text(
                          widget.food.extras
                              .map((e) => e.name)
                              .toList()
                              .join(', '),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Helper.getPrice(
                        widget.food.price,
                        context,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      widget.food.discountPrice > 0
                          ? Helper.getPrice(
                              widget.food.discountPrice,
                              context,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .merge(TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  )),
                            )
                          : SizedBox(height: 0),
                    ],
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 25,
                    height: 30,
                    child: Container(
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            if (currentUser.value.apiToken == null) {
                              Navigator.of(context).pushNamed("/Login");
                            } else {
                              if (widget.foodController
                                  .isSameRestaurants(widget.food)) {
                                widget.foodController.addToCart(widget.food);
                                widget.onCartChanged();
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AddToCartAlertDialogWidget(
                                      oldFood: widget.foodController.carts
                                          .elementAt(0)
                                          ?.food,
                                      newFood: widget.food,
                                      onPressed: (food, {reset: true}) {
                                        return widget.foodController.addToCart(
                                          food,
                                          reset: true,
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                            }
                          },
                          icon: Icon(Icons.add),
                          color: Theme.of(context).accentColor,
                          iconSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
