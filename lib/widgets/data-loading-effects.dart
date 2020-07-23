import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'backgrounds.dart';

Widget dataLoadingEffect(
    {BuildContext context,
    double width,
    double height,
    double borderRadius = 16.0}) {
  return SizedBox(
    child: Shimmer.fromColors(
      baseColor: Theme.of(context).hintColor.withOpacity(0.1),
      highlightColor: Theme.of(context).hintColor.withOpacity(0.25),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: Theme.of(context).backgroundColor,
        ),
      ),
    ),
  );
}

Widget chamasoftHomeLoadingData({BuildContext context}) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: cardDecoration(
              gradient: plainCardGradient(context), context: context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  dataLoadingEffect(
                      context: context,
                      width: 200,
                      height: 20,
                      borderRadius: 16.0)
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Divider(
                color: Theme.of(context).hintColor.withOpacity(0.1),
                thickness: 2.0,
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                      context: context,
                      width: 120,
                      height: 20,
                      borderRadius: 16.0),
                  dataLoadingEffect(
                      context: context,
                      width: 80,
                      height: 20,
                      borderRadius: 16.0),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                      context: context,
                      width: 80,
                      height: 16,
                      borderRadius: 16.0),
                  dataLoadingEffect(
                      context: context,
                      width: 100,
                      height: 16,
                      borderRadius: 16.0),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                      context: context,
                      width: 50,
                      height: 16,
                      borderRadius: 16.0),
                  dataLoadingEffect(
                      context: context,
                      width: 80,
                      height: 16,
                      borderRadius: 16.0),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(
                      context: context,
                      width: 140,
                      height: 16,
                      borderRadius: 16.0),
                  dataLoadingEffect(
                      context: context,
                      width: 100,
                      height: 16,
                      borderRadius: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(20.0, 6.0, 16.0, 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(context: context, width: 160, height: 20, borderRadius: 16.0)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(context: context, width: 60, height: 20, borderRadius: 16.0)
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: Container(
          padding: EdgeInsets.only(left:16.0,top:10.0,bottom: 10.0,right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              dataLoadingEffect(context: context, width: 140, height: 16, borderRadius: 16.0),
              dataLoadingEffect(context: context, width: 40, height: 16, borderRadius: 16.0),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: Container(
          height: 180.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                width: 16.0,
              ),
              Container(
                width: 160.0,
                padding: EdgeInsets.all(16.0),
                decoration: cardDecoration(
                    gradient: plainCardGradient(context), context: context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            dataLoadingEffect(
                                context: context,
                                width: 20,
                                height: 20,
                                borderRadius: 16.0)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    dataLoadingEffect(
                                        context: context,
                                        width: 90,
                                        height: 20,
                                        borderRadius: 16.0)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    Row(
                      children: <Widget>[
                        dataLoadingEffect(
                            context: context,
                            width: 90,
                            height: 20,
                            borderRadius: 16.0)
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 60,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 100,
                                    height: 20,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 50,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 26.0,
              ),
              Container(
                width: 160.0,
                padding: EdgeInsets.all(16.0),
                decoration: cardDecoration(
                    gradient: plainCardGradient(context), context: context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            dataLoadingEffect(
                                context: context,
                                width: 20,
                                height: 20,
                                borderRadius: 16.0)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    dataLoadingEffect(
                                        context: context,
                                        width: 90,
                                        height: 20,
                                        borderRadius: 16.0)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    Row(
                      children: <Widget>[
                        dataLoadingEffect(
                            context: context,
                            width: 90,
                            height: 20,
                            borderRadius: 16.0)
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 60,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 100,
                                    height: 20,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 50,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 26.0,
              ),
              Container(
                width: 160.0,
                padding: EdgeInsets.all(16.0),
                decoration: cardDecoration(
                    gradient: plainCardGradient(context), context: context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            dataLoadingEffect(
                                context: context,
                                width: 20,
                                height: 20,
                                borderRadius: 16.0)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    dataLoadingEffect(
                                        context: context,
                                        width: 90,
                                        height: 20,
                                        borderRadius: 16.0)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    Row(
                      children: <Widget>[
                        dataLoadingEffect(
                            context: context,
                            width: 90,
                            height: 20,
                            borderRadius: 16.0)
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 60,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 100,
                                    height: 20,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 50,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          color: Theme.of(context).cardColor.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      dataLoadingEffect(
                          context: context,
                          width: 190,
                          height: 42,
                          borderRadius: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(
                    context: context,
                    width: 160,
                    height: 20,
                    borderRadius: 16.0)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(
                    context: context, width: 60, height: 20, borderRadius: 16.0)
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: Container(
          height: 180.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                width: 16.0,
              ),
              Container(
                width: 160.0,
                padding: EdgeInsets.all(16.0),
                decoration: cardDecoration(
                    gradient: plainCardGradient(context), context: context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            dataLoadingEffect(
                                context: context,
                                width: 20,
                                height: 20,
                                borderRadius: 16.0)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    dataLoadingEffect(
                                        context: context,
                                        width: 90,
                                        height: 20,
                                        borderRadius: 16.0)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    Row(
                      children: <Widget>[
                        dataLoadingEffect(
                            context: context,
                            width: 90,
                            height: 20,
                            borderRadius: 16.0)
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 60,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 100,
                                    height: 20,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 50,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 26.0,
              ),
              Container(
                width: 160.0,
                padding: EdgeInsets.all(16.0),
                decoration: cardDecoration(
                    gradient: plainCardGradient(context), context: context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            dataLoadingEffect(
                                context: context,
                                width: 20,
                                height: 20,
                                borderRadius: 16.0)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    dataLoadingEffect(
                                        context: context,
                                        width: 90,
                                        height: 20,
                                        borderRadius: 16.0)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    Row(
                      children: <Widget>[
                        dataLoadingEffect(
                            context: context,
                            width: 90,
                            height: 20,
                            borderRadius: 16.0)
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 60,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 100,
                                    height: 20,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 50,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 26.0,
              ),
              Container(
                width: 160.0,
                padding: EdgeInsets.all(16.0),
                decoration: cardDecoration(
                    gradient: plainCardGradient(context), context: context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            dataLoadingEffect(
                                context: context,
                                width: 20,
                                height: 20,
                                borderRadius: 16.0)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    dataLoadingEffect(
                                        context: context,
                                        width: 90,
                                        height: 20,
                                        borderRadius: 16.0)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    Row(
                      children: <Widget>[
                        dataLoadingEffect(
                            context: context,
                            width: 90,
                            height: 20,
                            borderRadius: 16.0)
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 60,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 100,
                                    height: 20,
                                    borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(
                                    context: context,
                                    width: 50,
                                    height: 12,
                                    borderRadius: 16.0)
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget chamasoftGroupLoadingData({BuildContext context}) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  dataLoadingEffect(context: context, width: 200, height: 20, borderRadius: 16.0)
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Divider(
                color: Theme.of(context).hintColor.withOpacity(0.1),
                thickness: 2.0,
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(context: context, width: 120, height: 20, borderRadius: 16.0),
                  dataLoadingEffect(context: context, width: 80, height: 20, borderRadius: 16.0),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(context: context, width: 80, height: 16, borderRadius: 16.0),
                  dataLoadingEffect(context: context, width: 100, height: 16, borderRadius: 16.0),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(context: context, width: 50, height: 16, borderRadius: 16.0),
                  dataLoadingEffect(context: context, width: 80, height: 16, borderRadius: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(20.0, 6.0, 16.0, 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(context: context, width: 160, height: 20, borderRadius: 16.0)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                dataLoadingEffect(context: context, width: 60, height: 20, borderRadius: 16.0)
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: Container(
          height: 180.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 5.0, bottom: 10.0),
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                width: 16.0,
              ),
              Container(
                width: 160.0,
                padding: EdgeInsets.all(16.0),
                decoration: cardDecoration(
                  gradient: plainCardGradient(context),
                  context: context
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            dataLoadingEffect(context: context, width: 20, height: 20, borderRadius: 16.0)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    dataLoadingEffect(context: context, width: 90, height: 20, borderRadius: 16.0)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    Row(
                      children: <Widget>[
                        dataLoadingEffect(context: context, width: 90, height: 20, borderRadius: 16.0)
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(context: context, width: 60, height: 12, borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(context: context, width: 100, height: 20, borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(context: context, width: 50, height: 12, borderRadius: 16.0)
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 26.0,
              ),
              Container(
                width: 160.0,
                padding: EdgeInsets.all(16.0),
                decoration: cardDecoration(
                  gradient: plainCardGradient(context),
                  context: context
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            dataLoadingEffect(context: context, width: 20, height: 20, borderRadius: 16.0)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    dataLoadingEffect(context: context, width: 90, height: 20, borderRadius: 16.0)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    Row(
                      children: <Widget>[
                        dataLoadingEffect(context: context, width: 90, height: 20, borderRadius: 16.0)
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(context: context, width: 60, height: 12, borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(context: context, width: 100, height: 20, borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(context: context, width: 50, height: 12, borderRadius: 16.0)
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 26.0,
              ),
              Container(
                width: 160.0,
                padding: EdgeInsets.all(16.0),
                decoration: cardDecoration(
                  gradient: plainCardGradient(context),
                  context: context
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            dataLoadingEffect(context: context, width: 20, height: 20, borderRadius: 16.0)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    dataLoadingEffect(context: context, width: 90, height: 20, borderRadius: 16.0)
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14.0,
                    ),
                    Row(
                      children: <Widget>[
                        dataLoadingEffect(context: context, width: 90, height: 20, borderRadius: 16.0)
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(context: context, width: 60, height: 12, borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(context: context, width: 100, height: 20, borderRadius: 16.0)
                              ],
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                dataLoadingEffect(context: context, width: 50, height: 12, borderRadius: 16.0)
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: cardDecoration(gradient: plainCardGradient(context), context: context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  dataLoadingEffect(context: context, width: 200, height: 20, borderRadius: 16.0)
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Divider(
                color: Theme.of(context).hintColor.withOpacity(0.1),
                thickness: 2.0,
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(context: context, width: 120, height: 20, borderRadius: 16.0),
                  dataLoadingEffect(context: context, width: 80, height: 20, borderRadius: 16.0),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(context: context, width: 80, height: 16, borderRadius: 16.0),
                  dataLoadingEffect(context: context, width: 100, height: 16, borderRadius: 16.0),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  dataLoadingEffect(context: context, width: 150, height: 16, borderRadius: 16.0),
                  dataLoadingEffect(context: context, width: 80, height: 16, borderRadius: 16.0),
                ],
              ),
            ],
          ),
        ),
      ),
      
    ],
  );
}
