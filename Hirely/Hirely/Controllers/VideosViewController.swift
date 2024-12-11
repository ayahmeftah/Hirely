//
//  VideosViewController.swift
//  Hirely
//
//  Created by BP-36-201-19 on 11/12/2024.
//

import UIKit

class VideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
  
    
    
    var arrVideos = [Video]()
   

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        arrVideos.append(Video.init(title: "Video", link: <#T##URL#>))
        
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! VideoTableViewCell
        
        return cell
    }
    
    struct Video{
        
        
        let title : String
        let link : URL
        
        
    }
    
    
    
}
