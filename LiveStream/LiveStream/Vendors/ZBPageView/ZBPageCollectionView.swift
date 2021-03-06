//
//  ZBPageCollectionView.swift
//  ZBPageView
//
//  Created by zhang zhengbin on 2019/5/5.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

protocol ZBPageCollectionViewDataSource:class {
    func numberOfSections(in pageCollectionView: ZBPageCollectionView)-> Int
    func pageCollectionView(_ collectionView: ZBPageCollectionView, numberOfItemsInSection section: Int) -> Int
    func pageCollectionView(_ pageCollectionView: ZBPageCollectionView,_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
}

protocol ZBPageCollectionViewDelegate:class {
    func pageCollectionView(_ collectionView: ZBPageCollectionView, didSelectItemAt indexPath: IndexPath)
}



class ZBPageCollectionView: UIView {
    
    weak var dataSource:ZBPageCollectionViewDataSource?
    weak var delegate:ZBPageCollectionViewDelegate?
    
    fileprivate var titles:[String]
    fileprivate var isTitleInTop:Bool
    fileprivate var layout:ZBPageCollectionViewFlowLayout
    fileprivate var style:ZBTitleStyle
    fileprivate var collectionView:UICollectionView!
    fileprivate var pageControl:UIPageControl!
    fileprivate var sourceIndexPath:IndexPath = IndexPath(item: 0, section: 0)
    fileprivate var titleView:ZBTitleView!
    
    
    init(frame: CGRect,
         titles:[String],
         style:ZBTitleStyle,
         isTitleInTop:Bool,
         layout:ZBPageCollectionViewFlowLayout) {
        
        self.titles = titles
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        self.style = style
       
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 设置界面
extension ZBPageCollectionView {
    fileprivate func setupUI(){
        // 1 creat title view
        let titleY = isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        titleView = ZBTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        titleView.delegate = self
        addSubview(titleView)
        
        // 2 creat UIPageControl
        let pageControlHeight:CGFloat = 20
        let pageControlY = isTitleInTop ? (bounds.height - pageControlHeight):(bounds.height - pageControlHeight - style.titleHeight)
        let pageControlFrame = CGRect(x: 0, y: pageControlY, width: bounds.width, height: pageControlHeight)
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        pageControl.isEnabled = false
        pageControl.backgroundColor = UIColor.randomColor()
        addSubview(pageControl)
        
        // 3 creat UICollectionView
        let collectionViewY = isTitleInTop ? style.titleHeight : 0
        let collectionViewFrame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: bounds.height - style.titleHeight - pageControlHeight)
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.randomColor()
        addSubview(collectionView)
        
    }
}

// MARK: - 对外暴露的方法
extension ZBPageCollectionView{
    
    func register(cell:AnyClass?, identifier:String)  {
        collectionView.register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func register(nib:UINib, identifier:String)  {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}


// MARK: - UICollectionViewDataSource
extension ZBPageCollectionView:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        
        if (section == 0){
            
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
        }
        
        
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return dataSource!.pageCollectionView(self, collectionView, cellForItemAt: indexPath)
    }
    
    
}


extension ZBPageCollectionView:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView(self, didSelectItemAt: indexPath)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
        scrollView.isScrollEnabled = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            scrollViewEndScroll()
        }else{
            scrollView.isScrollEnabled = false
        }
    }
    
    fileprivate func scrollViewEndScroll(){
        
        //1 取出屏幕中显示的cell
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        guard  let indexPath = collectionView.indexPathForItem(at: point) else {return}
        
    
        
        //3 判断分组是否发生改变
        if sourceIndexPath.section != indexPath.section {
            // 3.1 修改pageControl 个数
            let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            // 3.3 设置titleView 位置
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: indexPath.section)
            
            //3.3 记录
            sourceIndexPath = indexPath
            
            
        }
        
        //2 根据indexPath 设置pageControl
        pageControl.currentPage = indexPath.item / (layout.cols  * layout.rows)
        
    }
    
    
}

extension ZBPageCollectionView:ZBTitleViewDelegate{
    
    func titleView(_ titleView: ZBTitleView, targetIndex: Int) {
        
        let indexPath = IndexPath(item: 0, section: targetIndex)
        //判断是否可以跳过去
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        scrollViewEndScroll()
        
    }
}
