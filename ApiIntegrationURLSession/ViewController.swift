//
//  ViewController.swift
//  ApiIntegrationURLSession
//
//  Created by Sumayya Siddiqui on 17/03/23.
//

import UIKit
import Reachability
import MBProgressHUD

class ViewController: UIViewController {
    
    var reachability : Reachability?
    var taskelement: [TaskElement] = []
    
    @IBOutlet weak var tblView: UITableView! {
        didSet {
            tblView.delegate = self
            tblView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oyeLabsApi()
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskelement.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as? TaskCell else { return UITableViewCell() }
        let item = taskelement[indexPath.row]
        cell.lblText1.text = item.title
        cell.lblText2.text = item.explanation
        cell.lblText3.text = item.copyright
        cell.imgView.imageFromUrl(urlString: item.url)
        cell.imgView.contentMode = .scaleAspectFill
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = taskelement[indexPath.row]
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FullViewVC") as? FullViewVC {
            vc.taskelement = self.taskelement
            vc.selectedIndex = indexPath
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension ViewController {
    func oyeLabsApi(){
        do {
            self.reachability = try Reachability.init()
        } catch {
            print("Unable tp start notifier")
        }
        if ((reachability?.connection) != .unavailable) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let url = URL(string: APIManager.shared.oyeLabs)!
            //            let tokenId = UserDefaults.standard.string(forKey: "token")
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if error == nil && data != nil {
                        
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse?.statusCode ?? 0)
                        if httpResponse?.statusCode == 200 {
                            let loginResponse = try? JSONDecoder().decode([TaskElement].self, from: data!)
                            let filterData = loginResponse?.filter({$0.mediaType == .image})
                            print("loginResponse data >>> ", loginResponse)
                            print("filtered data >>> ", filterData)
                            //                        self.lbl1.taskelement.append(taskelement)
                            
                            self.taskelement = filterData ?? []
                            self.tblView.reloadData()
                        }
                    }
                    
                    
                }
            }
            dataTask.resume()
            
            //        else {
            //            self.SimpleAlert(withTitle: "", message: "Please Check your Internet")
            //        }
            
        }
    }
}


// MARK: TaskCell
class TaskCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblText1: UILabel!
    @IBOutlet weak var lblText2: UILabel!
    @IBOutlet weak var lblText3: UILabel!
    
}

// MARK: ImageView Extension
extension UIImageView {
    public func imageFromUrl(urlString: String?) {
        guard let imageURLString = urlString else {
            self.image = UIImage(named: "default.png")
            return
        }
        DispatchQueue.global().async { [weak self] in
            let data = try? Data(contentsOf: URL(string: imageURLString)!)
            DispatchQueue.main.async {
                self?.image = data != nil ? UIImage(data: data!) : UIImage()
            }
        }
    }
}
