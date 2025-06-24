import 'package:plantcare_desktop/models/report_model.dart';
import 'base_provider.dart';

class ReportProvider extends BaseProvider<Report> {
  ReportProvider() : super('Report');

  @override
  Report fromJson(data) => Report.fromJson(data);
}
