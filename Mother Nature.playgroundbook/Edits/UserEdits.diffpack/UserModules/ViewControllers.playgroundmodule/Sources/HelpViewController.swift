import UIKit

final class HelpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    //MARK:- Variables
    
    let helpData = [(nil, "You are about to enter an incredible world, full of intrigue and mystery. May I wish you luck with your quest in finding all of nature's hidden elements."),
                    (#imageLiteral(resourceName: "Image-Help-1.jpg"), "Tap and hold to drag an element around."), (#imageLiteral(resourceName: "Image-Help-2.jpg"), "Release the element on the workspace."), (#imageLiteral(resourceName: "Image-Help-3.jpg"), "Put elements on top of each other and wait for the magic to appear!"), (#imageLiteral(resourceName: "Image-Help-4.jpg"), "But beware! Slightly faded out elements are at their purest form and do not give any results.")]
    let tableView = UITableView()
    
    var buttonClose = UIButton()
    
    
    
    //MARK:- Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonClose()
        setupTableView()
        setupView()
    }
    
    
    
    //MARK:- UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { helpData.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let imageView = UIImageView()
        let label = UILabel()
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        imageView.contentMode = .scaleAspectFill
        imageView.image = helpData[indexPath.row].0
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        imageView.layer.shadowOpacity = 0.25
        imageView.layer.shadowRadius = 10
        cell.addSubview(imageView)
        label.font = helpData[indexPath.row].0 != nil ? .systemFont(ofSize: 20) : .boldSystemFont(ofSize: 20)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 3, height: 3)
        label.layer.shadowOpacity = 0.25
        label.layer.shadowRadius = 10
        label.numberOfLines = 0
        label.textColor = .white
        label.text = helpData[indexPath.row].1
        cell.addSubview(label)
        imageView.layout([
            imageView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -20),
            imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        label.layout([
            label.leadingAnchor.constraint(equalTo: helpData[indexPath.row].0 != nil ? imageView.trailingAnchor : cell.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -20),
            label.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        return cell
    }
    
    
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 150 }
    
    
    
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
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        tableView.layout([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50, priority: .defaultHigh),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50, priority: .defaultHigh),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50, priority: .defaultHigh),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50, priority: .defaultHigh),
            tableView.widthAnchor.constraint(lessThanOrEqualToConstant: 750),
            tableView.heightAnchor.constraint(lessThanOrEqualToConstant: 750),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupView() {
        view.backgroundColor = UIColor(red: 224%, green: 203%, blue: 174%, alpha: 1)
        view.setBackgroundImage(#imageLiteral(resourceName: "Background.jpg"))
    }
    
}
