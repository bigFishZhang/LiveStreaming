//
//  AnchorViewController.swift
//  LiveStream
//
//  Created by zzb on 2019/5/3.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

private let kEdgeMargin : CGFloat = 8
private let kAnchorCellID = "kAnchorCellID"


class AnchorViewController: UIViewController {
    // MARK: 对外属性
    var homeType : HomeType!
    
    // MARK: 定义属性
    fileprivate lazy var homeVM : HomeViewModel = HomeViewModel()
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = ZBWaterFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: kEdgeMargin, left: kEdgeMargin, bottom: kEdgeMargin, right: kEdgeMargin)
        layout.minimumLineSpacing = kEdgeMargin
        layout.minimumInteritemSpacing = kEdgeMargin
        layout.dataSource = self
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellWithReuseIdentifier: kAnchorCellID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        loadData(index: 0)
    }

}

// MARK:- 设置UI界面内容
extension AnchorViewController {
    fileprivate func setupUI() {
        collectionView.backgroundColor = UIColor.randomColor()
        view.addSubview(collectionView)
        
    }
}

extension AnchorViewController {
    fileprivate func loadData(index : Int) {
        homeVM.loadHomeData(type: homeType, index : index, finishedCallback: {
            self.collectionView.reloadData()
        })
    }
}

// MARK:- collectionView的数据源&代理
extension AnchorViewController : UICollectionViewDataSource, ZBWaterFlowLayoutDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeVM.anchorModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAnchorCellID, for: indexPath) as! HomeViewCell
        
        cell.anchorModel = homeVM.anchorModels[indexPath.item]
        
        if indexPath.item == homeVM.anchorModels.count - 1 {
            loadData(index: homeVM.anchorModels.count)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("IndexPath: \(indexPath.row)")
        let liveVc = RoomViewController()
        navigationController?.pushViewController(liveVc, animated: true)
    }
    
    func waterfallLayout(_ layout: ZBWaterFlowLayout, indexPath: IndexPath) -> CGFloat {
        return indexPath.item % 2 == 0 ? SCREEN_WIDTH * 2 / 3 : SCREEN_WIDTH * 0.5
    }
}
