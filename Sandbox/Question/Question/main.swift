//
//  main.swift
//  Question
//
//  Created by Kang Mingu on 2020/10/10.
//

import Foundation

// MARK: - Question 1

let occupation = ["세신사", "개발자", "대장항문외과의사", "통역사", "판사", "국회의원", "문제출제자"]

var answer1 = [String]()

for i in occupation {
    if i.count == 3 {
        answer1.append(i)
    }
}
print(answer1)
    
let result1Array = occupation.filter{$0.count == 3}
print(result1Array)
// MARK: - Question 2

let numbers = [1, 3, 7, 11, 13, 17, 19, 28, 37, 51]

var answer2 = [Int]()

for i in numbers {
    answer2.append((i + 2) * 3)
}
print(answer2)

let result2Array = numbers.map{($0 + 2) * 3}
print(result2Array)
// MARK: - Question 3

let nums = [30, 1, 2]

var answer3 = 0

for i in nums {
    answer3 += i
}
print(answer3)

let result3 = nums.reduce(0){ $0 + $1 }
print(result3)
// MARK: - Question 4

let nums4 = [36, 200, 400, 17, 29, 113]

var answer4 = [Int]()

for i in nums4 {
    if i % 2 != 0 {
        answer4.append(i)
    }
}
print(answer4)

let result4Array = nums4.filter{$0 % 2 != 0}
print(result4Array)
// MARK: - Question 5

let nums5 = [32, 64, 912, 179, 361, 754]

var answer5 = [Int]()

for i in nums5 {
    if i < 100 {
        answer5.append(i)
    }
}

print(answer5)

let result5Array = nums5.filter{$0 < 100}
print(result5Array)
