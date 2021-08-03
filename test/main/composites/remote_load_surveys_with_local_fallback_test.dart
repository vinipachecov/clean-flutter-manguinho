import 'package:clean_flutter_manguinho/data/usecases/usecases.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteLoadSurveysWithLocalFallback {
  RemoteLoadSurveys remote;

  RemoteLoadSurveysWithLocalFallback({this.remote});

  Future<void> load() {
    remote.load();
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

void main() {
  RemoteLoadSurveysSpy remote;
  RemoteLoadSurveysWithLocalFallback sut;
  setUp(() {
    remote = RemoteLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote);
  });
  test('Should call remote load', () async {
    await sut.load();

    verify(remote.load()).called(1);
  });
}
