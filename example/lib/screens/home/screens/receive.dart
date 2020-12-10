import 'package:auto_route/auto_route.dart';
import 'package:esol/screens/home/home_page.dart';
import 'package:esol/screens/home/widgets/buttonwidget.dart';
import 'package:esol/screens/routes.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:esol/generated/i18n.dart';
import 'package:esol/models/app_state.dart';
import 'package:esol/utils/format.dart';
import 'package:esol/widgets/copy.dart';
import 'package:esol/widgets/main_scaffold.dart';
import 'package:esol/widgets/primary_button.dart';
import 'dart:core';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:equatable/equatable.dart';
import 'package:redux/redux.dart';

class ReceiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ReceiveModel>(
        distinct: true,
        onInitialBuild: (viewModel) {
          Segment.screen(screenName: '/receive-screen');
        },
        converter: _ReceiveModel.fromStore,
        builder: (_, viewModel) {
          final String barcodeData = 'ethereum:${viewModel.walletAddress}';
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: InkWell(
                child: Image.asset('assets/images/Group 2309.png'),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => HomePage(),
                  //   ),
                  // );
                  ExtendedNavigator.of(context).pushHomePage();
                },
              ),
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.only(right: 20),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       children: [
              //         Text(
              //           'Respaldar con frases',
              //           style: TextStyle(color: Colors.black, fontSize: 20),
              //         ),
              //         Text(
              //           'mneomónicas',
              //           textAlign: TextAlign.right,
              //           style: TextStyle(color: Colors.black, fontSize: 20),
              //         ),
              //       ],
              //     ),
              //   )
              // ],
            ),
            body: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        I18n.of(context).receive,
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 100.0, right: 100.0, bottom: 20.0, top: 20),
                        child: Text(I18n.of(context).scan_to_receive,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ),
                      Column(
                        children: <Widget>[
                          Center(
                            child: Container(
                                width: 200,
                                decoration: new BoxDecoration(
                                  color: Theme.of(context).splashColor,
                                  borderRadius: new BorderRadius.all(
                                    Radius.circular(30.0),
                                  ),
                                ),
                                child: QrImage(
                                  data: barcodeData,
                                )),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            width: 220,
                            child: Text(formatAddress(viewModel?.walletAddress),
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal)),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            width: 250,
                            height: 50,
                            child: Opacity(
                              opacity: 1,
                              child: Center(
                                child: CopyToClipboard(
                                  textColor: Color(0xFF0091ff),
                                  content: viewModel?.walletAddress,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                          child: PrimaryButton(
                        // buttonContentColor: Colors.white,
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        fontSize: 15,
                        labelFontWeight: FontWeight.normal,
                        width: 300,
                        label: I18n.of(context).share_button,
                        onPressed: () {
                          Share.share(viewModel?.walletAddress);
                        },
                      ))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _ReceiveModel extends Equatable {
  final String walletAddress;
  _ReceiveModel({
    this.walletAddress,
  });

  static _ReceiveModel fromStore(Store<AppState> store) {
    return _ReceiveModel(
      walletAddress: store.state.userState?.walletAddress ?? '',
    );
  }

  @override
  List<Object> get props => [
        walletAddress,
      ];
}
