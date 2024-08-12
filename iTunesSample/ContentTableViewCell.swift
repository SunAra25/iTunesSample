//
//  SearchTableViewCell.swift
//  iTunesSample
//
//  Created by 아라 on 8/8/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class ContentTableViewCell: UITableViewCell {
    static let identifier = "ContentTableViewCell"
    var disposeBag = DisposeBag()
    
    private let appLogoImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private let labelView = UIView()
    private let appTitleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let descriptionLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let downloadButton = {
        let button = UIButton()
        var attr = AttributedString.init("받기")
        attr.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attr
        config.baseForegroundColor = .systemBlue
        config.baseBackgroundColor = .systemGray
        button.configuration = config
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    private let aveRatingButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        let image = UIImage(systemName: "star.fill", withConfiguration: imageConfig)
        config.image = image
        config.baseForegroundColor = .systemBlue
        config.buttonSize = .small
        button.configuration = config
        button.isEnabled = false
        return button
    }()
    private let artistNameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    private let genreLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        return label
    }()
    private let collectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 8
        let inset: CGFloat = 16
        let width = (screenWidth - 2 * padding - 2 * inset) / 3
        layout.itemSize = CGSize(width: width, height: 200)
        layout.sectionInset = .init(top: 0, left: inset, bottom: 0, right: inset)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = padding
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ScreenShotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenShotCollectionViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [appLogoImageView, labelView, downloadButton, aveRatingButton, artistNameLabel, genreLabel, collectionView].forEach {
            contentView.addSubview($0)
        }
        
        [appTitleLabel, descriptionLabel].forEach {
            labelView.addSubview($0)
        }
        
        appLogoImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.size.equalTo(56)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(appLogoImageView)
            make.width.equalTo(48)
            make.height.equalTo(32)
        }
        
        labelView.snp.makeConstraints { make in
            make.centerY.equalTo(appLogoImageView)
            make.leading.equalTo(appLogoImageView.snp.trailing).offset(8)
            make.trailing.equalTo(downloadButton.snp.leading).offset(-8)
        }
        
        appTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(appTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        aveRatingButton.snp.makeConstraints { make in
            make.top.equalTo(appLogoImageView.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(8)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(aveRatingButton)
            make.centerX.equalToSuperview()
        }
        
        genreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(aveRatingButton)
            make.trailing.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(artistNameLabel.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureCell(_ data: SearchResult) {
        let logoURL = URL(string: data.artworkUrl512)
        appLogoImageView.kf.setImage(with: logoURL)
        appTitleLabel.text = data.trackName
        aveRatingButton.configuration?.title = String(format: "%.1f", data.averageUserRating)
        artistNameLabel.text = data.artistName
        genreLabel.text = data.primaryGenreName
        
        let screenShot = BehaviorSubject<[String]>(value: data.screenshotUrls)
        screenShot
            .bind(to: collectionView.rx.items(cellIdentifier: ScreenShotCollectionViewCell.identifier, cellType: ScreenShotCollectionViewCell.self)) { row, element, cell in
                cell.configureCell(URL(string: element))
            }.disposed(by: disposeBag)
        
        collectionView.layoutIfNeeded()
    }
}
