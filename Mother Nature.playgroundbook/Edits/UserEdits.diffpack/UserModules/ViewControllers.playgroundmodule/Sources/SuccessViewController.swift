import UIKit

final class SuccessViewController: UIViewController {
    
    
    
    //MARK:- Variables
    
    let stackView = UIStackView()
    
    var buttonClose = UIButton()
    
    
    
    //MARK:- Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonClose()
        setupStackView()
        setupView()
    }
    
    
    
    //MARK:- Functions
    
    @objc func dismiss(sender: UIButton) { DispatchQueue.main.async { [weak self] in self?.dismiss(animated: true) } }
    
    func setupButtonClose() {
        buttonClose = makeButton(backgroundColor: UIColor(red: 224%, green: 203%, blue: 174%, alpha: 0.9), fontWeight: .bold, shadowColor: .black, title: "Close", titleColor: UIColor(red: 0%, green: 107%, blue: 214%, alpha: 1))
        buttonClose.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        view.addSubview(buttonClose)
        buttonClose.layout([
            buttonClose.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            buttonClose.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonClose.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setupStackView() {
        let labelDescription = UILabel()
        let labelTitle = UILabel()
        labelDescription.font = .systemFont(ofSize: 20)
        labelDescription.numberOfLines = 0
        labelDescription.textAlignment = .center
        labelDescription.text = "You have discovered all of nature's deepest secrets. Yet, the adventure is only at its beginning. In the meantime, enjoy your accomplishments and cherish your perseverance."
        labelTitle.font = .boldSystemFont(ofSize: 50)
        labelTitle.text = "Congratulations!"
        [labelTitle, labelDescription].forEach {
            stackView.addArrangedSubview($0)
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 3, height: 3)
            $0.layer.shadowOpacity = 0.25
            $0.layer.shadowRadius = 10
            $0.textColor = .white
        }
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.layout([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupView() {
        view.backgroundColor = UIColor(red: 224%, green: 203%, blue: 174%, alpha: 1)
        view.setBackgroundImage(#imageLiteral(resourceName: "Background.jpg"))
    }
    
}
