//
//  Middle.swift
//  APPSwift
//  ReactiveSwift 用法
//  Created by 峰 on 2020/6/22.
//  Copyright © 2020 north_feng. All rights reserved.
//
import UIKit

import ReactiveSwift

/**
 RAS 官方文档 https://reactivecocoa.io/reactiveswift/docs/latest/Getting%20Started.html
 */

class MiddleVC: APPBaseController {
    
    let textField = UITextField()
    
    var signalA:Signal<String,Error>?
    
    let (signalB,observe) = Signal<String,Error>.pipe()//通常, 应该只通过Signal.pipe()函数来初始化一个热信号.
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.rac_signal()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        observe.send(value: "ffff")
        
        self.rac_signal2()
    }
    
    
    //MARK: ************************* 信号的基本使用 *************************
    ///信号基本使用， 信号传递
    func rac_signal() {
        signalA = signalB
        
        ///订阅观察者
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
    }
    
    ///信号基本使用2
    func rac_signal2() {
        
        //1.创建signal(output)和innerObserver(input)
        let (signal, innerObserver) = Signal<String,Error>.pipe()
        
        //2.创建Observer
        let outerObserver1 = Signal<String,Error>.Observer(value: { (value) in
            print("did received value: \(value)")
        })
        //2.还是创建Observer
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
