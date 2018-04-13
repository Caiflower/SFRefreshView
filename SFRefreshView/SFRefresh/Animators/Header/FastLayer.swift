//
//  FastLayer.swift
//  CRRefresh
//
// **************************************************
// *                                  _____         *
// *         __  _  __     ___        \   /         *
// *         \ \/ \/ /    / __\       /  /          *
// *          \  _  /    | (__       /  /           *
// *           \/ \/      \___/     /  /__          *
// *                               /_____/          *
// *                                                *
// **************************************************
//  Github  :https://github.com/imwcl
//  HomePage:https://imwcl.com
//  CSDN    :http://blog.csdn.net/wang631106979
//
//  Created by 王崇磊 on 16/9/14.
//  Copyright © 2016年 王崇磊. All rights reserved.
//
// @class FastLayer
// @abstract FastLayer
// @discussion FastLayer
//

import UIKit

@objc open class FastLayer: CALayer {
    
    @objc public var circle: FastCircleLayer?
    
    @objc public var arrow: FastArrowLayer?
    
    var color: UIColor
    
    var arrowColor: UIColor

    var lineWidth: CGFloat
    
    //MARK: Public Methods
    
    
    //MARK: Override
    
    
    //MARK: Initial Methods
   @objc init(frame: CGRect, color: UIColor = UIColor.coler(hex: 0xffd52b), arrowColor: UIColor = UIColor.coler(hex: 0x333333), lineWidth: CGFloat = 2.5) {
        self.color      = color
        self.arrowColor = arrowColor
        self.lineWidth  = lineWidth
        super.init()
        self.frame = frame
        initCircle()
        initArrowLayer()
        backgroundColor = UIColor.clear.cgColor
    }
    
    public override init() {
        self.color      = .init(rgb: (214, 214, 214))
        self.arrowColor = .init(rgb: (165, 165, 165))
        self.lineWidth  = 2.5
        super.init()
        self.frame = frame;
        initCircle()
        initArrowLayer()
        backgroundColor = UIColor.clear.cgColor
    }
    @objc open static func layer(frame: CGRect, lineWidth:(CGFloat)) -> FastLayer {
        return FastLayer(frame: frame, lineWidth: lineWidth)
    }
 
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Privater Methods
    private func initCircle() {
        circle = FastCircleLayer(frame: bounds, color: color, pointColor: arrowColor, lineWidth: lineWidth)
        addSublayer(circle!)
    }
    
    private func initArrowLayer() {
        arrow = FastArrowLayer(frame: bounds, color: arrowColor, lineWidth: lineWidth)
        addSublayer(arrow!)
    }
    
}
