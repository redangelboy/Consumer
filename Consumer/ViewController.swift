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
    let avatar_url: String?
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
    
    private var loginLabel = UILabel()
    private var nameLabel = UILabel()
    private var reposLabel = UILabel()
    private var followersLabel = UILabel()
    private var avatarImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabels()
        configureImageView()
        
        loadData()
//        let apiLoader = APIRequestLoader(apiRequest: GitHubRequest())
//        apiLoader.loadAPIRequest(requestData: "https://api.github.com/users/redangelboy") { (githubModel, error) in
//            print("Username -> \((githubModel?.login)!)")
//            print("Nickname -> \((githubModel?.name)!)")
//            print("Repos    -> \((githubModel?.public_repos)!)")
//            print("Repos    -> \((githubModel?.avatar_url)!)")
//            print("-------------------------------------------")
//
//        }
//
//        apiLoader.loadAPIRequest(requestData: "https://api.github.com/users/CarlosITguy") { (githubModel, error) in
//            print("Username -> \((githubModel?.login)!)")
//            print("Nickname -> \((githubModel?.name)!)")
//            print("Repos    -> \((githubModel?.public_repos)!)")
//            print("Repos    -> \((githubModel?.avatar_url)!)")
//            print("-------------------------------------------")
//        }
//        print(apiLoader.hardCodedData())
    }
    
    private func configureLabels() {
        
        loginLabel.textAlignment = .center
        nameLabel.textAlignment = .center
        reposLabel.textAlignment = .center
        followersLabel.textAlignment = .center
        
        view.addSubview(loginLabel)
        view.addSubview(nameLabel)
        view.addSubview(reposLabel)
        view.addSubview(followersLabel)
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        reposLabel.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 10),
            reposLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reposLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            followersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            followersLabel.topAnchor.constraint(equalTo: reposLabel.bottomAnchor, constant: 10)
        ])
    }
    
    private func configureImageView() {
        
        avatarImageView.contentMode = .scaleAspectFit
        
        view.addSubview(avatarImageView)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 200),
            avatarImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func loadData() {
        let apiLoader = APIRequestLoader(apiRequest: GitHubRequest())
        
        apiLoader.loadAPIRequest(requestData: "https://api.github.com/users/redangelboy") { [weak self] (githubModel, error) in
            guard let githubModel = githubModel else {
                print("Error loading GitHub data", error?.localizedDescription ?? "")
                return
            }
            
            //Update labels data
            
            DispatchQueue.main.async {
                self?.loginLabel.text = "Username: \(githubModel.login ?? "")"
                self?.nameLabel.text = "Nickname: \(githubModel.name ?? "")"
                self?.reposLabel.text = "Repos: \(githubModel.public_repos ?? 0)"
                self?.followersLabel.text = "Followers: \(githubModel.followers ?? 0)"
                self?.loadAvatarImage(urlString: githubModel.avatar_url)
            }
        }
    }
    
    private func loadAvatarImage(urlString: String?) {
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            //Update image with uploaded data
            DispatchQueue.main.async {
                self?.avatarImageView.image = image
            }
        }
        task.resume()
    }
}



