//
//  DetailViewController.swift
//  iTunesSample
//
//  Created by 아라 on 8/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class DetailViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let appLogoImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        return view
    }()
    private let appTitleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let artistNameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    private let downloadButton = {
        let button = UIButton()
        var attr = AttributedString.init("받기")
        attr.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attr
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .systemGray
        button.configuration = config
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    private let newTitleLabel = {
        let label = UILabel()
        label.text = "새로운 소식"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    private let versionLabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    private let newContentLabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    private let collectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth * 0.7
        layout.itemSize = CGSize(width: width, height: width * 1.8)
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ScreenShotCollectionViewCell.self, forCellWithReuseIdentifier: ScreenShotCollectionViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    private let appData: SearchResult
    private let viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    init(data: SearchResult) {
        appData = data
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigation()
        setConstraints()
        setLayout()
    }
    
    private func setNavigation() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func bind() {
        let receiveData = PublishSubject<SearchResult>()
        receiveData.onNext(appData)
        
        let input = DetailViewModel.Input(receiveData: receiveData)
        let output = viewModel.transform(input: input)
        
        output.configureData
            .bind(with: self) { owner, value in
                print(value)
                let logoURL = URL(string: value.artworkUrl512)
                owner.appLogoImageView.kf.setImage(with: logoURL)
                owner.appTitleLabel.text = value.trackName
                owner.artistNameLabel.text = value.artistName
                owner.versionLabel.text = "버전 \(value.version)"
                owner.newContentLabel.text = value.releaseNotes
//                let screenShot = BehaviorSubject<[String]>(value: data.screenshotUrls)
//                screenShot
//                    .bind(to: collectionView.rx.items(cellIdentifier: ScreenShotCollectionViewCell.identifier, cellType: ScreenShotCollectionViewCell.self)) { row, element, cell in
//                        cell.configureCell(URL(string: element))
//                    }.disposed(by: disposeBag)
                
            }.disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [appLogoImageView, appTitleLabel, artistNameLabel, downloadButton, newTitleLabel, versionLabel, newContentLabel, collectionView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview()
        }
        
        appLogoImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(120)
        }
        
        appTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(appLogoImageView).offset(8)
            make.leading.equalTo(appLogoImageView.snp.trailing).offset(8)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(appTitleLabel)
            make.bottom.equalTo(appLogoImageView)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(downloadButton)
            make.bottom.equalTo(downloadButton.snp.top).offset(-8)
        }
        
        newTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(appLogoImageView.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(newTitleLabel.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        newContentLabel.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(newContentLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
