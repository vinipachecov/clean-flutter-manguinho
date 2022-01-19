import 'package:flutter/material.dart';
import 'package:clean_flutter_manguinho/ui/helpers/helpers.dart';
import 'package:clean_flutter_manguinho/ui/components/components.dart';
import 'package:clean_flutter_manguinho/ui/pages/pages.dart';
import 'package:clean_flutter_manguinho/ui/pages/surveys/survey_viewmodel.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import './components/components.dart';
import '../../mixins/mixins.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with LoadingManager, NavigationManager, SessionManager, RouteAware {
  @override
  void didPopNext() {
    widget.presenter.loadData();
  }

  @override
  void dispose() {
    final routeObserver = Get.find<RouteObserver>();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeObserver = Get.find<RouteObserver>();

    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    return Scaffold(
        appBar: AppBar(title: Text(R.strings.surveys)),
        body: Builder(
          builder: (context) {
            handleLoading(context, widget.presenter.isLoadingStream);

            handleSession(widget.presenter.isSessionExpiredStream);

            handleNavigation(widget.presenter.navigateToStream);

            widget.presenter.loadData();

            return StreamBuilder<List<SurveyViewModel>>(
                stream: widget.presenter.surveysStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ReloadScreen(
                        error: '${snapshot.error}',
                        reload: widget.presenter.loadData);
                  }
                  if (snapshot.hasData) {
                    return ListenableProvider(
                        create: (_) => widget.presenter,
                        child: SurveyItems(snapshot.data!));
                  }
                  return SizedBox(height: 0);
                });
          },
        ));
  }
}
