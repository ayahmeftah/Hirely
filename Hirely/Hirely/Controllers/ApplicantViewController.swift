//
//  ApplicantViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 14/12/2024.
//

import UIKit

class ApplicantViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //Creating an Outlet for the recommended jobs table view
//    @IBOutlet weak var jobsTableView : UITableView!
    @IBOutlet weak var jobsCollectionView: UICollectionView!
    
    var companies = ["Microsoft Corporation", "Google LLC"]
    var jobs = ["Software Engineer", "Data Analyst"]
    var jobTypes = ["Full-Time","Part-Time"]
    var imageName = ["microsoft","google"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jobsCollectionView.backgroundColor = .clear

        // Register custom collection view cell
                let nib = UINib(nibName: "JobsCollectionViewCell", bundle: nil)
                jobsCollectionView.register(nib, forCellWithReuseIdentifier: "recommendedJob")
                
                jobsCollectionView.delegate = self
                jobsCollectionView.dataSource = self
                
                // Set the layout for horizontal scrolling
                if let layout = jobsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    layout.scrollDirection = .horizontal
                    layout.minimumLineSpacing = 10
                    layout.minimumInteritemSpacing = 10
                }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return companies.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedJob", for: indexPath) as! JobsCollectionViewCell
            cell.postInit(companies[indexPath.row], jobTypes[indexPath.row], jobs[indexPath.row], imageName[indexPath.row])
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.masksToBounds = true
            return cell
        }
        
        // MARK: - UICollectionViewDelegateFlowLayout (For Cell Size)

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 300, height: 150) // Adjust card size
        }
    

}
//extension ApplicantViewController{
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return companies.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedJob", for: indexPath) as? JobsTableViewCell
//        cell?.postInit(companies[indexPath.row], jobTypes[indexPath.row], jobs[indexPath.row], imageName[indexPath.row])
//        cell?.backgroundColor = .clear
//        return cell!
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(companies[indexPath.row])
//    }
//    
//}
