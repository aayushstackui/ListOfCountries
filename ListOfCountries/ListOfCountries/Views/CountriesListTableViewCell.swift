//
//  CountriesListTableViewCell.swift
//  ListOfCountries
//
//  Created by Aayush Raghuvanshi on 4/30/25.
//

import Foundation
import UIKit

class CountriesListTableViewCell: UITableViewCell {
    static let identifier = "CountriesListTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let nameRegionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private let capitalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupAccessibility()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(nameRegionLabel)
        containerView.addSubview(codeLabel)
        containerView.addSubview(capitalLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nameRegionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameRegionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameRegionLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -60),
            
            codeLabel.centerYAnchor.constraint(equalTo: nameRegionLabel.centerYAnchor),
            codeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            codeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            capitalLabel.topAnchor.constraint(equalTo: nameRegionLabel.bottomAnchor, constant: 6),
            capitalLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            capitalLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -60),
            capitalLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupAccessibility() {
        isAccessibilityElement = true
        nameRegionLabel.isAccessibilityElement = false
        codeLabel.isAccessibilityElement = false
        capitalLabel.isAccessibilityElement = false
        accessibilityTraits = .staticText
    }
    
    func configure(with country: CountryModel) {
        nameRegionLabel.text = "\(country.name.isEmpty ? "Unknown" : country.name), \(country.region.isEmpty ? "N/A" : country.region)"
        codeLabel.text = country.code.isEmpty ? "N/A" : country.code
        capitalLabel.text = country.capital.isEmpty ? "Unknown" : country.capital
        
        accessibilityLabel = "\(country.name.isEmpty ? "Unknown" : country.name), located in \(country.region.isEmpty ? "an unknown region" : country.region), with country code \(country.code.isEmpty ? "not available" : country.code), and capital \(country.capital.isEmpty ? "unknown" : country.capital)"
        accessibilityHint = "Country information"
    }
}
