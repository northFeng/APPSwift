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

extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

class MineVC: APPBaseController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numLable.text = "哈哈哈哈"
        numLable.textColor = UIColor.blue
        numLable.backgroundColor = UIColor.gray
        self.view.addSubview(numLable)
    }
    
    ///数据计算
    override func initData() {
        
    }
    
    //设置状态栏
    override func setNaviBarStyle() {
        
        self.naviBar.isHidden = false
        
        self.title = "RXSwift"
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
    ///创建一个定时序列
    let observableTime = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    let disposeBag = DisposeBag()
    
    ///1、bind事件
    func rx_bind() {
        observableTime.map { (value) -> String in
            "当前索引数:\(value)"
        }.bind {[unowned self] (text) in
            self.numLable.text = text
        }.disposed(by: disposeBag)//不能调用 dispose()方法，否则立刻终止序列！
    }
    
    ///2、使用 AnyObserver观察者 进行绑定
    func rx_bind_anyObserver() {
        
        //观察者
        let observer: AnyObserver<String> = AnyObserver { (event) in
            switch event {
            case .next(let data):
                print(data)
                self.numLable.text = data
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
         
        let observable = Observable.of("A", "B", "C")
        
        //1、把观察者 订阅 到 序列中
        //observable.subscribe(observer).disposed(by: disposeBag)
        
        //2、把观察者 绑定到 序列中
        observable.map {
            "当前索引数：\($0 )"
            }.bind(to: observer).disposed(by: disposeBag)
    }
    
    ///3、使用 Binder 绑定 观察者
    func rx_bind_binder() {
        //观察者
        let observer:Binder<String> = Binder(numLable, binding: {(label, text) in label.text = text})
        
        //Observable序列（每隔1秒钟发出一个索引数）
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.map { (value) -> String in
            "当前索引数：\(value )"
            }.bind(to: observer).disposed(by: disposeBag)
        
    }
    
    ///4、绑定UI属性（不用这种麻烦）
    func rx_bind_property() {
        //Observable序列（每隔0.5秒钟发出一个索引数）
        observableTime
            .map { CGFloat($0)}
            .bind(to: numLable.fontSize)
            .disposed(by: disposeBag)
    }
    
    ///5、RX的UI扩展 bind属性
    func rx_bind_RXUI_property() {
        
        observableTime.map { (vaule) -> String in
            "当前索引数：\(vaule)"
            }.bind(to: numLable.rx.text).disposed(by: disposeBag)
    }
    
    //MARK: ******************************************** 上面的是冷信号 类似 RACSignal  ********************************************
    //MARK: ******************************************** 下面的是热信号 类似 RACSubject ——> PublishSubject ********************************************
    /**
     1，Subjects 基本介绍

     （1）Subjects 既是订阅者，也是 Observable：

     说它是订阅者，是因为它能够动态地接收新的值。
     说它又是一个 Observable，是因为当 Subjects 有了新的值之后，就会通过 Event 将新值发出给他的所有订阅者。
     
     
     （2）一共有四种 Subjects，分别为：PublishSubject、BehaviorSubject、ReplaySubject、Variable。他们之间既有各自的特点，也有
     相同之处：
     首先他们都是 Observable，他们的订阅者都能收到他们发出的新的 Event。
     直到 Subject 发出 .complete 或者 .error 的 Event 后，该 Subject 便终结了，同时它也就不会再发出.next事件。
     对于那些在 Subject 终结后再订阅他的订阅者，————>  也能收到 subject发出的一条 .complete 或 .error的 event，告诉这个新的订阅者它已经终结了。！！！！！！！
     
     注意！已经终结的信号 ！订阅的话 仍然会收到  .complete  或 .error  事件！！
     
     最大的区别 —> 只是在于：当一个新的订阅者刚订阅它的时候，能不能收到 Subject 以前发出过的  【 旧 Event 】，如果能的话又能收到多少个。
     
     （3）Subject 常用的几个方法：

     onNext(:)：是 on(.next(:)) 的简便写法。该方法相当于 subject 接收到一个.next 事件。
     onError(:)：是 on(.error(:)) 的简便写法。该方法相当于 subject 接收到一个 .error 事件。
     onCompleted()：是 on(.completed)的简便写法。该方法相当于 subject 接收到一个 .completed 事件。
     */
    
    ///1、PublishSubject使用 —> 不需要初始值就能初始化
    func rx_PublishSubject() {
        /**  不需要初始值就能初始化
         
         PublishSubject是最普通的 Subject，【它不需要初始值就能创建】。
         PublishSubject 的订阅者从他们    ——> 开始订阅的时间点起，可以  ——> 收到订阅后 Subject 发出的新 Event，而不会收到他们在订阅前已发出的 Event。
         */
        //创建PublishSubject 序列者
        let subject = PublishSubject<String>()
        
        subject.onNext("111")//相当于 RAC中的 发送信号 send(event:Any)
        
        subject.subscribe(onNext: { (value) in
            Print("第1次订阅：\(value)")
        }, onCompleted: {
            Print("第1次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        //当前有1个订阅，则该信息会输出到控制台
        subject.onNext("222")
        
        //第2次订阅subject
        subject.subscribe(onNext: { string in
            print("第2次订阅：", string)
        }, onCompleted:{
            print("第2次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        //当前有2个订阅，则该信息会输出到控制台
        subject.onNext("333")
        
        //让subject结束
        subject.onCompleted()
         
        //subject完成后会发出.next事件了。
        subject.onNext("444")
         
        //subject完成后它的所有订阅（包括结束后的订阅），都能收到subject的.completed事件，
        subject.subscribe(onNext: { string in
            print("第3次订阅：", string)
        }, onCompleted:{
            print("第3次订阅：onCompleted")
        }).disposed(by: disposeBag)
    }
    
    ///2、BehaviorSubject 需要通过一个默认初始值来创建。 ——>  【订阅时】会立刻 接受 到 【上一个 Event 】，没有Event 则发送 初始值！  后面的发送Event则正常
    func rx_BehaviorSubject() {
        /**  相当于 缓存了 一个Event！！！！
         
         BehaviorSubject 需要通过一个默认初始值来创建。
         当一个订阅者来订阅它的时候，这个订阅者会立即收到 BehaviorSubjects 上一个发出的event。之后就跟正常的情况一样，它也会接收到 BehaviorSubject 之后发出的新的 event。
         */
        //创建一个BehaviorSubject
        let subject = BehaviorSubject(value: "111")
        
        //第一次订阅subject
        subject.subscribe { (event) in
            print("第1次订阅：\(event)")
        }.disposed(by: disposeBag)
        
        subject.onNext("222")
        
        //第二次订阅subject
        subject.subscribe { (event) in
            print("第2次订阅：\(event)")
        }.disposed(by: disposeBag)
        
        subject.onNext("333")
    }
    
    /**
       3、ReplaySubject  可以缓存Event，订阅时如果有缓存Event则会依次发送缓存的Event
                  即使 终止信号，也能收到 缓存的Event && error & complete
     */
    func rx_ReplaySubject() {
        /**  可以指定 缓存 Event 的数量！！
         
         ReplaySubject 在创建时候需要设置一个 bufferSize，表示它对于它发送过的 event 的缓存个数。
         比如一个 ReplaySubject 的 bufferSize 设置为 2，它发出了 3 个 .next 的 event，那么它会将后两个（最近的两个）event 给缓存起来。此时如果有一个 subscriber 订阅了这个 ReplaySubject，那么这个 subscriber 就会立即收到前面缓存的两个.next 的 event。
         如果一个 subscriber 订阅已经结束的 ReplaySubject，除了会收到缓存的 .next 的 event外，还会收到那个终结的 .error 或者 .complete 的event。
         */
        //创建一个bufferSize为2的ReplaySubject
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        //第1次订阅subject
        subject.subscribe { event in
            print("第1次订阅：\(event)")
        }.disposed(by: disposeBag)
         
        //再发送1个next事件
        subject.onNext("444")
         
        //第2次订阅subject
        subject.subscribe { event in
            print("第2次订阅：\(event)")
        }.disposed(by: disposeBag)
         
        //让subject结束
        subject.onCompleted()
         
        //第3次订阅subject
        subject.subscribe { event in
            print("第3次订阅：\(event)")
        }.disposed(by: disposeBag)
    }
    
    ///4、Variable
    func rx_Variable() {
        /**  也可以 ——> 缓存了 最后一个 Event！！！！订阅时，会立马 发送 缓存的 Event
         
         Variable 其实就是对 BehaviorSubject 的封装，所以它也必须要通过一个默认的初始值进行创建。
         Variable 具有 BehaviorSubject 的功能，能够向它的订阅者发出上一个 event 以及之后新创建的 event。
         不同的是，Variable 还会把当前发出的值保存为自己的状态。同时它会在销毁时自动发送 .complete的 event，
         
         【不需要也不能】——> 手动给 Variables 发送 completed或者 error 事件来结束它。
         
         简单地说就是 Variable 有一个 value 属性，我们改变这个 value 属性的值就相当于调用一般 Subjects 的 onNext() 方法，而这个最新的 onNext() 的值就被保存在 value 属性里了，直到我们再次修改它。
         
         注意：Variables 本身没有 subscribe() 方法，但是所有 Subjects 都有一个 asObservable() 方法。我们可以使用这个方法返回这个 Variable 的 Observable 类型，拿到这个 Observable 类型我们就能订阅它了。
         */
        //创建一个初始值为111的Variable
       let variable = Variable("111")
        
       //修改value值
       variable.value = "222"
        
       //第1次订阅
       variable.asObservable().subscribe {
           print("第1次订阅：", $0)
       }.disposed(by: disposeBag)
        
       //修改value值
       variable.value = "333"
        
       //第2次订阅
       variable.asObservable().subscribe {
           print("第2次订阅：", $0)
       }.disposed(by: disposeBag)
        
       //修改value值
       variable.value = "444"
    }
    
    //MARK: ************************* 信号拦截 map *************************
    ///buffer  widow
    func rx_map() {
        let subject = PublishSubject<String>()
        
        //1、buffer
       //每缓存3个元素则组合起来一起发出。
       //如果1秒钟内不够3个也会发出（有几个发几个，一个都没有发空数组 []）
       subject
        .buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        //2、window
        //每3个元素作为一个子Observable发出。
        subject
            .window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self]  in
                print("subscribe: \($0)")
                $0.asObservable()
                    .subscribe(onNext: { print($0) })
                    .disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)
        
        //3、map  该操作符通过传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列。
        subject
         .map {
            $0 + "哈哈哈"}
         .subscribe { (value) in
            print(value) }
         .disposed(by: disposeBag)
        
       subject.onNext("a")
       subject.onNext("b")
       subject.onNext("c")
        
       subject.onNext("1")
       subject.onNext("2")
       subject.onNext("3")
        
        
        //4、flatMap  ——> map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列。而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
         
        let variable = Variable(subject1)
         
        variable.asObservable()
            .flatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        //5、flatMapLatest  ——> flatMapLatest与flatMap 的唯一区别是：flatMapLatest只会接收最新的value 事件。
        variable.asObservable()
        .flatMapLatest { $0 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
    ///concatMap
    func rx_concatMap() {
        /**
         concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。
         */
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
         
        let variable = Variable(subject1)
         
        variable.asObservable()
            .concatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
        subject1.onCompleted() //只有前一个序列结束后，才能接收下一个序列
        
        /**
         scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作。
         */
        Observable.of(1, 2, 3, 4, 5)
        .scan(0) { acum, elem in
            acum + elem
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    }
    
    //MARK: ************************* 操作符  过滤filter / 取前后次数take / 跳过skip *************************
    ///filter  各种过滤
    func rx_filter() {
        /**
         1、filter  ——> 该操作符就是用来过滤掉某些不符合要求的事件。
         */
        Observable.of(2, 30, 22, 5, 60, 3, 40 ,9)
        .filter {
            $0 > 10
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        //2、distinctUntilChanged ——> 过滤掉连续重复的事件。
        Observable.of(1, 2, 3, 1, 1, 4)
        .distinctUntilChanged()
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        //3、single ——> 限制 【只发送一次事件】!!!!!，【或者 满足条件的第一个事件】。  如果存在  有多个事件或者没有事件 都会发出一个 error 事件。  如果只有一个事件，则不会发出 error事件。
        Observable.of(1, 2, 3, 4)
        .single{ $0 == 2 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)  //类似  if 语句
        
        //4、elementAt ——> 只处理在 【指定位置】 的事件。
        Observable.of(1, 2, 3, 4)
        .elementAt(2) //只接受 第二个Event
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        //5、ignoreElements ——> 忽略掉所有的元素，只发出 error或completed 事件。(只接受 error 和  completed 的信号)
        Observable.of(1, 2, 3, 4)
        .ignoreElements()
        .subscribe{
            print($0)
        }.disposed(by: disposeBag)
    }
    
    ///取前后 几次 take
    func rx_take() {
        //1、take ——> 取 Observable 序列中的前 n 个事件，在满足数量之后会自动 .completed。
        Observable.of(1, 2, 3, 4)
        .take(2) //只取前两次 后面的过滤
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

        //2、takeLast ——> 仅发送 Observable序列中的后 n 个事件。
        Observable.of(1, 2, 3, 4)
        .takeLast(2) //取最好两次 信号
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)

        //takeWhile ——> 判断 Observable 序列的每一个值是否满足给定的条件。 当第一个不满足条件的值出现时，它便自动完成。
        Observable.of(2, 3, 4, 5, 6)
        .takeWhile { $0 < 4 }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
        
        //takeUntil ——> 通过 takeUntil 方法我们还可以监视另外一个 Observable， 即 notifier。  如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件。
        //notifier 发送Event，则 source 发送完成Event
        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()
         
        source
            .takeUntil(notifier)
            .subscribe(onNext: { print($0) },onCompleted: {Print("发送完成")})
            .disposed(by: disposeBag)
         
        source.onNext("a")
        source.onNext("b")
        source.onNext("c")
        source.onNext("d")
         
        //停止接收消息
        notifier.onNext("z")
         
        source.onNext("e")
        source.onNext("f")
        source.onNext("g")
        
    }
    
    ///跳过skip
    func rx_skip() {
        //1、skip ——> 跳过源 Observable 序列发出的前 n 个事件。
        Observable.of(1, 2, 3, 4)
        .skip(2) //跳过两次
        .subscribe(onNext: { print("1------\($0)") })
        .disposed(by: disposeBag)
        
        //skipWhile ——> 该方法用于跳过前面所有满足条件的事件。 一旦遇到不满足条件的事件，之后就不会再跳过了。
        //一直跳过！！ 直到 ——> 条件 为 false 假 ——>  则不再跳过！！！
        Observable.of(2, 3, 4, 5, 6)
            .skipWhile { $0 > 4 }
            .subscribe(onNext: { print("2-------\($0)") })
            .disposed(by: disposeBag)
        

        /**
         skipUntil ——> 同上面的 takeUntil 一样，skipUntil 除了订阅源 Observable 外，通过 skipUntil方法我们还可以监视另外一个 Observable， 即 notifier 。
         与 takeUntil 相反的是。【源 Observable 序列事件默认会一直跳过】！！，————> 直到 notifier 发出值或 complete 通知。则不跳过 ，开始接受信号
         */
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<Int>()
         
        source
            .skipUntil(notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
         
        source.onNext(1)
        source.onNext(2)
        source.onNext(3)
        source.onNext(4)
        source.onNext(5)
         
        //开始接收消息
        notifier.onNext(0)
         
        source.onNext(6)
        source.onNext(7)
        source.onNext(8)
         
        //仍然接收消息
        notifier.onNext(0)
         
        source.onNext(9)
    
    }
    
    ///Sample
    func rx_Sample() {
        /** 一个订阅依赖于另一个订阅者
         Sample 除了订阅源Observable 外，还可以监视另外一个 Observable， 即 notifier 。
         每当收到 notifier 事件，就会从源序列取一个最新的事件并发送。而如果两次 notifier 事件之间没有源序列的事件，则不发送值。
         */
    }
    
    ///debounce
    func rx_debounce() {
        /**
         队列中的元素如果和下一个元素的间隔小于了指定的时间间隔，那么这个元素将被过滤掉。 ——> 可以用来过滤掉高频产生的元素，它只会发出这种元素：该元素产生后，一段时间内没有新元素产生。
         debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件。
         */
        
        //定义好每个事件里的值以及发送的时间
        let times = [
            [ "value": 1, "time": 0.1 ],
            [ "value": 2, "time": 1.1 ],
            [ "value": 3, "time": 1.2 ],
            [ "value": 4, "time": 1.2 ],
            [ "value": 5, "time": 1.4 ],
            [ "value": 6, "time": 2.1 ]
        ]
         
        //生成对应的 Observable 序列并订阅
        Observable.from(times)
            .flatMap { item in
                return Observable.of(Int(item["value"]!))
                    .delaySubscription(Double(item["time"]!),
                                       scheduler: MainScheduler.instance)
            }
            .debounce(0.5, scheduler: MainScheduler.instance) //只发出与下一个间隔超过0.5秒的元素
            .subscribe(onNext: { Print($0) })
            .disposed(by: disposeBag)
    }
    
    
    
    
    //MARK: ************************* 触摸事件 *************************
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.rx_skip()
    }
    
}
