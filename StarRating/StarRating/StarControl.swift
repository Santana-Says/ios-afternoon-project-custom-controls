//
//  StarControl.swift
//  StarRating
//
//  Created by Jeffrey Santana on 8/13/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit

class StarControl: UIControl {
	
	//MARK: - IBOutlets
	
	
	//MARK: - Properties
	
	let componentDimension = CGSize(width: 40, height: 40)
	let componentCount = 6
	let componentActiveColor = UIColor.black
	let componentInactiveColor = UIColor.gray
	
	var rating = 1
	var starLabels = [UILabel]()
	
	//MARK: - Life Cycle
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		setup()
	}
	
	//MARK: - Touch Actions
	
	override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		print("Began touch...")
		updateValue(at: touch)
		
		return true
	}
	
	override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		print("Continue touching..")
		if bounds.contains(touch.location(in: self)) {
			updateValue(at: touch)
			sendActions(for: [.touchDragInside, .valueChanged])
		} else {
			sendActions(for: [.touchDragOutside])
		}
		
		return true
	}
	
	override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		print("Ending touch.")
		defer {
			super.endTracking(touch, with: event)
		}
		
		guard let touch = touch else { return }
		
		if bounds.contains(touch.location(in: self)) {
			updateValue(at: touch)
			sendActions(for: [.touchUpInside, .valueChanged])
		} else {
			sendActions(for: [.touchUpOutside])
		}
	}
	
	override func cancelTracking(with event: UIEvent?) {
		sendActions(for: [.touchCancel])
	}
	
	//MARK: - Helpers
	
	override var intrinsicContentSize: CGSize {
		let componentsWidth = CGFloat(componentCount) * componentDimension.width
		let componentsSpacing = CGFloat(componentCount + 1) * 8.0
		let width = componentsWidth + componentsSpacing
		return CGSize(width: width, height: componentDimension.height)
	}

	private func setup() {
		for index in 1...componentCount {
			let label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: componentDimension))
			
			label.text = "⭑"
			label.textColor = componentInactiveColor
			label.font = UIFont(name: label.font.fontName, size: 32)
			label.textAlignment = .center
			label.tag = index
			label.isUserInteractionEnabled = false
			
			starLabels.append(label)
		}
		
		let stackView = UIStackView(arrangedSubviews: starLabels)
		stackView.distribution = .fillEqually
		stackView.alignment = .fill
		stackView.spacing = 8
		stackView.center = center
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.isUserInteractionEnabled = false
		
		addSubview(stackView)
		
		stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
	}
	
	private func updateValue(at touch: UITouch) {
		for star in starLabels {
			if touch.location(in: self).x >= star.frame.minX {
				star.textColor = componentActiveColor
				star.performFlare()
				rating = star.tag
			} else {
				star.textColor = componentInactiveColor
			}
		}
	}
	
}
