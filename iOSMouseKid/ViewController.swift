//
//  ViewController.swift
//  iOSMouseKid
//
//  Created by Takuto Nakamura on 2019/08/27.
//  Copyright © 2019 Takuto Nakamura. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BLEManagerDelegate {
    
    @IBOutlet weak var controllerView: ControllerView!
    @IBOutlet var buttons: [MouseButton]!
    @IBOutlet weak var syncBtn: UIButton!
    
    private let ble = BLEManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ble.delegate = self
        buttons.sort { (a, b) -> Bool in
            a.tag < b.tag
        }
        buttons[0].setSide(side: false)
        buttons[1].setSide(side: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controllerView.fingerUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    func updateConnectState(_ state: Bool) {
        syncBtn.isEnabled = !state
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: controllerView)
        if let phi = controllerView.updatePoint(point: location) {
            ble.update(data: String(format: "%+d", phi).data(using: .utf8)!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: controllerView)
        if let phi = controllerView.updatePoint(point: location) {
            ble.update(data: String(format: "%+d", phi).data(using: .utf8)!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        controllerView.fingerUp()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        controllerView.fingerUp()
    }

    @IBAction func btnTouchDown(_ sender: MouseButton) {
        buttons[sender.tag].changeState(true)
        let str: String = sender.tag == 0 ? "leftDown" : "rightDown"
        ble.update(data: str.data(using: .utf8)!)
    }
    
    @IBAction func btnTouchUp(_ sender: MouseButton) {
        buttons[sender.tag].changeState(false)
        let str: String = sender.tag == 0 ? "leftUp" : "rightUp"
        ble.update(data: str.data(using: .utf8)!)
    }
    
    @IBAction func sync(_ sender: Any) {
        ble.startAdvertise()
    }
}

