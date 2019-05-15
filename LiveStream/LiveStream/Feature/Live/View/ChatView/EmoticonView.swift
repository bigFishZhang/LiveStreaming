//
//  EmoticonView.swift
//  LiveStream
//
//  Created by bigfish on 2019/5/15.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

private let kEmoticonCellID = "kEmoticonCellID"

class EmoticonView: UIView {
    
    var emoticonClickCallback : ((Emoticon) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension EmoticonView{
    
    fileprivate func setupUI(){
        // 1 create pageCollectionView
        let style = ZBTitleStyle()
        style.isShowScrollLine = true
        let layout = ZBPageCollectionViewFlowLayout()
        layout.cols = 7
        layout.rows = 3
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let pageCollectionView = ZBPageCollectionView(frame: bounds, titles: ["普通","粉丝专属"], style: style, isTitleInTop: false, layout: layout)
        
        // 2 add
        addSubview(pageCollectionView)
        
        //3 set
        pageCollectionView.dataSource = self
//        pageCollectionView.delegate = self
        pageCollectionView.register(nib: UINib(nibName: "EmoticonViewCell", bundle: nil), identifier: kEmoticonCellID)
    }
}

extension EmoticonView : ZBPageCollectionViewDataSource{
    
    func numberOfSections(in pageCollectionView: ZBPageCollectionView) -> Int {
        return EmoticonViewModel.shareInstance.packages.count
    }
    
    func pageCollectionView(_ collectionView: ZBPageCollectionView, numberOfItemsInSection section: Int) -> Int {
         return EmoticonViewModel.shareInstance.packages[section].emoticons.count
    }
    func pageCollectionView(_ pageCollectionView: ZBPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCellID, for: indexPath) as! EmoticonViewCell
        cell.emotion = EmoticonViewModel.shareInstance.packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
    
    
    
}

//extension EmoticonView : zbpagecollectionviewd
