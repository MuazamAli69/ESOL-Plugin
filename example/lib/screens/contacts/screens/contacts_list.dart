import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:esol/constans/keys.dart';
import 'package:esol/screens/home/widgets/cash_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:esol/generated/i18n.dart';
import 'package:esol/models/app_state.dart';
import 'package:esol/models/views/contacts.dart';
import 'package:esol/screens/contacts/widgets/contact_tile.dart';
import 'package:esol/screens/contacts/widgets/recent_contacts.dart';
import 'package:esol/screens/contacts/widgets/search_panel.dart';
import 'package:esol/utils/contacts.dart';
import 'package:esol/utils/format.dart';
import 'package:esol/utils/phone.dart';
import 'package:esol/utils/send.dart';
import 'package:esol/widgets/main_scaffold.dart';
import "package:ethereum_address/ethereum_address.dart";
import 'package:esol/widgets/preloader.dart';
import 'package:esol/widgets/silver_app_bar.dart';
import '../widgets/custom_send_field.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<Contact> userList = [];
  List<Contact> filteredUsers = [];
  bool hasSynced = false;
  TextEditingController searchController = TextEditingController();
  List<Contact> _contacts;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, ContactsViewModel>(
        distinct: true,
        onInitialBuild: (viewModel) {
          Segment.screen(screenName: '/contacts-screen');
        },
        converter: ContactsViewModel.fromStore,
        builder: (_, viewModel) {
          return _contacts != null
              ? MainScaffold(
                  key: AppKeys.sendPageKey,
                  drawerIcon: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 15),
                    child: Image.asset(
                      'assets/images/menu_white.png',
                    ),
                  ),
                  expandedHeight: MediaQuery.of(context).size.height * 0.34,
                  newHeaderAppBar: CashHeader(
                    scaffoldState: AppKeys.sendPageKey.currentState,
                    // key: AppKeys.sendPageKey,
                    // scaffoldState: context,
                    avatarUrl: null,
                    text: null,
                    image: null,
                    imageshow: false,
                    contactEmpty: true,
                    textshow: true,

                    //Image
                    //Name
                  ),
                  automaticallyImplyLeading: true,
                  title: Text(
                    I18n.of(context).send_to,
                  ),
                  sliverList: _buildPageList(viewModel),
                )
              : Center(
                  child: Preloader(),
                );
        });
  }

  Future<void> refreshContacts() async {
    List<Contact> contacts = await ContactController.getContacts();
    if (mounted) {
      setState(() {
        _contacts = contacts;
      });
    }

    filterList();
    searchController.addListener(filterList);

    if (Platform.isAndroid) {
      for (final contact in contacts) {
        ContactsService.getAvatar(contact).then((avatar) {
          if (avatar == null) return;
          if (mounted) {
            setState(() => contact.avatar = avatar);
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    refreshContacts();
  }

  filterList() {
    List<Contact> users = [];
    users.addAll(_contacts);
    if (searchController.text.isNotEmpty) {
      users.retainWhere((user) => user.displayName
          .toLowerCase()
          .contains(searchController.text.toLowerCase()));
    }

    if (this.mounted) {
      setState(() {
        filteredUsers = users;
      });
    }
  }

  void resetSearch() {
    FocusScope.of(context).unfocus();
    if (mounted) {
      setState(() {
        searchController.text = '';
      });
    }
  }

  SliverPersistentHeader listHeader(String title) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: SliverAppBarDelegate(
        minHeight: 40.0,
        maxHeight: 40.0,
        child: Container(
          color: Color(0xFFF8F8F8),
          padding: EdgeInsets.only(left: 20, top: 7),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  SliverList listBody(ContactsViewModel viewModel, List<Contact> group) {
    List<Widget> listItems = List();
    for (Contact user in group) {
      Iterable<Item> phones = user.phones
          .map((e) => Item(
              label: e.label, value: clearNotNumbersAndPlusSymbol(e.value)))
          .toSet()
          .toList();
      for (Item phone in phones) {
        listItems.add(
          ContactTile(
            image: user.avatar != null && user.avatar.isNotEmpty
                ? MemoryImage(user.avatar)
                : null,
            displayName: user.displayName,
            phoneNumber: phone.value,
            onTap: () {
              resetSearch();
              sendToContact(ExtendedNavigator.named('contactsRouter').context,
                  user.displayName, phone.value,
                  isoCode: viewModel.isoCode,
                  countryCode: viewModel.countryCode,
                  avatar: user.avatar != null && user.avatar.isNotEmpty
                      ? MemoryImage(user.avatar)
                      : new AssetImage('assets/images/anom.png'));
            },
            trailing: Container(
              height: 30,
              width: 30,
              // child: Image.asset('assets\images\gift.png'),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Colors.blue,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      }
    }
    return SliverList(
      delegate: SliverChildListDelegate(listItems),
    );
  }

  Widget sendToAcccountAddress(String accountAddress) {
    Widget component = ContactTile(
      displayName: formatAddress(accountAddress),
      onTap: () {
        resetSearch();
        sendToPastedAddress(accountAddress);
      },
      trailing: InkWell(
        child: Text(
          I18n.of(context).next_button,
          style: TextStyle(color: Color(0xFF0377FF)),
        ),
        onTap: () {
          resetSearch();
          sendToPastedAddress(accountAddress);
        },
      ),
    );
    return SliverList(
      delegate: SliverChildListDelegate([component]),
    );
  }

  List<Widget> _buildPageList(ContactsViewModel viewModel) {
    List<Widget> listItems = List<Widget>();

    listItems.add(SearchPanel(
      searchController: searchController,
    ));
    listItems.add(
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
          minHeight: 40.0,
          maxHeight: 40.0,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Enviar dinero fuera de tus contactos'),
          ),
        ),
      ),
    );
    listItems.add(CustomSendField());
    if (searchController.text.isEmpty) {
      listItems.add(RecentContacts());
    } else if (isValidEthereumAddress(searchController.text)) {
      listItems.add(sendToAcccountAddress(searchController.text));
    }

    Map<String, List<Contact>> groups = new Map<String, List<Contact>>();
    for (Contact c in filteredUsers) {
      String groupName = c.displayName[0];
      if (!groups.containsKey(groupName)) {
        groups[groupName] = new List<Contact>();
      }
      groups[groupName].add(c);
    }

    List<String> titles = groups.keys.toList()..sort();

    for (String title in titles) {
      List<Contact> group = groups[title];
      // listItems.add(listHeader(title));
      // listItems.add(Text('Data'));
      listItems.add(listBody(viewModel, group));
    }

    return listItems;
  }
}
