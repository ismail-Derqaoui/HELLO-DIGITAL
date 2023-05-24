class RouteArgument {
  String id;
  String heroTag;
  dynamic param;

  RouteArgument({this.id, this.heroTag, this.param, String filter});

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}
