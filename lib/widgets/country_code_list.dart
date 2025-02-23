import 'package:extended_phone_number_input/models/country.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:flutter/material.dart';

class CountryCodeList extends StatefulWidget {
  final PhoneNumberInputController phoneNumberInputController;
  final bool allowSearch;
  final String? searchHint;
  final TextStyle? dialCodeTextStyle;
  const CountryCodeList({
    Key? key,
    this.dialCodeTextStyle,
    required this.phoneNumberInputController,
    this.allowSearch = true,
    this.searchHint = 'Search...',
  }) : super(key: key);

  @override
  State createState() => _CountryCodeListState();
}

class _CountryCodeListState extends State<CountryCodeList> {
  final TextEditingController _searchController =
      TextEditingController(text: '');
  late List<Country> _countries;

  @override
  void initState() {
    _countries = widget.phoneNumberInputController.getCountries;
    _searchController.addListener(_refresh);
    super.initState();
  }

  void _refresh() {
    widget.phoneNumberInputController.searchKey =
        _searchController.text.toLowerCase();
    setState(() {
      _countries = widget.phoneNumberInputController.getCountries;
    });
  }

  @override
  void dispose() {
    widget.phoneNumberInputController.resetSearch();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
          if (widget.allowSearch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _countries.length,
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      widget.phoneNumberInputController.selectedCountry =
                          _countries[index];
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              _countries[index].flagPath,
                              width: 24,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _countries[index].dialCode,
                            style: widget.dialCodeTextStyle
                                    ?.copyWith(fontWeight: FontWeight.bold) ??
                                TextStyle(
                                    color: Theme.of(context).primaryColor),
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _countries[index].name,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
