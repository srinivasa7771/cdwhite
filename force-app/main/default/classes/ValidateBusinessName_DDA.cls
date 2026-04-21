global class ValidateBusinessName_DDA {

    webService static String validateNameInDDA(String companyName) {
        Boolean bNameExist = false;
        String wsError='';
        Resp resp = new Resp();
        List<data> data1 = new List<data>();
        Req req = new Req(); data d = new data();

        d.companyName = companyName;
        data1.add(d);
        req.data = data1;
        req.methodname = 'validateName';
        String jsonBody = JSON.serialize(req);
        system.debug(jsonBody);

        try{
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            request.setHeader('Content-Type', 'application/json');
            //request.setEndpoint('callout:DCCA_QA/apexrest/onbordingapi');DCCA_Auth
            request.setEndpoint('callout:DCCA_Auth/apexrest/onbordingapi');
            request.setTimeout(120000);
            request.setMethod('POST');
            request.setBody(jsonBody);
            response = h.send(request);
            System.debug('jsonBody: ' + jsonBody);
            System.debug('#### response ' + response.getBody());

            if (response.getStatusCode()!=200) {
                //resp.errorMsg = '* Technical Error while searching the DDA database, please try after some time! 1';
                //resp.nameExists = true;
                resp.nameExists = false;
                return JSON.serialize(resp);
            }

            List<NameValidator> lstNameValidator = (List<NameValidator>) JSON.deserialize( response.getBody(), List<NameValidator>.class);

           if (lstNameValidator.size()>0) {
               bNameExist = !lstNameValidator[0].isValid;
               wsError = lstNameValidator[0].errorMessage;
           }
           else{
               bNameExist = true;
               wsError = '* Technical Error while searching the DDA database, please try after some time! 2';
           }

        }catch (Exception e) {
            resp.errorMsg = '* Technical Error while searching the DDA database, please try after some time! 3';
            resp.nameExists = true;
            return JSON.serialize(resp);
        }

        resp.nameExists = bNameExist;
        resp.errorMsg = wsError;
        return JSON.serialize(resp);
    }

public class Res {
    public string key1;
        public string city;
        public string value;
        public string product_type;
        public string id;
        public string name_slug;
    }

    public class NameValidator{
        public string companyName;
        public integer errorCode;
        public string errorMessage;
        public boolean isValid;
    }

    public class Req{
        public string methodname;
        public List<data> data;
    }

    public class data{
        public string companyName;
    }

    public class Resp{
        public Boolean nameExists;
        public String errorMsg;
    }
}