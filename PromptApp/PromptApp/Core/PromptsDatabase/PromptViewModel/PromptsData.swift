//
//  PromptsData.swift
//  PromptApp
//
//  Created by librius on 2024-04-03.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class PromptsData: ObservableObject {
    
    //Special case for each element
    var pronouns: [String] = ["someone", "something"]
    var prepositions: [String] = ["with", "at"]
    var determiner: [String] = ["a", "the"]
    
    //Can be randomize without any special treatment needed
    var basicColors: [String] = ["red", "black", "white", "blue", "yellow"]
    var colors: [String] = ["red", "black", "white", "blue", "yellow", "green", "brown", "pink"]
    var clothes: [String] = ["jacket", "dress", "pair of sneakers", "Jordans", "hat", "bag", "t-shirt", "jewlery", "watch"]
    var objects: [String] = ["coffe cup"]
    var pluralObjects: [String] = ["foods"]
    var location: [String] = ["subway", "market", "cinema", "cafe"]
    var setting: [String] = ["sunset", "sunrise"]
    var photoStyle: [String] = ["selfie", "mirror pic"]
    var blank: [String] = []
    
    var collectionOfArrays : [[String]]
    var recentPrompts : [String] = []
    var currentPrompt = String()
    @Published var prompt = String()
    var promptDate = Timestamp()
    @Published var postStatus: Bool = false
    var currentDay = Date()
    var firebaseDay = Date()
    @Published var friends = [User] ()
    @Published var challenge = [User:String]()
    @Published var challengeSelection = String()
    @Published var uid = String()
    @Published var selectedIndex: [User] = []
    @Published private var userData = [String: Any]()

    @MainActor
    init(){
        
        collectionOfArrays = [objects,
                              pronouns,
                              determiner,
                              location]
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        self.uid = uid
        
        Task{
            try await fetchRecentPrompts()
            try await fetchCurrentPrompt()
            try await fetchFriends()
            try await fetchChallenge()
            DateInitializer()
            try await todayPromptPostStatus()
            
            if(self.firebaseDay <  self.currentDay){
                PromptMaker()
            }
            
            else if(self.currentPrompt.isEmpty){
                PromptMaker()
            }
            
            else {
                self.prompt = self.currentPrompt
            }
        }
        
    }
    
    func DateInitializer() {
        let currentDate = Date()
        let firebaseDate = self.promptDate.dateValue()

        let calendar = Calendar.current
        let firebaseDateComponents = calendar.dateComponents([.year, .month, .day], from: firebaseDate)
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)

        if let firebaseDateOnly = calendar.date(from: firebaseDateComponents),
           let currentDateOnly = calendar.date(from: currentDateComponents) {
            self.currentDay = currentDateOnly
            self.firebaseDay = firebaseDateOnly
        }
    }
    
    @MainActor
    func fetchFriends() async throws{
        self.friends = []
        var stringArray: [String] = []
        
       
        stringArray = try await UserService.fetchFriends(withUid: uid)
                
        if stringArray.isEmpty{
            self.friends = []
        }
        else{
            for i in 0 ..< stringArray.count {
                let requestUsers = try await UserService.fetchUser(withUid: stringArray[i])
                self.friends.append(requestUsers)
            }
        }
    }
    
    @MainActor
    func fetchChallenge() async throws{
//        var stringArray: [String] = []
//        var value: [String] = []
        self.challenge = [:]

        let querySnapshot = try await Firestore.firestore().collection("user").document(uid).collection("friends").getDocuments()
        
        if querySnapshot.isEmpty{
            self.challenge = [:]
        }
        else{
            for document in querySnapshot.documents {
                
                if let value = document.data()["challenge"] as? String {
                    if let key = document.data()["ownerUID"] as? String {
                        let requestUsers = try await UserService.fetchUser(withUid: key)
                        self.challenge.updateValue(value, forKey: requestUsers)
                    }
                }
            }
            
        }
        
        self.challengeSelection = challenge.values.first ?? ""
    }
    
    func getUserFromValue(value: String) -> User {
        
        for (key, mvalue) in challenge {
            if mvalue == value{
                return key
            }
        }
        
        return challenge.keys.first ?? User.Mock_User[0]
    }
    
    @MainActor
    func fetchRecentPrompts() async throws{
        
        print("recent prompt")
        
//        guard let uid = Auth.auth().currentUser?.uid else {return}

        let user = try await UserService.fetchUser(withUid: uid)
        
        self.recentPrompts = user.recentPrompts ?? Array<String>(repeating: "", count: 14)
        
        print(self.recentPrompts)
    }
    
    @MainActor
    func fetchCurrentPrompt() async throws{
        
//        guard let uid = Auth.auth().currentUser?.uid else {return}

        let user = try await UserService.fetchUser(withUid: uid)
        
        self.currentPrompt = user.currentPrompt
        self.promptDate = user.promptDate
        
    }
    
    @MainActor
    func todayPromptPostStatus() async throws{
//        guard let uid = Auth.auth().currentUser?.uid else {return}

        let snapshot = try await Firestore.firestore().collection("PromptPosts").whereField("ownerUID", isEqualTo: uid).order(by: "timeStamp", descending: true).limit(to: 1).getDocuments()
        let posts = try snapshot.documents.compactMap({ try $0.data(as: Post.self)})
        
        for post in posts {
            let calendar = Calendar.current
            let firebaseDateComponents = calendar.dateComponents([.year, .month, .day], from: post.timeStamp.dateValue())
            
            if(self.currentDay == calendar.date(from: firebaseDateComponents)){
                self.postStatus = true
            }
        }
    }
    
    func RecentPrompt(prompt: String) -> Bool{

        if(recentPrompts.contains(prompt)){
            return true
        }
        
        return false
    }
    
    func addRecentPrompt(prompt: String) {

//        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        if recentPrompts.isEmpty{
            Task{
                try await fetchRecentPrompts()
            }
        }
        recentPrompts.remove(at: 0)
        recentPrompts.append(self.prompt)
        
        let updateRecentPrompts = Firestore.firestore().collection("user").document(uid)
        var data = [String: Any]()
        
        data["recentPrompts"] = recentPrompts
        data["currentPrompt"] = self.prompt
        data["promptDate"] = Timestamp()
        
        updateRecentPrompts.updateData(data)

    }
    
    func PromptMaker(){
        
        let randomArray = collectionOfArrays.randomElement()
        
        switch randomArray{
        case objects:
            let tempString = wordRandomizer(array: ["clothes", "objects", "pluralObjects"])
            if(tempString == "clothes"){
                self.prompt = "a" + specificationRandomizer(array: [colors, blank]) + specificationRandomizer(array: [clothes])
            }
            else if(tempString == "objects"){
                self.prompt = "a" + specificationRandomizer(array: [basicColors, blank]) + specificationRandomizer(array: [objects])
            }
            else if(tempString == "pluralObjects"){
                self.prompt = specificationRandomizer(array: [basicColors, blank]) + specificationRandomizer(array: [pluralObjects])
            }
        case pronouns:
            let tempString = wordRandomizer(array: pronouns)
            if(tempString == "someone"){
                self.prompt = "someone" + specificationRandomizer(array: [objects, pluralObjects, clothes, location])
            }
            else if(tempString == "something"){
                self.prompt = "something" + specificationRandomizer(array: [colors, location])
            }
        case location:
            self.prompt = "the " + wordRandomizer(array: location)
        case determiner:
            let tempString = wordRandomizer(array: determiner)
            if(tempString == "the"){
                self.prompt = "the " + wordRandomizer(array: setting)
            }
            else if(tempString == "a"){
                self.prompt = "a " + wordRandomizer(array: photoStyle)
            }
        case .none:
            print("case empty")
        case .some(let value):
            print(value)
        }
        
        if RecentPrompt(prompt: self.prompt) == true{
            PromptMaker()
        }
        else {
            addRecentPrompt(prompt: self.prompt)
        }
        
    }
    
    func specificationRandomizer(array: [[String]]) -> String{
        let randomArray = array.randomElement()
        var promptString = String()
        
        switch randomArray{
        case blank:
            promptString = ""
        case colors:
            promptString = " " + wordRandomizer(array: colors)
        case objects:
            promptString = " " + wordRandomizer(array: objects)
        case pluralObjects:
            promptString = " " + wordRandomizer(array: pluralObjects)
        case clothes:
            promptString = " " + wordRandomizer(array: clothes)
        case location:
            promptString = " at the " + wordRandomizer(array: location)
        case basicColors:
            promptString = " " + wordRandomizer(array: basicColors)
        case .none:
            print("case empty")
        case .some(let value):
            print("specific: ")
            print(value)
        }
        
        return promptString
    }
    
    func wordRandomizer(array: [String]) -> String{
        let randomString = array.randomElement() ?? ""
        return randomString
    }
    
    @MainActor
    func sendChallenge(myChallenge: String) async throws{
        
        for user in selectedIndex{

            let userRef = Firestore.firestore().collection("user").document(user.id).collection("friends").document(self.uid)
            userData["challenge"] = myChallenge

            Task{
                try await userRef.updateData(userData)
            }
        }
    }
    
    func UnselectFriend(user: User) {
        
        for i in 0...selectedIndex.count{
            
            if(user == selectedIndex[i]){
                selectedIndex.remove(at: i)
                break
            }
        }
    }
}
