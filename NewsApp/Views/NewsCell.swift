import UIKit

class NewsCell: UITableViewCell {

    // MARK: - Variables -
    
    static let identifier = Constants.NewsCellIdentifer
    
    // MARK: - UI -
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.placeholderImage
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Init -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(
            x: 5,
            y: 0,
            width: contentView.frame.size.width - 170,
            height: 70
        )
        
        subTitleLabel.frame = CGRect(
            x: 5,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height / 2
        )
        
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 160,
            y: 5,
            width: 150,
            height: contentView.frame.size.height - 10
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsTitleLabel.text = nil
        subTitleLabel.text  = nil
        newsImageView.image = nil
    }
    
    // MARK: - Helper Functions -
    
    func configure(with viewModel: NewsCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        
        // first time the cell loads, this imageData is gonna be nil so it will download the iamge and cahce it
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            // fetch the image from the api using the viewmodel imageURL
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }

                /**
                 * then cach the data we get from the api in the imageData property of the viewmodel
                 * so that tne next time the cell load it won't download the iamge aagain
                 */
                viewModel.imageData = data

                // and set the image with it in the main thread
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }

}
