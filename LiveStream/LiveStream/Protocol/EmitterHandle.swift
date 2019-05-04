//
//  EmitterHandle.swift
//  ZBEmitterLayer
//
//  Created by zzb on 2019/5/4.
//  Copyright © 2019 zzb. All rights reserved.
//

import UIKit

protocol EmitterHandle {
    
}

extension EmitterHandle where Self:UIViewController{
    func startEmitter(_ point:CGPoint){
        // 1.创建发射器
        let emitter = CAEmitterLayer()
        // 2.发射器位置
        emitter.emitterPosition = point
        // 3.开启三维效果
        emitter.preservesDepth = true
        // 4.创建例子
        var cells = [CAEmitterCell]()
        for i in 0..<10 {
            let cell = CAEmitterCell()
            //速度
            cell.velocity = 200
            cell.velocityRange = 150
            //大小
            cell.scale = 0.8
            cell.scaleRange = 0.4
            //方向 垂直
            //        cell.emissionLatitude 水平
            cell.emissionLongitude  = CGFloat(-(Double.pi / 2))
            cell.emissionRange  = CGFloat(Double.pi / 12)
            
            //存活时间
            cell.lifetime  = 3
            cell.lifetimeRange = 1.5
            
            //设置每秒弹出个数
            cell.birthRate = 3
            
            //图片
            cell.contents = UIImage(named: "good\(i)_30x30")?.cgImage
            cells.append(cell)
        }
        
        //5.粒子设置到发射器中
        emitter.emitterCells = cells
        
        //6 layer 添加
        view.layer.addSublayer(emitter)
    }
    
    func stopEmitter(){
        view.layer.sublayers?.filter({$0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
        
//        for layer in view.layer.sublayers! {
//            if layer.isKind(of: CAEmitterLayer.self){
//                layer.removeFromSuperlayer()
//            }
//        }
    }
    
    
}
