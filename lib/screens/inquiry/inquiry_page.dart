import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:projecthit/screens/inquiry/inquiry_model.dart';
import 'package:provider/provider.dart';

class Inquiry extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState<String>>();
  final _bodyKey = GlobalKey<FormFieldState<String>>();

  Future<void> _addInquiry(
    BuildContext context,
    InquiryModel inquiryModel,
  ) async {
    try {
      if (!_formKey.currentState.validate()) {
        return;
      }

      final email = _emailKey.currentState.value;
      final body = _bodyKey.currentState.value;

      inquiryModel.beginLoading();
      await inquiryModel.addInquiry(email: email, body: body);
      inquiryModel.endLoading();

      Navigator.pop(context);
    } catch (e) {
      inquiryModel.endLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InquiryModel>(
      create: (_) => InquiryModel(),
      builder: (context, child) {
        final inquiryModel = context.read<InquiryModel>();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).inquiry),
                actions: [
                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();

                      // TODO: お問い合わせを送信
                      await _addInquiry(context, inquiryModel);
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).inquiryBody,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        key: _bodyKey,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return AppLocalizations.of(context).presentError(
                              AppLocalizations.of(context).inquiryBody,
                            );
                          }

                          if (value.length > 10000) {
                            return AppLocalizations.of(context)
                                .maximumTextLengthError(
                              AppLocalizations.of(context).inquiryBody,
                            );
                          }

                          return null;
                        },
                        maxLength: 10000,
                        maxLines: null,
                        minLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context).inquiryEmail,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context).inquiryEmailDescription,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                      ),
                      SizedBox(height: 4),
                      TextFormField(
                        key: _emailKey,
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return AppLocalizations.of(context).presentError(
                              AppLocalizations.of(context).inquiryEmail,
                            );
                          }

                          if (!value.contains('@')) {
                            return AppLocalizations.of(context)
                                .emailFormatError;
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'projecthit@example.com',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            context.select((InquiryModel model) => model.isLoading)
                ? Container(
                    color: Colors.white.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox(),
          ],
        );
      },
    );
  }
}
