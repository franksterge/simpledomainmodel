//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//  Fangwen Ge
//  Info 449
//  10/15/18

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    public func convert(_ to: String) -> Money {
        let currencies = ["USD": 4, "GBP": 2, "EUR": 6, "CAN": 5]
        if let converter = currencies[to]{
            let toGBP = amount * currencies["GBP"]! / currencies[currency]!
            return Money(amount: converter * toGBP / 2, currency: to)
        }
        return self
    }
    
    public func add(_ to: Money) -> Money {
        var ownMoney = self
        if (to.currency != self.currency) {
            ownMoney = ownMoney.convert(to.currency)
        }
        return Money(amount: (to.amount + ownMoney.amount), currency: to.currency)
    }
    
    public func subtract(_ from: Money) -> Money {
        return self.add(Money(amount: from.amount * -1, currency: from.currency))
    }
}

//////////////////////////////////
// Job

open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type  = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let hourly):
            return hours *  Int(hourly * 10) / 10
        case .Salary(let salary):
            return salary
        }
    }
    
    open func raise(_ amt : Double) {
        switch type {
        case.Hourly(let hourly):
            type = JobType.Hourly(hourly + amt)
        case .Salary(let salary):
            type = JobType.Salary(salary + Int(round(amt)))
        }
    }
}

//////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {return _job}
        set(value) {
            if age < 16 {
                _job = nil
            } else {
                _job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {return _spouse}
        set(value) {
            if age < 18 {
                _spouse = nil
            } else {
                _spouse = value
            }
        }
    }

    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(_job?.type) spouse:\(_spouse?.firstName)]"
    }
}

//////////////////////////////////
// Family

open class Family {
    fileprivate var members : [Person] = []

    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
       
    }

    open func haveChild(_ child: Person) -> Bool {
        if members[0].age > 21 || members[1].age > 21 {
            members.append(child)
            return true
        }
        return false
    }

    open func householdIncome() -> Int {
        var income = 0
        for member in members {
            if member.job != nil {
                income += member.job!.calculateIncome(2000)
            }
        }
        return income
    }
}
