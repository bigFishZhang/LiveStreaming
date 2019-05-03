//
//  ZBWaterFlowLayout.swift
//  ZBWaterFlowLayout
//
//  Created by zzb on 2019/5/3.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

protocol ZBWaterFlowLayoutDataSource:class {
    
    /// 列数
    ///
    /// - Parameter waterFallLayout: <#waterFallLayout description#>
    /// - Returns: <#return value description#>
    func numberOfCols(_ waterFallLayout:ZBWaterFlowLayout
        ) -> Int
    
    /// 每个cell
    ///
    /// - Parameters:
    ///   - waterfall: <#waterfall description#>
    ///   - item: <#item description#>
    /// - Returns: <#return value description#>
    func waterfall(_ waterfall:ZBWaterFlowLayout,item:Int) ->CGFloat
}


class ZBWaterFlowLayout: UICollectionViewFlowLayout {
    // MARK: 对外提供属性
    weak var dataSource:ZBWaterFlowLayoutDataSource?
   
    // MARK: 私有属性
    fileprivate lazy var cellAttrs:[UICollectionViewLayoutAttributes] =   [UICollectionViewLayoutAttributes]()
   
    fileprivate lazy var cols:Int = {
       return self.dataSource?.numberOfCols(self) ?? 2
    }()
    // 0 定义默认初始时 所有cell位置的数组
    fileprivate lazy var totalHeight:[CGFloat] = Array(repeating:self.sectionInset.top, count: self.cols)
    
}
// MARK:准备布局
extension ZBWaterFlowLayout {
    
    override func prepare() {
        super.prepare()

        // 1 默认只有一个section  获取cell个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        let cellW : CGFloat = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
        // 2创建UICollectionViewLayoutAttributes
        for i in 0..<itemCount{
            //indexpath
            let indexPath = IndexPath(item: i, section: 0)
            //UICollectionViewLayoutAttributes
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath);
            
            //设置attr frame
//            let cellH :CGFloat = CGFloat(arc4random_uniform(150)) + 150
            guard  let cellH :CGFloat = dataSource?.waterfall(self, item: i) else{
                fatalError("请事先数据源方法，返回cell高度")
            }
            let minHeight = totalHeight.min()!
            let minIndex  = totalHeight.firstIndex(of: minHeight)!
            let cellX :CGFloat = sectionInset.left + (minimumInteritemSpacing + cellW) * CGFloat(minIndex)
            let cellY :CGFloat = minHeight + minimumLineSpacing
            
            attr.frame = CGRect(x: cellX, y: cellY, width: cellW, height: cellH)
 
            //save attr
            cellAttrs.append(attr)
            // 添加当前的高度
            totalHeight[minIndex] = minHeight + minimumLineSpacing + cellH
            
        }
    }
}

// MARK:返回准备好的布局
extension ZBWaterFlowLayout{
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}

// MARK:设置contentSize
extension ZBWaterFlowLayout{
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 0, height: totalHeight.max()! + sectionInset.bottom)
    }
    
}
