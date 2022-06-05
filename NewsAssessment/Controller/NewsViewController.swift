//
//  NewsViewController.swift
//  NewsAssessment
//
//  Created by Mohamed Ikhram Khan on 04/06/2022.
//

import UIKit
import PullToRefreshKit
import Localize_Swift

class NewsViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    
    private var newsViewModel = NewsFeedViewModel()
    
    private var newsArray = [Article](){
        didSet
        {
            if newsArray.count > 0 {
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.newsListTableView.reloadData()
                }
            }
        }
    }
    
    private var page = 0
    @IBOutlet weak var newsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All News"
        Localize.setCurrentLanguage("en")
        addNavigationBarButtonsWith(fisrtButtonDefaultTitle: "Ar", fisrtButtonSelectedTitle: "En", target: self)
        
        setupTableView()
        getAllNews(page: page)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserverForInternetConnectivity()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverForInternetConnectivity()
    }
    
    
    fileprivate func setupTableView() {
        newsListTableView.register(UINib(nibName: NewsFeedTableViewCell.reuseIdentifier(), bundle: nil), forCellReuseIdentifier: NewsFeedTableViewCell.reuseIdentifier())
        newsListTableView.dataSource = self
        newsListTableView.delegate = self
        newsListTableView.rowHeight = 100
        newsListTableView.estimatedRowHeight = 100
        newsViewModel.news.bind { [weak self] (news) in
            DispatchQueue.main.async {
                if self?.page == 0
                {
                    self?.newsArray.removeAll()
                    self?.newsListTableView.switchRefreshHeader(to: .normal(.success, 0.5))
                }
                
                if news.count != 0
                {
                    self?.newsListTableView.hideNoDataLabel()
                    self?.newsArray.append(contentsOf: news)
                }else if self?.newsArray.count == 0 && news.count == 0 {
                    self?.newsListTableView.showNoDataLabel(withText: "No data to show")
                }
                self?.newsListTableView.switchRefreshFooter(to: .normal)
            }
        }
        
        newsListTableView?.configRefreshHeader(container: self, action: { [weak self] in
            self?.page = 0
            self?.getAllNews(page: self?.page ?? 0)
        })
        
        newsListTableView.configRefreshFooter(container: self) { [weak self] in
            self?.page += 1
            self?.getAllNews(page: self?.page ?? 0)
        }
    }
    
    // MARK: - InternetConnection_Observer
    override func gotInternetConnectivity() {
        super.gotInternetConnectivity()
        page = 0
        getAllNews(page: page)
    }
    
    private func getAllNews(page: Int)
    {
        newsViewModel.getAllArticles(noAggregationCountCallback: { [weak self] in
            DispatchQueue.main.async {
                self?.newsListTableView.switchRefreshHeader(to: .normal(.success, 0.5))
                self?.newsListTableView.showNoDataLabel(withText: "No data to show")
            }
        }, startIndex: page, currentListCount: newsArray.count) { [weak self] in
            //noMoreDataCallback
            DispatchQueue.main.async {
                self?.newsListTableView.switchRefreshFooter(to: .noMoreData)
            }
        }
    }
    
}



//MARK: UITableViewDataSource, UITableViewDelegate

extension NewsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableViewCell.reuseIdentifier(), for: indexPath) as! NewsFeedTableViewCell
        cell.setUpCell(article: newsArray[indexPath.row])
        return cell
    }
}

//MARK:Navigation Bar button Action
extension NewsViewController
{
    @objc override public func didTaplanguageButton(sender: UIButton) {
        
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            
            updateLanguage(lang: "ar")
            
        }else
        {
            updateLanguage(lang: "en")
            
        }
        addNavigationBarButtonsWith(fisrtButtonDefaultTitle: "Ar", fisrtButtonSelectedTitle: "En",fisrtButtonSelected: sender.isSelected, target: self)
        newsListTableView.reloadData()
        self.title = "All News".localized()
    }
    
    func updateLanguage(lang:String) {
        self.view.setLanguage(lang: lang)
        Localize.setCurrentLanguage(lang)
        newsArray.removeAll()
        page = 0
        getAllNews(page: page)
        
    }
    
    @objc override public func didTapFilterButton(sender: UIButton) {
        
    }
    
    @objc override public func didTapColorButton(sender: UIButton){
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "colorPickerPopover") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 446)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverVC.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
    }
    
}

//MARK: App Color Theme Settings
extension NewsViewController {
    //App interface theme setup
    @objc override public func didTapThemeButton(sender: UIButton){
        view.setInterfaceTheme()
    }
    
    //Navigation Bar Color picker Delegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func setNavigationBarColor (_ color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = color
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
}
