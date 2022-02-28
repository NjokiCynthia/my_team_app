import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/settings/user-settings/update-profile.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ViewMemberProfile extends StatefulWidget {
  final GroupMemberDetail member;
  const ViewMemberProfile({Key key, this.member}) : super(key: key);

  @override
  _ViewMemberProfileState createState() => _ViewMemberProfileState();
}

class _ViewMemberProfileState extends State<ViewMemberProfile> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  PickedFile avatar;
  final ImagePicker _picker = ImagePicker();
  // String _retrieveDataError;

  String _userAvatar;
  String name = 'Jane Doe';
  String _oldName;
  String phoneNumber = '+254 701 234 567';
  String newNumber;
  String emailAddress, _oldEmailAddress;
  final _userNameFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  bool _isLoadingImage = false;

  //  Future<void> _fetchMemberDetails(BuildContext context) async {
  //   try {
  //     await Provider.of<Groups>(context, listen: false).getGroupMembersDetails();
  //   } on CustomException catch (error) {
  //     StatusHandler().handleStatus(
  //       context: context,
  //       error: error,
  //       callback: () {
  //         _fetchMemberDetails(context);
  //       },
  //     );
  //   }
  // }

  void _scrollListener() {
    double newElevation = _scrollController.offset > 1 ? appBarElevation : 0;
    if (_appBarElevation != newElevation) {
      setState(() {
        _appBarElevation = newElevation;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupObject =
        Provider.of<Groups>(context, listen: false).getCurrentGroup();

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.close,
        title: "Member Details",
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  heading1(
                      text: "${widget.member.name}'s Profile",
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor),
                  subtitle2(
                      text: "${groupObject.groupName} Member Profile",
                      // ignore: deprecated_member_use
                      color: Theme.of(context).textSelectionHandleColor),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        _isLoadingImage
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : widget.member.avatar != null
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    child: new CachedNetworkImage(
                                      imageUrl: widget.member.avatar,
                                      placeholder: (context, url) =>
                                          const CircleAvatar(
                                        backgroundImage: const AssetImage(
                                            'assets/no-user.png'),
                                      ),
                                      imageBuilder: (context, image) =>
                                          CircleAvatar(
                                        backgroundImage: image,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                        backgroundImage: const AssetImage(
                                            'assets/no-user.png'),
                                      ),
                                      fadeOutDuration:
                                          const Duration(seconds: 1),
                                      fadeInDuration:
                                          const Duration(seconds: 3),
                                    ),
                                  )
                                : const CircleAvatar(
                                    backgroundImage:
                                        const AssetImage('assets/no-user.png'),
                                  ),
                      ],
                    ),
                  ),
                  ProfileUpdateTile(
                    labelText: "Name",
                    updateText: /* groupMembersDetails.name  */ '${widget.member.name}',
                  ),
                  ProfileUpdateTile(
                    labelText: "Phone Number",
                    updateText: /* groupMembersDetails.phone */ '${widget.member.phone}',
                  ),
                  ProfileUpdateTile(
                    labelText: "Email Address",
                    updateText: /* groupMembersDetails.email */ '${widget.member.email}',
                  ),
                  ProfileUpdateTile(
                    labelText: "Last Seen",
                    updateText: /* groupMembersDetails.lastSeen */ '${widget.member.lastSeen}',
                  ),
                  ProfileUpdateTile(
                    labelText: "Total Contributions",
                    updateText: /* groupMembersDetails.contributions.toString() */ '${groupObject.groupCurrency} ${currencyFormat.format(widget.member.contributions)}',
                  ),
                  ProfileUpdateTile(
                    labelText: "Contribution Arrears",
                    updateText:
                        /* groupMembersDetails.contributionArrears.toString() */ '${groupObject.groupCurrency} ${currencyFormat.format(widget.member.contributionArrears)}',
                  ),
                  ProfileUpdateTile(
                    labelText: "Total Fines",
                    updateText: /* groupMembersDetails.fines.toString() */ '${groupObject.groupCurrency} ${currencyFormat.format(widget.member.fines)}',
                  ),
                  ProfileUpdateTile(
                    labelText: "Fines Arrears",
                    updateText: /* groupMembersDetails.fineArrears.toString() */ '${groupObject.groupCurrency} ${currencyFormat.format(widget.member.fineArrears)}',
                  ),
                  ProfileUpdateTile(
                    labelText: "Loan Balance",
                    updateText: /* groupMembersDetails.loanBalance.toString() */ '${groupObject.groupCurrency} ${currencyFormat.format(widget.member.loanBalance)}',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
