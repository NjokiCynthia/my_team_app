import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/utilities/common.dart';
import 'package:chamasoft/utilities/custom-helper.dart';
import 'package:chamasoft/utilities/status-handler.dart';
import 'package:chamasoft/utilities/theme.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

import 'group-setup/add-members-manually.dart';
import 'group-setup/list-contacts.dart';
import '../../../widgets/memberListItem.dart';

class ListMembers extends StatefulWidget {
  @override
  _ListMembersState createState() => _ListMembersState();
}

class _ListMembersState extends State<ListMembers> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void _showActions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Material(
                  color: Theme.of(context).backgroundColor,
                  child: InkWell(
                    splashColor: Colors.blueGrey.withOpacity(0.2),
                    onTap: () async {
                      final result = await Navigator.of(context)
                          .pushNamed(ListContacts.namedRoute);
                      Navigator.pop(context); // pop bottom sheet
                      if (result != null && result) {
                        _refreshIndicatorKey.currentState.show();
                        _fetchMembers(context);
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.group_add,
                        color: Colors.blueGrey,
                      ),
                      title: customTitle(
                          text: "Select From Contacts",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
                    ),
                  ),
                ),
                Material(
                  color: Theme.of(context).backgroundColor,
                  child: InkWell(
                    splashColor: Colors.blueGrey.withOpacity(0.2),
                    onTap: () async {
                      final result = await Navigator.of(context)
                          .pushNamed(AddMembersManually.namedRoute);
                      Navigator.pop(context); // pop bottom sheet
                      if (result != null && result) {
                        _refreshIndicatorKey.currentState.show();
                        _fetchMembers(context);
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.person_add,
                        color: Colors.blueGrey,
                      ),
                      title: customTitle(
                          text: "Add Manually",
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textSelectionHandleColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchMembers(BuildContext context) async {
    try {
      await Provider.of<Groups>(context, listen: false).fetchMembers();
    } on CustomException catch (error) {
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchMembers(context);
          });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        leadingIcon: LineAwesomeIcons.arrow_left,
        title: "Members",
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
        onPressed: () => _showActions(context),
      ),
      body:

          // RefreshIndicator(
          //   onRefresh: () => _fetchMembers(context),
          //   child: FutureBuilder(
          //     future: _fetchMembers(context),
          //     builder: (ctx, dataSnapshot) {
          //       if (dataSnapshot.connectionState == ConnectionState.waiting) {
          //         return Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       } else if (dataSnapshot.error != null) {
          //         //do error handling
          //         return Center(
          //           child: Text("Some error occurred"),
          //         );
          //       } else {
          //         return Container(
          //           height: MediaQuery.of(context).size.height,
          //           width: MediaQuery.of(context).size.width,
          //           decoration: primaryGradient(context),
          //           child: Consumer<Groups>(builder: (context, groupData, child) {
          //             return Expanded(
          //               child: ListView.builder(
          //                 itemBuilder: (context, index) {
          //                   Member member = groupData.members[index];
          //                   return CartItem(
          //                     id: member.id,
          //                     title:  member.name,
          //                     quantity: 2,
          //                     price: 20.00,
          //                     productId: member.userId,
          //                   );
          //                 },
          //                 itemCount: groupData.members.length,
          //               )
          //             );
          //           }),
          //         );
          //         // return Consumer<Orders>(
          //         //     builder: (ctx, orderData, child) => ListView.builder(
          //         //           itemCount: orderData.orders.length,
          //         //           itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
          //         //         ));
          //       }
          //     },
          //   ),
          // ),

          Builder(
        builder: (BuildContext context) {
          return RefreshIndicator(
            backgroundColor: (themeChangeProvider.darkTheme)
                ? Colors.blueGrey[800]
                : Colors.white,
            key: _refreshIndicatorKey,
            onRefresh: () => _fetchMembers(context),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: primaryGradient(context),
                child: Consumer<Groups>(builder: (context, groupData, child) {
                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: 100.0, top: 10.0),
                    itemCount: groupData.members.length,
                    itemBuilder: (context, index) {
                      Member member = groupData.members[index];
                      return ListTile(
                        dense: true,
                        leading: member.avatar != null
                            ? Container(
                                height: 50,
                                width: 50,
                                child: new CachedNetworkImage(
                                  imageUrl: member.avatar,
                                  placeholder: (context, url) =>
                                      const CircleAvatar(
                                    backgroundImage:
                                        const AssetImage('assets/no-user.png'),
                                  ),
                                  imageBuilder: (context, image) =>
                                      CircleAvatar(
                                    backgroundImage: image,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    backgroundImage:
                                        const AssetImage('assets/no-user.png'),
                                  ),
                                  fadeOutDuration: const Duration(seconds: 1),
                                  fadeInDuration: const Duration(seconds: 3),
                                ),
                              )
                            : const CircleAvatar(
                                backgroundImage:
                                    const AssetImage('assets/no-user.png'),
                              ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        customTitle(
                                          text: '${member.name}',
                                          color: Theme.of(context)
                                              .textSelectionHandleColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                customTitle(
                                                  text: '${member.identity}',
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(context)
                                                      .textSelectionHandleColor
                                                      .withOpacity(0.7),
                                                  fontSize: 12.0,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
//                  trailing: Padding(
//                    padding: EdgeInsets.all(10.0),
//                    child: circleIconButton(
//                      icon: Icons.close,
//                      backgroundColor: Colors.redAccent.withOpacity(.3),
//                      color: Colors.red,
//                      iconSize: 12.0,
//                      padding: 0.0,
//                      onPressed: () {
//                        // TODO: Implement Delete Method
//                      },
//                    ),
//                  ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Theme.of(context).dividerColor,
                        height: 6.0,
                      );
                    },
                  );
                })),
          );
        },
      ),
    );
  }
}
