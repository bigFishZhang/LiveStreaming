//
//  ZBContentView.swift
//  ZBPageView
//
//  Created by zzb on 2019/4/15.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

private let kContentCellId = "kContentCellId"

protocol ZBContentViewDelegate:class {
    func contentView(_ contentView:ZBContentView,targetIndex:Int)
    func contentView(_ contentView:ZBContentView,targetIndex:Int,progress:CGFloat)
}

class ZBContentView: UIView {
    weak var delegate:ZBContentViewDelegate?
    
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    //记录点击瞬间偏移量
    fileprivate var startOffsetX:CGFloat = 0
    
    fileprivate var isForbiddenScroll:Bool = false
    
    fileprivate lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
       let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellId)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
        
    }()
    
    
    init(frame: CGRect,childVcs:[UIViewController],parentVc:UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ZBContentView {
    //自控制器加到父控制器中
    fileprivate func setupUI() {
        for vc in childVcs {
            parentVc.addChild(vc)
        }
        addSubview(collectionView)
    }
}


extension ZBContentView :UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellId, for: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}
// MARK:UICollectionView delegate
extension ZBContentView:UICollectionViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            contentEndScroll()
        }
    }
    private func contentEndScroll(){
        //0 判断是否禁止
        guard !isForbiddenScroll else {return}
        
        //1 获取滚动到的位置
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        //2 通知title调整
        delegate?.contentView(self, targetIndex: currentIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         isForbiddenScroll = false
        startOffsetX = scrollView.contentOffset.x
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //0 判断是否禁止
//        guard !isForbiddenScroll else {return}
        // 0 判断偏移量和开始时是否一致
        guard startOffsetX != scrollView.contentOffset.x,!isForbiddenScroll else {
            return
        }
        // 1 定义
        var targetIndex = 0
        var progress:CGFloat = 0.0
        
        // 2 赋值
        let currentIndex = Int(startOffsetX / scrollView.bounds.width )
        if startOffsetX < scrollView.contentOffset.x { //左滑动
            targetIndex  = currentIndex + 1
            if targetIndex > childVcs.count - 1{
                targetIndex = childVcs.count - 1
            }
            
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
            
        }else{//右滑动
            targetIndex  = currentIndex - 1
            if targetIndex < 0 {
                targetIndex  = 0
            }
             progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        // 3 通知代理
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
        
        
    }
    
    
    
}


// MARK: titleView delegate
extension ZBContentView:ZBTitleViewDelegate{
    func titleView(_ titleView: ZBTitleView, targetIndex: Int) {
        isForbiddenScroll = true
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
