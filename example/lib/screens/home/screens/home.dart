import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:esol/models/app_state.dart';
import 'package:esol/models/views/home.dart';
import 'package:esol/redux/actions/cash_wallet_actions.dart';
import 'package:esol/screens/home/widgets/assets_list.dart';
import 'package:esol/screens/home/widgets/cash_header.dart';
import 'package:esol/screens/home/widgets/feed.dart';
import 'package:esol/utils/addresses.dart';
import 'package:esol/widgets/my_app_bar.dart';
import '../../../widgets/primary_button.dart';
// import 'package:esol/generated/i18n.dart';
import 'package:esol/screens/signup/verfiy_face.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esol/generated/i18n.dart';

final List<String> tabsTitles = ['Feed', 'Wallet'];

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  bool isFaceVerify = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getDataValue() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String data = prefs.get('data');
      print("This is the Data Shared Prefs : $data");
      if (data != null) {
        setState(() {
          isFaceVerify = true;
        });
      }
      setState(() {});
      // return data;
    }

    getDataValue();

    return new StoreConnector<AppState, HomeViewModel>(
        converter: HomeViewModel.fromStore,
        onInitialBuild: (viewModel) {
          viewModel.onReceiveBranchData(true);
        },
        onWillChange: (previousViewModel, newViewModel) {
          newViewModel.onReceiveBranchData(false);
        },
        onInit: (store) {
          final communities = store.state.cashWalletState.communities;
          String walletStatus = store.state.userState.walletStatus;
          if (walletStatus == 'created' &&
              !communities.containsKey(defaultCommunityAddress.toLowerCase())) {
            store.dispatch(switchCommunityCall(defaultCommunityAddress));
          }
        },
        builder: (_, viewModel) {
          final body = viewModel.tokens
                      .any((element) => element.originNetwork == null) ||
                  viewModel.communities.length > 1
              ? DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Container(
                    child: Builder(
                      builder: (BuildContext context) => Scaffold(
                        appBar: MyAppBar(
                          backgroundColor: Theme.of(context).splashColor,
                          child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Container(
                                color: Theme.of(context).splashColor,
                                child: TabBar(
                                  indicator: BoxDecoration(color: Colors.white),
                                  onTap: (int index) {
                                    setState(() {});
                                  },
                                  unselectedLabelStyle: TextStyle(
                                      backgroundColor:
                                          Theme.of(context).splashColor),
                                  tabs: tabsTitles.asMap().entries.map((title) {
                                    final int index =
                                        DefaultTabController.of(context).index;
                                    final bool isSeleceted = index != null
                                        ? title.key == index
                                        : false;
                                    return Chip(
                                      labelPadding: EdgeInsets.only(
                                          top: 2,
                                          bottom: 2,
                                          right: 50,
                                          left: 50),
                                      label: Text(title.value),
                                      shadowColor:
                                          Theme.of(context).splashColor,
                                      backgroundColor: isSeleceted
                                          ? Color(0xFFF2F2F2)
                                          : Theme.of(context).splashColor,
                                    );
                                  }).toList(),
                                ),
                              )),
                        ),
                        body: TabBarView(
                          children: [
                            Feed(
                              withTitle: false,
                            ),
                            AssetsList()
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : (isFaceVerify)
                  ? Feed()
                  : Center(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              CustomRectangle(
                                borderSize: 20,
                                borderColor: Colors.white,
                                height: 30.0,
                                borderRadius: 40.0,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 18, top: 0),
                                  child: Container(
                                    alignment: Alignment.bottomLeft,
                                    color: Colors.white,
                                    child: Text(
                                      I18n.of(context).transactions,
                                      // style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 14,
                              ),
                              Expanded(
                                // height:350,
                                child:
                               AlertDialog(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  ),
                                ),
                                title: Center(child: Text(" ")),
                                content: Text(
                                  "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.",
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  PrimaryButton(
                                    // buttonContentColor: Colors.white,
                                    icon: Text(''),
                                    labelFontWeight: FontWeight.bold,
                                    label: 'Déjanos Conocerte',
                                    fontSize: 15,
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => VeifyFaceDetect(),
                                      ));
                                    },
                                  ),
                                  Container(
                                    child: Text(
                                      'Data',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              ),
                             
                            ],
                          ),
                          Positioned(
                            top: 70,
                            left: 118,
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(32.0),
                                ),
                              ),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Image.asset(
                                      'assets/images/alert-icn.png',
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              16,
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text('Importante'),
                                  ],
                                ),
                                height: MediaQuery.of(context).size.height / 7,
                                width: 110,
                                decoration: BoxDecoration(
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey.withOpacity(0.5),
                                    //     spreadRadius: 1,
                                    //     blurRadius: 10,
                                    //     offset: Offset(
                                    //         0, 1), // changes position of shadow
                                    //   ),
                                    // ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(32.0),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
          // AlertDialog(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(32.0),
          //       ),
          //     ),
          //     title: Center(child:Text("Importante")),
          //     content: Text(
          //       "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.",
          //       textAlign: TextAlign.center,
          //     ),
          //     actions: [
          //       PrimaryButton(
          //         // buttonContentColor: Colors.white,
          //         icon: Text(''),
          //         labelFontWeight: FontWeight.normal,
          //         label: 'Verify Face',
          //         fontSize: 15,
          //         onPressed: () async {
          //           Navigator.of(context).push(MaterialPageRoute(
          //             builder: (context) => VeifyFaceDetect(),
          //           ));
          //         },
          //       ),
          //     ],
          //   );

          return Scaffold(
            appBar: MyAppBar(
              // Make it Responsive
              height: MediaQuery.of(context).size.height * 0.29,
              child: CashHeader(
                image: null,
                contactEmpty: false,
                textshow: false,
                imageshow: true,
              ),
            ),
            body: body,
          );
        });
  }
}
