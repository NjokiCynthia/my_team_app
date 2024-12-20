import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ViewMemberProfile extends StatefulWidget {
  final GroupMemberDetail /* Member */ member;
  const ViewMemberProfile({Key key, this.member}) : super(key: key);

  @override
  _ViewMemberProfileState createState() => _ViewMemberProfileState();
}

class _ViewMemberProfileState extends State<ViewMemberProfile> {
  double _appBarElevation = 0;
  ScrollController _scrollController;
  PickedFile avatar;
  // String _retrieveDataError;

  String name = 'Jane Doe';
  String phoneNumber = '+254 701 234 567';
  String newNumber;
  String emailAddress;
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
    String currentLanguage =
        Provider.of<TranslationProvider>(context, listen: false)
            .currentLanguage;

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        elevation: _appBarElevation,
        leadingIcon: LineAwesomeIcons.times,
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
                     
                      color: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor),
                  subtitle2(
                      text: "${groupObject.groupName} Member Profile",
                     
                      color: Theme.of(context)
                          .textSelectionTheme
                          .selectionHandleColor),
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
                  ListTile(
                    title: customTitle(
                        text: "Name",
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                    subtitle: customTitle(
                        text: widget.member.name,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                  ),
                  ListTile(
                    title: customTitle(
                        text: "Phone Number",
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                    subtitle: customTitle(
                        text: widget.member.phone,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                  ),
                  ListTile(
                    title: customTitle(
                        text: "Email Address",
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                    subtitle: customTitle(
                        text: widget.member.email,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                  ),
                  ListTile(
                    title: customTitle(
                        text: "Last Seen",
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                    subtitle: customTitle(
                        text: widget.member.lastSeen,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                  ),
                  ListTile(
                    title: customTitle(
                        text: currentLanguage == 'English'
                            ? "Total Contributions"
                            : Provider.of<TranslationProvider>(context,
                                        listen: false)
                                    .translate("Total Contributions") ??
                                "Total Contributions",
                        //"Total Contributions",
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                    subtitle: customTitle(
                        text:
                            '${groupObject.groupCurrency} ${currencyFormat.format(widget.member.contributions)}',
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                  ),
                  ListTile(
                    title: customTitle(
                        text: "Contribution Arrears",
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                    subtitle: customTitle(
                        text:
                            '${groupObject.groupCurrency} ${currencyFormat.format(widget.member.contributionArrears)}',
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                  ),
                  ListTile(
                    title: customTitle(
                        text: currentLanguage == 'English'
                            ? "Total Fines"
                            : Provider.of<TranslationProvider>(context,
                                        listen: false)
                                    .translate("Total Fines") ??
                                "Total Fines",
                        //"Total Fines",
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                    subtitle: customTitle(
                        text:
                            '${groupObject.groupCurrency} ${currencyFormat.format(widget.member.fines)}',
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                  ),
                  ListTile(
                    title: customTitle(
                        text: "Fines Arrears",
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                    subtitle: customTitle(
                        text:
                            '${groupObject.groupCurrency} ${currencyFormat.format(widget.member.fineArrears)}',
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                  ),
                  ListTile(
                    title: customTitle(
                        text: "Loan Balance",
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
                    subtitle: customTitle(
                        text:
                            '${groupObject.groupCurrency} ${currencyFormat.format(widget.member.loanBalance)}',
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start,
                       
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionHandleColor),
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
