import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var spartaImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func todoButton(_ sender: UIButton) {
        performSegue(withIdentifier: "TodoPage", sender: sender)
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        performSegue(withIdentifier: "DonePage", sender: sender)
    }
    
    @IBAction func profilePageMoveButton(_ sender: UIButton) {
        let profileDesignVC = ProfileDesignViewController()
          profileDesignVC.modalPresentationStyle = .fullScreen // 전체 화면으로 표시 (선택사항)
          self.present(profileDesignVC, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰가 로드 될 때 스파르타 이미지를 바로 로드
        if let spartaURL = URL(string: "https://spartacodingclub.kr/css/images/scc-og.jpg") {
            downloadImage(from: spartaURL) {
                // 2초 딜레이 후에 랜덤 이미지를 다운로드
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
    
    func downloadImage(from url: URL, completion: (() -> Void)?) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            DispatchQueue.main.async {
                // 이미지 다운로드가 완료되면 실제 이미지로 교체
                self.spartaImage.image = UIImage(data: data)
                completion?()
            }
        }
        task.resume()
    }
}
