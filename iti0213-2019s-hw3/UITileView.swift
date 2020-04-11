//
//  UITileView.swift
//  iti0213-2019s-hw3
//
//  Created by user169473 on 4/10/20.
//  Copyright © 2020 taannu. All rights reserved.
//

import UIKit

@IBDesignable
class UITileView: UIView {
    enum TileState {
        case HIDDEN
        case BOMB
        case NUMBER
        case FLAG
        case BAIT
    }
    
    var state: TileState = TileState.HIDDEN {didSet {setNeedsDisplay()}}
    
    @IBInspectable
    var colorHidden: UIColor = UIColor.gray {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorBorder: UIColor = UIColor.darkGray {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorBackground: UIColor = UIColor.lightGray {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorBehind: UIColor = UIColor.white {didSet {setNeedsDisplay()}}
    
    @IBInspectable
    var colorOne: UIColor = UIColor.blue {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorTwo: UIColor = UIColor.green {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorThree: UIColor = UIColor.red {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorMore: UIColor = UIColor.purple {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorCross: UIColor = UIColor.red {didSet {setNeedsDisplay()}}
    
    
    @IBInspectable
    var positionX: Int = 0
    @IBInspectable
    var positionY: Int = 0
    
    @IBInspectable
    var closeBombsCount: Int = 0 {didSet {setNeedsDisplay()}}
    
    
    // Should be 1:1 aspect ratio tho
    private var size: Int {return Int(bounds.width > bounds.height ? bounds.height : bounds.width)}
    
    init(frame: CGRect, x: Int, y: Int) {
        super.init(frame: frame)
        self.positionX = x
        self.positionY = y
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawBorder()
        switch state {
        case .HIDDEN:
            drawHidden()
        case .BOMB:
            drawText(text: "💣", color: UIColor.black)
        case .NUMBER:
            drawText(text: closeBombsCount > 0 ? String(closeBombsCount) : "", color: getNumberColor(number: closeBombsCount))
        case .FLAG:
            drawHidden()
            drawText(text: "🚩", color: UIColor.black)
        case .BAIT:
            drawText(text: "💣", color: UIColor.black)
            drawCross()
        }
    }
    
    private func drawBorder() {
        colorBehind.set()
        let behindPath = UIBezierPath(roundedRect: bounds, cornerRadius: 0)
        behindPath.fill()
        
        colorBorder.set()
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        path.fill()
        
        colorBackground.set()
        let centerPath = UIBezierPath(roundedRect: bounds.insetBy(dx: 4, dy: 4), cornerRadius: 10)
        centerPath.fill()

    }
    
    private func drawHidden() {
        colorBorder.set()
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        path.fill()
    }
    
    private func drawText(text: String, color: UIColor) {
        let font=UIFont(name: "Helvetica-Bold", size: CGFloat(Double(size) * 0.9))!
        let text_style=NSMutableParagraphStyle()
        text_style.alignment=NSTextAlignment.center
        let text_color=color
        let attributes=[NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:text_style, NSAttributedString.Key.foregroundColor:text_color]

        //vertically center (depending on font)
        let text_h=font.lineHeight
        let text_y=(CGFloat(bounds.height)-text_h)/2
        let text_rect=CGRect(x: (bounds.width - CGFloat(size)) / 2, y: text_y, width: CGFloat(size), height: text_h)
        text.draw(in: text_rect.integral, withAttributes: attributes)
    }
    
    private func drawCross() {
        let path = UIBezierPath()
        let sizef = Double(size)
        colorCross.set()
        path.move(to: CGPoint(x: sizef/5, y: sizef/5))
        path.addLine(to: CGPoint(x: sizef-sizef/5, y: sizef-sizef/5))
        path.move(to: CGPoint(x: sizef/5, y: sizef-sizef/5))
        path.addLine(to: CGPoint(x: sizef-sizef/5, y: sizef/5))
        
        path.lineWidth = 8
        path.stroke()
    }
    
    private func getNumberColor(number: Int) -> UIColor {
        switch number {
        case 1:
            return colorOne
        case 2:
            return colorTwo
        case 3:
            return colorThree
        default:
            return colorMore
        }
    }
}
