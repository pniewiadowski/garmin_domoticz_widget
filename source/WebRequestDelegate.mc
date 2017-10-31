//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Communications as Comm;
using Toybox.WatchUi as Ui;

class WebRequestDelegate extends Ui.BehaviorDelegate {
    var notify;
    // Handle menu button press
    function onMenu() {
        makeRequest();
        return true;
    }

    function onSelect() {
        makeRequest();
        return true;
    }

    function makeRequest() {
    
        notify.invoke("Gathering data");
		
		
			Comm.makeWebRequest(
            "", //url
            {
                "username" => "", //base64 decoded
                "password" => "", //base64 decoded
                "type"	   => "devices",
                "filter"   => "temp",
                "used"     => "true",
                "order"    => "Name"
            },
            {                                             // set the options
           :method => Comm.HTTP_REQUEST_METHOD_GET,      // set HTTP method
           
                                                                   // set response type
           :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON
       },
           method(:onReceive)
        );
    }

    // Set up the callback to the view
    function initialize(handler) {
        Ui.BehaviorDelegate.initialize();
        notify = handler;
        makeRequest(); //added to run just after initialization
    }

    // Receive the data from the web request
    function onReceive(responseCode, data) {
    	//System.println(data);
    	//System.println(results);
    	
        if (responseCode == 200) {
        	var receivedData = data.get("result");
    		var flat = receivedData[0]["Temp"].format("%.1f");
    		var balcony = receivedData[1]["Temp"].format("%.1f");
    		var outside = receivedData[2]["Temp"].format("%.1f");
            notify.invoke("\n" + "Mieszkanie:  " + flat +" C\n" + 
						         "Zabudowa:  " + balcony +" C\n" +
						         "Zewnetrzny: " + outside +" C\n");
            
        } else {
            notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
    }
}