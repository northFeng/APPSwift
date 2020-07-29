//
//  MineVC.swift
//  APPSwift
//
//  Created by 峰 on 2020/6/22.
//  Copyright © 2020 north_feng. All rights reserved.
//

import UIKit

import RxSwift //它只是基于 Swift 语言的 Rx 标准实现接口库，所以 RxSwift 里不包含任何 Cocoa 或者 UI方面的类。
import RxCocoa //是基于 RxSwift针对于 iOS开发的一个库，它通过 Extension 的方法给原生的比如 UI 控件添加了 Rx 的特性，使得我们更容易订阅和响应这些控件的事件。


class MineVC: APPBaseController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    ///数据计算
    override func initData() {
        
    }
    
    //设置状态栏
    override func setNaviBarStyle() {
        
        self.naviBar.isHidden = false
        
        self.title = "RXSwift"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.rx_bind()
    }
    
    //MARK: ************************* 基础用法 *************************
    ///1、创建Observable序列化
    func rx_observable_create() {
        
        /**
         let observable = Observable<Int>.just(5)//该方法通过传入一个默认值来初始化。
         
         let observable2 = Observable.of("a","b","c")//该方法可以接受可变数量的参数（必需要是同类型的）
         
         let observable3 = Observable.from(["A", "B", "C"])//该方法需要一个数组参数。
         
         //该方法创建一个空内容的 Observable 序列。
         let observable4 = Observable<Int>.empty()
         
         //该方法创建一个永远不会发出 Event（也不会终止）的 Observable 序列。
         let observable5 = Observable<Int>.never()
         
         enum MyError: Error {
             case A
             case B
         }
         //该方法创建一个不做任何操作，而是直接发送一个错误的 Observable 序列。
         let observable6 = Observable<Int>.error(MyError.A)
         */
        
        //5秒种后发出唯一的一个元素0
        let observable7 = Observable<Int>.timer(5, scheduler: MainScheduler.instance)
        observable7.subscribe { (event) in
            
            Print("传入事件：\(event)")
        }.dispose()
    }

    ///2、订阅Observable
    let observable = Observable.of("A", "B", "C")
    
    func rx_observable_subscribe() {
        //let observable = Observable.of("A", "B", "C")
        
        /**
         //1、第一种监听
         observable.subscribe { event in
             
             switch event {
             case .next(let element):
                 Print("----->\(element)")
             case .error(let error):
                 Print("----->\(error)")
             case .completed:
                 Print("发送完成")
             }
             
             //或者
             //Print("接受数据:\(event.element)")
         }
         
         //2、第二种
         observable.subscribe(onNext: { (element) in
             Print("----->\(element)")
         }, onError: { (error) in
             Print("----->\(error)")
         }, onCompleted: {
             Print("发送完成")
         }) {
             Print("序列终止disposed")
         }
         */
        
        //3、第三种  监听回调事件的 生命周期 ——> 拦截发送数据
        observable.do(onNext: { (element) in
            Print("开始发送--->\(element)")
        }, onError: { (error) in
            Print("--->\(error)")
        }, onCompleted: {
            Print("--->发送完成")
        }, onSubscribe: {
            Print("开始发送")
        }) {
            Print("监听完成")
        }.subscribe(onNext: { (element) in
            Print("--->\(element)")
        }, onError: { (error) in
            Print("----->\(error)")
        }, onCompleted: {
             Print("发送完成")
        }) {
            
            Print("序列终止disposed")
        }.dispose()
    }
    
    ///订阅销毁
    func rx_observable_dispose() {
        /**
        Observable 的销毁（Dispose）

        1，Observable 从创建到终结流程

        （1）一个 Observable 序列被创建出来  后   它不会马上就开始被激活从而发出 Event，而是要   【等到它被某个人订阅了】  才会激活它。

        （2）而 Observable 序列激活之后要一直等到它发出了.error或者 .completed的 event 后，它才被终结。
        
        2，dispose() 方法

        （1）使用该方法我们可以手动取消一个订阅行为。

        （2）如果我们觉得这个订阅结束了不再需要了，就可以调用 dispose()方法  ——> 把这个订阅给销毁掉！！  防止内存泄漏。

        （3）当一个订阅行为被dispose 了，那么之后 observable 如果再发出 event，这个已经 dispose 的订阅就收不到消息了。
        */
        //销毁订阅 1
        let subscription = observable.subscribe { (event) in
            Print(event)
        }
        //注意！！！！
        subscription.dispose()//调用这个订阅的dispose()方法 ——> 这个调用的话，会可以 终止序列！！
        
        /**
         3，DisposeBag

         （1）除了 dispose()方法之外，我们更经常用到的是一个叫 DisposeBag 的对象来管理多个订阅行为的销毁：

         我们可以把一个 DisposeBag对象看成一个垃圾袋，把用过的订阅行为都放进去。
         而这个DisposeBag 就会在自己快要dealloc 的时候，对它里面的所有订阅行为都调用 dispose()方法。
         */
        //销毁订阅 2
        let disposeBag = DisposeBag()
        observable.subscribe { (event) in
            Print(event)
        }.disposed(by: disposeBag)
    }
    
    //MARK: ************************* RXSwift的bind事件 *************************
    let numLable = UILabel(frame: CG_Rect(50, 100, 150, 50))
    let observableTime = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    let disposeBag = DisposeBag()
    ///bind事件
    func rx_bind() {
        numLable.textColor = UIColor.blue
        numLable.backgroundColor = UIColor.gray
        self.view.addSubview(numLable)
        
        observableTime.map { (value) -> String in
            "当前索引数:\(value)"
        }.bind {[unowned self] (text) in
            self.numLable.text = text
        }.disposed(by: disposeBag)//不能调用 dispose()方法，否则立刻终止序列！
    }
    
    ///使用 AnyObserver 创建观察者
    func rx_anyObserver() {
        //观察者
        let observer: AnyObserver<String> = AnyObserver { (event) in
            switch event {
            case .next(let data):
                print(data)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
         
        let observable = Observable.of("A", "B", "C")
        observable.subscribe(observer).disposed(by: disposeBag)
    }
    
    
    
}
