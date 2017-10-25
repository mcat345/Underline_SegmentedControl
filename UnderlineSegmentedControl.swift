//
//  UnderlineSegmentedControl.swift
//
//  Created by Denis Baralei on 10/25/17.
//

import UIKit
 class UnderlineSegmentedControl: UIControl {
  private var labels = [UILabel]()
  var selectedView = UIView()
  var labelColor = UIColor.App.purpleyGrey.color
  var labelFont = UIFont.appRegularFont(11)
  var selectedFont = UIFont.appMediumFont(11)
  var selectedColor = UIColor.black
  var underlineColor = UIColor.black
  var showUnderline = true
  var items: [String] = ["Label 1", "Label 2", "Label 3"] {
    didSet {
      setupLabels()
    }
  }
  var selectedIndex: Int = 0 {
    didSet {
      displayNewSelectedIndex()
    }
  }
  func setupView() {
    backgroundColor = UIColor.clear
    setupLabels()
    addSubview(selectedView)
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  func setupLabels() {
    for label in labels {
      label.removeFromSuperview()
    }
    labels.removeAll(keepingCapacity: true)
    for _ in 1...items.count {
      let label = UILabel(frame: .zero)
      label.textAlignment = .center
      label.layer.borderWidth = 0
      label.backgroundColor = UIColor.clear
      label.textColor = labelColor
      label.font = labelFont
      self.addSubview(label)
      labels.append(label)
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    var selectedFrame = self.bounds
    let newWidth = selectedFrame.width / CGFloat(items.count)
    selectedFrame.size.width = newWidth
    selectedView.frame = selectedFrame
    let labelHeight = self.bounds.height
    let labelWidth = self.bounds.width / CGFloat(labels.count)
    for index in 0...labels.count - 1 {
      let label = labels[index]
      label.text =  items[index]
      let xPosition = CGFloat(index) * labelWidth
      label.frame = CGRect(x: xPosition, y: 0, width: labelWidth, height: labelHeight)
    }
  }
  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let location = touch.location(in: self)
    var calculatedIndex: Int?
    for (index, item) in labels.enumerated() {
      if item.frame.contains(location) {
        calculatedIndex = index
      }
    }
    if calculatedIndex != nil {
      selectedIndex = calculatedIndex!
      sendActions(for: .valueChanged)
    }
    return false
  }
  func displayNewSelectedIndex() {
   _ = labels.map {
      $0.textColor = labelColor
      $0.font = labelFont
    }
    let label = labels[selectedIndex]
    label.textColor = selectedColor
    label.font = selectedFont
    if showUnderline {
      let bottomBorder = CALayer()
      bottomBorder.backgroundColor = underlineColor.cgColor
      bottomBorder.frame = CGRect(x: 0, y: label.frame.size.height, width: label.frame.size.width, height: 2)
      self.selectedView.layer.addSublayer(bottomBorder)
    }
    self.selectedView.frame = label.frame
  }
}
