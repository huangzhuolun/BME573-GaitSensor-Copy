//
//  ContentView.swift
//  GaitSensorUpdate
//
//  Created by Thomas  Hagan on 10/28/20.
//

import SwiftUI

struct BLEScannerView: View {
    @ObservedObject var viewmodel : BLEScannerVM
    var body: some View {
        VStack {
            sensorListView(sensorList: viewmodel.blesensors,vm:viewmodel)
            Spacer()
            Button(action: {viewmodel.scan()}, label: {Text("Scan")})
                .padding()
                .foregroundColor(Color.red)
        }
    }
    // note:    viewmodel has access to the sensors that were created
    //          actions are called to the vm here.



// Components of View:
// -------------------------------------------------------
    struct sensorListView: View {   // Second struct to contain all of the sensors
        var sensorList: [BLESensor] // var 1 for listview
        var vm:BLEScannerVM         // var 2 for listview

        var body: some View {       // body of what's in the view
            NavigationView { // This will set the sensors that "show up" as their own view destinations
                List { ForEach(sensorList) {sensor in
                    NavigationLink(destination: dataView(sensor:sensor,vm:vm)){
                        VStack(alignment:.leading){
                            Text("\(sensor.scannerName) : \(sensor.rssi)")
                            Text("UUID: \(sensor.id)").font(.caption)
                        }
                    }
                }
                }.navigationBarTitle("Sensors")
                .onDisappear() {
                    print("navigationView disappeared")
                }
            }.padding()
        }
    }

    struct dataView: View {
        var sensor:BLESensor
        var vm:BLEScannerVM
        var body: some View {
            VStack{
                Text("\(sensor.scannerName)").padding(20)
                dataDisplay(sensor:sensor, vm:vm)
            }.onAppear() {
                vm.connect(peripheral:sensor)
            }
            .onDisappear() {
                vm.disconnect(peripheral: sensor)
            }
        }
    }

    struct dataDisplay: View {
        var sensor:BLESensor
        var vm:BLEScannerVM
        var body: some View {
            VStack{
                Text("Front Foot")
                GeometryReader { geometry in
                    // sensor 1 data
                    ZStack{
                        Rectangle().fill(Color(.white)).border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).padding(0)

                        Path { path in
                            path.move(to: CGPoint(x: 0, y: geometry.size.height/2))
                            path.addLine(to: CGPoint(x: geometry.size.width,y: geometry.size.height/2))
                        }.stroke().foregroundColor(.black)

                        Path { path in
                            let FrontData = vm.bledataFront(uuid: sensor.id)
                            let width = Int(geometry.size.width)
                            let lengthData = FrontData.count
                            var start = FrontData.count - width
                            if start < 0 {
                                start = 0
                            }
                            if lengthData>start {
                                path.move(to: CGPoint(x: 0.0, y: geometry.size.height*(1.0-CGFloat(FrontData[start])/CGFloat(FrontData.max()!))))
                            for i in start..<lengthData {
                                path.addLine(to: CGPoint(x: CGFloat(i-start),
                                                         y: geometry.size.height*(1.0-CGFloat(FrontData[i])/CGFloat(FrontData.max()!))))
                            }}
                        }.stroke().foregroundColor(.red)
                    }
                }.padding()
                // ------------------------------------------------------------------------------------
                Text("Back Foot")
                GeometryReader { geometry in
                    // sensor 2 data
                    ZStack{
                        Rectangle().fill(Color(.white)).border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).padding(0)

                        Path { path in
                            path.move(to: CGPoint(x: 0, y: geometry.size.height/2))
                            path.addLine(to: CGPoint(x: geometry.size.width,y: geometry.size.height/2))
                        }.stroke().foregroundColor(.black)

                        Path { path in
                            let BackData = vm.bledataBack(uuid: sensor.id)
                            let width = Int(geometry.size.width)
                            let lengthData = BackData.count
                            var start = BackData.count - width
                            if start < 0 {
                                start = 0
                            }
                            if lengthData>start {
                                path.move(to: CGPoint(x: 0.0, y: geometry.size.height*(1.0-CGFloat(BackData[start])/CGFloat(BackData.max()!))))
                            for i in start..<lengthData {
                                path.addLine(to: CGPoint(x: CGFloat(i-start),
                                                         y: geometry.size.height*(1.0-CGFloat(BackData[i])/CGFloat(BackData.max()!))))
                            }}
                        }.stroke().foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        }
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        BLEScannerView()
//    }
//}
//

