//
//  ViewController.swift
//  Peripheral
//
//  Created by travis on 2015-07-08.
//  Copyright (c) 2015 C4. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {
    var peripheralManager : CBPeripheralManager?

    let connection_service_uuid = CBUUID(string: "39BB9101-9800-4C6D-B032-CAC5ABEA1B76")
    let transfer_service_uuid = CBUUID(string: "4268FA37-EADC-4C47-AFF8-15B4569BDE05")
    let transfer_characteristic_uuid = CBUUID(string: "F5815D05-DDDC-4922-BD79-63C6F4538D4D")
    let transfer_characteristic = CBMutableCharacteristic(type: CBUUID(string: "F5815D05-DDDC-4922-BD79-63C6F4538D4D"), properties: .Write | .Read | .Notify, value: nil, permissions: .Readable | .Writeable)
    override func viewDidLoad() {
        super.viewDidLoad()

        peripheralManager = CBPeripheralManager(delegate: self, queue: dispatch_get_main_queue())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:-
    //MARK: Peripheral Manager
    //MARK: Monitoring
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        println("peripheralManagerDidUpdateState")

        if peripheral.state != .PoweredOn {
            return
        }

        let service = CBMutableService(type: transfer_service_uuid, primary: true)
        service.characteristics = [transfer_characteristic]
        peripheralManager?.addService(service)
        peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [connection_service_uuid]])
    }

    func peripheralManager(peripheral: CBPeripheralManager!, willRestoreState dict: [NSObject : AnyObject]!) {
        println("will restore state")
    }

    func peripheralManager(peripheral: CBPeripheralManager!, didAddService service: CBService!, error: NSError!) {
        println("didAddService")
    }

    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didSubscribeToCharacteristic characteristic: CBCharacteristic!) {
        println("didSubscribeToCharacteristic")
    }

    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic!) {
        println("didUnsubscribeToCharacteristic")
    }

    func peripheralManager(peripheral: CBPeripheralManager!, didReceiveReadRequest request: CBATTRequest!) {
        println("didReceiveReadRequest")
    }

    func peripheralManager(peripheral: CBPeripheralManager!, didReceiveWriteRequests requests: [AnyObject]!) {
        println("didReceiveWriteRequests")
    }
}

