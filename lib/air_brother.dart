import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class AirBrother {
  static const MethodChannel _channel = const MethodChannel('air_brother');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Returns a list of available network devices.
  static Future<List<Connector>> getNetworkDevices(int timeout) async {
    var params = {
      "timeout": timeout,
    };

    final List<dynamic> resultList =
        await _channel.invokeMethod("getNetworkDevices", params);

    List<Connector> foundDevices =
        resultList.map((dartDevice) => Connector.fromMap(dartDevice)).toList();
    print("Received Connections: $foundDevices");
    return foundDevices;
  }

  /// Returns a list of available USB devices.
  static Future<List<Connector>> getUsbDevices(int timeout) async {
    var params = {
      "timeout": timeout,
    };

    final List<dynamic> resultList =
        await _channel.invokeMethod("getUsbDevices", params);

    List<Connector> foundDevices =
        resultList.map((dartDevice) => Connector.fromMap(dartDevice)).toList();
    return foundDevices;
  }

}

class Connector {
  final int _id;
  final String _descriptorIdentifier;
  final String _modelName;
  final bool _isFaxSupported;
  final bool _isScanSupported;
  final bool _isPrintSupported;

  const Connector._internal(
      {@required id,
      @required descriptorIdentifier,
      @required modelName,
      @required isFaxSupported,
      @required isPrintSupported,
      @required isScanSupported})
      : this._id = id,
        this._modelName = modelName,
        this._descriptorIdentifier = descriptorIdentifier,
        this._isFaxSupported = isFaxSupported,
        this._isPrintSupported = isPrintSupported,
        this._isScanSupported = isScanSupported;

  String getModelName() {
    return _modelName;
  }

  String getDescriptorIdentifier() {
    return _descriptorIdentifier;
  }

  bool isScanSupported() {
    return false;
  }

  bool isPrintSupported() {
    return false;
  }

  bool isFaxSupported() {
    return false;
  }

  Future<JobState> performScan(ScanParameters scanParams, List<String> outScannedPaths) async {
    var params = {
      "connector": this.toMap(),
      "scanParams": scanParams.toMap()
    };

    final Map<dynamic, dynamic> resultMap = await AirBrother._channel.invokeMethod("performScan", params);

    JobState jobState = JobState.fromMap(resultMap["jobState"]);

    List<dynamic> scannedPaths = resultMap["scannedPaths"];
    scannedPaths.forEach((element) {
      outScannedPaths.add(element);
    });

    return jobState;
  }

  static Connector fromMap(Map<dynamic, dynamic> map) {
    return Connector._internal(
        id: map["id"],
        descriptorIdentifier: map["descriptorIdentifier"],
        modelName: map["modelName"],
        isFaxSupported: map["isFaxSupported"],
        isPrintSupported: map["isPrintSupported"],
        isScanSupported: map["isScanSupported"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "descriptorIdentifier": _descriptorIdentifier,
      "modelName": _modelName,
      "faxSupported": _isFaxSupported,
      "isPrintSupported": _isPrintSupported,
      "isScanSupported": _isScanSupported
    };
  }

  @override
  String toString() {
    return this.toMap().toString();
  }
}

class Function {
  final String _name;

  const Function._internal(this._name);

  static const Print = Function._internal("Print");
  static const Scan = Function._internal("Scan");
  static const Fax = Function._internal("Fax");
  static const Phoenix = Function._internal("Phoenix");
  static const DeviceStatus = Function._internal("DeviceStatus");

  static final _values = [Print, Scan, Fax, Phoenix, DeviceStatus];

  static Function valueFromName(String name) {
    return Print;
  }

  static Function fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return valueFromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }
}

class ScanParameters {
  MediaSize documentSize;
  Duplex duplex;
  ColorProcessing colorType;
  Resolution resolution;
  ScanPaperSource paperSource;
  bool autoDocumentSizeScan;
  bool whitePageRemove;
  bool groundColorCorrection;
  ScanSpecialMode specialScanMode;

  ScanParameters(
      {this.documentSize = MediaSize.A4,
      this.duplex = Duplex.Simplex,
      this.colorType = ColorProcessing.FullColor,
      this.resolution = const Resolution(200, 200),
      this.paperSource = ScanPaperSource.AUTO,
      this.autoDocumentSizeScan = false,
      this.whitePageRemove = false,
      this.groundColorCorrection = false,
      this.specialScanMode = ScanSpecialMode.NORMAL_SCAN});

  Map<String, dynamic> toMap() {
    return {
      "documentSize": documentSize.toMap(),
      "duplex": duplex.toMap(),
      "colorType": colorType.toMap(),
      "resolution": resolution.toMap(),
      "paperSource": paperSource.toMap(),
      "autoDocumentSizeScan": autoDocumentSizeScan,
      "whitePageRemove": whitePageRemove,
      "groundColorCorrection": groundColorCorrection,
      "specialScanMode": specialScanMode.toMap()
    };
  }

  static fromMap(Map<dynamic, dynamic> map) {
    return ScanParameters(
        documentSize: MediaSize.fromMap(map["documentSize"]),
        duplex: Duplex.fromMap(map["duplex"]),
        colorType: ColorProcessing.fromMap(map["colorType"]),
        resolution: Resolution.fromMap(map["resolution"]),
        paperSource: ScanPaperSource.fromMap(map["paperSource"]),
        autoDocumentSizeScan: map["autoDocumentSizeScan"],
        whitePageRemove: map["whitePageRemove"],
        groundColorCorrection: map["groundColorCorrection"],
        specialScanMode: ScanSpecialMode.fromMap(map["specialScanMode"]));
  }
}

class MediaSize {
  final String _name;
  final double _width;
  final double _height;

  const MediaSize._internal(this._name, this._width, this._height);

  static const A3 = MediaSize._internal("iso_a3_297x420mm", 11.6929, 16.5354);
  static const A4 = MediaSize._internal("iso_a4_210x297mm", 8.2677, 11.6929);
  static const A5 = MediaSize._internal("iso_a5_148x210mm", 5.8267, 8.2677);
  static const A6 = MediaSize._internal("iso_a6_105x148mm", 4.1338, 5.8267);
  static const B4 = MediaSize._internal("iso_b4_250x353mm", 9.8425, 13.8976);
  static const B5 = MediaSize._internal("iso_b5_176x250mm", 6.9291, 9.8425);
  static const B6 = MediaSize._internal("iso_b6_125x176mm", 4.9212, 6.9291);
  static const C5Envelope =
      MediaSize._internal("iso_c5_162x229mm", 6.3779, 9.0157);
  static const DLEnvelope =
      MediaSize._internal("iso_dl_110x220mm", 4.3307, 8.6614);
  static const Letter = MediaSize._internal("na_letter_8.5x11in", 8.5, 11.0);
  static const Legal = MediaSize._internal("na_legal_8.5x14in", 8.5, 14.0);
  static const Ledger = MediaSize._internal("na_ledger_11x17in", 11.0, 17.0);
  static const Index4x6 = MediaSize._internal("na_index-4x6_4x6in", 4.0, 6.0);
  static const Photo2L = MediaSize._internal("na_5x7_5x7in", 5.0, 7.0);
  static const Executive =
      MediaSize._internal("na_executive_7.25x10.5in", 7.25, 10.5);
  static const JISB4 =
      MediaSize._internal("jis_b4_257x364mm", 10.1181, 14.3307);
  static const JISB5 = MediaSize._internal("jis_b5_182x257mm", 7.1653, 10.1181);
  static const Hagaki =
      MediaSize._internal("jpn_hagaki_100x148mm", 3.937, 5.8267);
  static const PhotoL = MediaSize._internal("oe_photo-l_3.5x5in", 3.5, 5.0);
  static const Folio =
      MediaSize._internal("om_folio_210x330mm", 8.2677, 12.9921);
  static const BusinessCard =
      MediaSize._internal("custom_card_60x90mm", 2.3622, 3.5433);
  static const BusinessCardLandscape =
      MediaSize._internal("custom_card-land_90x60mm", 3.5433, 2.3622);
  static const Undefined =
      MediaSize._internal("custom_undefined_0x0in", 0.0, 0.0);

  static final _values = [
    A3,
    A4,
    A5,
    A6,
    B4,
    B5,
    B6,
    C5Envelope,
    DLEnvelope,
    Letter,
    Legal,
    Ledger,
    Index4x6,
    Photo2L,
    Executive,
    JISB4,
    JISB5,
    Hagaki,
    PhotoL,
    Folio,
    BusinessCard,
    BusinessCardLandscape,
    Undefined
  ];

  static MediaSize fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      MediaSize d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return Undefined;
  }

  static fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return MediaSize.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class Duplex {
  final String _name;

  const Duplex._internal(this._name);

  static const Simplex = Duplex._internal("Simplex");
  static const FlipOnLongEdge = Duplex._internal("FlipOnLongEdge");
  static const FlipOnShortEdge = Duplex._internal("FlipOnShortEdge");

  static final _values = [Simplex, FlipOnLongEdge, FlipOnShortEdge];

  static Duplex fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      Duplex d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return Simplex;
  }

  static Duplex fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return Duplex.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class ColorProcessing {
  final String _name;

  const ColorProcessing._internal(this._name);

  static const BlackAndWhite = ColorProcessing._internal("BlackAndWhite");
  static const Grayscale = ColorProcessing._internal("Grayscale");
  static const FullColor = ColorProcessing._internal("FullColor");

  static final _values = [BlackAndWhite, Grayscale, FullColor];

  static ColorProcessing fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      ColorProcessing d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return FullColor;
  }

  static ColorProcessing fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return ColorProcessing.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class Resolution {
  final int width;
  final int height;

  const Resolution(this.width, this.height);

  Map<String, dynamic> toMap() {
    return {
      "width": width,
      "height": height,
    };
  }

  static Resolution fromMap(Map<dynamic, dynamic> map) {
    int width = map["width"];
    int height = map["height"];
    return Resolution(width, height);
  }
}

class ScanPaperSource {
  final int _value;

  const ScanPaperSource._internal(this._value);

  static const AUTO = ScanPaperSource._internal(0);
  static const ADF = ScanPaperSource._internal(1);
  static const FB = ScanPaperSource._internal(2);

  static final _values = [AUTO, ADF, FB];

  int toValue() {
    return this._value;
  }

  static ScanPaperSource fromValue(int value) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      ScanPaperSource d = _values[var3];
      if (d.toValue() == value) {
        return d;
      }
    }
    return null;
  }

  static ScanPaperSource fromMap(Map<dynamic, dynamic> map) {
    int value = map["value"];
    return ScanPaperSource.fromValue(value);
  }

  Map<String, dynamic> toMap() {
    return {"value": _value};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class ScanSpecialMode {
  final int _value;

  const ScanSpecialMode._internal(this._value);

  static const NORMAL_SCAN = ScanSpecialMode._internal(0);
  static const EDGE_SCAN = ScanSpecialMode._internal(1);
  static const ORIGINAL_SCAN = ScanSpecialMode._internal(2);
  static const CORNER_SCAN = ScanSpecialMode._internal(3);
  static const SKEW_ADJUST = ScanSpecialMode._internal(4);
  static const OVER_SCAN = ScanSpecialMode._internal(5);
  static const LABEL_SCAN_CIRCLE = ScanSpecialMode._internal(6);
  static const LABEL_SCAN_SQUARE = ScanSpecialMode._internal(7);
  static const COPYQUALITY_SCAN = ScanSpecialMode._internal(8);

  static final _values = [
    NORMAL_SCAN,
    EDGE_SCAN,
    ORIGINAL_SCAN,
    CORNER_SCAN,
    SKEW_ADJUST,
    OVER_SCAN,
    LABEL_SCAN_CIRCLE,
    LABEL_SCAN_SQUARE,
    COPYQUALITY_SCAN
  ];

  int toValue() {
    return this._value;
  }

  static ScanSpecialMode fromValue(int v) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      ScanSpecialMode d = _values[var3];
      if (d.toValue() == v) {
        return d;
      }
    }

    return null;
  }

  static ScanSpecialMode fromMap(Map<dynamic, dynamic> map) {
    int value = map["value"];
    return ScanSpecialMode.fromValue(value);
  }

  Map<String, dynamic> toMap() {
    return {"value": _value};
  }
}

class JobState {
  final String _name;
  const JobState._internal(this._name);

 static const SuccessJob = JobState._internal("SuccessJob");
 static const ErrorJob = JobState._internal("SuccessJob");
 static const ErrorJobConnectionFailure = JobState._internal("SuccessJob");
 static const ErrorJobParameterInvalid = JobState._internal("SuccessJob");
 static const ErrorJobCancel = JobState._internal("SuccessJob");

  static final _values = [
    SuccessJob,
    ErrorJob,
    ErrorJobConnectionFailure,
    ErrorJobParameterInvalid,
    ErrorJobCancel
  ];

  static JobState fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      JobState d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return ErrorJob;
  }

  static JobState fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return JobState.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
