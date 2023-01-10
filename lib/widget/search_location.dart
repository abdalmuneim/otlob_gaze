// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// 📦 Package imports:
import 'package:http/http.dart' as http;
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/constants/assets.dart';
import 'package:otlob_gas/common/constants/urls.dart';
import 'package:search_map_location/utils/google_search/geo_coding.dart';
import 'package:search_map_location/utils/google_search/latlng.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:search_map_location/utils/google_search/place_type.dart';

class SearchLocation extends StatefulWidget {
  //final Key ? key;

  /// API Key of the Google Maps API.
  final String apiKey;
  //text change im search
  final void Function(String value)? onChangeText;

  final void Function()? onClearIconPress;

  /// Placeholder text to show when the user has not entered any input.
  final String placeholder;

  /// The callback that is called when one Place is selected by the user.
  final void Function(Place place)? onSelected;

  /// The callback that is called when the user taps on the search icon.
  final void Function(Place place)? onSearch;

  /// Language used for the autocompletion.
  ///
  /// Check the full list of [supported languages](https://developers.google.com/maps/faq#languagesupport) for the Google Maps API
  final String language;

  /// set search only work for a country
  ///
  /// While using country don't use LatLng and radius
  final String? country;

  /// The point around which you wish to retrieve place information.
  ///
  /// If this value is provided, `radius` must be provided aswell.
  final LatLng? location;

  /// The distance (in meters) within which to return place results. Note that setting a radius biases results to the indicated area, but may not fully restrict results to the specified area.
  ///
  /// If this value is provided, `location` must be provided aswell.
  ///
  /// See [Location Biasing and Location Restrict](https://developers.google.com/places/web-service/autocomplete#location_biasing) in the documentation.
  final int? radius;

  /// Returns only those places that are strictly within the region defined by location and radius. This is a restriction, rather than a bias, meaning that results outside this region will not be returned even if they match the user input.
  final bool strictBounds;

  /// Place type to filter the search. This is a tool that can be used if you only want to search for a specific type of location. If this no place type is provided, all types of places are searched. For more info on location types, check https://developers.google.com/places/web-service/autocomplete?#place_types
  final PlaceType? placeType;

  /// The initial icon to show in the search box
  final IconData icon;

  /// Makes available "clear textfield" button when the user is writing.
  final bool hasClearButton;

  /// The icon to show indicating the "clear textfield" button
  final IconData clearIcon;

  /// The color of the icon to show in the search box
  final Color iconColor;
  final TextEditingController textEditingController;
  final String prefixText;

  /// Enables Dark Mode when set to `true`. Default value is `false`.
  final bool darkMode;
  final FormFieldValidator<String>? validator;
  final ScrollController scrollController;
  const SearchLocation({
    this.validator,
    required this.scrollController,
    required this.textEditingController,
    required this.apiKey,
    this.placeholder = 'Search',
    this.icon = Icons.search,
    this.hasClearButton = true,
    this.clearIcon = Icons.clear,
    this.iconColor = Colors.blue,
    this.onSelected,
    this.onSearch,
    this.onChangeText,
    this.onClearIconPress,
    this.language = 'en',
    this.country,
    this.location,
    this.radius,
    this.strictBounds = false,
    this.placeType,
    this.darkMode = false,
    Key? key,
    this.prefixText = "",
  }) : super(key: key);

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation>
    with TickerProviderStateMixin {
  late TextEditingController _textEditingController;
  late AnimationController _animationController;
  // SearchContainer height.
  Animation? _containerHeight;
  // Place options opacity.
  Animation? _listOpacity;

  List<dynamic> _placePredictions = [];
  bool _isEditing = false;
  Geocoding? geocode;

  String _tempInput = '';
  String _currentInput = '';

  final FocusNode _fn = FocusNode();

  @override
  void initState() {
    _textEditingController = widget.textEditingController;

    geocode = Geocoding(apiKey: widget.apiKey, language: widget.language);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _containerHeight = Tween<double>(begin: 60, end: 364).animate(
      CurvedAnimation(
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );
    _listOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );

    _textEditingController.addListener(_autocompletePlace);
    customListener();

    super.initState();
  }

  void _autocompletePlace() async {
    if (_fn.hasFocus) {
      setState(() {
        _currentInput = _textEditingController.text;
        _isEditing = true;
      });

      _textEditingController.removeListener(_autocompletePlace);

      if (_currentInput.isEmpty) {
        if (!_containerHeight!.isDismissed) _closeSearch();
        _textEditingController.addListener(_autocompletePlace);
        return;
      }

      if (_currentInput == _tempInput) {
        final predictions = await _makeRequest(_currentInput);
        await _animationController.animateTo(0.5);
        setState(() => _placePredictions = predictions);
        await _animationController.forward();

        _textEditingController.addListener(_autocompletePlace);
        return;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        _textEditingController.addListener(_autocompletePlace);
        if (_isEditing == true) _autocompletePlace();
      });
    }
  }

  Future<dynamic> _makeRequest(input) async {
    //
    String url = Urls.mapSearch(input: input, language: widget.language);

    if (widget.location != null && widget.radius != null) {
      url +=
          '&location=${widget.location!.latitude},${widget.location!.longitude}&radius=${widget.radius}';
      if (widget.strictBounds) {
        url += '&strictbounds';
      }
    }

    if (widget.placeType != null) {
      url += '&types=${widget.placeType!.apiString}';
    }

    if (widget.country != null) {
      url += '&components=country:${widget.country}';
    }

    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body);

    if (extractedData['error_message'] != null) {
      var error = extractedData['error_message'];
      if (error == 'This API project is not authorized to use this API.') {
        error +=
            ' Make sure the Places API is activated on your Google Cloud Platform';
      }
      throw Exception(error);
    } else {
      final predictions = extractedData['predictions'];
      return predictions;
    }
  }

  void _selectPlace({Place? prediction}) async {
    if (prediction != null) {
      _textEditingController.value = TextEditingValue(
        text: prediction.description,
        selection: TextSelection.collapsed(
          offset: prediction.description.length,
        ),
      );
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Makes animation
    _closeSearch();

    // Calls the `onSelected` callback
    if (prediction is Place) widget.onSelected!(prediction);
  }

  void _closeSearch() async {
    if (!_animationController.isDismissed) {
      await _animationController.animateTo(0.5);
    }
    _fn.unfocus();
    setState(() {
      _placePredictions = [];
      _isEditing = false;
    });
    _animationController.reverse();
    _textEditingController.addListener(_autocompletePlace);
  }

  void customListener() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _tempInput = _textEditingController.text;
          if (_placePredictions.isNotEmpty) {
            widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent - 200,
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
            );
          }
        });
        customListener();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _searchContainer(
        child: _searchInput(context),
      ),
    );
  }

  double extraHeight = 5;
  Widget _searchContainer({required Widget child}) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return SizedBox(
            height: _containerHeight!.value + extraHeight,
            child: Column(
              children: <Widget>[
                child,
                if (_placePredictions.isNotEmpty)
                  Opacity(
                    opacity: _listOpacity!.value,
                    child: Column(
                      children: <Widget>[
                        for (var prediction in _placePredictions)
                          _placeOption(Place.fromJSON(prediction, geocode!)),
                      ],
                    ),
                  ),
              ],
            ),
          );
        });
  }

  Widget _placeOption(Place prediction) {
    String place = prediction.description;

    return MaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      onPressed: () => _selectPlace(prediction: prediction),
      child: ListTile(
        title: Text(
          place.length < 45
              ? place
              : "${place.replaceRange(45, place.length, "")} ...",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: widget.darkMode ? Colors.grey[100] : Colors.grey[850],
          ),
          maxLines: 1,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 0,
        ),
      ),
    );
  }

  Widget _searchInput(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (widget.validator == null) {
          extraHeight = 0;
          setState(() {});
          return null;
        }
        if (widget.validator!(value) == null) {
          extraHeight = 0;
          setState(() {});
        } else {
          extraHeight = 40;
          setState(() {});
        }
        return widget.validator!(value);
      },
      onChanged: (value) {
        if (widget.onChangeText != null) {
          widget.onChangeText!(value);
        }
      },
      decoration: _inputStyle(),
      controller: _textEditingController,
      onFieldSubmitted: (_) => _selectPlace(),
      onEditingComplete: _selectPlace,
      autofocus: false,
      focusNode: _fn,
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.04,
        color: widget.darkMode ? Colors.grey[100] : Colors.grey[850],
      ),
    );
  }

  InputDecoration _inputStyle() {
    return InputDecoration(
      errorMaxLines: 3,
      hintText: widget.placeholder,
      prefixText: widget.prefixText,
      prefixIcon: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey[300],
        child: SvgPicture.asset(
          Assets.locationOutlinedIC,
          color: AppColors.mainApp,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(70)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(70)),
      fillColor: Colors.grey.shade200,
      filled: false,
      suffixIcon:
          widget.hasClearButton && _textEditingController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _textEditingController.clear();
                    if (widget.onClearIconPress != null) {
                      widget.onClearIconPress!();
                    }
                  },
                  icon: Icon(widget.clearIcon))
              : null,
      hintStyle: Theme.of(context).textTheme.headlineSmall,
      errorStyle: Theme.of(context).textTheme.labelMedium,
    );
  }
}
