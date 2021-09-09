import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static final _databaseName = "chamasoft-app.db";
  static final _databaseVersion = 5;

  static final dataTable = 'data';
  static final membersTable = 'members';
  static final meetingsTable = 'meetings';
  static final payContributionsTable = 'payContributions';
  static final contributionsTable = 'contributions';
  static final groupAccountsTable = 'groupAccounts';

  // create databases for the following tables:
  static final fineCategories = 'fineCategories';
  static final memberLoanOptions = 'memberLoanOptions';
  static final loanTypesTable = 'loanTypes';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    var documentsDirectory = await getDatabasesPath();
    String path = p.join(documentsDirectory, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // SQL code to create the database tables
  Future _onCreate(Database db, int version) async {
    print("oncreate Create");
    try {
      Batch batch = db.batch();
      // Settings table
      batch.execute('''
            CREATE TABLE IF NOT EXISTS $dataTable (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              section TEXT NOT NULL,
              value TEXT NOT NULL,
              modified_on INTEGER NOT NULL
            )
            ''');
      // Members table
      batch.execute('''
            CREATE TABLE IF NOT EXISTS $membersTable (
              _id INTEGER PRIMARY KEY AUTOINCREMENT,
              group_id INTEGER NOT NULL,
              id INTEGER NOT NULL,
              name TEXT NOT NULL DEFAULT '',
              avatar TEXT DEFAULT '',
              user_id INTEGER NOT NULL,
              identity TEXT NOT NULL DEFAULT '',
              modified_on INTEGER NOT NULL
            )
            ''');
      // Meetings table
      batch.execute('''
            CREATE TABLE IF NOT EXISTS $meetingsTable (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              group_id INTEGER NOT NULL,
              user_id INTEGER NOT NULL,
              title TEXT NOT NULL DEFAULT '',
              venue TEXT NOT NULL DEFAULT '',
              purpose TEXT NOT NULL DEFAULT '',
              date TEXT NOT NULL DEFAULT '',
              members TEXT NOT NULL DEFAULT '',
              agenda TEXT NOT NULL DEFAULT '',
              collections TEXT NOT NULL DEFAULT '',
              aob TEXT NOT NULL DEFAULT '',
              submitted_on INTEGER NOT NULL,
              synced INTEGER NOT NULL DEFAULT 0,
              synced_on INTEGER NOT NULL,
              modified_on INTEGER NOT NULL
            )
            ''');
      await batch.commit();
    } catch (error) {
      print("error1 $error");
    }
  }

  //upgrade tables after a database is created
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // In this case, oldVersion is 1, newVersion is 2
    print("oldVersion $oldVersion and new version $newVersion");
    if (oldVersion < newVersion) {
      try {
        Batch batch = db.batch();
        // Sample table to be used on upgrade
        // Contributions table
        batch.execute('''
            CREATE TABLE IF NOT EXISTS $payContributionsTable (
              _id INTEGER PRIMARY KEY AUTOINCREMENT,
              group_id INTEGER NOT NULL,
              id INTEGER NOT NULL,
              name TEXT NOT NULL DEFAULT '',
              active INTEGER NOT NULL DEFAULT 1,
              amount DOUBLE NOT NULL DEFAULT 0,
              is_hidden INTERGER NOT NULL DEFAULT 0,
              modified_on INTEGER NOT NULL
            )
            ''');

        // Fines Category table
        batch.execute('''
            CREATE TABLE IF NOT EXISTS $fineCategories (
              _id INTEGER PRIMARY KEY AUTOINCREMENT,
              group_id INTEGER NOT NULL,
              id INTEGER NOT NULL,
              name TEXT NOT NULL DEFAULT '',
              active INTEGER NOT NULL DEFAULT 1,
              amount DOUBLE NOT NULL DEFAULT 0,
              balance DOUBLE NOT NULL DEFAULT 0,
              modified_on INTEGER NOT NULL
            )
            ''');
        // Member loans options table
        batch.execute('''
            CREATE TABLE IF NOT EXISTS $memberLoanOptions (
              _id INTEGER PRIMARY KEY AUTOINCREMENT,
              id INTEGER NOT NULL,
              group_id INTEGER NOT NULL,
              member_id INTEGER NOT NULL,
              user_id INTEGER NOT NULL,
              is_selected INTEGER NOT NULL DEFAULT 0,
              description TEXT NOT NULL DEFAULT '',
              loanType TEXT NOT NULL DEFAULT '',
              amount DOUBLE NOT NULL DEFAULT 0,
              balance DOUBLE NOT NULL DEFAULT 0,
              modified_on INTEGER NOT NULL
            )
            ''');

        // Group contributions table
        batch.execute('''
            CREATE TABLE IF NOT EXISTS $contributionsTable (
              _id INTEGER PRIMARY KEY AUTOINCREMENT,
              id INTEGER NOT NULL,
              group_id INTEGER NOT NULL,
              amount DOUBLE NOT NULL DEFAULT 0,
              name TEXT NOT NULL DEFAULT '',
              type TEXT NOT NULL DEFAULT '',
              contribution_type TEXT NOT NULL DEFAULT '',
              frequency TEXT NOT NULL DEFAULT '',
              invoice_date TEXT NOT NULL DEFAULT '',
              contribution_date TEXT NOT NULL DEFAULT '',
              one_time_contribution_setting TEXT NOT NULL DEFAULT '',
              is_hidden INTERGER NOT NULL DEFAULT 0,
              active INTERGER NOT NULL DEFAULT 0,
              modified_on INTEGER NOT NULL
            )
            ''');

        // Group Accounts (banks/saccos/mobilemoney/pettycash)
        batch.execute('''
            CREATE TABLE IF NOT EXISTS $groupAccountsTable (
              _id INTEGER PRIMARY KEY AUTOINCREMENT,
              group_id INTEGER NOT NULL,
              value TEXT NOT NULL,
              modified_on INTEGER NOT NULL
            )
            ''');

        // Group Accounts (banks/saccos/mobilemoney/pettycash)
        batch.execute('''
            CREATE TABLE IF NOT EXISTS $loanTypesTable (
              _id INTEGER PRIMARY KEY AUTOINCREMENT,
              group_id INTEGER NOT NULL,
              value TEXT NOT NULL,
              modified_on INTEGER NOT NULL
            )
            ''');
        await batch.commit();
      } catch (error) {
        print("error2 $error");
      }
    }
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future batchInsert(List<dynamic> data, String table) async {
    try {
      Database db = await instance.database;
      Batch batch = db.batch();
      data.forEach((row) {
        batch.insert(table, row);
      });
      await batch.commit();
      //dynamic result = await batch.commit();
      //return result;
    } catch (error) {
      print(error);
    }
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryWhere({
    String table,
    String column,
    List<dynamic> whereArguments,
    String orderBy = 'id',
    String order = 'DESC',
    bool isMeeting = false,
  }) async {
    Database db = await instance.database;
    String q = 'SELECT * FROM $table WHERE $column = ?';
    if (isMeeting)
      q += ' ORDER BY synced ASC, $orderBy $order';
    else
      if(orderBy !='')
        q += ' ORDER BY $orderBy $order';
    return await db.rawQuery(
      q,
      whereArguments,
    );
  }

  Future<List<Map<String, dynamic>>> queryMultipleWhere({
    String table,
    List<dynamic> columns,
    List<dynamic> whereArguments,
    String orderBy = 'id',
    String order = 'DESC',
    bool isMeeting = false,
  }) async {
    Database db = await instance.database;
    String q = 'SELECT * FROM $table';
    if (columns.length > 0) {
      for (var i = 0; i < columns.length; i++) {
        if (i == 0) q += ' WHERE ';
        q += ' ${columns[i]} = ? ';
        try {
          if (columns[i + 1] != null) q += ' AND ';
        } catch (e) {}
      }
    }
    q += ' ORDER BY $orderBy $order';
    return await db.rawQuery(q, whereArguments);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String table) async {
    //try {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
    // } catch (error, stackTrace) {
    //   await sentry.captureException(
    //     exception: error,
    //     stackTrace: stackTrace,
    //   );
    //   return 0;
    // }
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id, String table) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMultipleMeetings(List<int> ids, String table) async {
    Database db = await instance.database;
    return await db.delete(table,
        where: 'group_id IN (${ids.join(', ')}) AND synced=1');
  }

  Future<int> deleteMultiple(List<int> ids, String table) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'group_id IN (${ids.join(', ')})');
  }

  Future<int> deleteGroupMembers(int id) async {
    Database db = await instance.database;
    return await db
        .delete(membersTable, where: 'group_id = ?', whereArgs: [id]);
  }
}
