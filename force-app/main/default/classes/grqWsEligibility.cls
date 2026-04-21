public class grqWsEligibility {
    public List<AccountEligbility> AccountEligbility {set;get;}
    public class AccountEligbility {
        public string AccountId {set;get;}
        public string AccountName {set;get;}
        public List<EligbDetail> EligbDetail {set;get;}
    }
    public class EligbDetail {
        public string EligibilityType {set;get;}
        public String EligibilitySubType {set;get;}
        public String BusinessPark {set;get;}
        public decimal Eligibility {set;get;}
        public String LeaseEndDate {set;get;}
        public String OppName {set;get;}
        public String AgNumber {set;get;}

    }
    public class ElgRes{
        public integer elgCnt {set;get;}
        public String accType {set;get;}
    }
    public static ElgRes getEligibilityCnt(String oracleId, string eType) { //'1702631', 'Visa'
        ElgRes elg = new ElgRes();
        decimal eligCnt = 0;
        elg.elgCnt = 0;
        Set<String> elgLst = new Set<String>();
        String res = grqWsEligibility.getEligibility(oracleId, eType);
        grqWsEligibility rec= (grqWsEligibility) json.deserialize(res, grqWsEligibility.class);
        if (rec != null && rec.AccountEligbility != null && !rec.AccountEligbility.isEmpty()) {
            for (grqWsEligibility.AccountEligbility ae : rec.AccountEligbility) {
                List<grqWsEligibility.EligbDetail> elst = ae.EligbDetail;
                if (elst != null && !elst.isEmpty()) {
                    for (grqWsEligibility.EligbDetail ed : elst) {
                        /*eligCnt=eligCnt+ed.Eligibility;*/
                        elgLst.add(ed.OppName);
                    }
                    Date dt1 = Date.today();

                    for (grqWsEligibility.EligbDetail ed : elst) {
                        Date lsEndDt = Date.valueOf(ed.LeaseEndDate);
                        if (!elgLst.contains('Renewal - '+ed.AgNumber) && dt1 < lsEndDt && ed.EligibilitySubType == 'Staff Visa') {
                            eligCnt=eligCnt+ed.Eligibility;
                            if (ed.BusinessPark == 'In5')
                                elg.accType = 'Customer - IN5';
                        }
                    }

                    elg.elgCnt = Math.round(eligCnt);
                }

            }
        }
        return elg;
    }
    public static String getEligibility(String oracleId, string eType) { //
        String respBody = '';
          Http h = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response   = new HttpResponse();
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('accept', 'application/json');

            request.setEndpoint('callout:D3_NC/apexrest/'+Label.VisaEligEndpoint+'/'+oracleId+'/'+eType);

            request.setTimeout(90000);request.setMethod('GET');
            try {
            response = h.send(request);
            if (response.getStatusCode()==200) {
                if (response.getBody()!=null) {
                     respBody = response.getBody();
                    respBody = respBody.replace('\\', '');
                    respBody = respBody.substring(1, respBody.length()-1);
                    system.debug('respBody:'+respBody);
                    /* {"AccountEligbility":[{"OracleID":"1702631 1702631/Visa", "EligbDetail":[{"OppName":"SK testing PMLA", "LeaseStartDate":"2021-02-01", "LeaseEndDate":"2024-01-31", "EligibilityType":"Visa", "EligibilityName":"ELG-1213", "Eligibility":15.00, "BusinessPark":"DIC", "AgNumber":"AG-066420"}, {"OppName":"Short term lease", "LeaseStartDate":"2021-02-01", "LeaseEndDate":"2021-04-15", "EligibilityType":"Visa", "EligibilityName":"ELG-1227", "Eligibility":15.00, "BusinessPark":"DIC", "AgNumber":"AG-066441"}, {"OppName":"SK testing PMLA antenna", "LeaseStartDate":"2021-02-01", "LeaseEndDate":"2023-01-31", "EligibilityType":"Visa", "EligibilityName":"ELG-1233", "Eligibility":1.00, "BusinessPark":"DIC", "AgNumber":"AG-066454"}], "AccountName":"ABC company1", "AccountId":"0015500001FSoeaAAD"}]} */
                }
            }
           }catch (System.CalloutException e) {system.debug('ex getEligibility:::'+e.getStackTraceString());}

       return respBody;
    }
}