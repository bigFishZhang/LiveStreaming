//
//  ZBTitleView.swift
//  ZBPageView
//
//  Created by zzb on 2019/4/15.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

protocol ZBTitleViewDelegate:class {
    func titleView(_ titleView:ZBTitleView,targetIndex:Int)
}

class ZBTitleView: UIView {
    
    weak var delegate : ZBTitleViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var style : ZBTitleStyle
    
    fileprivate lazy var currentIndex:Int = 0
    
    fileprivate lazy var titleLabels:[UILabel] = [UILabel]()
    
    fileprivate lazy var scrollView:UIScrollView = {
       let scrollView = UIScrollView(frame: self.bounds)
       scrollView.showsHorizontalScrollIndicator = false
       scrollView.scrollsToTop = false
       return scrollView
    }()
    
    fileprivate lazy var bottomLine:UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.scrollLineColor
        bottomLine.frame.size.height =  self.style.scrollLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.scrollLineHeight
        return bottomLine
    }()
    
    
    init(frame: CGRect,titles:[String],style:ZBTitleStyle) {
        self.titles = titles
        self.style  = style
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ZBTitleView {
    fileprivate func setupUI() {
        //1 添加scrollView到view
        addSubview(scrollView)
        //2 titlelabes 添加到scrollView
        setupTitleLabel()
        //3 设置titlelabes的Frame
        setupTitleLabelFrame()
        //4 设置滚动条
        if style.isShowScrollLine{
             scrollView.addSubview(bottomLine)
        }
       
        
    }
    
    private func setupTitleLabel() {
        for(i,title) in titles.enumerated() {
            let titleLabel = UILabel()
            
            titleLabel.text = title
            titleLabel.textColor = style.normalColor
            titleLabel.font = style.fontSize
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selectedColor :style.normalColor
            
            scrollView.addSubview(titleLabel)
            
            titleLabels.append(titleLabel)
            
            //添加手势
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLableClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabel.isUserInteractionEnabled = true
        }
        
    }
    private func setupTitleLabelFrame(){
        let count = titles.count
        for (i,label) in titleLabels.enumerated(){
            var w :CGFloat = 0;
            let h :CGFloat = bounds.height;
            var x :CGFloat = 0;
            let y :CGFloat = 0;
            
            if style.isScrollEnable {//可以滚动
                w =   (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:style.fontSize], context: nil).width
                if i == 0{
                    x = style.titleMargin  * 0.5
                    if style.isShowScrollLine{
                        bottomLine.frame.origin.x = x
                        bottomLine.frame.size.width =  w
                    }
                    
                }else{
                    let preLabel = titleLabels[i-1]
                    x = preLabel.frame.maxX + style.titleMargin
                }
            }else{
                
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
                if i == 0 && style.isShowScrollLine{
                    bottomLine.frame.origin.x = 0
                    bottomLine.frame.size.width = w
                }
             
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        
        
        scrollView.contentSize = style.isScrollEnable ?  CGSize(width: titleLabels.last!.frame.maxX+style.titleMargin*0.5, height: 0):CGSize.zero
        
    }
    
}
//MARK 监听事件
extension ZBTitleView{
    @objc fileprivate func titleLableClick(_ tapGes:UITapGestureRecognizer){
        //1 取出点击的View
        let targetLabel = tapGes.view as! UILabel
        //2 调整title
        adjustTitleLabel(targetIndex: targetLabel.tag)
        //3 调整bottomLine
        if style.isShowScrollLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }
       
        
        
        //4 通知contentView
        delegate?.titleView(self, targetIndex: currentIndex)
    }
    
    fileprivate func adjustTitleLabel(targetIndex:Int){
        
        if targetIndex == currentIndex {return}
        // 1 取出label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        //2 切换颜色
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectedColor
       
        //3 记录下标
        currentIndex = targetIndex
        //4 调整位置
        if style.isScrollEnable{
            var  offsetX = targetLabel.center.x - scrollView.bounds.width*0.5
            if offsetX < 0 {
                offsetX = 0
            }
            if offsetX > (scrollView.contentSize.width - scrollView.bounds.width){
                offsetX =  scrollView.contentSize.width - scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
}

extension ZBTitleView:ZBContentViewDelegate{
    
    func contentView(_ contentView: ZBContentView, targetIndex: Int) {
       adjustTitleLabel(targetIndex: targetIndex)
        
    }
    func contentView(_ contentView: ZBContentView, targetIndex: Int, progress: CGFloat) {
        // 1 取出label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        // 2 颜色渐变
        let deltaRGB = UIColor.getRGBDelta( style.selectedColor,  style.normalColor)
        let selectedRGB = style.selectedColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress , g:  normalRGB.1 + deltaRGB.1 * progress, b:  normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectedRGB.0 - deltaRGB.0 * progress , g:  selectedRGB.1 - deltaRGB.1 * progress, b:  selectedRGB.2 - deltaRGB.2 * progress)
        
        // 3.渐变BottomLine
        if style.isShowScrollLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            bottomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
        }
    }

    
}
