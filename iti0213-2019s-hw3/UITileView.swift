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
        case EMPTY
        case BOMB
        case NUMBER
        case FLAG
        case BAIT
    }
    
    var state: TileState = TileState.FLAG {didSet {setNeedsDisplay()}}
    
    @IBInspectable
    var colorHidden: UIColor = UIColor.gray {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorEmpty: UIColor = UIColor.darkGray {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorBomb: UIColor = UIColor.black {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorOne: UIColor = UIColor.blue {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorTwo: UIColor = UIColor.green {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorThree: UIColor = UIColor.red {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorMore: UIColor = UIColor.purple {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorFlag: UIColor = UIColor.red {didSet {setNeedsDisplay()}}
    @IBInspectable
    var colorBait: UIColor = UIColor.orange {didSet {setNeedsDisplay()}}
    
    @IBInspectable
    var positionX: Int = 0
    @IBInspectable
    var positionY: Int = 0
    
    @IBInspectable
    var closeBombsCount: Int = 0 {didSet {setNeedsDisplay()}}
    
    
    // Should be 1:1 aspect ratio tho
    private var size: Int {return Int(bounds.width > bounds.height ? bounds.height : bounds.width)}
    
    override func draw(_ rect: CGRect) {
        switch state {
        case .HIDDEN:
            break
        case .EMPTY:
            drawBorder()
        case .BOMB:
            break
        case .NUMBER:
            break
        case .FLAG:
            drawText(text: "a")
        case .BAIT:
            drawText(text: "b")
            drawCross()
        }
    }
    
    private func drawBorder() {
        let path = UIBezierPath()
    
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: size, y: 0))
        path.addLine(to: CGPoint(x: size, y: size))
        path.addLine(to: CGPoint(x: 0, y: size))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.lineWidth = 8
        path.stroke()
    }
    
    private func drawText(text: String) {
        colorEmpty.set()
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        path.fill()
        
        let font=UIFont(name: "Helvetica-Bold", size: CGFloat(size))!
        let text_style=NSMutableParagraphStyle()
        text_style.alignment=NSTextAlignment.center
        let text_color=UIColor.white
        let attributes=[NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:text_style, NSAttributedString.Key.foregroundColor:text_color]

        //vertically center (depending on font)
        let text_h=font.lineHeight
        let text_y=(CGFloat(size)-text_h)/2
        let text_rect=CGRect(x: 0, y: text_y, width: CGFloat(size), height: text_h)
        text.draw(in: text_rect.integral, withAttributes: attributes)
    }
    
    private func drawCross() {
        let path = UIBezierPath()
        let sizef = Double(size)

        path.addArc(withCenter: CGPoint(x: size/2, y: size/2),
                    radius: CGFloat(size/4),
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: true
        )
        
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
