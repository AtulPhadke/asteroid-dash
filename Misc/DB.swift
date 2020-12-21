//
//  Database.swift
//  scibowl
//
//  Created by Atul Phadke on 11/26/20.
//

import Foundation
import SQLite3

class DB
{
    
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "perms.sqlite"
    var db: OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
        
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS auth(id INTEGER PRIMARY KEY,perms TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(id:Int, perms:String)
        {
            let persons = read()
            for p in persons
            {
                if p.id == id
                {
                    return
                }
            }
            let insertStatementString = "INSERT INTO person (id, perms) VALUES (?, ?);"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(id))
                sqlite3_bind_text(insertStatement, 2, (perms as NSString).utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
        
        func read() -> [Perm] {
            let queryStatementString = "SELECT * FROM person;"
            var queryStatement: OpaquePointer? = nil
            var psns : [Perm] = []
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    let perms = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                    let year = sqlite3_column_int(queryStatement, 2)
                    psns.append(Perm(id: Int(id), perms: perms))
                    print("Query Result:")
                    print("\(id) | \(perms)")
                }
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
            return psns
        }
}
