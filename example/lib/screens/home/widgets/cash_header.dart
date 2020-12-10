import 'package:flutter/material.dart';
import 'package:esol/constans/keys.dart';
// import 'package:esol/generated/i18n.dart';s
import 'package:esol/models/views/cash_header.dart';
import 'package:esol/models/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:esol/utils/format.dart';
import 'package:esol/utils/send.dart';
import 'package:flutter_svg/svg.dart';

class CashHeader extends StatelessWidget {
  final bool imageshow;
  final bool textshow;
  final bool contactEmpty;
  final String text;
  final String avatarUrl;
  final ScaffoldState scaffoldState;
  final ImageProvider<dynamic> image;
  CashHeader(
      {@required this.imageshow,
      @required this.textshow,
      @required this.contactEmpty,
      @required this.image,
      this.scaffoldState,
      this.avatarUrl,
      this.text});
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CashHeaderViewModel>(
        distinct: true,
        converter: CashHeaderViewModel.fromStore,
        builder: (_, viewModel) {
          return Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(
                top: 20.0, left: 20.0, right: 20.0, bottom: 15.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withAlpha(20),
                  blurRadius: 30.0,
                  spreadRadius: 10.0,
                  offset: Offset(
                    0.0,
                    3.0,
                  ),
                )
              ],
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.only(
                //bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    AppKeys.homePageKey.currentState.openDrawer();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 35, bottom: 35, right: 35),
                    child: Image.asset(
                      'assets/images/menu_white.png',
                      width: 20,
                    ),
                  ),
                ),
                //Editing Start
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        HeaderExample(
                          texthide: (textshow && contactEmpty) ? true : false,
                          imageshow: imageshow,
                          textName: text,
                        ), // Editing Start
                        // Text('${I18n.of(context).hi} ${viewModel?.firstName() ?? ''}',
                        //     style: TextStyle(
                        //       color: Theme.of(context).splashColor,
                        //       fontSize: 25,
                        //     )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // verticalDirection: VerticalDirection.up,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Container(
                                  //   child: Text(I18n.of(context).balance,
                                  //       style: TextStyle(
                                  //           color: Theme.of(context).splashColor,
                                  //           fontSize: 12.0)),
                                  //   padding: EdgeInsets.only(bottom: 6.0),
                                  // ),
                                  viewModel.hasErc20Tokens
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                              RichText(
                                                text: TextSpan(
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            '\$${viewModel?.usdValue ?? '0'}',
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            color: Theme.of(
                                                                    context)
                                                                .splashColor)),
                                                  ],
                                                ),
                                              ),
                                            ])
                                      : RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .splashColor),
                                            children: viewModel
                                                        .community.token ==
                                                    null
                                                ?
                                                //Converting Text Span to text
                                                <TextSpan>[
                                                    TextSpan(
                                                        text: '0',
                                                        style: TextStyle(
                                                          fontSize: 30,
                                                          color:
                                                              Theme.of(context)
                                                                  .splashColor,
                                                        ))
                                                  ]
                                                : <TextSpan>[
                                                    // TextSpan(
                                                    //     text: '/S ',
                                                    //     style: TextStyle(
                                                    //         fontSize: 32,
                                                    //         color: Theme.of(context)
                                                    //             .splashColor,
                                                    //         fontWeight: FontWeight.normal,
                                                    //         height: 0.0)),
                                                    (textshow == true &&
                                                            contactEmpty ==
                                                                true)
                                                        ? TextSpan(
                                                            text: '',
                                                          )
                                                        : TextSpan(
                                                            text: imageshow
                                                                ? 'S/ ${formatValue(viewModel.community.token.amount, viewModel.community.token.decimals)}'
                                                                : 'S/ **********',
                                                            // formatValue(
                                                            //     viewModel
                                                            //         .community
                                                            //         .token
                                                            //         .amount,
                                                            //     viewModel
                                                            //         .community
                                                            //         .token
                                                            //         .decimals)
                                                            style: TextStyle(
                                                                fontSize: 36,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                                color: Theme.of(
                                                                        context)
                                                                    .splashColor)),
                                                  ],
                                          ),
                                        ),
                                ],
                              ),
                              // Container(
                              //   decoration: BoxDecoration(
                              //       color: Theme.of(context).splashColor,
                              //       borderRadius: BorderRadius.circular(20.0)),
                              //   padding: EdgeInsets.all(15),
                              //   child: InkWell(
                              //     onTap: bracodeScannerHandler,
                              //     child: Column(
                              //       children: [
                              //         SvgPicture.asset(
                              //           "assets/images/QR.svg",
                              //         ),
                              //         SizedBox(
                              //           height: 5,
                              //         ),
                              //         Text(
                              //           'QR',
                              //           style: TextStyle(
                              //               color: Theme.of(context).primaryColorDark),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    FittedBox(
                      child: Container(
                          decoration: BoxDecoration(
                              color: (image == null)
                                  ? (avatarUrl == null)
                                      ? Theme.of(context).splashColor
                                      : Colors.transparent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          padding: EdgeInsets.all(15),
                          child: (image == null)
                              ? (avatarUrl == null)
                                  ? InkWell(
                                      onTap: bracodeScannerHandler,
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/QR.svg",
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'QR',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: NetworkImage(avatarUrl),
                                            fit: BoxFit.fill),
                                      ),
                                    )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(image: image),
                                  ),
                                )
                          // : Text(image.),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class HeaderExample extends StatelessWidget {
  final bool imageshow;
  final bool texthide;
  final String textName;
  HeaderExample({
    @required this.imageshow,
    @required this.texthide,
    this.textName,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      (texthide)
          ? Container()
          : (textName == null)
              ? Text(
                  'S/',
                  style: TextStyle(
                    color: Theme.of(context).splashColor,
                    fontSize: 25,
                  ),
                )
              : Text(
                  textName,
                  style: TextStyle(
                    color: Theme.of(context).splashColor,
                    fontSize: 16,
                  ),
                ),
      (texthide)
          ? Container()
          : (textName == null)
              ? SizedBox(
                  width: 10,
                )
              : Container(),
      (texthide)
          ? Container()
          : (textName == null)
              ? Image.asset('assets/images/conversion_icon.png')
              : Container(),
      (texthide)
          ? Container()
          : (textName == null)
              ? SizedBox(
                  width: 10,
                )
              : Container(),
      (texthide)
          ? Container()
          : (textName == null)
              ? Text(
                  'ESOL',
                  style: TextStyle(
                    color: Theme.of(context).splashColor,
                    fontSize: 25,
                  ),
                )
              : Container(),
      (texthide)
          ? Container()
          : (textName == null)
              ? SizedBox(
                  width: 30,
                )
              : Container(),
      (texthide)
          ? Container()
          : (textName == null)
              ? InkWell(
                  onTap: () {},
                  child: Container(
                    height: 25,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue[600],
                    ),
                    child: Image.asset(
                      imageshow
                          ? 'assets/images/eye_hide.png'
                          : 'assets/images/eye_show.png',
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                )
              : Container(),
    ]);
  }
}
