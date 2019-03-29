//
//  JCGGProgressBar.swift
//  JCGGProgressBar
//
//  Created by Jacob Gold on 23/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//

import Cocoa

@IBDesignable
open class JCGGProgressBar: NSView {
    
    // Progress bar color
    @IBInspectable public var barColor: NSColor = NSColor.labelColor
    // Track color
    @IBInspectable public var trackColor: NSColor = NSColor.secondaryLabelColor
    // Progress bar thickness
    @IBInspectable public var barThickness: CGFloat = 10
    // Progress amount
    @IBInspectable public var progressValue: CGFloat = 0 {
        didSet {
            progressValue = min(max(progressValue, 0), 100)
            needsDisplay = true
        }
    }
    // Corner radius
    @IBInspectable public var cornerRadius: CGFloat = 2.5 {
        didSet {
            cornerRadius = min(max(cornerRadius, 0), barThickness / 2)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = NSGraphicsContext.current?.cgContext else {return}
        
        let trackRectangle = CGRect(x: barThickness / 2,
                                    y: (rect.height - barThickness) / 2 ,
                                    width: rect.width - (barThickness / 2),
                                    height: barThickness)
        let trackRoundedRectangle = CGPath(roundedRect: trackRectangle,
                                           cornerWidth: cornerRadius, cornerHeight:cornerRadius,
                                           transform: nil)
        
        // Progress Track
        context.setFillColor(trackColor.cgColor)
        context.addPath(trackRoundedRectangle)
        context.fillPath()
        
        // Progress Bar
        let progressRectangle = CGRect(x: barThickness / 2,
                                       y: (rect.height - barThickness) / 2,
                                       width: percentage() + (barThickness / 2),
                                       height: barThickness)
        let progressRoundedRectangle = CGPath(roundedRect: progressRectangle,
                                              cornerWidth: cornerRadius, cornerHeight: cornerRadius,
                                              transform: nil)
        
        context.setStrokeColor(barColor.cgColor)
        context.setFillColor(barColor.cgColor)
        context.addPath(progressRoundedRectangle)
        context.fillPath()
    }
    
    private func percentage() -> CGFloat {
        let screenWidth = frame.size.width - barThickness
        return ((progressValue / 100) * screenWidth)
    }
    
}
