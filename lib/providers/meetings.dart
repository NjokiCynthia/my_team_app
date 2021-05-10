Future<void> fetchAndSetUserGroups() async {
  const url = EndpointUrl.GET_GROUPS;
  try {
    final postRequest = json.encode({
      "user_id": _userId,
    });
    try {
      final response = await PostToServer.post(postRequest, url);

      //=== BEGIN: OFFLINE PLUG
      //=== Check if record exists...
      bool _exists = await entryExistsInDb(
        DatabaseHelper.dataTable,
        "section",
        "groups",
      );
      //=== ...if it doesn't exist, insert it.
      if (!_exists) {
        await insertToLocalDb(
          DatabaseHelper.dataTable,
          {
            "section": "groups",
            "value": jsonEncode(response['user_groups']),
            "modified_on": DateTime.now().millisecondsSinceEpoch,
          },
        );
      }
      //=== If it does exist, update it.
      else {
        dynamic _groups = await getLocalData('groups');
        await updateInLocalDb(
          DatabaseHelper.dataTable,
          {
            "id": _groups['id'],
            "section": "groups",
            "value": jsonEncode(response['user_groups']),
            "modified_on": DateTime.now().millisecondsSinceEpoch,
          },
        );
      }
      //=== END: OFFLINE PLUG

      final userGroups = response['user_groups'] as List<dynamic>;
      addGroups(userGroups);
    } on CustomException catch (error) {
      if (error.status == ErrorStatusCode.statusNoInternet) {
        //=== BEGIN: OFFLINE PLUG
        dynamic _localData = await getLocalData('groups');
        if (_localData['value'] != null) {
          final userGroups = _localData['value'] as List<dynamic>;
          addGroups(userGroups);
        }
        //=== END: OFFLINE PLUG
      } else {
        throw CustomException(message: error.message, status: error.status);
      }
    } catch (error) {
      throw CustomException(message: error.message);
    }
  } on CustomException catch (error) {
    if (error.status == ErrorStatusCode.statusNoInternet) {
      //=== BEGIN: OFFLINE PLUG
      dynamic _localData = await getLocalData('groups');
      if (_localData['value'] != null) {
        final userGroups = _localData['value'] as List<dynamic>;
        addGroups(userGroups);
      }
      //=== END: OFFLINE PLUG
    } else {
      throw CustomException(message: error.message, status: error.status);
    }
  } catch (error) {
    throw CustomException(message: ERROR_MESSAGE);
  }
}
