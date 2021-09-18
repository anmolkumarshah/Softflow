import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

Future<TypeAheadField<Object>> _showAutoTextCompleteDropdown({
  required String label,
  required Function textCallback,
  required Function setStateCallback,
  required Function suggestionCallback,
  required bool autoFocus,
  required TextEditingController controller,
  bool enable = true,
}) async {
  return TypeAheadField(
    textFieldConfiguration: TextFieldConfiguration(
      autofocus: autoFocus,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            // fontSize: 25,
            ),
        border: OutlineInputBorder(),
      ),
      controller: controller,
      enabled: enable,
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
      controller.text = textCallback(suggestion);
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
  controller,
  enable = true,
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
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        text.toString().split(':')[0] + " : ",
                        style: TextStyle(
                            // fontSize: 18,
                            ),
                      ),
                      Container(
                        width: 150,
                        child: Text(
                          text.toString().split(':')[1],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: onPressCallback,
                    icon: Icon(Icons.clear),
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
            controller: controller,
            enable: enable,
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
