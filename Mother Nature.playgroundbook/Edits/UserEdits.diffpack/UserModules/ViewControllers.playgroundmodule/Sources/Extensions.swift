import UIKit

postfix operator %

extension CGFloat {
    
    static postfix func %(n: CGFloat) -> CGFloat { n / 255 }
    
}

extension NSLayoutAnchor {
    
    @objc func constraint(equalTo: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0, priority: UILayoutPriority) -> NSLayoutConstraint {
        let layoutConstraint = constraint(equalTo: equalTo, constant: constant)
        layoutConstraint.priority = priority
        return layoutConstraint
    }
    
}

extension UITableView {
    
    override func setBackgroundImage(_ image: UIImage) {
        let imageView = UIImageView(image: image)
        let view = UIView()
        imageView.alpha = 0.1
        imageView.contentMode = .scaleAspectFill
        view.backgroundColor = backgroundColor
        view.addSubview(imageView)
        backgroundView = view
    }
    
}

extension UIView {
    
    func layout(_ constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func setBackgroundImage(_ image: UIImage) {
        subviews.forEach { if ($0 as? UIImageView)?.tag == 1 { $0.removeFromSuperview() } }
        let imageView = UIImageView(image: image)
        imageView.alpha = 0.1
        imageView.contentMode = .scaleAspectFill
        imageView.tag = 1
        insertSubview(imageView, at: 0)
        imageView.layout([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
}

extension UIViewController {
    
    enum FontWeight { case bold, regular }
    
    @objc private func shadowOn(sender: UIButton) { DispatchQueue.main.async { sender.layer.shadowOpacity = 0.25 } }
    @objc private func shadowOff(sender: UIButton) { DispatchQueue.main.async { sender.layer.shadowOpacity = 0 } }
    
    func makeButton(backgroundColor: UIColor = .clear, fontWeight: FontWeight = .regular, shadowColor: UIColor? = nil, title: String, titleColor: UIColor, userInteractable: Bool = true) -> UIButton {
        let button = UIButton(type: .system)
        let fontSize = button.titleLabel?.font.pointSize ?? 12
        button.backgroundColor = backgroundColor
        button.isUserInteractionEnabled = userInteractable
        button.layer.cornerRadius = 15
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = fontWeight == .regular ? .systemFont(ofSize: fontSize): .boldSystemFont(ofSize: fontSize)
        if let shadowColor = shadowColor {
            button.addTarget(self, action: #selector(shadowOff), for: .touchDown)
            button.addTarget(self, action: #selector(shadowOn), for: .touchUpInside)
            button.addTarget(self, action: #selector(shadowOn), for: .touchUpOutside)
            button.layer.shadowColor = shadowColor.cgColor
            button.layer.shadowOffset = CGSize(width: 3, height: 3)
            button.layer.shadowOpacity = 0.25
            button.layer.shadowRadius = 10
        }
        return button
    }
    
    func presentAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
    
}
