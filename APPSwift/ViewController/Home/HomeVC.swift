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
    
    let tableView = UITableView(frame: CG_Rect(0, 100, kAPPWidth, kAPPHeight - 100), style: .grouped)
        
    let button = UIButton(type: .custom)
    
    var dataArray:[WordModel]? = []
    
    var param = 0
    
    var imgView:UIImageView = UIImageView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createView()
        self.bindViewModel()
        
        tableView.mj_header?.beginRefreshing()
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
        
        tableView.mj_header = MJRefreshStateHeader(refreshingBlock: {
            [unowned self] in
            self.netData()
        })
//        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
//            [unowned self] in
//            sleep(2)
//            self.array1 = []
//            self.stopRefresh()
//        })
    }
    
    func stopRefresh() {
        tableView.mj_header?.endRefreshing()
        tableView.mj_footer?.endRefreshing()
    }
    
    
    func netData() {
        AlertLoading()
//        APPNetTool.getNetDataCache(method: .get, url: "v2/front/tag/getTagList", params: ["tagType":"1","param":param]) { (result, data, status) in
//            AlertHideLoading()
//            self.tableView.mj_header?.endRefreshing()
//            if result {
//                let jsonArray = data as! [[String:Any]]
//                let data = JsonToModel(json: jsonArray, Model: WordModel.self)
//                if let dataArray = data as? [WordModel] {
//                    self.dataArray = dataArray
//                }
//                self.tableView.reloadData()
//                
//                if case APPNetStatus.sucess(let code) = status {
//                    Print("结果code：\(code)")
//                }
//                
//            } else {
//                AlertMessage(data as! String)
//                if case let APPNetStatus.failHttp(code) = status {
//                    Print("结果code：\(code)")
//                }
//            }
//        }
        
        APPNetTool.getNetData(method: .get, url: "v2/front/tag/getTagList", params: ["tagType":"1","param":param]) { (result, data, status) in
            AlertHideLoading()
            self.tableView.mj_header?.endRefreshing()
            if result {
                let jsonArray = data as! [[String:Any]]
                let data = JsonToModel(json: jsonArray, Model: WordModel.self)
                if let dataArray = data as? [WordModel] {
                    self.dataArray = dataArray
                }
                self.tableView.reloadData()

                if case APPNetStatus.sucess(let code) = status {
                    Print("结果code：\(code)")
                }

            } else {
                AlertMessage(data as! String)
                if case let APPNetStatus.failHttp(code) = status {
                    Print("结果code：\(code)")
                }
            }
        }
        
        param += 1
    }
    
    //MARK: ************************* Action && Event *************************
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    

    //MARK: ************************* 逻辑处理 *************************
    
    
    //MARK: ************************* tableViewDelegate *************************
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1//返回组数
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0//返回行数
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //返回 cell
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let wordModel = dataArray![indexPath.row]
        
        let chName:String = wordModel.chName
        let enName:String = wordModel.enName
        
        cell.textLabel?.text = chName + enName
        
        ImageLoadImage(imgView: cell.imageView!, url: wordModel.picUrl)
        
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
        return 100//返回cell高度
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //点击cell
        let cell = tableView.cellForRow(at: indexPath)
        
        imgView.image = cell?.imageView?.image
        
        let cellFrame = cell!.frame
        let cellImageFrame = cell!.imageView!.frame
        
        imgView.frame = CGRect(x: 20, y: cellFrame.origin.y - tableView.contentOffset.y + 100, width: cellImageFrame.size.width, height: cellImageFrame.size.height)
        imgView.isHidden = false
        
        
        let homeDetailVC = HomeDetailVC()
        homeDetailVC.image = self.imgView.image
    
        UIView.animate(withDuration: 0.4, animations: {
            self.imgView.frame = CGRect(x: (kAPPWidth - 120.0)/2.0, y: (kAPPHeight - 160.0)/2.0, width: 120, height: 160)
        }) { (complete) in
            self.imgView.isHidden = true
            self.navigationController?.pushViewController(homeDetailVC, animated: false)
        }
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
        
        imgView.isHidden = true
        self.view.addSubview(imgView)
    }
    
}


class WordModel: BaseModel {
    var tagId = ""
    var updateTime = ""
    var chName = ""
    var enName = ""
    var picUrl = ""
    var tagType:Int = 0
}
