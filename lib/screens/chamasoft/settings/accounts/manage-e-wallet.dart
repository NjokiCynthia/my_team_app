import 'package:chamasoft/providers/groups.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/svg-icons.dart';
import 'package:chamasoft/widgets/appbars.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class ManageEWallet extends StatefulWidget {
  @override
  _ManageEWalletState createState() => _ManageEWalletState();
}

class _ManageEWalletState extends State<ManageEWallet> {
  bool _walletEnabled = true;

  @override
  Widget build(BuildContext context) {
    final group = Provider.of<Groups>(context, listen: false).getCurrentGroup();
    print(group);
    //_walletEnabled = group.onlineBankingEnabled;

    return Scaffold(
      appBar: secondaryPageAppbar(
          title: "Manage E-Wallet Account",
          leadingIcon: LineAwesomeIcons.times,
          elevation: 2,
          action: () => Navigator.of(context).pop(),
          context: context),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        width: double.infinity,
        //decoration: primaryGradient(context),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SvgPicture.asset(
                  customIcons['wallet'],
                  semanticsLabel: 'icon',
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.all(12),
                    color: (themeChangeProvider.darkTheme)
                        ? Colors.blueGrey[800]
                        : Color(0xffededfe),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          customTitleWithWrap(
                              text:
                                  "With the Chamasoft E-Wallet, your group can enjoy the power of automatic reconciliations by transacting with M-Pesa",
                              // ignore: deprecated_member_use
                              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                              fontWeight: FontWeight.w600,
                              maxLines: null,
                              textAlign: TextAlign.start),
                          // subtitle1(
                          //     text:
                          //         "This comes with the added advantage of automatic reconciliations for any payments made via M-Pesa.",
                          //     color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                          //     textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                  ),
                  SwitchListTile(
                    title: customTitle(
                        text: "Chamasoft E-Wallet Account",
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w500),
                    subtitle: subtitle2(
                        text: _walletEnabled ? "Enabled" : "Disabled",
                        // ignore: deprecated_member_use
                        color: Theme.of(context).textSelectionTheme.selectionHandleColor,
                        textAlign: TextAlign.start),
                    value: _walletEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _walletEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
