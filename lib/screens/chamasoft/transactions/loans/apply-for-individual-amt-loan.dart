import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/screens/chamasoft/transactions/loans/amt-individual-stepper.dart';
import 'package:chamasoft/widgets/backgrounds.dart';
import 'package:chamasoft/widgets/textstyles.dart';
import 'package:flutter/material.dart';

class ApplyIndividualAmtLoan extends StatefulWidget {
  Map<String, dynamic> formLoadData;
  List<LoanProduct> loanProducts;
  ApplyIndividualAmtLoan({this.formLoadData, this.loanProducts});

  @override
  _ApplyIndividualAmtLoanState createState() => _ApplyIndividualAmtLoanState();
}

class _ApplyIndividualAmtLoanState extends State<ApplyIndividualAmtLoan> {
  double _appBarElevation = 0;
  ScrollController _scrollController = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //  List<MembersFilterEntry> selectedMembersList = [];

  int currentStep = 0;
  bool complete = false;

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
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          toolTip(
            context: context,
            title: "Note that...",
            message:
                "Apply quick loan from Amt guaranteed by your savings and fellow group members.",
          ),
          SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.749,
                child:
                    // _loanProducts.length > 0
                    // ?
                    ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: true,
                  itemCount: 3, // Replace with actual itemCount
                  itemBuilder: (context, index) {
                    return AmtLoanProduct(
                      index: index,
                      onProductSelected: (selectedIndex) {
                        // Handle the selected index and pick the corresponding value here
                        String selectedValue = (selectedIndex)
                            .toString(); // Convert index to value
                        print(
                            'Selected value is here : $selectedValue'); // Replace with your logic
                      },
                    );
                  },
                )

                // : emptyList(
                //     color: Colors.blue[400],
                //     iconData: LineAwesomeIcons.angle_double_down,
                //     text: "There are no loan products to display"),
                ),
          ),
        ],
      ),
    );
  }
}

// class AmtLoanProduct extends StatelessWidget {
//   const AmtLoanProduct({Key key, this.loanProduct, this.formLoadData})
//       : super(key: key);

//   final LoanProduct loanProduct;
//   final Map<String, dynamic> formLoadData;
class AmtLoanProduct extends StatelessWidget {
  final Function(String) onProductSelected; // Callback function
  final int index; // Index of the item
  const AmtLoanProduct({
    Key key,
    this.index,
    this.onProductSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        borderOnForeground: false,
        child: Container(
          decoration: cardDecoration(
            gradient: plainCardGradient(context),
            context: context,
          ),
          child: ListTile(
            title: subtitle1(
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              text: 'Water', // Placeholder text, modify as needed
              textAlign: TextAlign.start,
            ),
            subtitle: subtitle2(
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              text: 'Water Loan type', // Placeholder text, modify as needed
              textAlign: TextAlign.start,
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Call the callback function and pass the selected option
              if (onProductSelected != null) {
                String selectedOption = (index + 1).toString();
                onProductSelected(selectedOption);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StepperPage(selectedOption: selectedOption),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
