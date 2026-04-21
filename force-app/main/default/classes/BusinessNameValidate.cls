global class BusinessNameValidate {

    webService static String validateBusiness(String name, String accID) {
        Resp resp = new Resp();
        String errorMessage = '';
        boolean nameExist = false;

        try{
            name = name.trim();
            List<Account> accLst = [SELECT id FROM Account WHERE (on__c=:name OR name=:name) AND Id!=:accID];
            if (accLst != null && !accLst.isEmpty()) { resp.nameExists = true; resp.errorMsg = '* This name already exists!'; return JSON.serialize(resp); }

            /*List<g_req__c> lstRqs = [select id, name, xcfn__c, xcmn__c, xcln__c from g_req__c where (xcfn__c=:name OR xcmn__c=:name OR xcln__c=:name) and (srvc__r.uid__c='216' OR srvc__r.uid__c='322')];
            if (lstRqs != null && !lstRqs.isEmpty() && lstRqs.size()>1) {
                resp.nameExists = true;
                resp.errorMsg = '* This name already exists!';
                return JSON.serialize(resp);
            }*/

            //String responseDCCI = ;
            /*Resp dcciResp = (Resp) JSON.deserialize(validate(name), Resp.class);
            System.debug('dcciResp'  + dcciResp);
            if (dcciResp.nameExists) {
                resp.nameExists = true;
                resp.errorMsg = dcciResp.errorMsg;
                return JSON.serialize(resp);
            }*/

            //String responseDDA = ValidateBusinessName_DDA.validateNameInDDA(name);
            Resp ddaResp = (Resp) JSON.deserialize(ValidateBusinessName_DDA.validateNameInDDA(name), Resp.class);
            resp.nameExists = ddaResp.nameExists;
            resp.errorMsg = ddaResp.errorMsg;
            return JSON.serialize(resp);

        }catch (Exception e) {
            resp.nameExists = true; resp.errorMsg = '** Technical Error, please try after sometime!'; return JSON.serialize(resp);
        }

    }

    public static String validate(String name) {
        //[{"key1":"46956", "city":"dubai", "value":"Telnet Communications Tech LLC", "product_type":"1", "id":"5584", "name_slug":"telnet-communications-tech-llc"}]
        boolean nameExist = false;
        Resp resp = new Resp();
        resp.nameExists = false;
        resp.errorMsg ='';

        try{
            system.debug('name::'+name);
            //name = name.replace(' ', '%20');
            HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:dcciinfo_ae/sitefront/home/getSearchSuggestions?term='+name.replace(' ', '%20'));
            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = http.send(req);

            System.debug('res.getBody():: ' + res.getBody());

            if (res != null && String.isNotBlank(res.getBody())) {
                List<Res> resLst = (List<Res>)Json.deserialize(res.getBody(), List<Res>.class);
                system.debug('res::'+resLst);
                if (resLst != null && resLst.size() > 0 ) {
                    for (res r : resLst) {
                        if (String.isNotBlank(r.value) && name.equalsIgnoreCase(r.value)) {
                            System.debug('r.value : ' + r.value + ' name: ' + name );
                            resp.nameExists = true;
                            resp.errorMsg = '<b>* '+r.value + '</b> is already in use, please try another name.' ;
                            return JSON.serialize(resp);
                        }
                    }
                }
            }

            system.debug('res flg ::'+nameExist);
            //throw new System.NullPointerException();

        }catch (Exception ex) {
            system.debug('ex::'+ex.getMessage());
            resp.nameExists = true;resp.errorMsg = '** Technical Error [DCCI WS], please try after sometime!';
        }

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

    public class Resp{
        public Boolean nameExists;
        public String errorMsg;
    }
}