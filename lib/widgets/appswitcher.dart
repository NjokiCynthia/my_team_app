import 'dart:async';
import 'package:flutter/material.dart';

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
    double borderWidth = 2.0;
    Color borderColor = Theme.of(context).accentColor;

    return new Positioned.fill(
      child: new IgnorePointer(
        ignoring: false,
        child: new CustomSingleChildLayout(
          delegate: new _CustomDelegate(
            target: target,
            verticalOffset: -5.0,
          ),
          child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                maxHeight: 100.0,
              ),
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border(
                    right: new BorderSide(color: borderColor, width: borderWidth),
                    bottom: new BorderSide(color: borderColor, width: borderWidth),
                    left: new BorderSide(color: borderColor, width: borderWidth),
                  ),
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

class _CustomInputState extends State<_CustomInput> {
  TextEditingController _inputController = new TextEditingController();
  FocusNode _focus = new FocusNode();
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

  void _handleFocus(){
    if(_focus.hasFocus){
      _inputController.addListener(_handleInput);
      print('Added input handler');
      _handleInput();
    }
    else{
      _inputController.removeListener(_handleInput);
      print('Removed input handler');
    }
  }

  void _handleInput() {
    // String newVal = _inputController.text;

    if(widget.parentStream != null && _sub == null){
      _sub = widget.parentStream.listen(_handleStream);
      print('Added stream listener');
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
      // This can be used if the listItems get updated, which won't happen in
      // this example, but I figured it was useful info.
      if(!_entryIsVisible && _listItems.length > 0){
        _toggleEntry(true);
      }else if(_entryIsVisible && _listItems.length == 0){
        _toggleEntry(false);
      }else{
        _entry.markNeedsBuild();
      }
    });
  }

  void _exitInput(){
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
    // Set to selected value
    _inputController.text = newVal;
    _exitInput();
  }

  void _handleStream(ev) {
    print('Input Stream : $ev');
    switch(ev){
      case 'TAP_UP':
        _exitInput();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_handleFocus);
    _listItems = widget.listItems;
  }

  @override
  void dispose() {
    _inputController.removeListener(_handleInput);
    _inputController.dispose();

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
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new TextField(
            autocorrect: true,
            focusNode: _focus,
            controller: _inputController,
            decoration: new InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(5.0),
                ),
                borderSide: new BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              contentPadding: new EdgeInsets.all(10.0),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: _handleSubmit,
          ),
        ),
      ]
    );
  }
}

class _CustomInput extends StatefulWidget {
  final List<String> listItems;
  final Stream parentStream;

  _CustomInput({
    Key key,
    this.listItems,
    this.parentStream,
  }): super(key: key);

  @override
  State createState() => new _CustomInputState();
}

class HomeState extends State<Home> {
  List<String> _overlayItems = [
    'Item 01',
    'Item 02',
    'Item 03',
  ];
  StreamController _eventDispatcher = new StreamController.broadcast();

  Stream get _stream => _eventDispatcher.stream;

  _onTapUp(TapUpDetails details) {
    _eventDispatcher.add('TAP_UP');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    _eventDispatcher.close();
  }

  @override
  Widget build(BuildContext context){
    return new GestureDetector(
      onTapUp: _onTapUp,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Row(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(
                  right: 10.0,
                ),
                child: new Icon(Icons.layers),
              ),
              new Text("appTitle")
            ],
          ),
          bottom: new PreferredSize(
            preferredSize: const Size.fromHeight(30.0),
            child: new Padding(
              padding: new EdgeInsets.only(
                bottom: 10.0,
                left: 10.0,
                right: 10.0,
              ),
              child: new _CustomInput(
                key: new ObjectKey('$_overlayItems'),
                listItems: _overlayItems,
                parentStream: _stream,
              ),
            ),
          ),
        ),
        body: const Text('Body content'),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State createState() => new HomeState();
}
