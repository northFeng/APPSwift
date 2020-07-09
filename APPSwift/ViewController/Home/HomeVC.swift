//
//  HomeVC.swift
//  APPSwift
//
//  Created by 峰 on 2020/6/22.
//  Copyright © 2020 north_feng. All rights reserved.
//

import UIKit

class HomeVC: APPBaseController, UITableViewDelegate,UITableViewDataSource {
    
    var array1 = [1,2,3,4,5]
    
    var array2 = ["a","b","c","d","f"]
    
    let tableView = UITableView(frame: CG_Rect(0, 0, kAPPWidth, kAPPHeight - 100), style: .grouped)
    
    let con = UIRefreshControl(frame: CG_Rect(0, -100, kAPPWidth, 100))
    
    let button = UIButton(type: .custom)
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Print("viewDidLoad")
        
        self.createView()
        self.bindViewModel()
    }
    
    ///数据计算
    override func initData() {
        
    }
    
    //设置状态栏
    override func setNaviBarStyle() {
        
    }
    
    //MARK: ************************* viewModel绑定 *************************
    ///数据绑定
    func bindViewModel() {
        
        
        
    }
    
    //MARK: ************************* Action && Event *************************
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let homeVC = HomeVC()
        Print("touch")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            Print("pushVC")
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    

    //MARK: ************************* 逻辑处理 *************************
    
    
    //MARK: ************************* tableViewDelegate *************************
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3//返回组数
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//返回行数
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //返回 cell
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "第\(String(indexPath.section))组的\(indexPath.row)行" 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil//返回组头视图
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil//返回组尾视图
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1//返回组头高度
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20//返回组尾高度
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40//返回cell高度
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击cell
    }
    

    //MARK: ************************* 页面搭建 *************************
    func createView() {
        
        tableView.backgroundColor = UIColor.gray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.register(UINib(nibName: "", bundle: nil), forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        con.tintColor = UIColor.red
        con.attributedTitle = NSAttributedString(string: "刷新")
        tableView.addSubview(con)
    }
    
    
}


