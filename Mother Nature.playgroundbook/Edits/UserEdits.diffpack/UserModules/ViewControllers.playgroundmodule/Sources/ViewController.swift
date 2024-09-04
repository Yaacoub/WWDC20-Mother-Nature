import AVFoundation
import MobileCoreServices
import UIKit

public class ViewController: UIViewController, UIDragInteractionDelegate, UIDropInteractionDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDelegate {
    
    
    
    //MARK:- Variables
    
    let tableViewSide = UITableView()
    let viewWorkspace = UIView()
    
    var audioPlayerFX: AVAudioPlayer?
    var audioPlayerMusic: AVAudioPlayer?
    var buttonClear = UIButton()
    var buttonEmojiCount = UIButton()
    var buttonHelp = UIButton()
    var elements: [Element] { Element.userElements }
    
    
    
    //MARK:- Override
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupButtonClear()
        setupButtonEmojiCount()
        setupButtonHelp()
        setupTableViewSide()
        setupViewWorkspace()
        setupView()
        playAudioPlayerMusic()
        present(HelpViewController())
    }
    
    
    
    //MARK:- UIDragInteractionDelegate
    
    public func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let label = viewWorkspace.hitTest(session.location(in: viewWorkspace), with: nil) as? UILabel {
            guard let data = label.text?.data(using: .utf8) else { return [] }
            let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = label
            return [dragItem]
        }
        return []
    }
    
    public func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        guard let view = item.localObject as? UIView else { return nil }
        view.backgroundColor = UIColor(red: 224%, green: 203%, blue: 174%, alpha: 1)
        return UITargetedDragPreview(view: view)
    }
    
    public func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        guard let view = session.items.first?.localObject as? UIView else { return }
        animator.addCompletion { [weak self] in
            if $0 == .start {
                view.backgroundColor = .clear
                self?.viewWorkspace.addSubview(view)
            } else {
                view.removeFromSuperview()
            }
        }
    }
    
    
    
    //MARK:- UIDropInteractionDelegate
    
    public func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) && session.items.count == 1
    }
    
    public func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        _ = session.loadObjects(ofClass: String.self) { [weak self] in
            guard let self = self else { return }
            let label = UILabel()
            label.frame.size = CGSize(width: 75, height: 75)
            label.center = session.location(in: self.viewWorkspace)
            label.font = .systemFont(ofSize: 50)
            label.text = $0.first
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            self.viewWorkspace.addSubview(label)
            DispatchQueue.main.async {
                self.viewWorkspace.subviews.compactMap({ $0 as? UILabel }).forEach {
                    if label.frame.intersects($0.frame) { self.combineLabels($0, with: label) }
                }
            }
        }
    }
    
    public func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        UIDropProposal(operation: .copy)
    }
    
    
    
    //MARK:- UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.prepareForReuse()
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = tableView.backgroundColor
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = selectedBackground
        cell.textLabel?.alpha = elements[indexPath.row].isFinal ? 0.5 : 1
        cell.textLabel?.font = .systemFont(ofSize: 50)
        cell.textLabel?.frame = cell.frame
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = elements[indexPath.row].symbol
        return cell
    }
    
    
    
    //MARK:- UITableViewDragDelegate
    
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let data = tableView.cellForRow(at: indexPath)?.textLabel?.text?.data(using: .utf8) else { return [] }
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    public func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameter = UIDragPreviewParameters()
        parameter.backgroundColor = tableView.backgroundColor
        return parameter
    }
    
    
    
    //MARK:- UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
    
    //MARK:- Functions
    
    @objc func clearWorkspace(sender: UIButton) { viewWorkspace.subviews.forEach { ($0 as? UILabel)?.removeFromSuperview() } }
    
    @objc func presentHelpAction(sender: UIButton) { present(HelpViewController()) }
    
    func combineLabels(_ label1: UILabel, with label2: UILabel) {
        guard label1 != label2 else { return }
        guard let element1 = Element(forSymbol: (label1.text ?? "")), let element2 = Element(forSymbol: (label2.text ?? "")) else { return }
        guard let newElement = element1 + element2 else { return }
        let label = UILabel()
        buttonEmojiCount.setTitle("\(elements.count)/\(Element.elementsCount)", for: .normal)
        label.frame = CGRect(x: label1.frame.origin.x + 25, y: label1.frame.origin.y + 25, width: label1.frame.width, height: label1.frame.height)
        label.font = .systemFont(ofSize: 50)
        label.text = newElement.symbol
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        viewWorkspace.addSubview(label)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: .curveEaseOut, animations: { label.transform = .identity }) }
        [label1, label2].forEach { $0.removeFromSuperview() }
        tableViewSide.reloadData()
        playAudioPlayerFX()
        if elements.count == Element.elementsCount { present(SuccessViewController()) }
    }
    
    func playAudioPlayerFX() {
        guard let audioPath = elements.count == Element.elementsCount ? Bundle.main.path(forResource: "FX-Success", ofType: "mp3") : Bundle.main.path(forResource: "FX-New", ofType: "mp3") else { return }
        audioPlayerFX = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
        audioPlayerFX?.volume = 0.5
        audioPlayerMusic?.setVolume(0, fadeDuration: 3)
        audioPlayerFX?.play()
        audioPlayerMusic?.setVolume(1, fadeDuration: 6)
    }
    
    func playAudioPlayerMusic() {
        guard let audioPath = Bundle.main.path(forResource: "Music", ofType: "mp3") else { return }
        audioPlayerMusic = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
        audioPlayerMusic?.numberOfLoops = -1
        audioPlayerMusic?.volume = 0
        audioPlayerMusic?.play()
        audioPlayerMusic?.setVolume(1, fadeDuration: 6)
    }
    
    func present(_ viewController: UIViewController) {
        let viewController = viewController
        viewController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async { [weak self] in self?.present(viewController, animated: true) }
    }
    
    func setupButtonClear() {
        buttonClear = makeButton(backgroundColor: UIColor(red: 224%, green: 203%, blue: 174%, alpha: 0.9), fontWeight: .bold, shadowColor: .black, title: "Clear", titleColor: UIColor(red: 214%, green: 0%, blue: 0%, alpha: 1))
        buttonClear.addTarget(self, action: #selector(clearWorkspace), for: .touchUpInside)
        viewWorkspace.addSubview(buttonClear)
        buttonClear.layout([
            buttonClear.bottomAnchor.constraint(equalTo: viewWorkspace.bottomAnchor, constant: -10),
            buttonClear.trailingAnchor.constraint(equalTo: viewWorkspace.trailingAnchor, constant: -10),
            buttonClear.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setupButtonEmojiCount() {
        buttonEmojiCount = makeButton(title: "\(elements.count)/\(Element.elementsCount)", titleColor: UIColor(red: 150%, green: 125%, blue: 93%, alpha: 1), userInteractable: false)
        buttonEmojiCount.titleLabel?.frame = buttonEmojiCount.frame
        viewWorkspace.addSubview(buttonEmojiCount)
        buttonEmojiCount.layout([
            buttonEmojiCount.bottomAnchor.constraint(equalTo: buttonClear.topAnchor, constant: -10),
            buttonEmojiCount.trailingAnchor.constraint(equalTo: viewWorkspace.trailingAnchor, constant: -10),
            buttonEmojiCount.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setupButtonHelp() {
        buttonHelp = makeButton(backgroundColor: UIColor(red: 224%, green: 203%, blue: 174%, alpha: 0.9), fontWeight: .bold, shadowColor: .black, title: "?", titleColor: UIColor(red: 0%, green: 107%, blue: 214%, alpha: 1))
        buttonHelp.addTarget(self, action: #selector(presentHelpAction), for: .touchUpInside)
        viewWorkspace.addSubview(buttonHelp)
        buttonHelp.layout([
            buttonHelp.topAnchor.constraint(equalTo: viewWorkspace.topAnchor, constant: 10),
            buttonHelp.trailingAnchor.constraint(equalTo: viewWorkspace.trailingAnchor, constant: -10),
            buttonHelp.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupTableViewSide() {
        tableViewSide.backgroundColor = UIColor(red: 224%, green: 203%, blue: 174%, alpha: 1)
        tableViewSide.dataSource = self
        tableViewSide.delegate = self
        tableViewSide.dragDelegate = self
        tableViewSide.dragInteractionEnabled = true
        tableViewSide.separatorStyle = .none
        tableViewSide.setBackgroundImage(#imageLiteral(resourceName: "Background.jpg"))
        view.addSubview(tableViewSide)
        tableViewSide.layout([
            tableViewSide.topAnchor.constraint(equalTo: view.topAnchor),
            tableViewSide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableViewSide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewSide.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupViewWorkspace() {
        viewWorkspace.addInteraction(UIDragInteraction(delegate: self))
        viewWorkspace.addInteraction(UIDropInteraction(delegate: self))
        viewWorkspace.backgroundColor = .clear
        viewWorkspace.clipsToBounds = true
        view.insertSubview(viewWorkspace, at: 1)
        viewWorkspace.layout([
            viewWorkspace.topAnchor.constraint(equalTo: view.topAnchor),
            viewWorkspace.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewWorkspace.leadingAnchor.constraint(equalTo: tableViewSide.trailingAnchor),
            viewWorkspace.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupView() {
        view.backgroundColor = UIColor(red: 250%, green: 225%, blue: 193%, alpha: 1)
        view.setBackgroundImage(#imageLiteral(resourceName: "Background.jpg"))
    }
    
}
