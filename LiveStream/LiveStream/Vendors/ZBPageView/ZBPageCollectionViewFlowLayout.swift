//
//  ZBPageCollectionViewFlowLayout.swift
//  ZBPageView
//
//  Created by zhang zhengbin on 2019/5/6.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

class ZBPageCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var cols:Int = 4 //列
    var rows:Int = 2 //行
    
    fileprivate lazy var cellAttrs:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var maxWidth:CGFloat = 0

}

extension ZBPageCollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        //0 计算item 宽高
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(cols - 1)) / CGFloat(cols)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - minimumLineSpacing * CGFloat(rows - 1)) / CGFloat(rows)
        
        //1 获取一共多少组
        let sectionCount = collectionView!.numberOfSections
        //2 每个组多少个item
        var prePageCount:Int = 0
        for i in 0..<sectionCount {
            let itemCount = collectionView!.numberOfItems(inSection: i)
            
            for j in 0..<itemCount {
                //2.1 获取对应的indexPath
                let indexPath = IndexPath(item: j, section: i)
                //2.2 创建 UICollectionViewLayoutAttributes
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                //2.3 计算J所在页
                let page = j / (cols * rows)
                let index = j % (cols * rows)
 
                //2.3 设置attr的fame
                let itemY = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat( index / cols)
                let itemX = CGFloat(prePageCount + page) * collectionView!.bounds.width + (itemW + minimumInteritemSpacing) * CGFloat(index % cols)
                attr.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                //2.4 保存
                cellAttrs.append(attr)
            }
            prePageCount += (itemCount - 1) / (cols * rows)  + 1
        }
        //3 计算最大Y值
        maxWidth = CGFloat(prePageCount) * collectionView!.bounds.width
    }
}

extension ZBPageCollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
}

extension ZBPageCollectionViewFlowLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxWidth, height: 0)
    }
}
