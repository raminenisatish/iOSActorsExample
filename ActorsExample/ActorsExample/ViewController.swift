//
//  ViewController.swift
//  ActorsExample
//
//  Created by Satish Babu on 20/02/24.
//

import UIKit

/// Actors will solve the concurrency issues
/// When there is a race condition occures or data breach happens will use barrier flag
/// With Swift 5.5 we can achieve the concurrency using actors with asyn/await
class ActorsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let flight = Flight()
        let queue1 = DispatchQueue(label: "queue1")
        let queue2 = DispatchQueue(label: "queue2")
        /// If you want to check the traditional approach with barrier flag
        /// Uncomment the commented functions and put comments for Task block
        /// Replace actor with class and uncomment the commented lines in Flight class
        queue1.async {
            Task {
                let bookedSeat = await flight.bookSeat()
                print("Booked seat \(bookedSeat)")
            }
//            let bookedSeat = flight.bookSeat()
//            print("Booked seat \(bookedSeat)")
        }
        queue2.async {
            Task {
                let availableSeats = await flight.getAvailableSeats()
                print("Available seats \(availableSeats)")
            }
//            let availableSeats = flight.getAvailableSeats()
//            print("Available seats \(availableSeats)")
        }
    }
    
}

actor Flight {

    var availableSeats = ["1A", "2B", "3C"]
    let barrierQueue = DispatchQueue(label: "barrierQueue", attributes: .concurrent)

    func getAvailableSeats() -> [String] {
      //  barrierQueue.sync(flags: .barrier) {
            return availableSeats
      //  }
    }
    
    func bookSeat() -> String {
      //  barrierQueue.sync(flags: .barrier) {
            let bookedSeat = availableSeats.first ?? ""
            availableSeats.removeFirst()
            return bookedSeat
     //   }
    }
}
