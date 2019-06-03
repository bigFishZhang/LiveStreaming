//
//  ZBWaterFlowLayout.swift
//  ZBWaterFlowLayout
//
//  Created by zzb on 2019/5/3.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

@objc protocol ZBWaterFlowLayoutDataSource:class {
    
    func waterfallLayout(_ layout : ZBWaterFlowLayout, indexPath : IndexPath) -> CGFloat
    
    @objc optional func numberOfColsInWaterfallLayout(_ layout : ZBWaterFlowLayout) -> Int
}


class ZBWaterFlowLayout: UICollectionViewFlowLayout {
    // MARK: 对外提供属性
    weak var dataSource:ZBWaterFlowLayoutDataSource?
   
    // MARK: 私有属性
    fileprivate lazy var attrsArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
   
    fileprivate var totalHeight : CGFloat = 0
    
    fileprivate lazy var colHeights : [CGFloat] = {
        
        let cols = self.dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        
        var colHeights = Array(repeating: self.sectionInset.top, count: cols)
        
        return colHeights
    }()
    
    fileprivate var maxH : CGFloat = 0
    
    fileprivate var startIndex = 0
    

    
}
// MARK:准备布局
extension ZBWaterFlowLayout {
    
    override func prepare() {
        super.prepare()

        // 0.获取item的个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        // 1.获取列数
        let cols = dataSource?.numberOfColsInWaterfallLayout?(self) ?? 2
        
        // 2.计算Item的宽度
        let itemW = (collectionView!.bounds.width - self.sectionInset.left - self.sectionInset.right - self.minimumInteritemSpacing) / CGFloat(cols)
        
        
        // 3.计算所有的item的属性
        for i in startIndex..<itemCount {
            // 1.设置每一个Item位置相关的属性
            let indexPath = IndexPath(item: i, section: 0)
            
            // 2.根据位置创建Attributes属性
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 3.随机一个高度
            guard let height = dataSource?.waterfallLayout(self, indexPath: indexPath) else {
                fatalError("请设置数据源,并且实现对应的数据源方法")
            }
            
            // 4.取出最小列的位置
            var minH = colHeights.min()! // sectionInset.top
            
            let index = colHeights.firstIndex(of: minH)!
            
            let cellX:CGFloat = self.sectionInset.left + (self.minimumInteritemSpacing + itemW) * CGFloat(index)
            
            let cellY:CGFloat = minH - height - self.minimumLineSpacing
            
            // 5.设置item的属性
            attrs.frame = CGRect(x:cellX , y:cellY , width: itemW, height: height)
            
            attrsArray.append(attrs)
            
            minH = minH + height + minimumLineSpacing
            colHeights[index] = minH
            
        }
        // 4.记录最大值
        maxH = colHeights.max()!
        
        // 5.给startIndex重新赋值
        startIndex = itemCount
     
    }
}

extension ZBWaterFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: maxH + sectionInset.bottom - minimumLineSpacing)
    }
}

