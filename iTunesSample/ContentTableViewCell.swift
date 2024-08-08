//
//  SearchTableViewCell.swift
//  iTunesSample
//
//  Created by 아라 on 8/8/24.
//

import UIKit
import SnapKit

final class ContentTableViewCell: UITableViewCell {
    static let identifier = "ContentTableViewCell"
    
    private let contentLabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    private let collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.sectionInset = .init(top: 8, left: 16, bottom: 8, right: 16)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(contentLabel)
        contentView.addSubview(collectionView)
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
