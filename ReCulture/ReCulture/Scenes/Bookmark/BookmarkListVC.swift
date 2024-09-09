//
//  BookmarkListVC.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 9/7/24.
//

import UIKit

class BookmarkListVC: UIViewController {
    
    // MARK: - Properties
    
    private let tagMinimumLineSpacing: CGFloat = 0
    private let tagMinimumInterItemSpacing: CGFloat = 8
    private let viewModel = BookmarkViewModel()
    private var isAllTagSelected = true  // 태그 필터링 초기화 - 전체로
    private var selectedCategory: RecordType = .all
    
    // MARK: - Views
    
    private lazy var tagCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = tagMinimumLineSpacing
        flowLayout.minimumInteritemSpacing = tagMinimumInterItemSpacing
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        return view
    }()
    
    private lazy var recordTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchContentCell.self, forCellReuseIdentifier: SearchContentCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupTagCollectionView()
        setupRecordTableView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getBookmarkList(fromCurrentVC: self)
    }
    
    // MARK: - Layouts
    
    private func setupNavigationBar() {
        self.navigationItem.title = "내 북마크"
    }
    
    private func setupTagCollectionView() {
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tagCollectionView)
        
        NSLayoutConstraint.activate([
            tagCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tagCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tagCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tagCollectionView.heightAnchor.constraint(equalToConstant: 33),
            
        ])
    }
    
    private func setupRecordTableView() {
        recordTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(recordTableView)
        
        NSLayoutConstraint.activate([
            recordTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            recordTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            recordTableView.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor),
            recordTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Functions
    
    private func filterRecordsBy(_ type: RecordType){
//        filteredTickets.removeAll()
//        
//        if type != .all {
//            for i in 0 ..< viewModel.getMyTicketBookCount() {
//                let data = viewModel.getMyTicketBookDetailAt(i)
//                if data.categoryType == type {
//                    print(data)
//                    filteredTickets.append(data)
//                }
//            }
//        }
//        
//        ticketCollectionView.reloadData()
    }
    
    private func bind() {
        viewModel.bookmarkListDidChange = { [weak self] in
            print("==== bind() ====")
            DispatchQueue.main.async {
                self?.recordTableView.reloadData()
            }
        }
    }
}

// MARK: - Extension: CollectionView

extension BookmarkListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecordType.allTypesWithAll.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier,
                                                               for: indexPath) as? TagCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.configure(tag: RecordType.allTypesWithAll[indexPath.item].rawValue)
        
        if indexPath.item == 0 && isAllTagSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            cell.isSelected = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isAllTagSelected = false
        selectedCategory = RecordType.allTypesWithAll[indexPath.item]
        print("selected filter item: \(selectedCategory.rawValue)")
        filterRecordsBy(selectedCategory)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier,
                                                               for: indexPath) as? TagCollectionViewCell
        else { return .zero }
        
        cell.configure(tag: RecordType.allTypesWithAll[indexPath.item].rawValue)
        // ✅ sizeToFit() : 텍스트에 맞게 사이즈가 조절

        // ✅ cellWidth = 글자수에 맞는 UILabel 의 width + 24(여백)
        let cellFrame = cell.getLabelFrame()
        let cellWidth = cellFrame.width + 24
        let cellHeight = cellFrame.height + 12

        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: - Extension: UITableView

extension BookmarkListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getBookmarkCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchContentCell.cellId, for: indexPath) as? SearchContentCell else { return UITableViewCell() }
        cell.selectionStyle = .none

        let bookmarkData = viewModel.getBookmarkAt(indexPath.row)
        
        let authorId = bookmarkData.postOwnerId
        
//        if let userProfile = viewModel.getUserProfileModel(for: authorId) {
//            cell.creatorLabel.text = userProfile.nickname
//            if let profileImageUrl = userProfile.profilePhoto {
//                let imageUrlStr = "http://34.27.50.30:8080\(profileImageUrl)"
//                imageUrlStr.loadAsyncImage(cell.profileImageView)
//            }
//        } else {
//            // Fetch user profile if not loaded yet
//            viewModel.getUserProfile(userId: authorId) { userProfile in
//                DispatchQueue.main.async {
//                    cell.creatorLabel.text = userProfile?.nickname
//                    if let profileImageUrl = userProfile?.profilePhoto {
//                        let imageUrlStr = "http://34.27.50.30:8080\(profileImageUrl)"
//                        imageUrlStr.loadAsyncImage(cell.profileImageView)
//                    }
//                }
//            }
//        }
    
        cell.creatorLabel.text = "바꿔야 함"
        cell.titleLabel.text = bookmarkData.title

        if let date = bookmarkData.date.toDate() {
            cell.createDateLabel.text = date.toString()
        } else {
            cell.createDateLabel.text = bookmarkData.date
        }
        
//        let category: String
//        switch bookmarkData.categoryType+1 {
//        case 1:
//            category = "영화"
//        case 2:
//            category = "뮤지컬"
//        case 3:
//            category = "연극"
//        case 4:
//            category = "스포츠"
//        case 5:
//            category = "콘서트"
//        case 6:
//            category = "드라마"
//        case 7:
//            category = "독서"
//        case 8:
//            category = "전시회"
//        case 9:
//            category = "기타"
//        default:
//            category = "기타"
//        }
        cell.categoryLabel.text = bookmarkData.categoryType.rawValue
        cell.contentImageView.loadImage(urlWithoutBaseURL: bookmarkData.firstImageURL)
        return cell
    }
}