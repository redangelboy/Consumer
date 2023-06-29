//
//  ViewController.swift
//  Consumer
//
//  Created by Cesar Rojas on 6/29/23.
//

import UIKit
import CRFramework

struct MyGitHub: Codable {
    
    let login: String?
    let name: String?
    let location: String?
    let public_repos: Int?
    let followers: Int?
    
}

enum RequestError: Error {
    case invalidUrl
}

struct GitHubRequest: APIRequest {
    
    func makeRequest(from stringUrl: String) throws -> URLRequest {
        guard let gitUrl = URL(string: stringUrl) else {
            throw RequestError.invalidUrl
        }
        return URLRequest(url: gitUrl)
    }
    
    func parseResponse(data: Data) throws -> MyGitHub {
        return try JSONDecoder().decode(MyGitHub.self, from: data)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let apiLoader = APIRequestLoader(apiRequest: GitHubRequest())
        apiLoader.loadAPIRequest(requestData: "https://api.github.com/users/redangelboy") { (githubModel, error) in
            print("Username -> \((githubModel?.login)!)")
            print("Nickname -> \((githubModel?.name)!)")
            print("Repos    -> \((githubModel?.public_repos)!)")
            print("-------------------------------------------")
            
        }
        
        apiLoader.loadAPIRequest(requestData: "https://api.github.com/users/CarlosITguy") { (githubModel, error) in
            print("Username -> \((githubModel?.login)!)")
            print("Nickname -> \((githubModel?.name)!)")
            print("Repos    -> \((githubModel?.public_repos)!)")
        }
        print(apiLoader.hardCodedData())
    }
}

