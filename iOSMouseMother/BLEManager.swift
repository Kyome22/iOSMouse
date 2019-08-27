//
//  BLEManager.swift
//  iOSMouseMother
//
//  Created by Takuto Nakamura on 2019/08/27.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BLEManagerDelegate {
    func updateData(_ data: Data)
}

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    private var centralManager: CBCentralManager!
    private var centralFlag: Bool = false
    private var peripheral: CBPeripheral! = nil
    private var characteristic: CBCharacteristic!
    private var timer: Timer?
    public var delegate: BLEManagerDelegate?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        centralFlag = (central.state == CBManagerState.poweredOn)
        Swift.print(centralFlag)
    }
    
    func scan() {
        if centralFlag && !centralManager.isScanning {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
            Swift.print("scan start")
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                self.centralManager.stopScan()
                Swift.print("scan stop")
            }
        }
    }
    
    func stop() {
        if peripheral != nil {
            peripheral.setNotifyValue(false, for: characteristic)
            centralManager.cancelPeripheralConnection(peripheral)
        }
        if centralManager.isScanning {
            centralManager.stopScan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "iOSMouseKid" {
            self.peripheral = peripheral
            self.centralManager.stopScan()
            self.centralManager.connect(self.peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: "0011")])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Swift.print("Connect Failed")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services, !services.isEmpty {
            for service in services {
                peripheral.discoverCharacteristics([CBUUID(string: "0012")], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                Swift.print(characteristic.uuid)
                if characteristic.uuid == CBUUID(string: "0012") {
                    self.characteristic = characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            Swift.print("No Data")
            return
        }
        guard let data = characteristic.value else { return }
        delegate?.updateData(data)
    }
}


