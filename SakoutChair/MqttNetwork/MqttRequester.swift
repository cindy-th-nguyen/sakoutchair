//
//  MqttRequester.swift
//  SakoutcherMqttTester
//
//  Created by Oudjama on 29/06/2021.
//

import Foundation
import Moscapsule
import FirebaseDatabase
import FirebaseAuth

struct UserPayload {
    static var payload: Payload?
}
public class MqttRequester {
    
    static var mqttClient: MQTTClient?
    var ref: DatabaseReference! {
        get{
            return Database.database(url: "https://sakoutchair-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        }
    }
    
    public static func prepareRequester() {
        let mqttConfig = MQTTConfig(clientId: "99ab8a569d244195954e17b8d842c8d6", host: "test.mosquitto.org", port: 1883, keepAlive: 300)
        
        mqttConfig.onConnectCallback = { returnCode in
            print("CONNECTED : \(returnCode.description)")
        }
        
        mqttConfig.onDisconnectCallback = { returnCode in
            print("DISCCONECTED : \(returnCode)")
        }
        
        mqttConfig.onMessageCallback = { mqttMessage in
            guard let msg = mqttMessage.payloadString else {
                return
            }
            print("Message reçu = \(msg)")
            
            if mqttMessage.topic == "sakoutcher/test/payload" {
                print("PAYLOAD CONVERT")
                do {
                    let decoder = JSONDecoder()
                    let payloadJson = try decoder.decode(MqttPayload.self, from: Data(msg.utf8))
                    FirebaseAuthManager().sendDataSensorsToDatabase(payload: payloadJson.payload)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        mqttConfig.onSubscribeCallback = { (messageId, grantedQos) in
            print("subscribed (mid=\(messageId),grantedQos=\(grantedQos))")
        }
        self.mqttClient = MQTT.newConnection(mqttConfig)
    }
}
