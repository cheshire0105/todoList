//
//  MainViewController.swift
//  todoListApp
//
//  Created by cheshire on 2023/09/13.
//

import UIKit

class MainViewModel {
    
    var updateSpartaImage: ((UIImage?) -> Void)?
    
    func fetchInitialImage() {
        if let spartaURL = URL(string: "https://spartacodingclub.kr/css/images/scc-og.jpg") {
            downloadImage(from: spartaURL) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.fetchRandomImage()
                }
            }
        }
    }
    
    func fetchRandomImage() {
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching random image: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                   let firstImageInfo = jsonArray.first,
                   let imageUrlString = firstImageInfo["url"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    
                    self.downloadImage(from: imageUrl, completion: nil)
                } else {
                    print("Failed to parse image data")
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    private func downloadImage(from url: URL, completion: (() -> Void)?) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            DispatchQueue.main.async {
                self.updateSpartaImage?(UIImage(data: data))
                completion?()
            }
        }
        task.resume()
    }
}
