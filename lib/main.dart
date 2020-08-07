import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceryapp/grocerry_kit/SignIn.dart';
import 'package:groceryapp/providers/cart.dart';
import 'package:groceryapp/providers/category.dart';
import 'package:groceryapp/providers/product.dart';
import 'package:groceryapp/providers/store.dart';
import 'package:groceryapp/providers/user.dart';
import 'package:groceryapp/splash_screen.dart';
import 'package:provider/provider.dart';
import 'grocerry_kit/store_package/add_store_screen.dart';
import 'grocerry_kit/store_package/stores_list_screen.dart';
import 'grocerry_kit/sub_pages/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Store(),
        ),
        ChangeNotifierProvider.value(
          value: Category(),
        ),
        ChangeNotifierProvider.value(
          value: Product(),
        ),
        ChangeNotifierProvider.value(
          value: User(),
        ),ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grocery App',
        theme: ThemeData(
primaryColor: Colors.amber,
          brightness: Brightness.light,
          primarySwatch: Colors.amber,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if(userSnapshot.hasData){
              return StoresListPage();
            }
            return SignInPage();
          },
        ),
        routes: {
          SignInPage.routeName: (context) => SignInPage(),
          '/grocerry/cart': (context) => CartPage(),
          StoresListPage.routeName: (context) => StoresListPage(),
          AddStorePage.routeName: (context) => AddStorePage(),
        },
      ),
    );
  }
}
