import 'package:event_app/redux_store/store.dart' show QueryOptions;
import 'package:flutter/material.dart';

/// * Search settings dialog
class FilterOptions extends StatefulWidget {
  factory FilterOptions.fromEventStore(
      Map<QueryOptions, String> searchOptions) {
    // Parse all data to a map to be used in dialog
    // TODO: Clean this code by directly using this type of object in store
    // or using store data directly here
    Map parsedSearchOptions = {};

    // Sort data
    if (searchOptions.containsKey(QueryOptions.BYSTART)) {
      parsedSearchOptions["SORT"] = "start";
    } else if (searchOptions.containsKey(QueryOptions.BYEND)) {
      parsedSearchOptions["SORT"] = "end";
    } else {
      parsedSearchOptions["SORT"] = "eventName";
    }

    // Order data
    if (searchOptions.containsKey(QueryOptions.DESCENDING)) {
      parsedSearchOptions["ORDER"] = "desc";
    } else {
      parsedSearchOptions["ORDER"] = "asc";
    }

    // Limit data
    if (searchOptions.containsKey(QueryOptions.LIMIT)) {
      parsedSearchOptions["LIMITCHK"] = true;
      parsedSearchOptions["LIMITVAL"] = searchOptions[QueryOptions.LIMIT];
    } else {
      parsedSearchOptions["LIMITCHK"] = false;
      parsedSearchOptions["LIMITVAL"] = "10";
    }

    // Factory return
    return FilterOptions(parsedSearchOptions);
  }

  FilterOptions(this.searchOptions);
  final Map searchOptions;

  @override
  State<StatefulWidget> createState() => FilterOptionsState();
}

class FilterOptionsState extends State<FilterOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Filter Results"),
      ),
      body: _buildOptions(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleSaveButtonPressed,
        child: Icon(Icons.save_alt),
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildLimitOptions(context),
        _buildSortByOptions(context),
        _buildOrderByOptions(context),
      ],
    );
  }

  /// Sort options
  Widget _buildSortByOptions(BuildContext context) {
    return _buildExpansionTile(
      context: context,
      icon: Icons.sort,
      title: "Sort",
      children: <Widget>[
        _buildRadioButton(context, "Sort By Start Date",
            "Will be sorted using start date/time", "SORT", "start"),
        _buildRadioButton(context, "Sort By End Date",
            "Will be sorted using end date/time", "SORT", "end"),
        _buildRadioButton(context, "Sort By Event Name",
            "Will be sorted using name of event", "SORT", "eventName"),
      ],
    );
  }

  /// Order options
  Widget _buildOrderByOptions(BuildContext context) {
    return _buildExpansionTile(
      context: context,
      icon: Icons.swap_vert,
      title: "Order",
      children: <Widget>[
        _buildRadioButton(context, "Ascending",
            "Will be sorted in increasing order", "ORDER", "asc"),
        _buildRadioButton(context, "Descending",
            "Will be sorted in increasing order", "ORDER", "desc"),
      ],
    );
  }

  /// Limit options
  Widget _buildLimitOptions(BuildContext context) {
    return _buildExpansionTile(
      context: context,
      icon: Icons.plus_one,
      title: "Limit Results",
      children: <Widget>[
        _buildCheckBox(
          context,
          "Limit Results",
          "Limits result to a number. If unchecked all results will be shown.",
          "LIMITCHK",
        ),
        // Slider box to get limit
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Slider(
            value: double.parse(this.widget.searchOptions["LIMITVAL"]),
            max: 100.0,
            min: 10.0,
            divisions: 9,
            onChanged: this.widget.searchOptions["LIMITCHK"]
                ? (v) => setState(() => this.widget.searchOptions["LIMITVAL"] =
                    v.toInt().toString())
                : null,
            label: this.widget.searchOptions["LIMITVAL"].toString(),
          ),
        ),
      ],
    );
  }

  /// Build Check box
  Widget _buildCheckBox(
      BuildContext context, String text, String message, String key) {
    return CheckboxListTile(
      title: Text(text),
      subtitle: Text(message),
      value: this.widget.searchOptions[key],
      onChanged: (v) => setState(() => this.widget.searchOptions[key] = v),
      activeColor: Theme.of(context).primaryColor,
    );
  }

  /// Build Check box
  Widget _buildRadioButton(BuildContext context, String text, String subtitle,
      String group, String key) {
    return RadioListTile(
      value: key,
      activeColor: Theme.of(context).primaryColor,
      groupValue: this.widget.searchOptions[group],
      onChanged: (v) => setState(() => this.widget.searchOptions[group] = key),
      title: Text(text),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildExpansionTile(
      {BuildContext context,
      IconData icon,
      String title,
      List<Widget> children}) {
    return ExpansionTile(
      title: Text(title),
      leading: Icon(
        icon,
        color: Theme.of(context).accentColor,
      ),
      children: children,
      initiallyExpanded: true,
    );
  }

  // Save and Close dialog
  // Tapping elsewhere will close without saving
  void _handleSaveButtonPressed() {
    // Parse back to store data format
    Map<QueryOptions, String> parsedSearchOptions = {};

    // Sort Option
    if (this.widget.searchOptions["SORT"] == "start") {
      parsedSearchOptions[QueryOptions.BYSTART] = "";
    } else if (this.widget.searchOptions["SORT"] == "end") {
      parsedSearchOptions[QueryOptions.BYEND] = "";
    } else {
      parsedSearchOptions[QueryOptions.BYNAME] = "";
    }

    // Order Option
    if (this.widget.searchOptions["ORDER"] == "desc") {
      parsedSearchOptions[QueryOptions.DESCENDING] = "";
    }

    // Limit Option
    if (this.widget.searchOptions["LIMITCHK"] == true) {
      parsedSearchOptions[QueryOptions.LIMIT] =
          this.widget.searchOptions["LIMITVAL"];
    } else {
      parsedSearchOptions[QueryOptions.ALL] = "";
    }

    // Return value
    Navigator.pop(context, parsedSearchOptions);
  }
}
