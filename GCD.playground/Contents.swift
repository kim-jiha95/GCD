import UIKit
import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # 비동기(async) VS 동기(sync)


let queue = DispatchQueue.global()
//let queue = DispatchQueue(label: "com.a.b")


func task1() {
    print("Task 1 시작")
    sleep(1)
    print("Task 1 완료★")
}

func task2() {
    print("Task 2 시작")
    print("Task 2 완료★")
}

func task3() {
    print("Task 3 시작")
    sleep(4)
    print("Task 3 완료★")
}

func task4() {
    print("Task 4 시작")
    sleep(3)
    print("Task 4 완료★")
}


//: # 비동기(작업) 예시
//: ### 작업을 시작시키기만 하고, 끝나는 것은 기다리지 않고 다음 작업을 진행함
//queue.async {
//    task1()
//}
//
//queue.async {
//    task2()
//}
//
//queue.async {
//    task3()
//}

/// serial queue의 경우...?

//: # 동기(작업) 예시
//: ### 작업을 시작시키고, 끝나는 것을 기다렸다가 다음 작업을 진행함


//task1()
//task2()
//task3()
//task4()


// ★ 코드가 순서적으로 있을때, (비동기적으로 보내는 것이 아니라면) 위의 작업이
// 다 끝나야 아래작업이 시작한다는 것을 이제는 꼭 인지할 필요 ★

print("====================")


    queue.sync {
        task1()
    }
    
    queue.sync {
        task2()
    }
    
    queue.sync {
        task3()
    }
    
    queue.sync {
        task4()
    }

//: # 큐의 종류


func task11() {
    print("Task 11 시작")
    sleep(2)
    /// !?? for 문 10개..로 실행 순서 문제..
    print("Task 11 완료★")
}

func task22() {
    print("Task 22 시작")
    print("Task 22 완료★")
}

func task33() {
    print("Task 33 시작")
    sleep(1)
    print("Task 33 완료★")
}

func task44() {
    print("Task 44 시작")
    sleep(3)
    print("Task 44 완료★")
}



//: # 메인큐
//: ### 메인큐 = 메인쓰레드("쓰레드1번"을 의미), 한개뿐이고 Serial큐
// 메인큐
let mainQueue = DispatchQueue.main

    task11()


// 위와 아래의 코드는 (의미상)같다.
// (다만, 에러가 나는 것은 뒤에서 설명: sync메서드 주의사항(2) 참고)
//    mainQueue.sync {
//        task1()
//    }



//: # 글로벌큐
//: ### 6가지의 Qos를 가지고 있는 글로벌(전역) 대기열

let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)
let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
let defaultQueue = DispatchQueue.global()  // 디폴트 글로벌큐
let utilityQueue = DispatchQueue.global(qos: .utility)
let backgroundQueue = DispatchQueue.global(qos: .background)
let unspecifiedQueue = DispatchQueue.global(qos: .unspecified)


    defaultQueue.async {
        task11()
    }

    defaultQueue.async(qos: .userInitiated) {
        task22()
    }

    defaultQueue.async {
        task33()
    }




//: # 프라이빗(커스텀)큐
//: ### 기본적인 설정은 Serial, 다만 Concurrent설정도 가능


let privateQueue = DispatchQueue(label: "com.inflearn.serial")



privateQueue.async {
    task11()
}

privateQueue.async {
    task22()
}

privateQueue.async {
    task33()
}




let prinvateConcurrentQueue = DispatchQueue(label: "com.inflearn.concurrent", attributes: .concurrent)


prinvateConcurrentQueue.async {
    task11()
}

prinvateConcurrentQueue.async {
    task22()
}

prinvateConcurrentQueue.async {
    task33()
}





sleep(5)
