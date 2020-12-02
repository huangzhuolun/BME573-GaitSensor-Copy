//
//  BLEScanners.swift
//  GaitSensorUpdate
//
//  Created by Thomas  Hagan on 10/29/20.
//

import Foundation
//import CoreBluetooth

struct BLESensors {
    var availSensors: [BLESensor] = []
    
    mutating func addscanner(scannerName:String,localName:String,rssi:Int,uuid:UUID){
        var matched : Bool = false
        for sensor in availSensors {
            if (sensor.scannerName == scannerName) &&
                (sensor.localName == localName) {
                matched = true
                break
            }
        }
        if !matched {
            availSensors.append(BLESensor(scannerName:scannerName,
                                            localName:localName,
                                            rssi:rssi,
                                            id:uuid))

        }
    }
    
    mutating func addFrontData(id: UUID, sensorData:Int) {
        for (i,sensor) in availSensors.enumerated() {
            if sensor.id == id {
                availSensors[i].front_foot_data.append(sensorData)
                break
            }
        }
    }
    
    mutating func addBackData(id: UUID, sensorData:Int) {
        for (i,sensor) in availSensors.enumerated() {
            if sensor.id == id {
                availSensors[i].back_foot_data.append(sensorData)
                break
            }
        }
    }
    
    mutating func appendToGlobalFront(id: UUID, dataArray: [Int]){
        for (i,sensor) in availSensors.enumerated() {
            if sensor.id == id {
                availSensors[i].totalDataFront.append(contentsOf: dataArray)

            }
        }
    }
    mutating func appendToGlobalBack(id: UUID, dataArray: [Int]){
        for (i,sensor) in availSensors.enumerated() {
            if sensor.id == id {
                availSensors[i].totalDataBack.append(contentsOf: dataArray)

            }
        }
    }
    
    
}







//-----------------------------------------------------------------
//// change to 16 bit uuid   6ce2



// 2 functions add front and add back (x)


// sensor, starting date, data, frequency when data was taken (x)

// make global data array in declaration struct. append to it with mutating function


// save the date and time of a total global array (x)



struct BLESensor: Identifiable {
    var scannerName: String
    var localName: String
    var rssi: Int
    //var peripheral: CBPeripheral
    var id : UUID
    //var data: [Int] = []
    var front_foot_data: [Int] = []
    var back_foot_data:[Int] = []
    var totalDataFront: [Int] = []
    var totalDataBack: [Int] = []
}
