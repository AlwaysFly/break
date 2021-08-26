import 'package:logger/logger.dart';

PrefixPrinter prefixPrinter = PrefixPrinter(
  PrettyPrinter(
    methodCount: 1, // number of method calls to be displayed
    errorMethodCount: 5, // number of method calls if stacktrace is provided
    lineLength: 100, // width of the output
    printTime: true, // Should each log print contain a timestamp
  ),
  debug: '[Herakles][D]',
  info: '[Herakles][I]',
  error: '[Herakles][E]',
  warning: '[Herakles][W]',
  verbose: '[Hereakles][V]',
  wtf: '[Hereakles][WTF]',
);

Logger logger = Logger(
  level: Level.nothing,
  printer: prefixPrinter,
);

void initLogger(Level level) {
  logger = Logger(
    level: level,
    printer: prefixPrinter,
  );
}