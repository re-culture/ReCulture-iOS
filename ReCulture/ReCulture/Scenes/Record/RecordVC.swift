//
//  RecordVC.swift
//  ReCulture
//
//  Created by Jini on 5/3/24.
//

import UIKit

class RecordVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel = RecordViewModel()
    private let myviewModel = MypageViewModel()
    
    struct RecordContent {
        var title: String
        var name: String
        var id: String
        var createdAt: String
        var category: String
        var profileImage: String
        var comment: String
        var contentImages: [String]
    }
    
    var selectedCategory: String = "전체"
    
    let tempData = [
        RecordContent(title: "오늘은 시카고를 봐서 너무 행복한 하루", name: "수현", id: "@soohyun", createdAt: "4시간 전", category: "뮤지컬", profileImage: "temp1", comment: "시카고는 정말 볼 때마다 너무 재미있다... 이번에 눈, 귀 둘 다 호강하고 왔지롱", contentImages: ["temp_img"]),
        RecordContent(title: "애니메이션 러버라면 타카하타 이사오전 필수", name: "애니러버", id: "@anilover", createdAt: "12시간 전", category: "전시회", profileImage: "temp2", comment: "시카고는 정말 볼 때마다 너무 재미있다... 이번에 눈, 귀 둘 다 호강하고 왔찌롱", contentImages: ["temp_img2"]),
        RecordContent(title: "아이유 콘서트는 매번 가야겠다", name: "해삐", id: "@happygirl", createdAt: "3일 전", category: "콘서트", profileImage: "temp3", comment: "랄라", contentImages: ["temp_img2"]),
        RecordContent(title: "오늘은 시카고를 봐서 너무 행복한 하루", name: "LOVE", id: "@lovelove", createdAt: "2024.04.20", category: "뮤지컬", profileImage: "temp4", comment: "랄라", contentImages: ["temp_img"])
    ]
    
    //image는 가로스크롤 추가 예정
    
    let biglabel: UILabel = {
        let label = UILabel()
        label.text = "내 기록"
        label.textColor = UIColor.white
        label.font = UIFont.rcFont24B()
        
        return label
    }()
    
    let ticketButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.rcGrayBg
        button.setTitle("T", for: .normal)
        button.layer.cornerRadius = 8
        button.setTitleColor(UIColor.rcGray600, for: .normal)
        button.addTarget(self, action: #selector(goToTicketBook), for: .touchUpInside)
        
        return button
    }()
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let categoryScrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.showsHorizontalScrollIndicator = false
        
        return scrollview
    }()
    
    let contentTableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .singleLine
        tableview.showsVerticalScrollIndicator = false
        
        return tableview
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = UIColor.rcMain
        
        bind()
        viewModel.getmyRecords(fromCurrentVC: self)
        myviewModel.getMyInfo(fromCurrentVC: self)
        
        setupHeaderView()
        setupContentView()
        
        contentTableView.register(RecordContentCell.self, forCellReuseIdentifier: RecordContentCell.cellId)
        
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 네비게이션 바 숨김 설정
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            
        // 다른 뷰로 이동할 때 네비게이션 바 보이도록 설정
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func bind() {
        viewModel.myRecordModelDidChange = { [weak self] in
             DispatchQueue.main.async {
                 self?.contentTableView.reloadData()
             }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recordCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordContentCell.cellId, for: indexPath) as! RecordContentCell
        cell.selectionStyle = .none
        let model = viewModel.getRecord(at: indexPath.row)
        
        cell.titleLabel.text = model.culture.title
        
        cell.nameLabel.text = "\(myviewModel.getNickname())"
        let imageUrlStr = "http://34.27.50.30:8080\(myviewModel.getProfileImage())"
        imageUrlStr.loadAsyncImage(cell.profileImageView)
        
        cell.idLabel.text = "@\(model.culture.authorId)"
        cell.createDateLabel.text = model.culture.date.toDate()?.toString()
        cell.commentLabel.text = model.culture.review
        
        if let imageUrl = model.photoDocs.first {
            print("기록 이미지:\(imageUrl)")
            let baseUrl = "http://34.27.50.30:8080"
            let imageUrlStr = "\(baseUrl)\(imageUrl.url)"
            imageUrlStr.loadAsyncImage(cell.contentImageView)
        }
        

        return cell
    }

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tempData.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let data = tempData[indexPath.row]
//         
//        let cell = tableView.dequeueReusableCell(withIdentifier: RecordContentCell.cellId, for: indexPath) as! RecordContentCell
//        cell.selectionStyle = .none
//        
//        cell.profileImageView.image = UIImage(named: data.profileImage)
//        cell.titleLabel.text = data.title
//        cell.nameLabel.text = data.name
//        cell.idLabel.text = data.id
//        cell.createDateLabel.text = data.createdAt
//        cell.commentLabel.text = data.comment
//        //cell.categoryLabel.text = data.category
//
//        if let contentImage = data.contentImages.first {
//            cell.contentImageView.image = UIImage(named: contentImage)
//        }
//        
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 390
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.getRecord(at: indexPath.row)

        // 이동할 뷰 컨트롤러 초기화
        let vc = RecordDetailVC()

        // 선택된 데이터를 디테일 뷰 컨트롤러에 전달
        vc.recordId = model.culture.id
        vc.titleText = model.culture.title
        vc.creator = "\(myviewModel.getNickname())"
        vc.createdAt = model.culture.date.toDate()?.toString() ?? model.culture.date
        //vc.category = "\(model.culture.categoryId)"
        vc.contentImage = model.photoDocs.map { $0.url }

        // 뷰 컨트롤러 표시
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    

    @objc func goToTicketBook(){
        let vc = TicketBookVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupHeaderView() {
        biglabel.translatesAutoresizingMaskIntoConstraints = false
        ticketButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(biglabel)
        view.addSubview(ticketButton)
        
        NSLayoutConstraint.activate([
            biglabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            biglabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            biglabel.heightAnchor.constraint(equalToConstant: 34),
            
            ticketButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
            ticketButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -14),
            ticketButton.heightAnchor.constraint(equalToConstant: 34),
            ticketButton.widthAnchor.constraint(equalToConstant: 34)
            
        ])
    }
    
    func setupContentView() {
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        contentTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentsView)
        contentsView.addSubview(categoryView)
        contentsView.addSubview(contentTableView)
        
        NSLayoutConstraint.activate([
            contentsView.topAnchor.constraint(equalTo: biglabel.bottomAnchor, constant: 8),
            contentsView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            contentsView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            categoryView.topAnchor.constraint(equalTo: contentsView.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 60),
            
            contentTableView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 0),
            contentTableView.leadingAnchor.constraint(equalTo: contentsView.leadingAnchor),
            contentTableView.trailingAnchor.constraint(equalTo: contentsView.trailingAnchor, constant: -16),
            contentTableView.bottomAnchor.constraint(equalTo: contentsView.bottomAnchor)
        ])
        
        setupCategoryButtons()

    }
    
    func setupCategoryButtons() {

        categoryView.addSubview(categoryScrollView)
        
        NSLayoutConstraint.activate([
            categoryScrollView.topAnchor.constraint(equalTo: categoryView.topAnchor),
            categoryScrollView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor),
            categoryScrollView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor),
            categoryScrollView.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor)
        ])
        
        // Define categories
        let categories = ["전체", "뮤지컬", "전시회", "콘서트", "스포츠", "영화", "독서", "기타"]
        
        var previousButton: UIButton?

        for category in categories {
            // Create button
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.backgroundColor = category == selectedCategory ? UIColor.rcMain : UIColor.rcGray000
            button.setTitleColor(category == selectedCategory ? .white : .rcMain, for: .normal)
            button.layer.cornerRadius = 15
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false

            // Add button to scrollView
            categoryScrollView.addSubview(button)

            // Set button constraints
            NSLayoutConstraint.activate([
                button.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
                button.widthAnchor.constraint(equalToConstant: 65),
                button.heightAnchor.constraint(equalToConstant: 31)
            ])
            
            if let previousButton = previousButton {
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 8)
                ])
            } else {
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor, constant: 16)
                ])
            }

            previousButton = button

            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            
        }

        // Set content size of scrollView based on buttons
        if let lastButton = previousButton {
            NSLayoutConstraint.activate([
                lastButton.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor, constant: -16)
            ])
        }
    }
    
    @objc func categoryButtonTapped(_ sender: UIButton) {
        // Update UI based on selected category
        if let selectedCategory = sender.currentTitle {
            self.selectedCategory = selectedCategory
            updateCategoryButtonAppearance()
            print("\(selectedCategory) 버튼 선택됨")
            // Perform actions based on selected category...
        }
    }

    func updateCategoryButtonAppearance() {
        // Iterate through scrollView's subviews to update buttons
        for case let button as UIButton in categoryScrollView.subviews {
            if let category = button.currentTitle {
                button.backgroundColor = category == selectedCategory ? UIColor.rcMain : UIColor.rcGray000
                button.setTitleColor(category == selectedCategory ? .white : .rcMain, for: .normal)
            }
        }
    }
}

class RecordContentCell: UITableViewCell {
    
    static let cellId = "CellId"
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.blue
        imageView.layer.cornerRadius = 14
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont16B()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14B()
        label.textColor = UIColor.rcGray800
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont12M()
        label.textColor = UIColor.rcGray500
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let separateLineImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "separate_line")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        return imageview
    }()
    
    let createDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont12M()
        label.textColor = UIColor.rcGray500
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.rcFont14M()
        label.textColor = UIColor.rcGray800
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
//    let categoryLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.rcFont14M()
//        label.textColor = UIColor.rcMain
//        label.backgroundColor = UIColor.rcGrayBg
//        label.textAlignment = .center
//        label.layer.cornerRadius = 6
//        label.clipsToBounds = true
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        return label
//    }()
    
    let contentImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.layer.cornerRadius = 6
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(separateLineImageView)
        contentView.addSubview(idLabel)
        contentView.addSubview(createDateLabel)
        contentView.addSubview(commentLabel)
        //contentView.addSubview(categoryLabel)
        contentView.addSubview(contentImageView)

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 28),
            profileImageView.widthAnchor.constraint(equalToConstant: 28),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            
            separateLineImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            separateLineImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            separateLineImageView.heightAnchor.constraint(equalToConstant: 12),
            separateLineImageView.widthAnchor.constraint(equalToConstant: 1),
            
            //idLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            idLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
            idLabel.leadingAnchor.constraint(equalTo: separateLineImageView.trailingAnchor, constant: 8),
            idLabel.heightAnchor.constraint(equalToConstant: 15),
            
            createDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            createDateLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            createDateLabel.heightAnchor.constraint(equalToConstant: 15),
            
            titleLabel.topAnchor.constraint(equalTo: createDateLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            commentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            commentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            contentImageView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 16),
            contentImageView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            contentImageView.heightAnchor.constraint(equalToConstant: 210),
            contentImageView.widthAnchor.constraint(equalToConstant: 180)
        ])
    }

//    func bind(with model: RecordModel) {
//        titleLabel.text = model.title
//        nameLabel.text = "\(model.authorId)"
//        createDateLabel.text = model.date
//        commentLabel.text = model.review
//        // 추가적인 바인딩 로직...
//    }
    
}
