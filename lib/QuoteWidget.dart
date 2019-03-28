import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class QuoteState extends State<Quote> with TickerProviderStateMixin<Quote> {
  AnimationController _animationController;
  Animation<int> _animation;

  String _quote;
  String get quote =>_quote;
  set quote(String str) {
    void _animHandling(){
      setState(() {
        _dataString = _quote.substring(0, _animation.value);
        print(_dataString);
      });
    }

    if (_animation != null) {
      _animation.removeListener(_animHandling);
    }
    _quote = str;
    if (_quote != _dataString) {
      _animationController.reset();
      _animation = IntTween(begin: _dataString.length, end: _quote.length)
          .animate(_animationController)
        ..addListener(_animHandling);
    if(_quote.length > _dataString.length)
      _animationController.forward();
    else
      _animationController.reverse();
    }

  }

  String _dataString;

  @override
  void initState() {
    _dataString = '';
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style.inherit)
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    if (MediaQuery.boldTextOverride(context))
      effectiveTextStyle = effectiveTextStyle
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    Widget result = RichText(
      textAlign:
          widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection: widget
          .textDirection, // RichText uses Directionality.of to obtain a default if this is null.
      locale: widget
          .locale, // RichText uses Localizations.localeOf to obtain a default if this is null
      softWrap: widget.softWrap ?? defaultTextStyle.softWrap,
      overflow: widget.overflow ?? defaultTextStyle.overflow,
      textScaleFactor:
          widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context),
      maxLines: widget.maxLines ?? defaultTextStyle.maxLines,
      strutStyle: widget.strutStyle,
      text: TextSpan(
        style: effectiveTextStyle,
        text: '"$_dataString "',
        children: widget.textSpan != null ? <TextSpan>[widget.textSpan] : null,
      ),
    );
    if (widget.semanticsLabel != null) {
      result = Semantics(
          textDirection: widget.textDirection,
          label: widget.semanticsLabel,
          child: ExcludeSemantics(
            child: result,
          ));
    }
    return result;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('data', _dataString, showName: false));
    if (widget.textSpan != null) {
      properties.add(widget.textSpan.toDiagnosticsNode(
          name: 'textSpan', style: DiagnosticsTreeStyle.transition));
    }
    widget.style?.debugFillProperties(properties);
    properties.add(EnumProperty<TextAlign>('textAlign', widget.textAlign,
        defaultValue: null));
    properties.add(EnumProperty<TextDirection>(
        'textDirection', widget.textDirection,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Locale>('locale', widget.locale,
        defaultValue: null));
    properties.add(FlagProperty('softWrap',
        value: widget.softWrap,
        ifTrue: 'wrapping at box width',
        ifFalse: 'no wrapping except at line break characters',
        showName: true));
    properties.add(EnumProperty<TextOverflow>('overflow', widget.overflow,
        defaultValue: null));
    properties.add(DoubleProperty('textScaleFactor', widget.textScaleFactor,
        defaultValue: null));
    properties
        .add(IntProperty('maxLines', widget.maxLines, defaultValue: null));
    if (widget.semanticsLabel != null) {
      properties.add(StringProperty('semanticsLabel', widget.semanticsLabel));
    }
  }
}

class Quote extends StatefulWidget {
  /// Creates a text widget.
  ///
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  const Quote(
      {Key key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  })  :
        textSpan = null,
        super(key: key);

  /// The text to display as a [TextSpan].
  ///
  /// This will be null if [data] is provided instead.
  final TextSpan textSpan;

  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle style;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale locale;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  ///
  /// The value given to the constructor as textScaleFactor. If null, will
  /// use the [MediaQueryData.textScaleFactor] obtained from the ambient
  /// [MediaQuery], or 1.0 if there is no [MediaQuery] in scope.
  final double textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int maxLines;

  /// An alternative semantics label for this text.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text value:
  ///
  /// ```dart
  /// Text(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  final String semanticsLabel;

  @override
  State<StatefulWidget> createState() => QuoteState();
}
