import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:records/utils/constants/locator.dart';
import 'package:records/utils/dialogeManager/dialogModels.dart';
import 'package:records/utils/dialogeManager/dialogService.dart';

class ProgressManager extends StatefulWidget {
  final Widget child;
  ProgressManager({Key key, this.child}) : super(key: key);

  _ProgressManagerState createState() => _ProgressManagerState();
}

class _ProgressManagerState extends State<ProgressManager> {
  ProgressService _progressService = locator<ProgressService>();

  @override
  void initState() {
    super.initState();
    _progressService.registerProgressListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(ProgressRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;
    var dialogType = request.buttonTitle != null;

    if (dialogType) {
         showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title ?? ''),
        content: Text(request.description ?? ""),
        actions: <Widget>[
          if (isConfirmationDialog)
            TextButton(
              child: Text(request.cancelTitle),
              onPressed: () {
                _progressService.dialogComplete(ProgressResponse(confirmed: false));
              },
            ),
          TextButton(
            child: Text(request.buttonTitle),
            onPressed: () {
              _progressService.dialogComplete(ProgressResponse(confirmed: true));
            },
          ),
        ],
      ),
    );
    }

    else {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        dismissable: false,
        loadingWidget: SpinKitChasingDots(
        color: Colors.orangeAccent[200],
        size: 40,
      ),
        backgroundColor: Colors.transparent,);

    // pr.show();
    progressDialog.show();
   
  }
  }

}
