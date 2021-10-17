// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'dart:async';

import 'package:chamasoft/config.dart';
import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/screens/chamasoft/models/group-model.dart';
import 'package:chamasoft/helpers/theme.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

import 'backgrounds.dart';

class _CustomDelegate extends SingleChildLayoutDelegate {
  final Offset target;
  final double verticalOffset;

  _CustomDelegate({
    @required this.target,
    @required this.verticalOffset,
  })  : assert(target != null),
        assert(verticalOffset != null);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: true,
    );
  }

  @override
  bool shouldRelayout(_CustomDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset;
  }
}

class _CustomOverlay extends StatelessWidget {
  final Widget child;
  final Offset target;
  final double width;
  final int itemCount;

  const _CustomOverlay({
    Key key,
    this.child,
    this.target,
    this.width,
    this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = 260; //itemCount>4?330:210;
    return new Positioned.fill(
      child: new IgnorePointer(
        ignoring: false,
        child: new CustomSingleChildLayout(
          delegate: new _CustomDelegate(
            target: target,
            verticalOffset: -4.0,
          ),
          child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new Row(
              children: <Widget>[
                new Stack(
                  children: [
                    new Container(
                      width: width,
                      constraints: BoxConstraints(maxHeight: (height - 6)),
                      alignment: Alignment.topLeft,
                      color: Colors.transparent,
//                    decoration: new BoxDecoration(
//                      color: Theme.of(context).backgroundColor,
//                      boxShadow:
//                          mildShadow(Theme.of(context).unselectedWidgetColor),
//                      // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
//                    ),
                      child: child,
                    ),
                    Positioned(
                      bottom: 20.0,
                      child: Container(
                        width: width,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 16.0,
                        ),
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              Theme.of(context).backgroundColor.withOpacity(0),
                              Theme.of(context)
                                  .backgroundColor
                                  .withOpacity(0.5),
                              Theme.of(context).backgroundColor.withOpacity(1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SwitcherScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class _AppSwitcherState extends State<AppSwitcher> {
  List<dynamic> _listItems;
  OverlayState _overlay;
  OverlayEntry _entry;
  bool _entryIsVisible = false;
  StreamSubscription _sub;
  double width = 200;

  void _toggleEntry(show) {
    if (_overlay.mounted && _entry != null) {
      if (show) {
        _overlay.insert(_entry);
        setState(() {
          _entryIsVisible = true;
        });
      } else {
        _entry.remove();
        setState(() {
          _entryIsVisible = false;
        });
      }
    } else {
      setState(() {
        _entryIsVisible = false;
      });
    }
  }

  void _handleSwitch() {
    if (widget.parentStream != null && _sub == null) {
      _sub = widget.parentStream.listen(_handleStream);
    }

    if (_overlay == null) {
      final RenderBox bounds = context.findRenderObject();
      final Offset target =
          bounds.localToGlobal(bounds.size.bottomCenter(Offset.zero));

      _entry = new OverlayEntry(builder: (BuildContext context) {
        return new _CustomOverlay(
          itemCount: _listItems.length,
          target: target,
          width: width,
          child: new Material(
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      boxShadow: appSwitcherShadow(
                        Theme.of(context).unselectedWidgetColor,
                      ),
                      // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                    ),
                    child: ScrollConfiguration(
                      behavior: SwitcherScrollBehavior(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        itemBuilder: (BuildContext context, int ndx) {
                          return new Container(
                            color: (_listItems[ndx]["id"] ==
                                    widget.currentGroup["id"])
                                ? Colors.blue[200].withOpacity(0.2)
                                : Colors.transparent,
                            child: new ListTile(
                              dense: true,
                              title: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 10.0,
                                    ),
                                    child: Icon(
                                      _listItems[ndx]["id"] ==
                                              widget.currentGroup["id"]
                                          ? Feather.check
                                          : Feather.plus,
                                      color: (_listItems[ndx]["id"] ==
                                              widget.currentGroup["id"])
                                          ? primaryColor
                                          : (_listItems[ndx]["id"] !=
                                                      widget
                                                          .currentGroup["id"] &&
                                                  _listItems[ndx]["id"] != '0')
                                              ? Colors.transparent
                                              : Colors.blueGrey[300],
                                      size: 20.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _listItems[ndx]["title"]
                                              .toString()
                                              .toUpperCase(),
                                          style: TextStyle(
                                            color: (_listItems[ndx]["id"] ==
                                                        0 ||
                                                    _listItems[ndx]["id"] ==
                                                        widget
                                                            .currentGroup["id"])
                                                ? primaryColor
                                                : Colors.blueGrey[
                                                    400], //Theme.of(context).textSelectionHandleColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'SegoeUI',
                                          ),
                                          softWrap: false,
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                        ),
                                        Text(
                                          _listItems[ndx]["role"],
                                          style: TextStyle(
                                            color: (_listItems[ndx]["id"] ==
                                                        0 ||
                                                    _listItems[ndx]["id"] ==
                                                        widget
                                                            .currentGroup["id"])
                                                ? primaryColor.withOpacity(0.7)
                                                : Colors.blueGrey[
                                                    300], //Theme.of(context).indicatorColor,
                                            fontSize: 12.0,
                                            fontFamily: 'SegoeUI',
                                            //                                    fontWeight: FontWeight.w600,
                                          ),
                                          softWrap: false,
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // print('Chose: ${_listItems[ndx]["title"]}');
                                _handleSelection(_listItems[ndx]["id"], ndx);
                              },
                            ),
                          );
                        },
                        itemCount: _listItems.length,
                      ),
                    ),
                  ),
                ),
                Container(
                  // color: null,
                  decoration: BoxDecoration(
                    boxShadow: appSwitcherShadow(
                      Theme.of(context).unselectedWidgetColor,
                    ),
                    color: Theme.of(context).backgroundColor,
                    borderRadius: new BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 10.0,
                  ),
                ),
              ],
            ),
          ),
        );
      });
      _overlay = Overlay.of(context, debugRequiredFor: widget);
    }

    setState(() {
      // Can be used if the listItems get updated
      if (!_entryIsVisible && _listItems.length > 0) {
        _toggleEntry(true);
      } else if (_entryIsVisible && _listItems.length == 0) {
        _toggleEntry(false);
      } else {
        _entry.markNeedsBuild();
      }
    });
  }

  Widget groupSwitcherButton(
      {BuildContext context, String title, String role}) {
    // ignore: deprecated_member_use
    return FlatButton(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
      child: Column(
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: 320),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: Config.appName.toLowerCase() == 'chamasoft'
                              ? Colors.blueGrey[400]
                              : primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0,
                          fontFamily: 'SegoeUI',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        textAlign: TextAlign.center,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          // Icon(
                          //   Icons.beenhere,
                          //   size: 12.0,
                          // ),
                          // SizedBox(width: 4.0),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Text(
                                role, //.toUpperCase(),
                                style: TextStyle(
                                  color: Config.appName.toLowerCase() ==
                                          'chamasoft'
                                      ? Colors.blueGrey[300]
                                      : primaryColor.withOpacity(0.8),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11.0,
                                  fontFamily: 'SegoeUI',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 32.0,
                  width: 32.0,
                  margin: EdgeInsets.only(left: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: _entryIsVisible
                        ? BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0))
                        : BorderRadius.circular(40.0),
                    color: Config.appName.toLowerCase() == 'chamasoft'
                        ? Theme.of(context).hintColor.withOpacity(0.6)
                        : primaryColor.withOpacity(0.6),
                  ),
                  child: Icon(
                    Feather.users,
                    color: Colors.white70,
                    size: 18.0,
                  ),
                  // ** If group image is available, replace above child with this: **
                  // =================================================================
                  // child: Image(
                  //   image:  AssetImage('assets/no-user.png'),
                  //   height: 32.0,
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
      onPressed: () {
        setState(() {
          width = this.context.size.width;
        });
        _entryIsVisible ? _exitSwitcher() : _handleSwitch();
        // groupSwitcherDialog(widget.currentGroup["id"]);
      },
      shape: _entryIsVisible
          ? new RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                topRight: Radius.circular(19.0),
                topLeft: Radius.circular(20.0),
              ),
            )
          : new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
      textColor: primaryColor,
      color: Theme.of(context).buttonColor.withOpacity(0.9),
    );
  }

  groupSwitcherDialog(dynamic currentGroup) {
    return showGeneralDialog(
      // barrierColor: Colors.white.withOpacity(0.5),
      barrierDismissible: true,
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: AlertDialog(
            content: Container(
              height: 200,
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width - 100,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            boxShadow: appSwitcherShadow(
                              Theme.of(context).unselectedWidgetColor,
                            ),
                            // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                          ),
                          child: ScrollConfiguration(
                            behavior: SwitcherScrollBehavior(),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              itemBuilder: (BuildContext context, int ndx) {
                                return new Container(
                                  color: (_listItems[ndx]["id"] == currentGroup)
                                      ? Colors.blue[200].withOpacity(0.2)
                                      : Colors.transparent,
                                  child: new ListTile(
                                    dense: true,
                                    title: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: 10.0,
                                          ),
                                          child: Icon(
                                            _listItems[ndx]["id"] ==
                                                    currentGroup
                                                ? Feather.check
                                                : Feather.plus,
                                            color: (_listItems[ndx]["id"] ==
                                                    currentGroup)
                                                ? primaryColor
                                                : (_listItems[ndx]["id"] !=
                                                            currentGroup &&
                                                        _listItems[ndx]["id"] !=
                                                            '0')
                                                    ? Colors.transparent
                                                    : Colors.blueGrey[300],
                                            size: 20.0,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _listItems[ndx]["title"]
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: (_listItems[ndx]
                                                                  ["id"] ==
                                                              0 ||
                                                          _listItems[ndx]
                                                                  ["id"] ==
                                                              currentGroup)
                                                      ? primaryColor
                                                      : Colors.blueGrey[
                                                          400], //Theme.of(context).textSelectionHandleColor,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'SegoeUI',
                                                ),
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                              ),
                                              Text(
                                                _listItems[ndx]["role"],
                                                style: TextStyle(
                                                  color: (_listItems[ndx]
                                                                  ["id"] ==
                                                              0 ||
                                                          _listItems[ndx]
                                                                  ["id"] ==
                                                              currentGroup)
                                                      ? primaryColor
                                                          .withOpacity(0.7)
                                                      : Colors.blueGrey[
                                                          300], //Theme.of(context).indicatorColor,
                                                  fontSize: 12.0,
                                                  fontFamily: 'SegoeUI',
                                                  //                                    fontWeight: FontWeight.w600,
                                                ),
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      // print('Chose: ${_listItems[ndx]["title"]}');
                                      _handleSelection(
                                          _listItems[ndx]["id"], ndx);
                                    },
                                  ),
                                );
                              },
                              itemCount: _listItems.length,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // color: null,
                        decoration: BoxDecoration(
                          boxShadow: appSwitcherShadow(
                            Theme.of(context).unselectedWidgetColor,
                          ),
                          color: Theme.of(context).backgroundColor,
                          borderRadius: new BorderRadius.only(
                            bottomRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 400),
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return SizedBox();
      },
    );
  }

  void _exitSwitcher() {
    if (_sub != null) {
      _sub.cancel();
      _sub = null;
      // print('Removed stream listener');
    }
    _toggleEntry(false);
  }

  Future<void> _prepMeetings() async {
    dynamic group = Provider.of<Groups>(context, listen: false);
    Group _currentGroup = group.getCurrentGroup();
    if (_currentGroup.isGroupAdmin) {
      await group.fetchMembers();
      await group.fetchContributions();
      await group.fetchPayContributions();
      await group.fetchLoanTypes();
      await group.fetchAccounts();
      await group.fetchFineTypes();
      await group.fetchGroupMembersOngoingLoans();
    }
  }

  void _handleSelection(selectedOption, idx) {
    // Move the selected item to top of the list
    dynamic _selected = _listItems.removeAt(idx);
    _listItems.insert(1, _selected);
    widget.selectedOption(selectedOption);
    _exitSwitcher();
    _prepMeetings();
  }

  void _handleStream(ev) {
    print('Input Stream : $ev');
    switch (ev) {
      case 'TAP':
        _exitSwitcher();
        break;
      case 'ORIENTATION':
        _exitSwitcher();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _listItems = widget.listItems;
  }

  @override
  void dispose() {
    if (mounted) {
      if (_sub != null) _sub.cancel();
      if (_entryIsVisible) {
        _entry.remove();
        _entryIsVisible = false;
      }
      // if(_overlay != null && _overlay.mounted) _overlay.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return groupSwitcherButton(
      title: widget.currentGroup["title"],
      role: widget.currentGroup["role"],
      context: context,
    );
  }
}

class AppSwitcher extends StatefulWidget {
  final List<dynamic> listItems;
  final Stream parentStream;
  final dynamic currentGroup;
  final ValueChanged<dynamic> selectedOption;

  AppSwitcher({
    Key key,
    this.listItems,
    this.parentStream,
    this.currentGroup,
    this.selectedOption,
  }) : super(key: key);

  @override
  State createState() => new _AppSwitcherState();
}
