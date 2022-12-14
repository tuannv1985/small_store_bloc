import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_small_bloc/models/user_model.dart';
import 'package:store_small_bloc/views/account/account.dart';
import 'package:store_small_bloc/views/login/login.dart';

import '../../../app/utils/colors.dart';
import '../../../core/type/enum.dart';
import '../../widget/app_loading_widget.dart';
import '../../widget/big_text.dart';
import '../../widget/show_dialog.dart';
import '../../widget/show_snack_bar.dart';
import '../components/header_image_profile.dart';
import '../components/profile_infomation.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool checkClick = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        if(state.errorMessage != ""){
          if(state.statusSetData != StatusType.init){
            ShowDialogWidget.showDialogDefaultBloc(context: context, status: state.statusSetData, text: state.errorMessage);
          }else{
            ShowSnackBarWidget.showSnackCustom(context: context,isError: true,text: state.errorMessage);
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                toolbarHeight: size.height * 0.075,
                backgroundColor: AppColors.mainColor,
                centerTitle: true,
                title: BigText(
                    text: "Profile",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.026),
                actions: [
                  IconButton(onPressed: () => context.read<AccountCubit>().logoutRequested(), icon: const Icon(Icons.login_outlined)),
                ],
              ),
              body: BlocBuilder<AccountCubit, AccountState>(
                  buildWhen: (previous, current) => previous.rebuildInfo != current.rebuildInfo,
                  builder: (context, state) {
                    print("rebuild account info");
                    print(state.yourUser.address);
                return Column(
                  children: [
                    HeaderImageProfile(
                      yourUser: state.yourUser,
                    ),
                    ProfileInfomation(
                      yourUser: state.yourUser, clicked: (bool value) {
                      checkClick = value;
                      setState(() {

                      });
                    } ,
                    ),
                  ],
                );
              })),
          checkClick==true?const Scaffold(
            backgroundColor: Colors.black26,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ):const SizedBox(),
        ],
      ),
    );
  }
}
