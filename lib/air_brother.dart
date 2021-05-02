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
    return _isScanSupported;
  }

  bool isPrintSupported() {
    return _isPrintSupported;
  }

  bool isFaxSupported() {
    return _isFaxSupported;
  }

  Future<JobState> performScan(
      ScanParameters scanParams, List<String> outScannedPaths) async {
    var params = {
      "connector": this.toMap(),
      "scanParams": scanParams.toMap()
    };

    final Map<dynamic, dynamic> resultMap =
        await AirBrother._channel.invokeMethod("performScan", params);

    JobState jobState = JobState.fromMap(resultMap["jobState"]);

    List<dynamic> scannedPaths = resultMap["scannedPaths"];
    scannedPaths.forEach((element) {
      outScannedPaths.add(element);
    });

    return jobState;
  }

  Future<JobState> performPrint(
      PrintParameters printParams, List<String> pathsToPrint) async {
    var params = {
      "connector": this.toMap(),
      "filePaths": pathsToPrint,
      "printParams": printParams.toMap()};

    if (!isPrintSupported()) {
      return JobState.ErrorJob;
    }

    final Map<dynamic, dynamic> resultMap = await AirBrother._channel.invokeMethod("performPrint", params);

    JobState jobState = JobState.fromMap(resultMap);

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
  static const ErrorJob = JobState._internal("ErrorJob");
  static const ErrorJobConnectionFailure = JobState._internal("ErrorJobConnectionFailure");
  static const ErrorJobParameterInvalid = JobState._internal("ErrorJobParameterInvalid");
  static const ErrorJobCancel = JobState._internal("ErrorJobCancel");

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

class PrintParameters {
  MediaSize paperSize;
  PrintMediaType mediaType;
  Duplex duplex;
  ColorProcessing color;
  PrintOrientation orientation;
  PrintScale scale;
  PrintQuality quality;
  Resolution resolution;
  PrintMargin margin;
  ContentType printContent;
  int copyCount;
  PrintCollate collate;
  PrintOrigin origin;
  PrintColorMatching colorMatching;
  PrintCustomScaling customScaling;
  bool directPrinting;

  PrintParameters(
      {this.paperSize = MediaSize.A4,
      this.mediaType = PrintMediaType.Plain,
      this.duplex = Duplex.Simplex,
      this.color = ColorProcessing.FullColor,
      this.orientation = PrintOrientation.AutoRotation,
      this.scale = PrintScale.NoScalingAtPrintableAreaCenter,
      this.quality = PrintQuality.Draft,
      this.resolution = const Resolution(300, 300),
      this.margin = PrintMargin.Normal,
      this.printContent = ContentType.IMAGE_JPEG,
      this.copyCount = 1,
      this.collate = PrintCollate.OFF,
      this.colorMatching = PrintColorMatching.ContentOriginal,
      this.origin = const PrintOrigin(),
      this.customScaling = const PrintCustomScaling(),
      this.directPrinting = false});

  static fromMap(Map<dynamic, dynamic> map) {
    return PrintParameters(
        paperSize: MediaSize.fromMap(map["paperSize"]),
        mediaType: PrintMediaType.fromMap(map["mediaType"]),
        duplex: Duplex.fromMap(map["duplex"]),
        color: ColorProcessing.fromMap(map["color"]),
        orientation: PrintOrientation.fromMap(map["orientation"]),
        scale: PrintScale.fromMap(map["scale"]),
        quality: PrintQuality.fromMap(map["quality"]),
        resolution: Resolution.fromMap(map["resolution"]),
        margin: PrintMargin.fromMap(map["margin"]),
        printContent: ContentType.fromMap(map["printContent"]),
        copyCount: map["copyCount"],
        collate: PrintCollate.fromMap(map["collate"]),
        colorMatching: PrintColorMatching.fromMap(map["colorMatching"]),
        origin: PrintOrigin.fromMap(map["origin"]),
        customScaling: PrintCustomScaling.fromMap(map["customScaling"]),
        directPrinting: map["directPrinting"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "paperSize": paperSize.toMap(),
      "mediaType": mediaType.toMap(),
      "duplex": duplex.toMap(),
      "color": color.toMap(),
      "orientation": orientation.toMap(),
      "scale": scale.toMap(),
      "quality": quality.toMap(),
      "resolution": resolution.toMap(),
      "margin": margin.toMap(),
      "printContent": printContent.toMap(),
      "copyCount": copyCount,
      "collate": collate.toMap(),
      "colorMatching": colorMatching.toMap(),
      "origin": origin.toMap(),
      "customScaling": customScaling.toMap(),
      "directPrinting": directPrinting
    };
  }
}

class PrintMediaType {
  final String _name;

  const PrintMediaType._internal(this._name);

  static const Plain = PrintMediaType._internal("Plain");
  static const Photographic = PrintMediaType._internal("Photographic");
  static const InkjetPaper = PrintMediaType._internal("InkjetPaper");
  static const Transparency = PrintMediaType._internal("Transparency");
  static const ThinPaper = PrintMediaType._internal("ThinPaper");
  static const RecycledPaper = PrintMediaType._internal("RecycledPaper");

  static final _values = [
    Plain,
    Photographic,
    InkjetPaper,
    Transparency,
    ThinPaper,
    RecycledPaper
  ];

  static PrintMediaType fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      PrintMediaType d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return Plain;
  }

  static PrintMediaType fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return PrintMediaType.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class PrintOrientation {
  final String _name;

  const PrintOrientation._internal(this._name);

  static const Portrait = const PrintOrientation._internal("Portrait");
  static const Landscape = const PrintOrientation._internal("Landscape");
  static const AutoRotation = const PrintOrientation._internal("AutoRotation");

  static final _values = [Portrait, Landscape, AutoRotation];

  static PrintOrientation fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      PrintOrientation d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return Portrait;
  }

  static PrintOrientation fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return PrintOrientation.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class PrintScale {
  final String _name;

  const PrintScale._internal(this._name);

  static const NoScaling = PrintScale._internal("NoScaling");
  static const FitToPrintableArea = PrintScale._internal("FitToPrintableArea");
  static const UniformFitToPrintableArea =
      PrintScale._internal("UniformFitToPrintableArea");
  static const UniformFillPrintableArea =
      PrintScale._internal("UniformFillPrintableArea");
  static const CustomScaling = PrintScale._internal("CustomScaling");
  static const NoScalingAtPrintableAreaCenter =
      PrintScale._internal("NoScalingAtPrintableAreaCenter");

  static final _values = [
    NoScaling,
    FitToPrintableArea,
    UniformFitToPrintableArea,
    UniformFillPrintableArea,
    CustomScaling,
    NoScalingAtPrintableAreaCenter
  ];

  static PrintScale fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      PrintScale d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return NoScaling;
  }

  static PrintScale fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return PrintScale.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class PrintQuality {
  final String _name;

  const PrintQuality._internal(this._name);

  static const Draft = PrintQuality._internal("Draft");
  static const Document = PrintQuality._internal("Document");
  static const WebPage = PrintQuality._internal("WebPage");
  static const Photographic = PrintQuality._internal("Photographic");

  static final _values = [Draft, Document, WebPage, Photographic];

  static PrintQuality fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      PrintQuality d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return Draft;
  }

  static PrintQuality fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return PrintQuality.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class PrintMargin {
  final String _name;

  const PrintMargin._internal(this._name);

  static const Normal = PrintMargin._internal("Normal");
  static const Borderless = PrintMediaType._internal("Borderless");

  static final _values = [Normal, Borderless];

  static PrintMargin fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      PrintMargin d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return Normal;
  }

  static PrintMargin fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return PrintMargin.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class ContentType {
  final String _name;

  const ContentType._internal(this._name);

  static const IMAGE_JPEG = ContentType._internal("IMAGE_JPEG");
  static const IMAGE_PNG = ContentType._internal("IMAGE_PNG");
  static const IMAGE_BMP = ContentType._internal("IMAGE_BMP");
  static const IMAGE_TIFF = ContentType._internal("IMAGE_TIFF");
  static const DOC_PDF = ContentType._internal("DOC_PDF");
  static const DOC_MS_WORD = ContentType._internal("DOC_MS_WORD");
  static const DOC_MS_EXCEL = ContentType._internal("DOC_MS_EXCEL");
  static const DOC_MS_POWERPOINT = ContentType._internal("DOC_MS_POWERPOINT");
  static const DOC_TEXT = ContentType._internal("DOC_TEXT");

  static final _values = [
    IMAGE_JPEG,
    IMAGE_PNG,
    IMAGE_BMP,
    IMAGE_TIFF,
    DOC_PDF,
    DOC_MS_WORD,
    DOC_MS_EXCEL,
    DOC_MS_POWERPOINT,
    DOC_TEXT
  ];

  static ContentType fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      ContentType d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return IMAGE_JPEG;
  }

  static ContentType fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return ContentType.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class PrintCollate {
  final String _name;

  const PrintCollate._internal(this._name);

  static const ON = PrintCollate._internal("ON");
  static const OFF = PrintCollate._internal("OFF");

  static final _values = [ON, OFF];

  static PrintCollate fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      PrintCollate d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return OFF;
  }

  static PrintCollate fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return PrintCollate.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class PrintOrigin {
  final double inchX;
  final double inchY;

  const PrintOrigin({this.inchX = 0, this.inchY = 0});

  static PrintOrigin fromMap(Map<dynamic, dynamic> map) {
    double x = map["inchX"];
    double y = map["inchX"];

    return PrintOrigin(inchX: x, inchY: y);
  }

  Map<String, dynamic> toMap() {
    return {"inchX": inchX, "inchY": inchY};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class PrintColorMatching {
  final String _name;

  const PrintColorMatching._internal(this._name);

  static const ContentOriginal =
      PrintColorMatching._internal("ContentOriginal");
  static const SlowDryPrint = PrintColorMatching._internal("SlowDryPrint");
  static const CopyQuality = PrintColorMatching._internal("CopyQuality");

  static final _values = [ContentOriginal, SlowDryPrint, CopyQuality];

  static PrintColorMatching fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      PrintColorMatching d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return ContentOriginal;
  }

  static PrintColorMatching fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return PrintColorMatching.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class PrintCustomScaling {
  final double scaleX;
  final double scaleY;
  final HorizontalAlignment hAlignment;
  final VerticalAlignment vAlignment;

  const PrintCustomScaling({
    this.hAlignment = HorizontalAlignment.LEFT,
    this.vAlignment = VerticalAlignment.TOP,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
  });

  static PrintCustomScaling fromMap(Map<dynamic, dynamic> map) {
    return PrintCustomScaling(
      hAlignment: HorizontalAlignment.fromMap(map["hAlignment"]),
      vAlignment: VerticalAlignment.fromMap(map["vAlignment"]),
      scaleX: map["scaleX"],
      scaleY: map["scaleY"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "hAlignment": hAlignment.toMap(),
      "vAlignment": vAlignment.toMap(),
      "scaleX": scaleX,
      "scaleY": scaleY
    };
  }
}

class HorizontalAlignment {
  final String _name;

  const HorizontalAlignment._internal(this._name);

  static const UNDEFINED = const HorizontalAlignment._internal("UNDEFINED");
  static const LEFT = const HorizontalAlignment._internal("LEFT");
  static const CENTER = const HorizontalAlignment._internal("CENTER");
  static const RIGHT = const HorizontalAlignment._internal("RIGHT");

  static final _values = [UNDEFINED, LEFT, CENTER, RIGHT];

  static HorizontalAlignment fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      HorizontalAlignment d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return UNDEFINED;
  }

  static HorizontalAlignment fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return HorizontalAlignment.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class VerticalAlignment {
  final String _name;

  const VerticalAlignment._internal(this._name);

  static const UNDEFINED = const VerticalAlignment._internal("UNDEFINED");
  static const TOP = const VerticalAlignment._internal("TOP");
  static const CENTER = const VerticalAlignment._internal("CENTER");
  static const BOTTOM = const VerticalAlignment._internal("BOTTOM");

  static final _values = [UNDEFINED, TOP, CENTER, BOTTOM];

  static VerticalAlignment fromName(String name) {
    int var2 = _values.length;

    for (int var3 = 0; var3 < var2; ++var3) {
      VerticalAlignment d = _values[var3];
      if (d._name == name) {
        return d;
      }
    }

    return UNDEFINED;
  }

  static VerticalAlignment fromMap(Map<dynamic, dynamic> map) {
    String name = map["name"];
    return VerticalAlignment.fromName(name);
  }

  Map<String, dynamic> toMap() {
    return {"name": _name};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
