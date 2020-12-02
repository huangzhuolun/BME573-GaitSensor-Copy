//
//  BLEScannerVMcopy.swift
//  GaitSensorUpdate
//
//  Created by Thomas  Hagan on 11/3/20.
//

import SwiftUI
//import CoreBluetooth

//class BLEScannerVM: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
class BLEScannerVM: ObservableObject {
    
    @Published private var scannerdata: BLESensors = createBLESensors()
        
    //var fakedatastruck:
    //var centralManager : CBCentralManager!
    var timer: Timer!
    var fakeDataIndex = 0
    var timer1:Timer!
    var fakeDataIndex1 = 0
    
    static func createBLESensors() -> BLESensors {
        return BLESensors()
    }
    
//    override init() {
//        super.init()
//        centralManager = CBCentralManager(delegate: self, queue: nil)
//    }
    
    // MARK: - Access to data
    var blesensors: [BLESensor] {
        return scannerdata.availSensors
    }
    
//    func bledata(uuid:UUID) -> [Int] {
//        for (i,sensor) in scannerdata.availSensors.enumerated() {
//            if sensor.id == uuid {
//               return scannerdata.availSensors[i].data
//            }
//        }
//        return []
//    }
    
    func bledataFront(uuid:UUID) -> [Int] {
        for (i,sensor) in scannerdata.availSensors.enumerated() {
            if sensor.id == uuid {
               return scannerdata.availSensors[i].front_foot_data
            }
        }
        return []
    }
    
    func bledataBack(uuid:UUID) -> [Int] {
        for (i,sensor) in scannerdata.availSensors.enumerated() {
            if sensor.id == uuid {
               return scannerdata.availSensors[i].back_foot_data
            }
        }
        return []
    }
    
    
    // MARK: - Intents
    func scan() {
        print("scanning...")
        scannerdata.addscanner(scannerName: fakeSensorDictionary["Sensor1"]!.scannerName,
                               localName: fakeSensorDictionary["Sensor1"]!.localName,
                               rssi: fakeSensorDictionary["Sensor1"]!.rssi,
                               uuid: fakeSensorDictionary["Sensor1"]!.id)
        
        scannerdata.addscanner(scannerName: fakeSensorDictionary["Sensor2"]!.scannerName,
                               localName: fakeSensorDictionary["Sensor2"]!.localName,
                               rssi: fakeSensorDictionary["Sensor2"]!.rssi,
                               uuid: fakeSensorDictionary["Sensor2"]!.id)
// Cutting out the bluetooth dependence:
//        if centralManager.state == .poweredOn {
//            centralManager.scanForPeripherals(withServices: [], options: nil)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                print("stop scanning")
//                self.centralManager.stopScan()
//            }
//        }
    }
    
    // withServices: [pressure_service_uuid]
    
    
    
    func connect(peripheral: BLESensor) {

        print("called connect...")
        
        //let date = Date()
        //print(date)
        //peripheral.peripheral.delegate = self
        //centralManager.connect(peripheral.peripheral, options:nil)
        //print("The peripheral is: \(peripheral)")
//
//        var first: Bool = true
//        var sensorValue: Int = 0
        if peripheral.scannerName == "Sensor1" {
            //let characteristic1 = fakeData
            //let characteristic2 = fakeData2
            let values1 = fakeData
            let values2 = fakeData2
            
            values1.forEach { (digit) in
                scannerdata.addFrontData(id: peripheral.id, sensorData: Int(digit))
                }
            
            values2.forEach { digit in
                scannerdata.addBackData(id: peripheral.id, sensorData: Int(digit))
            }
        }
        
        if peripheral.localName == "Sensor2" {
            let characteristic2 = fakeData2
            
            let values = characteristic2
                values.forEach { digit in
                    scannerdata.addBackData(id: peripheral.id, sensorData: Int(digit))
                }
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            print("Timer fired!")
            self.scannerdata.addFrontData(id: peripheral.id, sensorData: Int(fakeData[self.fakeDataIndex]))
            self.fakeDataIndex = (self.fakeDataIndex + 1) % fakeData.count
        }
        self.timer1 = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer1 in
            print("Timer1 fired!")
            self.scannerdata.addBackData(id: peripheral.id, sensorData: Int(fakeData2[self.fakeDataIndex1]))
            self.fakeDataIndex1 = (self.fakeDataIndex1 + 1) % fakeData2.count
        
        }
        //print(characteristic[0..<9])//.hexEncodedString())
//        let values = characteristic
//            values.forEach { (digit) in
//                scannerdata.adddata(id: peripheral.id, sensorData: Int(digit))
//            }
                    
                    //if first {
//                        sensorValue = Int(digit)
//                        first = false
//                    } else {
//                        sensorValue = sensorValue + Int(digit)
//                        scannerdata.adddata(id: peripheral.id, sensorData: sensorValue)
//                        first = true
//                    }
                
            // create a timer to start when you connect
            // 
        
    }
    
    
    
    
    
    
    func disconnect(peripheral: BLESensor) {
        var dataString: String = ""
        print("disconnect...")
        self.timer.invalidate()
        self.timer1.invalidate()
        scannerdata.appendToGlobalFront(id: peripheral.id, dataArray: peripheral.front_foot_data)
        scannerdata.appendToGlobalBack(id: peripheral.id, dataArray: peripheral.back_foot_data)
        
        //centralManager.cancelPeripheralConnection(peripheral.peripheral)
        
        // Append dataset to global array
        //let dataList = peripheral.front_foot_data
        
        
        // ------------------------------------------------------
        // This is where Toe and Heel data gets saved to a string
        dataString = dataString + "All Toe Data: (\(peripheral.totalDataFront.count) points)\n\nToe Data: (\(peripheral.front_foot_data.count) points) \n"
        
        
        for dataPoint in peripheral.front_foot_data {
            if dataPoint < peripheral.front_foot_data.count-2{
                dataString = dataString + "\(dataPoint) \n"
            }
            else {
                dataString = dataString + "\(dataPoint) \n"
            }
        }
        dataString = dataString + "\n\nAll Heel Data: (\(peripheral.totalDataBack.count) points)\n\nHeel Data: (\(peripheral.back_foot_data.count) points) \n"
        for dataPoint in peripheral.back_foot_data {
            if dataPoint < peripheral.back_foot_data.count-2{
                dataString = dataString + "\(dataPoint) \n"
            }
            else {
                dataString = dataString + "\(dataPoint) \n"
            }
        }
        print("\(dataString)")
        // Acquiring the date/time info for the file header
        let date = NSDate();
        
        let formatter = DateFormatter();
        formatter.dateFormat = "MM-dd-yyyy HH:mm:ss";
        formatter.timeZone = TimeZone(abbreviation: "EST");
        let utcTimeZoneStr = formatter.string(from: date as Date);
        let fileID = String(peripheral.localName)+"  "+utcTimeZoneStr
        print("\(fileID)")
        
        let fileURL = URL(fileURLWithPath: fileID, relativeTo: getDocumentsDirectory()).appendingPathExtension("txt")
        do {
            try dataString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            print("saving data...")
        } catch {
            print("something went wrong writing the data")
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
        //scannerdata.appendToGlobalFront(id: peripheral.id, dataArray: peripheral.front_foot_data)
        //scannerdata.appendToGlobalBack(id: peripheral.id, dataArray: peripheral.back_foot_data)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // MARK: - Bluetooth
    // This checks if bluetooth is turned on.
    
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        print("DidUpdateState called")
//        if central.state == .poweredOn {
//            print("BLE working")
//        } else {
//            print("ERROR: BLE is not working")
//        }
//    }
    
    
    

//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        print("\(peripheral.name ?? "nothing") rssi:\(RSSI)")
//        print("local name: \(advertisementData["kCBAdvDataLocalName"] ?? "no local name")")
//        print("uuid: \(peripheral.identifier)")
//        scannerdata.addscanner(scannerName: peripheral.name ?? "noname",
//                                   localName: (advertisementData["kCBAdvDataLocalName"] ?? "no local name") as! String,
//                                    rssi: Int(truncating: RSSI),
//                                    peripheral:peripheral,
//                                    uuid: peripheral.identifier)
//    }
    
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        print("peripheral connected: \(peripheral)")
//        peripheral.discoverServices([pressure_service_uuid])
//    }
    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        print("service discovered:")
//        if let services = peripheral.services {
//            for service in services {
//                print("\(service)")
//                peripheral.discoverCharacteristics([pressure_char_uuid], for: service)
//            }
//        }
//    }
    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        print("characteristic discovered")
//        if let characteristics = service.characteristics {
//            for characteristic in characteristics {
//                print("characteristic: \(characteristic)")
//                peripheral.setNotifyValue(true, for: characteristic)
//            }
//        }
//    }
    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        print(characteristic.value!.hexEncodedString())
//        var first: Bool = true
//        var sensorValue: Int = 0
//        if let values = characteristic.value {
//            values.forEach { (digit) in
//                if first {
//                    sensorValue = Int(digit)
//                    first = false
//                } else {
//                    sensorValue = sensorValue + Int(digit)*256
//                    scannerdata.adddata(id: peripheral.identifier, sensorData: sensorValue)
//                    first = true
//                }
//            }              // talked about a 1 or 2 representing the datapoint associated with peripheral 1 or 2 when appending the data packets HERE
//        }
//    }
    
//    let pressure_char_uuid = CBUUID(string:"5A8AC39C-0CE1-4212-8B46-D589BA126CE2")
//    let period_char_uuid = CBUUID(string:"F8BC0798-E447-4625-959F-CE6970B70ED1")
//    let pressure_service_uuid = CBUUID(string:"573BC605-1C3C-4467-B4AA-44E0C6C6B410")

}
