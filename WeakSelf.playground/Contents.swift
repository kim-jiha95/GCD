import UIKit

/*:
 ---
 * weak self와 관련
 ---
 */
//DispatchQueue.global().async { [weak self] in
//
//
//    DispatchQueue.main.async {
//
//
//
//    }
//}


/*:
 ---
 * ARC / 클로저의 캡처 리스트
 ---
 */
// ARC(Automatic Reference Counting)
// 자동 참조 카운팅

// Heap(힙)메모리에 할당되는 메모리 관리를 위해
// ARC 방법으로 메모리 관리
// ====> 강한 참조 사이클이 일어날 가능성(Memory Leak)

// weak / unowned 사용해서 해결



// 클래스의 인스턴스(객체), 클로저 ===> 힙 메모리에 할당

// 1) 클래스 인스턴스
// 변수를 weak, unowned로 선언
// ===> 인스턴스를 참조하되, RC가 올라가지 않게 하므로 강한 참조 사이클 일어나지 않음


// 2) 클로저
// 클로저의 캡처리스트내에서 + weak, unowned로 선언
// ===> 인스턴스를 참조하되, RC가 올라가지 않게 하므로 강한 참조 사이클 일어나지 않음


/*:
 ---
 * Strong Reference(강한 참조)
 ---
 */

class ViewController: UIViewController {
    
    var name: String = "뷰컨"
    
    func doSomething() {
        DispatchQueue.global().async {
            sleep(3)
            print("글로벌큐에서 출력하기: \(self.name)")
            DispatchQueue.main.async {
                print("메인큐에서 출력하기: \(self.name)")
            }
        }
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}


func localScopeFunction() {
    let vc = ViewController()
    vc.doSomething()
}


localScopeFunction()

//글로벌큐에서 출력하기: 뷰컨
//메인큐에서 출력하기: 뷰컨
//뷰컨 메모리 해제



// (글로벌큐)클로저가 강하게 캡처하기 때문에, 뷰컨트롤러의 RC가 유지되어
// 뷰컨트롤러가 해제되었음에도, 3초뒤에 출력하고 난 후 해제됨
// (강한 순환 참조가 일어나진 않지만, 뷰컨트롤러가 필요없음에도 오래 머무름)


/*:
 ---
 * Weak Reference(약한 참조)
 ---
 */

class ViewController1: UIViewController {
    
    var name: String = "뷰컨"
    
    func doSomething() {
        // 강한 참조 사이클이 일어나지 않지만, 굳이 뷰컨트롤러를 길게 잡아둘 필요가 없다면
        // weak self로 선언
        DispatchQueue.global().async { [weak self] in
            sleep(3)
            print("글로벌큐에서 출력하기: \(self?.name)")
            DispatchQueue.main.async {
                print("메인큐에서 출력하기: \(self?.name)")
            }
        }
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}


func localScopeFunction1() {
    let vc = ViewController1()
    vc.doSomething()
}


//localScopeFunction1()

//뷰컨 메모리 해제
//글로벌큐에서 출력하기: nil
//메인큐에서 출력하기: nil



/*:
 ---
 * Weak Reference(약한 참조) - 더 나아가
 ---
 */

class ViewController2: UIViewController {
    
    var name: String = "뷰컨"
    
    func doSomething() {
        // 강한 참조 사이클이 일어나지 않지만, 굳이 뷰컨트롤러를 길게 잡아둘 필요가 없다면
        // weak self로 선언
        DispatchQueue.global().async { [weak self] in
            sleep(3)
            guard let weakSelf = self else { return }
            print("글로벌큐에서 출력하기: \(weakSelf.name)")
            DispatchQueue.main.async {
                print("메인큐에서 출력하기: \(weakSelf.name)")
            }
        }
    }
    
    deinit {
        print("\(name) 메모리 해제")
    }
}


func localScopeFunction2() {
    let vc = ViewController2()
    vc.doSomething()
}


//localScopeFunction2()


//뷰컨 메모리 해제
//클로저에서 일어나는 일도 하지 않음 ===> return





