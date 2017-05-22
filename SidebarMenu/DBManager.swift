//
//  DBManager.swift
//  CGAapps
//
//  Created by user on 12/5/2017.
//  Copyright © 2017年 AppCoda. All rights reserved.
//

import UIKit
import Foundation

class DBManager: NSObject {
    
    let field_MovieID = "movieID"
    let field_MovieTitle = "title"
    let field_MovieCategory = "category"
    let field_MovieYear = "year"
    let field_MovieURL = "movieURL"
    let field_MovieCoverURL = "coverURL"
    let field_MovieWatched = "watched"
    let field_MovieLikes = "likes"
    
    
    
    let f_nos = "nos"
    let f_loginID = "loginID"
    let f_teamID = "teamID"
    let f_gameAccount = "gameAccount"
    let f_pictureUrl = "pictureURL"
    let f_nickname = "nickName"
    let f_urlname = "urlName"
    let f_deviceOwner = "deviceOwner"
    let f_title = "title"

    
    
    static let shared: DBManager = DBManager()
    
    let databaseFileName = "CGA.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            if database != nil {
                // Open the database.
                if database.open() {
                    
                    let createMoviesTableQuery = "create table members (\(f_nos) integer primary key autoincrement null, \(f_loginID) text null, \(f_teamID) text null, \(f_deviceOwner) text null, \(f_gameAccount) text, \(f_pictureUrl) text  null, \(f_nickname) text null , \(f_urlname) text null , \(f_title) text null )"
                    
               //     let acreateMoviesTableQuery = "create table members (\(f_nos) integer primary key autoincrement not null, \(f_loginID) text not null, \(f_teamID) text not null, \(f_deviceOwner) integer not null, (f_gameAccount) text, \(f_pictureUrl) text not null, \(f_nickname) bool not null default 0, \(field_MovieLikes) integer not null)"
                    do {
                        try database.executeUpdate(createMoviesTableQuery, values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    database.close()
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
        
        return created
    }
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                print("opened the database.")
                return true
                           }
        }
        print("Could not open the database.")
        return false
    }
    
    func insertMemberData() {
        if openDatabase() {
           if let pathToMoviesFile = Bundle.main.path(forResource: "movies", ofType: "tsv") {
                do {
                  let moviesFileContents = try String(contentsOfFile: pathToMoviesFile)
                    
                    let moviesData = moviesFileContents.components(separatedBy: "\r\n")
                    
                    var query = ""
                   for movie in moviesData {
                        let movieParts = movie.components(separatedBy: "\t")
                        
                        if movieParts.count == 5 {
                            let movieTitle = movieParts[0]
                            let movieCategory = movieParts[1]
                            let movieYear = movieParts[2]
                            let movieURL = movieParts[3]
                            let movieCoverURL = movieParts[4]
                            
                            query += "insert into movies (\(field_MovieID), \(field_MovieTitle), \(field_MovieCategory), \(field_MovieYear), \(field_MovieURL), \(field_MovieCoverURL), \(field_MovieWatched), \(field_MovieLikes)) values (null, '\(movieTitle)', '\(movieCategory)', \(movieYear), '\(movieURL)', '\(movieCoverURL)', 0, 0);"
                        }
                   }
                    
                    if !database.executeStatements(query) {
                        print("Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            database.close()
        }
    }
    func insertMovieData() {
        if openDatabase() {
            if let pathToMoviesFile = Bundle.main.path(forResource: "movies", ofType: "tsv") {
                do {
                    let moviesFileContents = try String(contentsOfFile: pathToMoviesFile)
                    
                    let moviesData = moviesFileContents.components(separatedBy: "\r\n")
                    
                    var query = ""
                    for movie in moviesData {
                        let movieParts = movie.components(separatedBy: "\t")
                        
                        if movieParts.count == 5 {
                            let movieTitle = movieParts[0]
                            let movieCategory = movieParts[1]
                            let movieYear = movieParts[2]
                            let movieURL = movieParts[3]
                            let movieCoverURL = movieParts[4]
                            
                            query += "insert into movies (\(field_MovieID), \(field_MovieTitle), \(field_MovieCategory), \(field_MovieYear), \(field_MovieURL), \(field_MovieCoverURL), \(field_MovieWatched), \(field_MovieLikes)) values (null, '\(movieTitle)', '\(movieCategory)', \(movieYear), '\(movieURL)', '\(movieCoverURL)', 0, 0);"
                        }
                    }
                    
                    if !database.executeStatements(query) {
                        print("Failed to insert initial data into the database.")
                        print(database.lastError(), database.lastErrorMessage())
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            database.close()
        }
    }
    
    
    func loadMovies() -> [MovieInfo]! {
        var movies: [MovieInfo]!
        
        if openDatabase() {
            let query = "select * from movies order by \(field_MovieYear) asc"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    let movie = MovieInfo(movieID: Int(results.int(forColumn: field_MovieID)),
                                          title: results.string(forColumn: field_MovieTitle),
                                          category: results.string(forColumn: field_MovieCategory),
                                          year: Int(results.int(forColumn: field_MovieYear)),
                                          movieURL: results.string(forColumn: field_MovieURL),
                                          coverURL: results.string(forColumn: field_MovieCoverURL),
                                          watched: results.bool(forColumn: field_MovieWatched),
                                          likes: Int(results.int(forColumn: field_MovieLikes))
                    )
                    
                    if movies == nil {
                        movies = [MovieInfo]()
                    }
                    
                    movies.append(movie)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return movies
    }
    
    func deleteRec(){
        
        if openDatabase(){
            do {
                let query = "delete from members"
                try database.executeUpdate(query, values:nil)
            }
            catch {
                print(error.localizedDescription)
            }
         
           database.close()
        }
        
    }
    
    
    func loadRec() -> [Members]! {
        var xmember: [Members]!
        var x=0
        if openDatabase() {
            
            
               let query = "select * from members order by \(f_loginID) asc"
            
            do {
                print(database)
                let results = try database.executeQuery(query, values: nil)
                
                while results.next() {
                    x=x+1
                    print(x)
                    let member = Members(
                                        loginID: Int(results.int(forColumn: f_loginID)),
                                        teamID: results.string(forColumn: f_teamID),
                                        gameAccount: results.string(forColumn: f_gameAccount),
                                        picture_url: results.string(forColumn: f_pictureUrl),
                                        nickname: results.string(forColumn: f_nickname),
                                        urlname: results.string(forColumn: f_urlname),
                                        deviceOwner: results.string(forColumn: f_deviceOwner),
                                        title: results.string(forColumn: f_title)
                    )
                    
                    if xmember == nil {
                        xmember = [Members]()
                    }
                    
                    xmember.append(member)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return xmember
    }
    
    
    
    
    
    
    
    
    
    
    func updateMovie(withID ID: Int, watched: Bool, likes: Int) {
        if openDatabase() {
            let query = "update movies set \(field_MovieWatched)=?, \(field_MovieLikes)=? where \(field_MovieID)=?"
            
            do {
                try database.executeUpdate(query, values: [watched, likes, ID])
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
    }
    
    
    func deleteMovie(withID ID: Int) -> Bool {
        var deleted = false
        
        if openDatabase() {
            let query = "delete from movies where \(field_MovieID)=?"
            
            do {
                try database.executeUpdate(query, values: [ID])
                deleted = true
            }
            catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return deleted
    }
    
    
    
    
    func jsonDecode(jString: String)-> [Members]!  {
        var members:[Members]!
       
        let data = jString.data(using: .utf8)!
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any],
            let field = json?["data"] as? [[String:Any]],
            let name = field[1]["nickname"] as? String, field.count > 0
        {
           for ux in field {
            
                let picture_urlx = ux["picture_url"] as? String
                let nicknamex = ux["nickname"] as? String
                let loginIDx = ux["id"] as? Int
                let urlnamex = ux["urlname"] as? String
            let member = Members( loginID:loginIDx,
                                  teamID:"nil",
                                  gameAccount:"nil",
                                  picture_url:picture_urlx ?? "",
                                  nickname:nicknamex ?? "",
                                  urlname:urlnamex ?? "",
                                  deviceOwner:"Y",
                                  title:"member"
                                  )
            if members == nil {
                members = [Members]()
            }
            
            members.append(member)
            }
        } else {
            print("bad json - do some recovery")
        }
        return members
    }
    
    
    func jsonFeelDecode(jString: String)-> [Feel]!  {
        var feels:[Feel]!
        
        let data = jString.data(using: .utf8)!
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any],
            let field = json?["data"] as? [[String:Any]],
            let name = field[0]["content_html"] as? String, field.count > 0
        {
            let content = field[1]["content"] as? String
            print("====>",content ?? " ")
            for ux in field {
                print("getfeel")
                let zid = ux["id"] as? Int
                let zcontent = ux["content"] as? String
                let zcontent_html = ux["content_html"] as? String
                let ztype = ux["type"] as? Int
                let zsender_type = ux["sender_type"] as? String
                let zsender_id = ux["sender_id"] as? String
                let zsender_name = ux["sender_name"] as? String
                let zreceiver_type = ux["receiver_type"] as? String
                let zreceiver_id = ux["receiver_id"] as? String
                let zreceiver_name = ux["receiver_type"] as? String
                let zsender_picture_url = ux["sender_picture_url"] as? String
                let zreceiver_picture_url = ux["received_picture_url"] as? String
                let zcreated_datetime = ux["created_datetime"] as? String
                print(zsender_picture_url ?? " ")
                let feel = Feel(      id:zid,
                                      content:zcontent ?? "",
                                      content_html:zcontent_html ?? "",
                                      ftype:ztype,
                                      sender_type:zsender_type ?? "",
                                      sender_id:zsender_id ?? "",
                                      sender_name:zsender_name ?? "",
                                      receiver_type:zreceiver_type ?? "",
                                      receiver_id:zreceiver_id ?? "",
                                      receiver_name:zreceiver_name ?? "",
                                      receiver_picture_url:zreceiver_picture_url ?? "",
                                      created_datetime:zcreated_datetime ?? "",
                                      sender_picture_url:zsender_picture_url ?? ""
                                    )
                if feels == nil {
                    feels = [Feel]()
                }
                
                feels.append(feel)
            }
        } else {
            print("bad json - do some recovery")
        }
        return feels
    }
    
    func updateRec(mx:[Members])
    {
        if openDatabase(){
            
        var query = ""
        for mm in mx {
            
            
            print(mm.loginID, mm.deviceOwner, mm.nickname, mm.picture_url, mm.title, mm.urlname)
            
            query = "insert into members (loginID, pictureURL, nickname, urlname) values ( ?, ?, ?, ?)";
            
            
            do {
                try database.executeUpdate(query, values:[mm.loginID, mm.picture_url, mm.nickname, mm.urlname])                          }
            catch {
                print(error.localizedDescription)
            }
            
            

            }
        
        
           database.close()
        }
    
    
    }
    
    
    func loadFeel() {
        
        print("loadFeel")
        var request = URLRequest(url: URL(string: "https://test.cga.hk/api/user/feed/list/")!)
        request.httpMethod = "POST"
        let postString = "user_id=10903&session_id=TD07aBd3hdZIm7TYFEjrIYUwWW8AuC"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error!)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!)")
            
            let memx = self.jsonFeelDecode(jString:responseString!)
           /* self.deleteRec()
            
            self.updateRec(mx: memx!)
            let rmx = self.loadRec() */
            for mm in memx! {
                
                print("=====>>", mm.id, mm.created_datetime, mm.content, mm.receiver_name, mm.sender_name, mm.sender_picture_url, mm.ftype)
                
                
            }
            
            
            
        }
        task.resume()
        
    }
    


    func loadData() {
    
        print("loadData")
        var request = URLRequest(url: URL(string: "https://test.cga.hk/api/team/member/list/")!)
        request.httpMethod = "POST"
        let postString = "team_id=10184&fields=nickname,picture_url,urlname,game_account"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            print("error=\(error!)")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response!)")
        }
        
        let responseString = String(data: data, encoding: .utf8)
        print("responseString = \(responseString!)")
       
        let memx = self.jsonDecode(jString:responseString!)
        self.deleteRec()

        self.updateRec(mx: memx!)
        let rmx = self.loadRec()
            for mm in rmx! {
                
                    print(mm.loginID, mm.deviceOwner, mm.nickname, mm.picture_url, mm.title, mm.urlname)
                
                
            }
            
            
            
        }
        task.resume()
    
        }
    
}
