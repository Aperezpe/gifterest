import 'package:flutter/material.dart';
import 'package:gifterest/resize/size_config.dart';
import 'package:gifterest/ui/common_widgets/custom_button.dart';
import 'package:line_icons/line_icons.dart';

import 'models/sign_in_model.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key key, this.model}) : super(key: key);

  void _onOpenTerms(BuildContext context) async {
    final response = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => TermsAndConditionsPage(),
      ),
    );

    if (response == null) return;
    if (response) model.updateHasAcceptedTerms(true);
    model.updateHasReadTerms(true);
  }

  void _onCheckboxToggle(bool value) => model.updateHasAcceptedTerms(value);

  final SignInModel model;
  @override
  Widget build(BuildContext context) {
    return model.formType == EmailSignInFormType.signUp
        ? CheckboxListTile(
            title: Row(
              children: [
                Text(
                  "Agree with",
                  style: TextStyle(
                    fontSize: SizeConfig.subtitleSize / 1.2,
                    color: model.submitted && !model.hasAcceptedTerms
                        ? Colors.red[700]
                        : Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () => _onOpenTerms(context),
                  child: Text(
                    "Terms & Conditions",
                    style: TextStyle(fontSize: SizeConfig.subtitleSize / 1.2),
                  ),
                )
              ],
            ),
            activeColor: Colors.blue,
            controlAffinity: ListTileControlAffinity.leading,
            value: model.hasAcceptedTerms,
            onChanged: model.hasReadTerms ? _onCheckboxToggle : null,
          )
        : Container();
  }
}

class TermsAndConditionsPage extends StatelessWidget {
  TermsAndConditionsPage({Key key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();
  final terms =
      ''' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus. Faucibus et molestie ac feugiat sed lectus vestibulum mattis ullamcorper. Nec feugiat in fermentum posuere urna nec. Elit duis tristique sollicitudin nibh sit amet commodo nulla facilisi. Lacinia at quis risus sed. Amet consectetur adipiscing elit duis tristique sollicitudin. Sit amet est placerat in. Id aliquet risus feugiat in ante metus. Neque volutpat ac tincidunt vitae semper. Non quam lacus suspendisse faucibus interdum posuere lorem ipsum dolor. Maecenas sed enim ut sem.

Et tortor at risus viverra adipiscing at in tellus integer. Ultrices vitae auctor eu augue ut lectus arcu bibendum at. Lacus suspendisse faucibus interdum posuere lorem. At volutpat diam ut venenatis tellus. Non nisi est sit amet facilisis magna etiam. Enim praesent elementum facilisis leo vel fringilla est ullamcorper. Lectus magna fringilla urna porttitor rhoncus dolor. Aliquam vestibulum morbi blandit cursus risus at. Quam lacus suspendisse faucibus interdum posuere lorem ipsum dolor sit. Vitae aliquet nec ullamcorper sit amet risus. Proin sed libero enim sed faucibus turpis in eu mi. Vel risus commodo viverra maecenas accumsan lacus. Et netus et malesuada fames ac turpis egestas. Tellus in hac habitasse platea.

Neque vitae tempus quam pellentesque nec nam aliquam sem et. Aenean sed adipiscing diam donec. Scelerisque felis imperdiet proin fermentum leo. Velit laoreet id donec ultrices tincidunt arcu non. Arcu ac tortor dignissim convallis aenean et tortor. Consequat interdum varius sit amet. Enim lobortis scelerisque fermentum dui faucibus in ornare quam viverra. Interdum posuere lorem ipsum dolor sit amet consectetur adipiscing. Fames ac turpis egestas integer eget. Id aliquet lectus proin nibh nisl condimentum. Orci sagittis eu volutpat odio facilisis mauris sit amet. Elit scelerisque mauris pellentesque pulvinar pellentesque habitant. Odio ut enim blandit volutpat maecenas volutpat blandit. Bibendum at varius vel pharetra vel turpis nunc eget. At erat pellentesque adipiscing commodo elit.

A condimentum vitae sapien pellentesque habitant morbi tristique senectus et. Convallis aenean et tortor at risus viverra. Orci porta non pulvinar neque laoreet suspendisse interdum. Nunc eget lorem dolor sed viverra ipsum nunc aliquet bibendum. Magna ac placerat vestibulum lectus mauris ultrices. Elementum eu facilisis sed odio morbi quis commodo odio aenean. Nulla facilisi nullam vehicula ipsum a. Ut tortor pretium viverra suspendisse. Vel risus commodo viverra maecenas. Ultricies lacus sed turpis tincidunt id aliquet. Pellentesque dignissim enim sit amet venenatis urna cursus eget nunc. Ac feugiat sed lectus vestibulum. Turpis egestas integer eget aliquet nibh praesent. Consectetur lorem donec massa sapien faucibus. Sit amet est placerat in egestas. Sit amet consectetur adipiscing elit duis tristique sollicitudin nibh sit. In egestas erat imperdiet sed euismod.

Massa eget egestas purus viverra accumsan in nisl nisi. Augue eget arcu dictum varius duis at consectetur. Lobortis feugiat vivamus at augue eget arcu dictum varius. Etiam sit amet nisl purus in mollis nunc. Sit amet commodo nulla facilisi. At in tellus integer feugiat scelerisque varius morbi. Tristique senectus et netus et malesuada fames ac turpis. Quis imperdiet massa tincidunt nunc pulvinar sapien et. Etiam sit amet nisl purus in mollis nunc sed id. Aliquam eleifend mi in nulla posuere. Amet consectetur adipiscing elit pellentesque habitant morbi. Urna nunc id cursus metus aliquam eleifend mi. Felis bibendum ut tristique et egestas quis ipsum. Turpis massa tincidunt dui ut. Tincidunt eget nullam non nisi est sit. Et netus et malesuada fames ac turpis egestas. Est lorem ipsum dolor sit. Elementum tempus egestas sed sed risus pretium quam vulputate dignissim. Euismod in pellentesque massa placerat duis ultricies. Maecenas accumsan lacus vel facilisis.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        isAlwaysShown: false,
        thickness: SizeConfig.safeBlockHorizontal * 2.5,
        radius: Radius.circular(15),
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.fromLTRB(
            SizeConfig.blockSizeHorizontal * 8,
            SizeConfig.blockSizeVertical * 5,
            SizeConfig.blockSizeHorizontal * 8,
            SizeConfig.blockSizeVertical * 5,
          ),
          child: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(LineIcons.times),
                    onPressed: () => Navigator.of(context).pop(null),
                    iconSize: SizeConfig.blockSizeVertical * 3,
                  ),
                ),
                Container(),
                Text(
                  "Terms & Conditions",
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 5,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  terms,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 2,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 2),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        text: "Cancel",
                        onPressed: () => Navigator.of(context).pop(false),
                        color: Colors.white,
                        textColor: Colors.black87,
                        borderRadius: 15,
                        textSize: 21,
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                    Expanded(
                      flex: 1,
                      child: CustomButton(
                        text: "Agree",
                        onPressed: () => Navigator.of(context).pop(true),
                        borderRadius: 15,
                        textSize: 21,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
