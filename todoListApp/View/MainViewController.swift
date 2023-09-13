import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var spartaImage: UIImageView!
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.updateSpartaImage = { [weak self] image in
            self?.spartaImage.image = image
        }
    }
    
    @IBAction func todoButton(_ sender: UIButton) {
        performSegue(withIdentifier: "TodoPage", sender: sender)
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        performSegue(withIdentifier: "DonePage", sender: sender)
    }
    
    @IBAction func profilePageMoveButton(_ sender: UIButton) {
        let profileDesignVC = ProfileDesignViewController()
        profileDesignVC.modalPresentationStyle = .fullScreen
        self.present(profileDesignVC, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchInitialImage()
    }
}
