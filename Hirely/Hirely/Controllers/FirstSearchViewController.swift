//
//  FirstSearchViewController.swift
//  Hirely
//
//  Created by Ayah Meftah  on 22/12/2024.
//

import UIKit

class ResultsVC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}

class FirstSearchViewController: UIViewController, UISearchResultsUpdating {
    
    // creating the search controller
    let searchController = UISearchController(searchResultsController: ResultsVC())

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        // assigning the search controller property to the navigation items
        navigationItem.searchController = searchController
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        let vc = searchController.searchResultsController as? ResultsVC
        vc?.view.backgroundColor = .yellow
        
        print(text)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
