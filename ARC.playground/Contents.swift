import UIKit

// Strong Reference Cycle

class Job {
    var name: Name?

    deinit {
        print("deinit Job")
    }
}

class Name {
    var job: Job?

    deinit {
        print("deinit Name")
    }

}


var a: Job? = Job()
var b: Name? = Name()


a?.name = b
b?.job = a

a = nil
b = nil // => ... 아무것도 호출되지 않음 객체 내부에서 서로 호출해서 RC가 1이기 때문에

// Strong Reference Cycle 해결법
// Job객체와 Name객체의 서로 참조 해제
var c: Job? = Job()
var d: Name? = Name()


c?.name = d
d?.job = c

c?.name = nil
d?.job = nil
c = nil
d = nil // => RC 0!

// 두 객체간 서로 참조 구조중 하나만 해제

var e: Job? = Job()
var f: Name? = Name()


e?.name = f
f?.job = e

e?.name = nil
e = nil
f = nil // 한쪽의 참조만 끊어도 rc 0

// weak
class Jobs {
    weak var name: Names?

    deinit {
        print("deinit Job")
    }
}

class Names {
    var jobs: Jobs?

    deinit {
        print("deinit Name")
    }

}


var g: Jobs? = Jobs()
var h: Names? = Names()

g?.name = h
h?.jobs = g

g = nil
h = nil

//unowoned
class Job2 {
    unowned var name2: Name2?

    deinit {
        print("deinit Job")
    }
}

class Name2 {
    var job2: Job2?

    deinit {
        print("deinit Name")
    }

}


var i: Job2? = Job2()
var j: Name2? = Name2()

i?.name2 = j
j?.job2 = i

i = nil
j = nil

// 클로저
class Person {
    let name: String
    
    lazy var introduction: () -> String = {
        return "안녕하세요 저는 \\(self.name)입니다"
    }
    
    init(name: String) {
        self.name = name
    }
    deinit {
        print("\\(name) is being deinitialized")
    }
}

var rock: Person? = Person(name: "rock")
print(rock?.introduction())
rock = nil // Person객체를 변수 “rock”과 클로저가 참조하고 있어서 해제 안됨

// capture list
func closureCaptureTestDefault() {
    var num = 30
    let printNum = {
        print(num)
    }
    num = 40
    printNum() // 캡쳐
}
closureCaptureTestDefault()

func closureCaptureTest() {
    var num = 30
    let printNum = { [num] in
        print(num)
    }
    num = 40
    printNum() // 값을 복사
}
closureCaptureTest()

// let closure = { [weak referenceVariable1, weak referenceVariable2] in }

class Person2 {
    let name: String
    
    lazy var introduction: () -> String = { [weak self] in
        return "안녕하세요 저는 \\(self?.name)입니다"
    }
    
    init(name: String) {
        self.name = name
    }
    deinit {
        print("\\(name) is being deinitialized")
    }
}

var rock2: Person2? = Person2(name: "rock")
print(rock2?.introduction())
rock2 = nil // cycle x

/// delayed deinitialization -> weak self
//override func viewDidLoad() {
//        super.viewDidLoad()
//        exampleFunction { [weak self] str in
//            self?.vcValue = str
//            print(self?.vcValue)
//        }
//    }

