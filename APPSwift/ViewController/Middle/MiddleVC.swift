//
//  Middle.swift
//  APPSwift
//  ReactiveSwift 用法
//  Created by 峰 on 2020/6/22.
//  Copyright © 2020 north_feng. All rights reserved.
//
import UIKit

import ReactiveCocoa
import ReactiveSwift

/**
 RAS 官方文档 https://reactivecocoa.io/reactiveswift/docs/latest/Getting%20Started.html
 */

typealias APPSignal = Signal<Any,Error>

class MiddleVC: APPBaseController {
    
    let errorLabel = UILabel(frame: CG_Rect(50, 270, 200, 50))
    
    let button = UIButton(type: .custom)
    
    let textField = UITextField()
    
    var signalA:Signal<String,Error>?
    
    let (signalB,observe) = Signal<String,Error>.pipe()//通常, 应该只通过Signal.pipe()函数来初始化一个热信号.
    
    ///属性绑定
    let tfProperty = MutableProperty("")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.frame = CG_Rect(50, 100, 150, 50)
        textField.backgroundColor = UIColor.gray
        self.view.addSubview(textField)
        
        button.frame = CG_Rect(50, 200, 100, 50)
        button.backgroundColor = UIColor.blue
        button.setTitle("点击", for: .normal)
        self.view.addSubview(button)
        
        errorLabel.backgroundColor = UIColor.red
        self.view.addSubview(errorLabel)
        
        self.rac_signal()
        
        //信号绑定
        self.rac_UI_textField()
        self.rac_bingValue()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    //MARK: ************************* 1、热信号的基本使用 （平时用这个就可以了） *************************
    /**
     热信号是活动着的事件发生器，订阅后，只要发送信号，订阅者便可接受信号 ——> 类似 RACSubject   ——> 先订阅后发送信号！
     */

    ///信号基本使用， 信号传递 (平时基本用这个即可)
    func rac_signal() {
        signalA = signalB
        
        ///创建订阅者者  ——> 内部实现： 传进 —> 把一个Action闭包  ——> Observer(action)创建一个observer订阅者 —> core.observe(observer) 把订阅者保存到  case alive(Bag<Observer>, hasDeinitialized: Bool) 关联值数组中
        signalA?.observe{value in
            
            switch value {
            case .value(let string):
                Print("信号收到：\(string)")
            case .failed(let error):
                Print("信号失败：\(error)")
            case .completed:
                Print("信号完成")
            case .interrupted:
                Print("信号中断")
            }
        }
        
        //发送信号
        observe.send(value: "ffff")
    }
    
    ///信号基本使用2
    func rac_signal2() {
        
        //1.创建signal(output)和innerObserver(input)
        /** 内部实现：
          pipe()函数会通过一个generator: (Observer, Lifetime)闭包  ——> 去创建Core对象, 然后通过这个 Core对象  —> 去创建Signal, pipe()函数通过generator闭包捕获了Core.init()中的innerObserver对象, 而这个InnerObserver对象的_send  指向的其实是 ——>   Core.send   函数！！！！！  最后pipe()将创建完成Signal和InnerObserver打包返回.
         innerObserver ——> 调用 send(value) ——> 内部触发 Core.send 函数 ——> case alive(Bag<Observer>, hasDeinitialized: Bool) 关联值中 Bag数组 会 循环遍历 依次触发observe内部的send方法！
         */
        let (signal, innerObserver) = Signal<String,Error>.pipe() //通过pipe()创建的 innerObserver观察者 ，他里面的send函数 指向的是 Core中的send函数！！因此只有 innerObserver发送send，才会让所有的 观察者 接受到信号，Core.send(value) 里会触发 观察者数组，遍历全部接受信号
        
        //2.创建Observer 观察者1
        let outerObserver1 = Signal<String,Error>.Observer(value: { (value) in
            print("did received value: \(value)")
        })
        //2.还是创建Observer 观察者2
        let outerObserver2 = Signal<String,Error>.Observer { (event) in
            switch event {
            case let .value(value):
                print("did received value: \(value)")
            default: break
            }
        }
        
        //每订阅一次Signal实际上就是在向Signal中添加一个Observer对象.!
        signal.observe(outerObserver1)//3.向signal中添加Observer
        signal.observe(outerObserver2)//3.还是向signal中添加Observer
        
        innerObserver.send(value: "1")//4.向signal发生信息(执行signal保存的所有Observer对象的Event处理逻辑)
        innerObserver.sendCompleted()//4.还是执向signal发生信息
    }
    
    ///信号基本使用3
    func rac_signal3() {
        //1.创建signal(output)和innerObserver(input)
        let (signal, innerObserver) = Signal<Int,Error>.pipe()
        

        signal.observe{ (value) in   //2&3.创建Observer并添加到Signal中
            print("did received value: \(value)")
        }
        signal.observe{ (value) in   //2&3.还是创建Observer并添加到Signal中
            print("did received value: \(value)")
        }
        
        innerObserver.send(value: 1) //4. ...
        innerObserver.sendCompleted() //4. ...
    }
    
    ///信号宏定义用法
    func rac_signal4() {
        
        let (signal, sender) = APPSignal.pipe()
        
        signal.observe { (Value) in
            
            switch Value {
            case .value(let value):
                Print("信号收到：\(value)")
            case .failed(let error):
                Print("信号失败：\(error)")
            case .completed:
                Print("信号完成")
            case .interrupted:
                Print("信号中断")
            }
        }
        
        sender.send(value: ["a":15,"b":16])
    }
    
    //MARK: ************************* 2、冷信号基本使用 （不常用） *************************
    /**
     冷信号则是   休眠中的事件发生器.   也就是说冷信号需要一个  【唤醒操作】 , 然后才能发送事件, 而这个  【唤醒操作就是订阅它】！. 因为订阅后才发送事件, 显然,  冷信号不存在时机早晚的问题.
     */
    ///冷信号 使用1
    func rac_signalProducer() {
        //1. 通过SignalProducer.init(startHandler: (Observer, Lifetime) -> Void)创建SignalProducer
        let producer = SignalProducer<Any, Error> { (innerObserver, lifetime) in
            lifetime.observeEnded({
                print("信号无效了 你可以在这里进行一些清理工作")
            })
            
            //2. 向外界发送事件
            innerObserver.send(value: 1)
            innerObserver.send(value: 2)
            innerObserver.sendCompleted()
        }
        //3. 创建一个观察者封装事件处理逻辑
        let outerObserver = Signal<Any, Error>.Observer({ (value) in
            print("did received value: \(value)")
        })
        //4. 添加观察者到SignalProducer
        producer.start(outerObserver)//订阅一次发一次信号
        
        producer.start(outerObserver)
        
        //信号无效了 你可以在这里进行一些清理工作
    }
    
    //MARK: ************************* 3、Property/MutableProperty 信号基本使用 （简版信号使用,） *************************
    ///信号使用
    func rac_property() {
        
        /**
         Property.value不可设置, MutableProperty.value可设置.
         Property/MutableProperty内部有一个Producer一个Signal,
         设置value即是在向这两个信号发送Value事件即可.
         */
        
        //类似冷信号
        let constant = Property(value: 1)
        // constant.value = 2  //error: Property(value)创建的value不可变
        print("initial value is: \(constant.value)")
        constant.producer.startWithValues { (value) in
            print("1-----producer received: \(value)")
        }
        constant.signal.observeValues { (value) in
            print("2----signal received: \(value)")
        }
        /**
         输出: initial value is: 1
         producer received: 1
         */
        
        //类似热信号
        let mutableProperty = MutableProperty(1)
        print("initial value is: \(mutableProperty.value)")
        
        ///这是冷信号，可以监听到初始值
        mutableProperty.producer.startWithValues { /** 冷信号可以收到初始值value=1和2,3 */
            print("3------producer received \($0)")
        }
        
        ///这是热信号，只能监听到修改变化值
        mutableProperty.signal.observeValues { /** 热信号只能收到后续的变化值value=2,3 */
            print("4------signal received \($0)")
        }
        mutableProperty.value = 2 /** 设置value值就是在发送Value事件 */
        mutableProperty.value = 3 /** 设置value值就是在发送Value事件 */
        /**
         输出: initial value is: 1
         producer received: 1
         producer received: 2
         signal received: 2
         producer received: 3
         signal received: 3
         */
    }
    
    //MARK: ************************* 4、属性信号绑定 *************************
    ///信号绑定
    func rac_bindEvent() {
        /**
         需求: 1.用户输入手机号 限制手机号最多输入11个数字
         2.验证手机号是否有效 手机号无效需要展示错误信息
         */
        /*UIKit控件*/
        /**
         let errorLabel: UILabel
         let sendButton: UIButton
         let phoneNumerTextField: UITextField
         
         /*属性变量*/
         var errorText = MutableProperty("")
         var validPhoneNumer = MutableProperty("")
         */
        
        /**
         errorLabel.reactive.text <~ errorText //绑定错误信息到errorLabel
         sendButton.reactive.isEnabled <~ errorText.map{ $0.count == 0 } //只是演示一下什么都可以绑
         sendButton.reactive.backgroundColor <~ errorText.map{ $0.count == 0 ? UIColor.red : UIColor.gray } //只是演示一下什么都可以绑
         phoneNumerTextField.reactive.text <~ validPhoneNumer //绑定有效输入到输入框
         */
        
        
    }
    
    //MARK: ************************* 5、通知信号 / KVO信号  使用 *************************
    
    ///通知监听信号
    func rac_notification() {
        NotificationCenter.default.reactive.notifications(forName: Notification.Name(rawValue: "notificaiton"), object: nil).observe { (Value) in
            Print("接受的通知：\(Value)")
        }
    }
    
    //MARK: ************************* 6、UIKit信号使用 *************************
    /**  自定义操作符
     /// 定义优先级组
     precedencegroup MyPrecedence {

         // higherThan: AdditionPrecedence   // 优先级,比加法运算高
         lowerThan: AdditionPrecedence       // 优先级, 比加法运算低
         associativity: none                 // 结合方向:left, right or none
         assignment: false                   // true=赋值运算符,false=非赋值运算符
     }

     infix operator +++: MyPrecedence        // 继承 MyPrecedence 优先级组
     // infix operator +++: AdditionPrecedence // 也可以直接继承加法优先级组(AdditionPrecedence)或其他优先级组
     func +++(left: Int, right: Int) -> Int {

         return left+right*2
     }
      */
    ///各种UI空间使用
    func rac_UI_Button() {
        
        ///按钮点击
        button.reactive.controlEvents(UIControl.Event.touchUpInside).observe { (Value) in
            switch Value {
            case .value(let value):
                Print("信号收到：\(value)")
            case .failed(let error):
                Print("信号失败：\(error)")
            case .completed:
                Print("信号完成")
            case .interrupted:
                Print("信号中断")
            }
        }
    }
    
    ///输入框
    func rac_UI_textField() {
        textField.reactive.continuousTextValues.observe {
            [unowned self]
            (Value) in
            switch Value {
            case .value(let value):
                Print("信号收到：\(value)")
                self.tfProperty.value = value
            case .failed(let error):
                Print("信号失败：\(error)")
            case .completed:
                Print("信号完成")
            case .interrupted:
                Print("信号中断")
            }
        }
    }
    
    ///属性绑定
    func rac_bingValue() {
        //属性信号绑定
        errorLabel.reactive.text <~ tfProperty//textField.reactive.continuousTextValues
    }
     
     //MARK: ************************* KVO信号使用 *************************
     func rac_kvo() {
        
     }
    
    //MARK: ************************* 7、Action用法 *************************
    ///基本用法
    func rac_action() {
        /**
         typealias APIAction = ReactiveSwift.Action
         1. 创建一个Action 输入类型为[String: String]? 输出类型为Int 错误类型为APIError
         let action = APIAction { (input) -> APIProducer in
             print("input: ", input)
             return APIProducer({ (innerObserver, _) in
                 
                 //发起网络请求
                 innerObserver.send(value: 1)
                 DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                     innerObserver.send(value: 2)
                     innerObserver.sendCompleted()
                 })
             })
         }
         2. 订阅Action的执行事件
         action.events.observe { print("did received Event: ($0)") }
         3. 订阅Action的各种输出事件
         action.values.observeValues { print("did received Value: ($0)")  }
         //action.errors.observeValues { print("did received Error: ($0)")  }
         //action.completed.observeValues { print("did received completed: ($0)") }
         4. 执行Action 开始输出
         action.apply(["1": "xxx"]).start()
         5. 在返回的Producer还未结束前继续执行Action 什么也不会输出
         for i in 0...10 {
             action.apply([String(i): "xxx"]).start()
         }
         输出: input:  Optional(["0": "xxx"])
               did received Value: 1
               did received Event: VALUE VALUE 1
                    ....两秒后....
               did received Value: 2
               did received Event: VALUE VALUE 2
               did received Event: VALUE COMPLETED
               did received Event: COMPLETED
         */
        
    }
    
    //MARK: ************************* 8、Scheduler(调度器)延时加载 *************************
    ///Scheduler(调度器)延时加载
    func rac_scheduler() {
        QueueScheduler.main.schedule(after: Date.init(timeIntervalSinceNow: 0.3)) {
            Print("主线程调用延时操作")
        }
    }
    
    //MARK: ************************* 信号的过滤 && 合并信号 *************************
    ///map 用于转换事件流中的值，并用结果创建新流。
    func rac_mapping() {
        
        //通过信号发生器 创建冷信号
        let (signal, observer) = Signal<String, Error>.pipe()
        
        signal.map{string in string.uppercased()}.observe{value in Print(value)}
        
        observer.send(value: "a")
        
        observer.send(value: "b")

        observer.send(value: "c")
    }
    
    ///filter 用于过滤不满足条件的值。
    func rac_filtering() {
        
        let (signal, observer) = Signal<Int,Error>.pipe()
        
        signal.filter { (number) -> Bool in
                
                if number % 2 == 0 {
                  return true
                }else{
                    return false
                }
        }.observe{value in Print(value)}
        
        observer.send(value: 1)
        observer.send(value: 2)
        observer.send(value: 3)
        observer.send(value: 4)
        
    }
    
    ///combineLatest 用于将两个（或多个）事件流组合为最新流，所得到的流将仅在每个输入都发送至少一个值之后才发送其第一次值。之后，任何输入上的新值将导致输出上的新值。
    func rac_combineLatest() -> Void {
        let (numbersSignal, numbersObserver) = Signal<Int, Error>.pipe()
        let (lettersSignal, lettersObserver) = Signal<String, Error>.pipe()

    //        let signal = numbersSignal.combineLatest(with: lettersSignal)
        let signal = Signal.combineLatest(numbersSignal, lettersSignal)
        signal.observe{ next in print("Next: \(next)") }
        signal.observeCompleted { print("Completed") }

        numbersObserver.send(value: 0)      // nothing printed
        numbersObserver.send(value: 1)      // nothing printed
        lettersObserver.send(value: "A")    // prints (1, A)
        numbersObserver.send(value: 2)      // prints (2, A)
        numbersObserver.sendCompleted()     // nothing printed
        lettersObserver.send(value: "B")    // prints (2, B)
        lettersObserver.send(value: "C")    // prints (2, C)
        lettersObserver.sendCompleted()     // prints "Completed"
    }
    
    ///zip 成对地连接两个（或多个）事件流的值，即多个输入流第N个元组的元素对应于输入流的第N个元素，这意味着在每个输入发送至少N个值之前，不能发送输出流的第N个值。
    func rac_zipping() {
        let (numbersSignal, numbersObserver) = Signal<Int, Error>.pipe()
            let (lettersSignal, lettersObserver) = Signal<String, Error>.pipe()

        //        let signal = numbersSignal.zip(with: lettersSignal)
            let signal = Signal.zip(numbersSignal, lettersSignal)
            signal.observe{ next in print("Next: \(next)") }
            signal.observeCompleted { print("Completed") }

            numbersObserver.send(value: 0)      // nothing printed
            numbersObserver.send(value: 1)      // nothing printed
            lettersObserver.send(value: "A")    // prints (0, A)
            numbersObserver.send(value: 2)      // nothing printed
            numbersObserver.sendCompleted()  // nothing printed
            lettersObserver.send(value: "B")    // prints (1, B)
            lettersObserver.send(value: "C")    // prints (2, C) & "Completed"
    }
    
    ///.merge 策略会序列化内部事件流，按顺序执行 send 进来的事件流，后一个事件流必须等待前一个事件流的完成才开始执行。
    func rac_concat() {
        let (lettersSignal, lettersObserver) = Signal<String, Error>.pipe()
        let (numbersSignal, numbersObserver) = Signal<String, Error>.pipe()
        let (signal, observer) = Signal<Signal<String, Error>, Error>.pipe()

        signal.flatten(.concat).observe{ print($0) }

        observer.send(value: lettersSignal)
        observer.send(value: numbersSignal)
        observer.sendCompleted()

        numbersObserver.send(value: "1")    // nothing printed
        lettersObserver.send(value: "a")    // prints "a"
        lettersObserver.send(value: "b")    // prints "b"
        numbersObserver.send(value: "2")    // nothing printed
        lettersObserver.send(value: "c")    // prints "c"
        lettersObserver.sendCompleted()     // prints "1, 2"
        numbersObserver.send(value: "3")    // prints "3"
        numbersObserver.sendCompleted()
    }
    
    
    ///.latest 策略仅从最新输入事件流转发值或错误。
    func rac_latest() {
        let (lettersSignal, lettersObserver) = Signal<String, Error>.pipe()
        let (numbersSignal, numbersObserver) = Signal<String, Error>.pipe()
        let (signal, observer) = Signal<Signal<String, Error>, Error>.pipe()

        signal.flatten(.latest).observe{ print($0) }

        observer.send(value: lettersSignal) // nothing printed
        numbersObserver.send(value: "1")    // nothing printed
        lettersObserver.send(value: "a")    // prints "a"
        lettersObserver.send(value: "b")    // prints "b"
        numbersObserver.send(value: "2")    // nothing printed
        observer.send(value: numbersSignal) // nothing printed
        lettersObserver.send(value: "c")    // nothing printed
        numbersObserver.send(value: "3")    // prints "3"
    }
    
    ///flatMapError 可以捕获可能在输入事件流上发生的任何失败，然后再开启一个新的 SignalProducer.
    func rac_flatMapError() {
        let (signal, observer) = Signal<String, NSError>.pipe()
           let producer = SignalProducer(signal)

           let error = NSError(domain: "domain", code: 2, userInfo: nil)

           producer
               .flatMapError { (err) -> SignalProducer<String, Error> in
                   switch err.code {
                   case 0:
                       print("code is 0")
                       return SignalProducer<String, Error>(value:"code is 0")

                   default:
                       return SignalProducer<String, Error>(value:"code is unknow")
                   }}
               .startWithResult { (value) in
                   print(value)
           }

           observer.send(value: "First")     // prints "First"
           observer.send(value: "Second")    // prints "Second"
           observer.send(error: error)       // prints "code is unknow"
    }
    
}
