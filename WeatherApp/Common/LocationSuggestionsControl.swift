//
//  LocationSuggestionsControl.swift
//  WeatherApp
//
//  Created by Sam King on 2/2/19.
//  Copyright © 2019 Sam King. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MKLocalSearchCompletion: SuggestionItem {
    
}

@objc
@objcMembers
class LocationSuggestionsControl: NSObject, MKLocalSearchCompleterDelegate {
    
    var textField: UITextField
    
    var suggestionsView: SuggestionsInputView
    var localSearchCompleter: MKLocalSearchCompleter
    
    var items: [MKLocalSearchCompletion] = [] {
        didSet {
            suggestionsView.items = items
        }
    }
    
    init(textField field: UITextField) {
        textField = field
        suggestionsView = SuggestionsInputView()
        localSearchCompleter = MKLocalSearchCompleter()
        super.init()
        
        localSearchCompleter.delegate = self
        localSearchCompleter.filterType = .locationsOnly
        
        field.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        field.inputAccessoryView = suggestionsView
        
        suggestionsView.cellStyle = .subtitle
        suggestionsView.rowHeight = 44
        suggestionsView.backgroundColor = UIColor.white
        suggestionsView.tableViewBackgroundColor = UIColor.white
        suggestionsView.tableViewSeparatorColor = UIColor.clear
        suggestionsView.onItemSelect = { [weak self] item in
            if let c = item as? MKLocalSearchCompletion {
                if c.subtitle.count > 0 {
                    self?.textField.text = "\(c.title), \(c.subtitle)"
                } else {
                    self?.textField.text = "\(c.title)"
                }
                self?.textField.endEditing(true)
            }
        }
        
    }
    
    @objc
    fileprivate func textDidChange() {
        if let text = textField.text {
            localSearchCompleter.queryFragment = text
        }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        items = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
    }
}
