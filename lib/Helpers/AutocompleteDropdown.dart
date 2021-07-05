import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

Future<TypeAheadField<Object>> _showAutoTextCompleteDropdown({
  required String label,
  required Function textCallback,
  required Function setStateCallback,
  required Function suggestionCallback,
  required bool autoFocus,
}) async {
  // print(textCallback());
  return TypeAheadField(
    textFieldConfiguration: TextFieldConfiguration(
      autofocus: autoFocus,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 20,
        ),
        border: OutlineInputBorder(),
      ),
    ),
    suggestionsCallback: (pattern) async {
      return await suggestionCallback(pattern);
    },
    itemBuilder: (context, suggestion) {
      return ListTile(
        leading: Icon(Icons.business),
        title: suggestion == "Not Found Anything"
            ? Text("Not Found Anything")
            : Text(textCallback(suggestion)),
      );
    },
    onSuggestionSelected: (suggestion) {
      setStateCallback(suggestion);
    },
    hideSuggestionsOnKeyboardHide: true,
  );
}

additionalAutoComplete({
  name,
  text,
  onPressCallback,
  textCallback,
  stateCallback,
  suggestionCallback,
  label,
  autoFocus = false,
}) {
  return name.getId() != '-1'
      ? Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onPressCallback,
                    icon: Icon(Icons.settings_backup_restore),
                  )
                ],
              ),
            ),
            // Divider(
            //   thickness: 3,
            // ),
          ],
        )
      : FutureBuilder<Widget>(
          future: _showAutoTextCompleteDropdown(
            label: label,
            textCallback: textCallback,
            setStateCallback: stateCallback,
            suggestionCallback: suggestionCallback,
            autoFocus: autoFocus,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data as Widget;
            } else if (snapshot.hasError) {
              return Text("Error");
            }
            return CircularProgressIndicator();
          },
        );
}
