//
//  BLEManager.swift
//  iOSMouseKid
//
//  Created by Takuto Nakamura on 2019/08/27.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BLEManagerDelegate {
    func updateConnectState(_ state: Bool)
}

class BLEManager: NSObject, CBPeripheralManagerDelegate {
    
    private var peripheralManager: CBPeripheralManager!
    private var service: CBMutableService!
    private var characteristic: CBMutableCharacteristic?
    private var peripheralFlag: Bool = false
    private var connectFlag: Bool = false
    public var delegate: BLEManagerDelegate?
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        Swift.print("state: \(peripheral.state.rawValue)")
        if peripheral.state == .poweredOn {
            peripheralFlag = true
            let serviceUUID = CBUUID(string: "0011")
            service = CBMutableService(type: serviceUUID, primary: true)
            
            let characteristicUUID = CBUUID(string: "0012")
            let properties: CBCharacteristicProperties = [.notify, .read, .write]
            let permissions: CBAttributePermissions = [.readable, .writeable]
            characteristic = CBMutableCharacteristic(type: characteristicUUID,
                                                     properties: properties,
                                                     value: nil,
                                                     permissions: permissions)
            service.characteristics = [characteristic!]
            peripheralManager.add(service)
        } else {
            peripheralFlag = false
        }
        Swift.print(peripheralFlag)
    }
    
    func startAdvertise() {
        if peripheralFlag {
            let data = [CBAdvertisementDataLocalNameKey: "iOSMouseKid"]
            peripheralManager.startAdvertising(data)
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                self.peripheralManager.stopAdvertising()
                Swift.print("stop")
            }
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if error != nil {
            Swift.print("Failed: \(error.debugDescription)")
            return
        }
    }
    
    func update(data: Data) {
        if connectFlag {
            guard let characteristic = characteristic, let centrals = characteristic.subscribedCentrals, !centrals.isEmpty else {
                return
            }
            peripheralManager?.updateValue(data, for: characteristic, onSubscribedCentrals: nil)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        connectFlag = true
        delegate?.updateConnectState(connectFlag)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        connectFlag = false
        delegate?.updateConnectState(connectFlag)
    }
}

