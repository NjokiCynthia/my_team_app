import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/custom-helper.dart';
import 'package:chamasoft/helpers/status-handler.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

enum InstitutionFlag {
  flagBanks,
  flagBankBranches,
  flagSaccos,
  flagSaccoBranches
}

class InstitutionArguments {
  dynamic bank;
  InstitutionFlag institutionFlag;

  InstitutionArguments(this.bank, this.institutionFlag);
}

class ListInstitutions extends StatefulWidget {
  static const namedRoute = 'list-institutions';

  @override
  _ListInstitutionsState createState() => _ListInstitutionsState();
}

class _ListInstitutionsState extends State<ListInstitutions> {
  List<Bank> _banksList = [];
  List<BankBranch> _branchList = [];
  List<Sacco> _saccoList = [];
  List<SaccoBranch> _saccoBranchList = [];
  List<dynamic> _list = [];
  InstitutionArguments _arguments;
  String filter;
  TextEditingController _controller = new TextEditingController();

  Future<void> _fetchBankBranchOptions(BuildContext context, String id) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchBankBranchOptions(id);
      Navigator.of(context).pop();
      Navigator.of(context).pop(_arguments);
    } on CustomException catch (error) {
      Navigator.of(context).pop();
      StatusHandler().handleStatus(
          context: context,
          error: error,
          callback: () {
            _fetchBankBranchOptions(context, id);
          });
    }
  }

  Future<void> _fetchSaccoBranchOptions(BuildContext context, String id) async {
    try {
      await Provider.of<Groups>(context, listen: false)
          .fetchSaccoBranchOptions(id);
      Navigator.of(context).pop();
      Navigator.of(context).pop(_arguments);
    } on CustomException catch (error) {
      print(error);
      Navigator.of(context).pop();
//      StatusHandler().handleStatus(
//          context: context,
//          error: error,
//          callback: () {
//            _fetchSaccoBranchOptions(context, id);
//          });
    }
  }

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        filter = _controller.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final InstitutionFlag flag = ModalRoute.of(context).settings.arguments;
    String title = "Select Bank";
    String labelText = "Search Bank";
    if (flag == InstitutionFlag.flagBanks) {
      _banksList = Provider.of<Groups>(context).bankOptions;
      _list = _banksList;
    } else if (flag == InstitutionFlag.flagBankBranches) {
      title = "Select Bank Branch";
      labelText = "Search Bank Branch";
      _branchList = Provider.of<Groups>(context).bankBranchOptions;
      _list = _branchList;
    } else if (flag == InstitutionFlag.flagSaccos) {
      title = "Select Sacco";
      labelText = "Search Sacco";
      _saccoList = Provider.of<Groups>(context).saccoOptions;
      _list = _saccoList;
    } else if (flag == InstitutionFlag.flagSaccoBranches) {
      title = "Select Sacco Branch";
      labelText = "Search Sacco Branch";
      _saccoBranchList = Provider.of<Groups>(context).saccoBranchOptions;
      _list = _saccoBranchList;
    }

    return Scaffold(
      appBar: secondaryPageAppbar(
        context: context,
        action: () => Navigator.of(context).pop(),
        leadingIcon: LineAwesomeIcons.times,
        title: title,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(top: 16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    labelText: labelText,
                    prefixIcon: Icon(LineAwesomeIcons.search),
                  ),
                  controller: _controller,
                ),
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (_, int index) {
                        String name;
                        int id;
                        if (flag == InstitutionFlag.flagBanks) {
                          name = _banksList[index].name;
                          id = _banksList[index].id;
                        } else if (flag == InstitutionFlag.flagBankBranches) {
                          name = _branchList[index].name;
                          id = _branchList[index].id;
                        } else if (flag == InstitutionFlag.flagSaccos) {
                          name = _saccoList[index].name;
                          id = _saccoList[index].id;
                        } else if (flag == InstitutionFlag.flagSaccoBranches) {
                          name = _saccoBranchList[index].name;
                          id = _saccoBranchList[index].id;
                        }

                        return filter == null || filter.isEmpty
                            ? buildListTile(index, name, context, flag, id)
                            : name.toLowerCase().contains(filter.toLowerCase())
                                ? buildListTile(index, name, context, flag, id)
                                : Visibility(
                                    visible: false, child: new Container());
                      },
                      itemCount: _list.length),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  ListTile buildListTile(int index, String name, BuildContext context,
      InstitutionFlag flag, int id) {
    return ListTile(
      title: customTitle(text: name, textAlign: TextAlign.start),
      onTap: () async {
        if (flag == InstitutionFlag.flagBanks) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
          _arguments = InstitutionArguments(
              _banksList[index], InstitutionFlag.flagBanks);
          await _fetchBankBranchOptions(context, id.toString());
        } else if (flag == InstitutionFlag.flagBankBranches) {
          _arguments = InstitutionArguments(
              _branchList[index], InstitutionFlag.flagBankBranches);
          Navigator.of(context).pop(_arguments);
        } else if (flag == InstitutionFlag.flagSaccos) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
          _arguments = InstitutionArguments(
              _saccoList[index], InstitutionFlag.flagSaccos);
          print("Sacco: $name");
          print("Id: $id");
          await _fetchSaccoBranchOptions(context, id.toString());
        } else if (flag == InstitutionFlag.flagSaccoBranches) {
          _arguments = InstitutionArguments(
              _saccoBranchList[index], InstitutionFlag.flagSaccoBranches);
          Navigator.of(context).pop(_arguments);
        }
      },
    );
  }
}
