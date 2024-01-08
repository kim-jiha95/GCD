import UIKit

/// Conflicting Access to In-Out Parameters
var stepSize = 1

/// inout -> class struct 다 쓸 수 있는지
func increment(_ number: inout Int) {
    number += stepSize
}

//increment(&stepSize)
// Error: conflicting accesses to stepSize => 읽기와 쓰기 동시에 허용하지 않기 때문

// 1. Make an explicit copy.
var copyOfStepSize = stepSize //먼저 stepSize를 읽어서 값을 복사한다
increment(&copyOfStepSize)

// Update the original.
stepSize = copyOfStepSize //원본을 교체한다.
// stepSize is now 2


/// in-out
func balance(_ x: inout Int, _ y: inout Int) {
let sum = x + y
x = sum / 2
y = sum - x
}
var playerOneScore = 42
var playerTwoScore = 30
balance(&playerOneScore, &playerTwoScore)  // OK
//balance(&playerOneScore, &playerOneScore)
// Error: conflicting accesses to playerOneScore -> 단일변수 전달하여 충돌

struct Player {
    var name: String
    var health: Int
    var energy: Int

    static let maxHealth = 10
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}

extension Player {
    mutating func shareHealth(with teammate: inout Player) { // 메모리 장기적 접근
        balance(&teammate.health, &health)
    }
}

var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)
oscar.shareHealth(with: &maria)  // OK

