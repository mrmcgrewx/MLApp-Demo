//
//  ReviewTableController.swift
//  MLApp
//
//  Created by Kyle McGrew on 2/17/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import UIKit

struct History {
    var file: UIImage
    var creationDate: String
}

class ReviewTableController: UIViewController, ReviewTableView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var onReviewComplete: (() -> Void)?
    
    private let photoDir = "photos"
    private let dateFormatter = DateFormatter()
    private var files = [History]()
    
    //MARK: - Setup Functions
    func loadHistoryData(_ dire:String) {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(dire)
        guard let content = try? FileManager.default.contentsOfDirectory(atPath: directory.path) else { return }
        for file in content {
            let path = directory.appendingPathComponent(file).path
            let image = UIImage(contentsOfFile: path)
            let processedImage = UIImage(cgImage: (image?.cgImage)!, scale: (image?.scale)!, orientation: .right)
            guard let attr = try? FileManager.default.attributesOfItem(atPath: path) else { continue }
            guard let creationDate = attr[.creationDate] as? Date else { continue }
            
            let hist = History(file: processedImage, creationDate: dateFormatter.string(from: creationDate))
            files.append(hist)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        loadHistoryData(photoDir)
        files = files.sorted { $0.creationDate > $1.creationDate }
        tableView.animateTable()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            onReviewComplete?()
        }
    }
    
    //MARK: - TableView Delegate Functions
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    public  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let file = files[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableCell", for: indexPath) as! ReviewTableCell
        cell.historyImage.contentMode = .scaleAspectFit
        cell.historyImage.image = file.file
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.bounds.height - 100)
    }
    
}
