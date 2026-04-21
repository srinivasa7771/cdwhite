public class reqstssearchctl {
  public list <g_itmHistorySTA__c> hist{get;set;}
    public string searchstring {get;set;}
    public string actMsg {set;get;}
     public Boolean codeCheck{get;set;}
    public boolean noSRfg{get;set;}

    private static String baseUrl = 'https://www.google.com/recaptcha/api/siteverify';
    //private static String secret = '6LcCUEEUAAAAANjzDnlRyDT8n_U-c2TwBNJHbbdH';
         private static String secret = Label.CaptchaSecret;
    //'6LeSuTYUAAAAAC-ANDQ7_ZjSTeUBUPj2jEEI9T0h';

    public static String TestResponse = 'System.HttpResponse[Status=OK, StatusCode=200]';

    public String sitekey {
        get {return Label.CaptchaSitekey;
            //return '6LcCUEEUAAAAAJpB9jCj6rriclGV1X1bk1w-ir6f';
             // return '6LeSuTYUAAAAAGb5qXaXzgj2ZzDjACg9mdcUsjHP';
            }
    }
    public String response  {
       // get{ return 'true';}
        get { return String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('g-recaptcha-response')); }
    }

    public reqstssearchctl ( ) {
        noSRfg=false;
    }

    public pageReference search(){
        System.debug('<search starts>');
        string str = searchstring; pageReference ref= null;
       System.debug('<search starts>');
        str=str.trim();

        String responseBody = makeRequest(baseUrl,'secret=' + secret +'&response='+ response);
        String success;
        if (Test.isRunningTest()){
            success='true';

        }else{
            success = getValueFromJson(responseBody, 'success');
        }
        if (success.equalsIgnoreCase('true')) { List < g_req__c > rqLst = [select id, name from g_req__c where(name =: str or con__r.p__c =: str) and Acc__r.Name != 'test identity 1' and createddate = last_n_days: 365 order by createddate desc limit 1 ]; if (rqLst != null && !rqLst.isEmpty()) { ref = new PageReference('/apex/statusinfo?id='+rqLst[0].id); } else { noSRfg = true; } } else { ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please verify the captcha'); ApexPages.addMessage(errorMsg); }
        return ref;

    }

    public void clear(){
        if (hist!=null && hist.size()>0){
            hist.clear();
        }
        searchstring='';
        noSRfg=false;
    }


    /**
* Make request to verify captcha
* @return      response message from google
*/
    private static String makeRequest(string url, string body)  {
        HttpResponse response = null;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);

        try {
            Http http = new Http();
            if (Test.isRunningTest()){
                return TestResponse;

            }else{ response = http.send(req); return response.getBody();}
        } catch (System.Exception e) { System.debug('ERROR: ' + e); }return '{"success":false}';
    }

    /**
* to get value of the given json string
* @params
*  - strJson       json string given
*  - field         json key to get the value from
* @return          string value
*/
  public static string getValueFromJson ( String strJson, String field ){ JSONParser parser = JSON.createParser(strJson); while (parser.nextToken() != null) { if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) { if (parser.getText() == field){ parser.nextToken(); return parser.getText(); } } } return null; }


}