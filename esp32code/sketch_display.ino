
#include <Adafruit_GFX.h>
#include <Max72xxPanel.h>
#include <SPI.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// Define the number of devices we have in the chain and the hardware interface

#define DATA_PIN   23  //MOSI
#define CLK_PIN     18  //SCK
#define CS_PIN      15  //SS


const int numberOfHorizontalDisplays = 8;
const int numberOfVerticalDisplays = 1;
Max72xxPanel matrix = Max72xxPanel(CS_PIN, numberOfHorizontalDisplays, numberOfVerticalDisplays);
const int wait = 50; // Velocidad a la que realiza el scroll
const int spacer = 1;
const int width = 5 + spacer; // Ancho de la fuente a 5 pixeles
//ble server
BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
uint32_t value = 0;
float prev_temp;
float prev_humidity;

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"


class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      BLEDevice::startAdvertising();
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

void setup(){
   Serial.begin(9600);
   matrix. setIntensity ( 1 ) ;  // Adjust the brightness between 0 and 15
   matrix. setPosition ( 0 ,  0 ,  0 ) ;  // The first display is at <0, 0>
   matrix. setPosition ( 1 ,  1 ,  0 ) ;  // The second display is at <1, 0>
   matrix. setPosition ( 2 ,  2 ,  0 ) ;  // The third display is in <2, 0>
   matrix. setPosition ( 3 ,  3 ,  0 ) ;  // The fourth display is at <3, 0>
   matrix. setPosition ( 4 ,  4 ,  0 ) ;  // The fifth display is at <4, 0>
   matrix. setPosition ( 5 ,  5 ,  0 ) ;  // The sixth display is at <5, 0>
   matrix. setPosition ( 6 ,  6 ,  0 ) ;  // The seventh display is at <6, 0>
   matrix. setPosition ( 7 ,  7 ,  0 ) ;  // The eighth display is in <7, 0>
   matrix. setPosition ( 8 ,  8 ,  0 ) ;  // The ninth display is at <8, 0>
   matrix. setRotation ( 0 ,  1 ) ;     // Display position
   matrix. setRotation ( 1 ,  1 ) ;     // Display position
   matrix. setRotation ( 2 ,  1 ) ;     // Display position
   matrix. setRotation ( 3 ,  1 ) ;     // Display position
   matrix. setRotation ( 4 ,  1 ) ;     // Display position
   matrix. setRotation ( 5 ,  1 ) ;     // Display position
   matrix. setRotation ( 6 ,  1 ) ;     // Display position
   matrix. setRotation ( 7 ,  1 ) ;     // Display position
   matrix. setRotation ( 8 ,  1 ) ;     // Display position
   matrix.fillScreen(LOW);
   matrix.drawPixel(0, 0, LOW);
   matrix.write();

     // Create the BLE Device
  BLEDevice::init("ESP32 Test");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  // https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}


bool getbool(String value){
  if(value=="1"){
    return HIGH;
    }else{
       return LOW;
    }    }

  

void loop(){

 


    
    // notify changed value
    if (deviceConnected) {
   std::string value = pCharacteristic->getValue();

    

if(value.length() > 0){
   Serial.println("===================");
        Serial.print("New Value: ");
        String result = "";
        for (int i = 0; i < value.length(); i++) {
         // Serial.print(value[i]);
          result += value[i];
        }
        Serial.println("helo"+result);
        Serial.println("===================");

if(result=="clear"){
    matrix.fillScreen(LOW);
   matrix.drawPixel(0, 0, LOW);
   matrix.write();
  }else{
    
    
    String value1, value2;
 
// For loop which will separate the String in parts
// and assign them the the variables we declare
for (int i = 0; i < result.length(); i++) {
  if (result.substring(i, i+1) == "+") {
    value1 = (result.substring(0, i));
    value2= (result.substring(i+1));
    break;
  }
}
 

        int index = value1.toInt();
        int y = floor(index / 32);
        int x = index % 32;
        matrix.drawPixel(x, y, getbool(value2));
        matrix.write();
   
    
    }


  
  }

  
 // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
    }
    // disconnecting Serial.println("start advertising");
        oldDeviceConnected = deviceConnected;
    if (!deviceConnected && oldDeviceConnected) {
        delay(500); // give the bluetooth stack the chance to get things ready
        pServer->startAdvertising(); // restart advertising
       
    }
    // connecting
    if (deviceConnected && !oldDeviceConnected) {
        // do stuff here on connecting
        oldDeviceConnected = deviceConnected;
    }

}
