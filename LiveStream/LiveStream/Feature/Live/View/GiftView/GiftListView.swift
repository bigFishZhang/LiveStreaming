//
//  GiftListView.swift
//  LiveStream
//
//  Created by zhang zhengbin on 2019/5/15.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

private let kGiftCellID = "kGiftCellID"


protocol GiftListViewDelegate : class {
      func giftListView(giftView : GiftListView, giftModel : GiftModel)
}


class GiftListView: UIView,NibLoadable {

    @IBOutlet weak var giftView: UIView!
    
    @IBOutlet weak var sendGiftBtn: UIButton!
    
    fileprivate var pageCollectionView : ZBPageCollectionView!
    fileprivate var currentIndexPath : IndexPath?
    fileprivate var giftViewModel : GiftViewModel = GiftViewModel()
    
    weak var delegate : GiftListViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 1.初始化礼物的View
        setupGiftView()
        
        // 2.加载礼物的数据
        loadGiftData()
        
    }
    

    @IBAction func sendGiftBtnClick(_ sender: UIButton) {
        let package = giftViewModel.giftlistData[currentIndexPath!.section]
        let giftModel = package.list[currentIndexPath!.item]
        delegate?.giftListView(giftView: self, giftModel: giftModel)
        
    }
    
}

extension GiftListView {
    fileprivate func setupUI() {
        setupGiftView()
    }
    
    fileprivate func setupGiftView() {
        let style = ZBTitleStyle()
        style.isScrollEnable = false
        style.isShowScrollLine = true
        style.normalColor = UIColor(r: 255, g: 255, b: 255)
        
        let layout = ZBPageCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.cols = 4
        layout.rows = 2
        
        var pageViewFrame = giftView.bounds
        pageViewFrame.size.width = SCREEN_WIDTH
        pageCollectionView = ZBPageCollectionView(frame: pageViewFrame, titles: ["热门", "高级", "豪华", "专属"], style: style, isTitleInTop: true, layout : layout)
        giftView.addSubview(pageCollectionView)
        
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        
        pageCollectionView.register(nib: UINib(nibName: "GiftViewCell", bundle: nil), identifier: kGiftCellID)
    }
    
}


// MARK:- 加载数据
extension GiftListView {
    fileprivate func loadGiftData() {
        giftViewModel.loadGiftData {
             self.pageCollectionView.reloadData()
        }
    }
}


// MARK:- 数据设置
extension GiftListView : ZBPageCollectionViewDelegate, ZBPageCollectionViewDataSource {
    func numberOfSections(in pageCollectionView: ZBPageCollectionView) -> Int {
        return giftViewModel.giftlistData.count
    }
    
    func pageCollectionView(_ collectionView: ZBPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = giftViewModel.giftlistData[section]
        return package.list.count
    }
    
    func pageCollectionView(_ pageCollectionView: ZBPageCollectionView, _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGiftCellID, for: indexPath) as! GiftViewCell
        
        let package = giftViewModel.giftlistData[indexPath.section]
        cell.giftModel = package.list[indexPath.item]
        
        return cell
    }
    
    func pageCollectionView(_ pageCollectionView: ZBPageCollectionView, didSelectItemAt indexPath: IndexPath) {
        sendGiftBtn.isEnabled = true
        currentIndexPath = indexPath
    }
    
}
