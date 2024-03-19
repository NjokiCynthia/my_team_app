import 'package:chamasoft/config.dart';
import 'package:chamasoft/providers/bankBalancesSummary.dart';
import 'package:chamasoft/providers/chamasoft-loans.dart';
import 'package:chamasoft/providers/chatmessage.dart';
import 'package:chamasoft/providers/dashboard.dart';
import 'package:chamasoft/providers/expenses-summaries.dart';
import 'package:chamasoft/providers/fine_summary.dart';
import 'package:chamasoft/providers/loan-summaries.dart';
import 'package:chamasoft/providers/notification_summary.dart';
import 'package:chamasoft/providers/recent-transactions.dart';
import 'package:chamasoft/providers/summaries.dart';
import 'package:chamasoft/providers/translation-provider.dart';
import 'package:chamasoft/screens/chamasoft/dashboard.dart';
import 'package:chamasoft/screens/chamasoft/reports.dart';
import 'package:chamasoft/screens/chamasoft/settings/accounts/create-bank-account.dart';
import 'package:chamasoft/screens/chamasoft/settings/accounts/list-institutions.dart';
import 'package:chamasoft/screens/chamasoft/settings/group-setup/add-contribution-dialog.dart';
import 'package:chamasoft/screens/chamasoft/settings/group-setup/add-members-manually.dart';
import 'package:chamasoft/screens/chamasoft/settings/group-setup/list-contacts.dart';
import 'package:chamasoft/screens/chamasoft/transactions.dart';
//import 'package:chamasoft/screens/chamasoft/transactions/invoicing-and-transfer/account-to-account-transfer.dart';
import 'package:chamasoft/screens/configure-group.dart';
import 'package:chamasoft/screens/create-group.dart';
import 'package:chamasoft/screens/intro.dart';
import 'package:chamasoft/screens/login.dart';
import 'package:chamasoft/screens/login_password.dart';
import 'package:chamasoft/screens/my-groups.dart';
import 'package:chamasoft/screens/pinlogin.dart';
import 'package:chamasoft/screens/register.dart';
import 'package:chamasoft/screens/resetpassword.dart';
import 'package:chamasoft/screens/signup.dart';
import 'package:chamasoft/helpers/common.dart';
import 'package:chamasoft/helpers/notifications.dart';
import 'package:chamasoft/helpers/theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './providers/groups.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  //  Status bar fixes
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Config.appName.toLowerCase() == 'chamasoft'
          ? Color(0xff00a9f0)
          : Color(0xff8f2c21),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones(); // Initialize timezone package
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// void logSents(){
//   facebookAppEvents.
// }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  initDB() async {
    // Any call to the DB will instantiate it, whether valid or invalid
    await getLocalData('app');
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    initDB();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // ignore: todo
    // TODO: implement didChangeDependencies
    // firebaseNotificationListenHandler

    Map<String, dynamic> messageBody =
        NotificationManager.firebaseNotificationListenHandler();
    if (messageBody.length > 0) {
      print("message here $messageBody");
    }

    FirebaseMessaging.instance.subscribeToTopic('chamasoft');
    NotificationManager.listenTokenChange(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TranslationProvider>(
          create: (context) => TranslationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatMessage(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        ),
        ChangeNotifierProxyProvider<Auth, Groups>(
          update: (ctx, auth, previousGroups) => Groups(
            previousGroups == null ? [] : previousGroups.item,
            auth.id,
            auth.userIdentity,
            previousGroups == null ? '' : previousGroups.currentGroupId,
          ),
          create: (BuildContext context) {
            return Groups([], '', '', '');
          },
        ),
        ChangeNotifierProxyProvider<Groups, ChamasoftLoans>(
          update: (ctx, groups, previousGroups) => ChamasoftLoans(
            groups.userId,
            groups.currentGroupId,
          ),
          create: (BuildContext context) {
            return ChamasoftLoans('', '');
          },
        ),
        ChangeNotifierProxyProvider<Groups, Dashboard>(
          update: (ctx, groups, dashboardData) => Dashboard(
              groups.userId,
              groups.currentGroupId,
              dashboardData == null ? {} : dashboardData.memberDashboardData,
              dashboardData == null ? {} : dashboardData.groupDashboardData),
          create: (BuildContext context) {
            return Dashboard('', '', {}, {});
          },
        ),
        ChangeNotifierProxyProvider<Groups, DashboardContributionSummary>(
          update: (ctx, groups, dashboardContributionSummary) =>
              DashboardContributionSummary(
            groups.userId,
            groups.currentGroupId,
            dashboardContributionSummary == null
                ? {}
                : dashboardContributionSummary.memberData,
            dashboardContributionSummary == null
                ? {}
                : dashboardContributionSummary.totalGroupContributionAmount,
          ),
          create: (BuildContext context) {
            return DashboardContributionSummary('', '', {}, {});
          },
        ),
        ChangeNotifierProxyProvider<Groups, DashboardFineSummary>(
          update: (ctx, groups, dashboardFineSummary) => DashboardFineSummary(
            groups.userId,
            groups.currentGroupId,
            dashboardFineSummary == null ? {} : dashboardFineSummary.memberData,
            dashboardFineSummary == null
                ? {}
                : dashboardFineSummary.totalGroupFineAmount,
          ),
          create: (BuildContext context) {
            return DashboardFineSummary('', '', {}, {});
          },
        ),
        ChangeNotifierProxyProvider<Groups, BalancesDashboardSummary>(
          update: (ctx, groups, balancesDashboardSummary) =>
              BalancesDashboardSummary(
            groups.userId,
            groups.currentGroupId,
            balancesDashboardSummary == null
                ? {}
                : balancesDashboardSummary.accountData,
            balancesDashboardSummary == null
                ? {}
                : balancesDashboardSummary.totalBankBalance,
          ),
          create: (BuildContext context) {
            return BalancesDashboardSummary('', '', {}, {});
          },
        ),
        ChangeNotifierProxyProvider<Groups, LoanDashboardSummary>(
          update: (ctx, groups, loanDashboardSummary) => LoanDashboardSummary(
            groups.userId,
            groups.currentGroupId,
            loanDashboardSummary == null ? {} : loanDashboardSummary.loanData,
            loanDashboardSummary == null
                ? {}
                : loanDashboardSummary.totalLoanBankBalance,
          ),
          create: (BuildContext context) {
            return LoanDashboardSummary('', '', {}, {});
          },
        ),
        ChangeNotifierProxyProvider<Groups, MemberRecentTransaction>(
          update: (ctx, groups, memberRecentTransaction) =>
              MemberRecentTransaction(
            groups.userId,
            groups.currentGroupId,
            memberRecentTransaction == null
                ? {}
                : memberRecentTransaction.recentTransactionData,
          ),
          create: (BuildContext context) {
            return MemberRecentTransaction('', '', {});
          },
        ),
        ChangeNotifierProxyProvider<Groups, NewExpensesSummaries>(
          update: (ctx, groups, newExpensesSummaries) => NewExpensesSummaries(
            groups.userId,
            groups.currentGroupId,
            newExpensesSummaries == null
                ? {}
                : newExpensesSummaries.expensesSummariesData,
            newExpensesSummaries == null
                ? {}
                : newExpensesSummaries.expensesSummariesTotalData,
          ),
          create: (BuildContext context) {
            return NewExpensesSummaries('', '', {}, {});
          },
        ),
        ChangeNotifierProxyProvider<Groups, GroupNotifications>(
          update: (ctx, groups, groupNotifications) => GroupNotifications(
            groups.userId,
            groups.currentGroupId,
            groupNotifications == null ? {} : groupNotifications.notifications,
          ),
          create: (BuildContext context) {
            return GroupNotifications('', '', {});
          },
        ),
      ],
      child: Consumer<DarkThemeProvider>(
          builder: (BuildContext context, value, Widget child) {
        return MaterialApp(
          builder: (BuildContext context, Widget child) {
            final data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(
                  textScaleFactor:
                      data.textScaleFactor > 1.0 ? 1.0 : data.textScaleFactor),
              child: child,
            );
          },
          debugShowCheckedModeBanner: false,
          color: themeChangeProvider.darkTheme
              ? Colors.blueGrey[900]
              : Colors.blue[50],
          title: 'Chamasoft',
          theme: Styles.themeData(themeChangeProvider.darkTheme, context),
          home: IntroScreen(),
          routes: {
            IntroScreen.namedRoute: (ctx) => IntroScreen(),
            Login.namedRoute: (ctx) => Login(),
            MyGroups.namedRoute: (ctx) => MyGroups(),
            SignUp.namedRoute: (ctx) => SignUp(),
            CreateGroup.namedRoute: (ctx) => CreateGroup(),
            ConfigureGroup.namedRoute: (ctx) => ConfigureGroup(),
            ListContacts.namedRoute: (ctx) => ListContacts(),
            CreateBankAccount.namedRoute: (ctx) => CreateBankAccount(),
            AddContributionDialog.namedRoute: (ctx) => AddContributionDialog(),
            AddMembersManually.namedRoute: (ctx) => AddMembersManually(),
            ListInstitutions.namedRoute: (ctx) => ListInstitutions(),
            ChamasoftDashboard.namedRoute: (ctx) => ChamasoftDashboard(),
            ChamasoftTransactions.namedRoute: (ctx) => ChamasoftTransactions(),
            PinLogin.namedRoute: (ctx) => PinLogin(),
            RegisterScreen.namedRoute: (ctx) => RegisterScreen(),
            LoginPassword.namedRoute: (ctx) => LoginPassword(),
            ResetPassword.namedRoute: (ctx) => ResetPassword(),
            '/reports': (ctx) => ChamasoftReports(),
          },
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (context) => IntroScreen());
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (context) => IntroScreen());
          },
        );
      }),
    );
  }
}

class BackgroundMessageHandler {
  static Future<void> handle(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}
