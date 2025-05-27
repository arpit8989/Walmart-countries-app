//
//  CountryCell.swift
//  WalmartProject
//
//  Created by Arpit Mallick on 5/22/25.
//

import UIKit

class CountryListCell: UITableViewCell {
    static let identifier = "CountryCell"

    private let nameRegionLabel = UILabel()
    private let codeLabel = UILabel()
    private let capitalLabel = UILabel()
    private let separatorLine = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Country Name & Region
        nameRegionLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameRegionLabel.numberOfLines = 1
        nameRegionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Country Code (Right aligned)
        codeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        codeLabel.textAlignment = .right
        codeLabel.translatesAutoresizingMaskIntoConstraints = false

        // Capital City (below the first row)
        capitalLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        capitalLabel.numberOfLines = 1
        capitalLabel.translatesAutoresizingMaskIntoConstraints = false

        // Separator Line
        separatorLine.backgroundColor = .lightGray
        separatorLine.translatesAutoresizingMaskIntoConstraints = false

        // Horizontal Stack: Name+Region (Left) & Code (Right)
        let topRowStack = UIStackView(arrangedSubviews: [nameRegionLabel, codeLabel])
        topRowStack.axis = .horizontal
        topRowStack.spacing = 8
        topRowStack.alignment = .fill
        topRowStack.distribution = .equalSpacing
        topRowStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(topRowStack)
        contentView.addSubview(capitalLabel)
        contentView.addSubview(separatorLine)

        NSLayoutConstraint.activate([
            topRowStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topRowStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            topRowStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            capitalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            capitalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            capitalLabel.topAnchor.constraint(equalTo: topRowStack.bottomAnchor, constant: 4),

            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorLine.topAnchor.constraint(equalTo: capitalLabel.bottomAnchor, constant: 8),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with country: CountryModel) {
        nameRegionLabel.text = "\(country.name), \(country.region)"
        codeLabel.text = country.code
        capitalLabel.text = country.capital
    }
}
