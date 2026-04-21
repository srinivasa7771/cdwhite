public class ParkingSession {
    private static String SESSION_ID = null;

    private ParkingSession() {

        HttpRequest request = new HttpRequest();
        // URL: https://<your-domain>.salesforce.com/services/Soap/u/60.0
        // Identity Type: Named Principal, Auth Protocol: Password Authentication
        request.setEndpoint('callout:Salesforce_SOAP/services/Soap/u/60.0');
        request.setMethod('POST');  request.setHeader('Content-Type', 'text/xml;charset=UTF-8');    request.setHeader('SOAPAction', '""');
        request.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' +
            gu.csStr('tecomU') + '</username><password>' + gu.csStr('tecomP') + '</password></login></Body></Envelope>');
        Dom.XmlNode resultElmt  = (new Http()).send(request).getBodyDocument().getRootElement().getChildElement('Body',
            'http://schemas.xmlsoap.org/soap/envelope/').getChildElement('loginResponse', 'urn:partner.soap.sforce.com').getChildElement('result',
            'urn:partner.soap.sforce.com');
        final String SERVER_URL = resultElmt.getChildElement('serverUrl', 'urn:partner.soap.sforce.com').getText().split('/services')[0];
        SESSION_ID = resultElmt.getChildElement('sessionId', 'urn:partner.soap.sforce.com').getText();
    }

    public static String getParkingSessionId() {
        System.debug('< getParkingSessionId > : ' + SESSION_ID);
        if (SESSION_ID == null) {ParkingSession ps = new ParkingSession();}return SESSION_ID;
    }

    public static soapNrtaActivation.Tecom_Parking_SOAP_WS setParkingSessionId() {
        soapNrtaActivation.Tecom_Parking_SOAP_WS tps = new soapNrtaActivation.Tecom_Parking_SOAP_WS();
        tps.SessionHeader = new soapNrtaActivation.SessionHeader_element();
        tps.SessionHeader.sessionId = ParkingSession.getParkingSessionId();
        System.debug('< setParkingSessionId > : ' + tps.SessionHeader.sessionId);
        return tps;
    }

}