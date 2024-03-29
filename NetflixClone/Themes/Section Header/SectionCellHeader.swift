//
//  TableCellHeader.swift
//  NetflixClone
//
//  Created by Adlan Nourindiaz on 10/04/23.
//

import UIKit

class SectionCellHeader: UITableViewHeaderFooterView {
    static let identifier = "SectionCellHeader"
    private var sectionIndex: Int?
    var homeVCDelegate: TabBarControllerDelegate?
    var navigationController: UINavigationController?

    
    private lazy var headerTitle: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return lb
    }()
    
    private lazy var viewAllButton: UIButton = {
        let bt = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 25))
//        bt.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        bt.setTitle("View All", for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.tintColor = UIColor.label
        bt.addTarget(self, action: #selector(tapViewAllButton(sender:)), for: .touchUpInside)

        return bt
    }()
    
    func addSubviews() {
        self.contentView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        contentView.addSubview(headerTitle)
        contentView.addSubview(viewAllButton)
        
        setupHeaderTitle()
        setupViewAllButton()
    }
    
    func setupHeaderTitle() {
        NSLayoutConstraint.activate([
            headerTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10),
            headerTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            headerTitle.trailingAnchor.constraint(equalTo: viewAllButton.leadingAnchor, constant: -10),
        ])
    }
    
    func setupViewAllButton() {
        NSLayoutConstraint.activate([
            viewAllButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 14),
            viewAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    func configure(title: String, index: Int) {
        headerTitle.text = title
        self.sectionIndex = index
        let sections = TableSections(rawValue: self.sectionIndex ?? 0)
        
        switch sections {
        case .genres:
            viewAllButton.isHidden = true
        default:
            viewAllButton.isHidden = false
        }
    }

    @objc
    func tapViewAllButton(sender: UIButton){
        guard let navigationController = self.navigationController else { return }
        homeVCDelegate?.moveToViewAllPage(section: self.sectionIndex ?? 0, navCon: navigationController)
    }
}
