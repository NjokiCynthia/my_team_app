import 'dart:async';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class _CustomDelegate extends SingleChildLayoutDelegate {
  final Offset target;
  final double verticalOffset;

  _CustomDelegate({
    @required this.target,
    @required this.verticalOffset,
  }) : assert(target != null), assert(verticalOffset != null);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) => constraints.loosen();

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
    return target != oldDelegate.target || verticalOffset != oldDelegate.verticalOffset;
  }
}

class _CustomOverlay extends StatelessWidget {
  final Widget child;
  final Offset target;

  const _CustomOverlay({
    Key key,
    this.child,
    this.target,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return new Positioned.fill(
      child: new IgnorePointer(
        ignoring: false,
        child: new CustomSingleChildLayout(
          delegate: new _CustomDelegate(
            target: target,
            verticalOffset: -5.0,
          ),
          child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: 100.0,
              ),
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  boxShadow: mildShadow(Theme.of(context).unselectedWidgetColor),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppSwitcherState extends State<AppSwitcher> {
  List<String> _listItems;
  OverlayState _overlay;
  OverlayEntry _entry;
  bool _entryIsVisible = false;
  StreamSubscription _sub;

  void _toggleEntry(show) {
    if(_overlay.mounted && _entry != null){
      if(show){
        _overlay.insert(_entry);
        _entryIsVisible = true;
      }
      else{
        _entry.remove();
        _entryIsVisible = false;
      }
    }
    else {
      _entryIsVisible = false;
    }
  }

  void _handleSwitch() {
    if(widget.parentStream != null && _sub == null){
      _sub = widget.parentStream.listen(_handleStream);
    }

    if(_overlay == null){
      final RenderBox bounds = context.findRenderObject();
      final Offset target = bounds.localToGlobal(bounds.size.bottomCenter(Offset.zero));

      _entry = new OverlayEntry(builder: (BuildContext context){
        return new _CustomOverlay(
          target: target,
          child: new Material(
            child: new ListView.builder(
              padding: const EdgeInsets.all(0.0),
              itemBuilder: (BuildContext context, int ndx) {
                String label = _listItems[ndx];
                return new ListTile(
                  title: new Text(label),
                  onTap: () {
                    print('Chose: $label');
                    _handleSubmit(label);
                  },
                );
              },
              itemCount: _listItems.length,
            ),
          ),
        );
      });
      _overlay = Overlay.of(context, debugRequiredFor: widget);
    }

    setState(() {
      // Can be used if the listItems get updated
      if(!_entryIsVisible && _listItems.length > 0){
        _toggleEntry(true);
      }else if(_entryIsVisible && _listItems.length == 0){
        _toggleEntry(false);
      }else{
        _entry.markNeedsBuild();
      }
    });
  }

  Widget groupSwitcherButton({BuildContext context, String title, String role}) {
    return FlatButton(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
      child: Column(
        children: <Widget>[
          Container(
            // height: 32.0,
            constraints: BoxConstraints(maxWidth: 320),
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.blueGrey[400],
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      textAlign: TextAlign.end,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // Icon(
                        //   Icons.person,
                        //   size: 12.0,
                        // ),
                        // SizedBox(width: 4.0),
                        Text(
                          role,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w900,
                            fontSize: 14.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          textAlign: TextAlign.end,
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
                  borderRadius: BorderRadius.circular(40.0),
                  color: Theme.of(context).hintColor.withOpacity(0.4),
                ),
                child: Icon(
                  Feather.plus,
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
            ]),
          ),
        ],
      ),
      onPressed: () {
        _handleSwitch();
      },
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      textColor: Colors.blue,
      color: Theme.of(context).buttonColor,
    );
  }

  void _exitSwitcher(){
    if(_sub != null){
      _sub.cancel();
      _sub = null;
      print('Removed stream listener');
    }
    // Blur the input
    FocusScope.of(context).requestFocus(new FocusNode());
    // hide the list
    _toggleEntry(false);

  }

  void _handleSubmit(newVal) {
    _exitSwitcher();
  }

  void _handleStream(ev) {
    print('Input Stream : $ev');
    switch(ev){
      case 'TAP_UP':
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
    if(mounted){
      if(_sub != null) _sub.cancel();
      if(_entryIsVisible){
        _entry.remove();
        _entryIsVisible = false;
      }
      if(_overlay != null && _overlay.mounted) _overlay.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return groupSwitcherButton(
      title: "Witcher Welfare Association",
      role: "Chairperson",
      context: context,
    );
  }
}

class AppSwitcher extends StatefulWidget {
  final List<String> listItems;
  final Stream parentStream;

  AppSwitcher({
    Key key,
    this.listItems,
    this.parentStream,
  }): super(key: key);

  @override
  State createState() => new _AppSwitcherState();
}
