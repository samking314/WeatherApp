//
//  SuggestionsInputView.swift
//  WeatherApp
//
//  Created by Sam King on 2/2/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation
import SnapKit

@objc
protocol SuggestionItem {
    @objc optional var title: String { get }
    @objc optional var subtitle: String { get }
}

@objc
class SuggestionsInputView: UIView {
    
    var cellStyle: UITableViewCell.CellStyle = .default
    
    var textColor: UIColor?
    var font: UIFont?
    
    var tableViewBackgroundColor: UIColor? {
        set {
            tableView.backgroundColor = newValue
        }
        get {
            return tableView.backgroundColor
        }
    }
    
    var tableViewSeparatorColor: UIColor? {
        set {
            tableView.separatorColor = newValue
        }
        get {
            return tableView.separatorColor
        }
    }
    
    var rowHeight: CGFloat = 44 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    var numberOfVisibleRows: Int = 3 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    var items: [Any] = [] {
        didSet {
            tableView.reloadData()
            invalidateIntrinsicContentSize()
        }
    }
    var onItemSelect: ((_ item: Any) -> ())?
    
    var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        autoresizingMask = [.flexibleHeight]
    }
    
    override var intrinsicContentSize: CGSize {
        let c = min(items.count, numberOfVisibleRows)
        return CGSize(width: self.bounds.width, height: CGFloat(c) * rowHeight)
    }
}

extension SuggestionsInputView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        onItemSelect?(item)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SuggestionsCell-\(cellStyle)"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: cellStyle, reuseIdentifier: identifier)
        }
        
        let item = items[indexPath.row]
        if let value = item as? SuggestionItem {
            cell.textLabel?.text = value.title
            cell.textLabel?.textColor = textColor
            if let f = font {
                cell.textLabel?.font = f
            }
            if cellStyle == .subtitle {
                cell.detailTextLabel?.text = value.subtitle
                cell.detailTextLabel?.textColor = textColor
            }
        } else if let value = item as? CustomStringConvertible {
            cell.textLabel?.text = value.description
            cell.textLabel?.textColor = textColor
            if let f = font {
                cell.textLabel?.font = f
            }
        }
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
}
