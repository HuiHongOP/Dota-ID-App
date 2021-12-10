//
//  DotaRequest.swift
//  DotaCheck
//
//  Created by Hui Hong Zheng on 11/3/21.
//
//
import Foundation


struct DotaRequest {
    //initalize the URL with a empty api
    var resourceURL:URL = URL(string: "https://api.opendota.com/api/players/")!

    //take in one parameter from searchbar and initalize it from user input
    init (player_ID:String){
        let resourceString =
        "https://api.opendota.com/api/players/\(player_ID)"
        //guard the resourceURl else return nothing into the resourceURl
        guard let resourceURL = URL(string: resourceString) else {
        return
        }
        self.resourceURL = resourceURL
    }
}
