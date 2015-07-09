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
    var currentCentral : CBCentral?

    var peripheralManager : CBPeripheralManager?

    let connection_service_uuid = CBUUID(string: "39BB9101-9800-4C6D-B032-CAC5ABEA1B76")
    let transfer_service_uuid = CBUUID(string: "4268FA37-EADC-4C47-AFF8-15B4569BDE05")
    let transfer_characteristic_uuid = CBUUID(string: "F5815D05-DDDC-4922-BD79-63C6F4538D4D")
    let transfer_characteristic = CBMutableCharacteristic(type: CBUUID(string: "F5815D05-DDDC-4922-BD79-63C6F4538D4D"), properties: .Write | .Read | .Notify, value: nil, permissions: .Readable | .Writeable)

    let interaction_service_uuid = CBUUID(string: "E8AA69DA-3D6F-4747-AC46-7CC750D26DFA")
    let notify_tap_uuid = CBUUID(string: "40A9CA6F-3862-4169-A715-FB3737D27134")
    let notify_tap_characteristic = CBMutableCharacteristic(type: CBUUID(string: "40A9CA6F-3862-4169-A715-FB3737D27134"), properties: .Read | .Notify, value: nil, permissions: .Readable)
    let receive_tap_uuid = CBUUID(string: "D06202A0-A67B-49DF-AA13-DCC7240B10D2")
    let receive_tap_characteristic = CBMutableCharacteristic(type: CBUUID(string: "D06202A0-A67B-49DF-AA13-DCC7240B10D2"), properties: .Write , value: nil, permissions: .Writeable)

    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralManager = CBPeripheralManager(delegate: self, queue: dispatch_get_main_queue())

        let t = UITapGestureRecognizer(target: self, action: Selector("sendTap"))
        view.addGestureRecognizer(t)
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

        let interaction_service = CBMutableService(type: interaction_service_uuid, primary: true)
        interaction_service.characteristics = [notify_tap_characteristic, receive_tap_characteristic]

        peripheralManager?.addService(interaction_service)
        peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [interaction_service_uuid]])
    }

    func peripheralManager(peripheral: CBPeripheralManager!, willRestoreState dict: [NSObject : AnyObject]!) {
        println("will restore state")
    }

    func peripheralManager(peripheral: CBPeripheralManager!, didAddService service: CBService!, error: NSError!) {
        println("didAddService w/ \(service.characteristics.count) characteristics")
    }

    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didSubscribeToCharacteristic characteristic: CBCharacteristic!) {

        if let c = currentCentral { }
        else { currentCentral = central }
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

    //MARK: Gesture
    func sendTap() {
        let s = "{\(rand()),\(rand())}" as NSString
        let d = s.dataUsingEncoding(NSUTF8StringEncoding)

        self.peripheralManager?.updateValue(d, forCharacteristic: notify_tap_characteristic, onSubscribedCentrals: nil)

        println(s)
    }
}

