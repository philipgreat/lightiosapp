//
//  ViewController.swift
//  LightControl
//
//  Created by 张喜来 on 12/8/15.
//  Copyright © 2015 张喜来. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("control when view did load")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("did receive memory warning")
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func valueChanged(sender: UISwitch) {
        
        if sender.on {
            NSLog("find value changed to on")
            sendCommand("switchOnAllLights")
            return
        }
        sendCommand("switchOffAllLights")
        NSLog("find value changed to off")
        
        
    }
    func htons(value: CUnsignedShort) -> CUnsignedShort {
        return (value << 8) + (value >> 8);
    }
    func sendCommand(command:String){
    
    
        //            ai_next: nil)
    
        let destIP = in_addr(s_addr: 0x0101a8c0)
        //this is 192.168.1.1
        let sock = socket(AF_INET, SOCK_DGRAM, 0) // DGRAM makes it UDP
        NSLog("sock value %d",sock);
        var destAddress = sockaddr_in(
            sin_len:    __uint8_t(sizeof(sockaddr_in)),
            sin_family: sa_family_t(AF_INET),
            sin_port:   htons(8899),
            sin_addr:   destIP,
            sin_zero:   ( 0, 0, 0, 0, 0, 0, 0, 0 )
        )
        command.withCString { cstr -> Void in
            withUnsafePointer(&destAddress) { ptr -> Void in
                let addrptr = UnsafePointer<sockaddr>(ptr)
                sendto(sock, cstr, Int(strlen(cstr)), 0,
                    addrptr, socklen_t(destAddress.sin_len))
            }
        }
        close(sock)
    }
    
    
    
}

