//
//  HomeViewController.swift
//  News
//
//  Created by bigfish on 2019/4/10.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension HomeViewController {
    
    fileprivate func setupUI() {
//        view.backgroundColor = UIColor(hex: "#FFB6C1")
        view.backgroundColor = UIColor.randomColor()
//        view.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        // left
        let logoImage = UIImage(named: "home-logo")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil)
        // right
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self, action: #selector(followItemClick))
        // search
        let searchFrame = CGRect(x: 0, y: 0, width: 200, height: 32)
        let searchBar = UISearchBar(frame: searchFrame)
        searchBar.placeholder = "主播昵称/房间号/链接"
        navigationItem.titleView = searchBar
        searchBar.searchBarStyle = .minimal
        let searchFiled = searchBar.value(forKey: "_searchField") as? UITextField
        searchFiled?.textColor = UIColor.white
        
        
    }
    
}

extension HomeViewController {
    @objc fileprivate func followItemClick() {
        print("---followItemClick---")
    }
}
