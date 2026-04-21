public with sharing class PSADocController{

    public string accid {
        set;
        get;
    }
    public string LicenseNumber {
        set;
        get;
    }
    public string ManagerInCharge {
        set;
        get;
    }
    public string CompanyName {
        set;
        get;
    }
    public Date AgreementDate {
        set;
        get;
    }
    public string managerInChargeId {
        set;
        get;
    }
    public string park {
        set;
        get;
    }
    public string managerEmail {
        set;
        get;
    }
    //Added by CB to validate that the loggedIn email is same as DDA email
    public Boolean showPSA {
        set;
        get;
    }

    public string managerDDAEmail {
        set;
        get;
    }
    public Boolean isManagerInCharge {
        set;
        get;
    }
    public string messageToShow {
        set;
        get;
    }
    public string signedBy{
        set;
        get;
    }
    public Datetime signedDate{
        set;
        get;
    }
    //constructor
    public PSADocController() {
        User currentUser = [SELECT ContactId , Contact.AccountId, Contact.Email, Email, Contact.Type__c, Account.ec__c, Account.vespe__c, Account.PSA_Signed_By__r.flnm__c
                            FROM User
                            WHERE Id = :UserInfo.getUserId() ];

        accid = currentUser.Contact.AccountId;
        managerInChargeId = currentUser.ContactId;
        managerEmail = currentUser.Email;
        isManagerInCharge = currentUser.Contact.Type__c == 'Manager Incharge';
        signedBy = currentUser.Account.PSA_Signed_By__r.flnm__c;
        if (currentUser.Account.ec__c != null && currentUser.Account.vespe__c != 0) {
            messageToShow = 'Thank you for accepting the ESA terms and conditions. You may now proceed to apply for your employees visas.';
        }else if (currentUser.Account.ec__c == null && currentUser.Account.vespe__c != 0) {
            messageToShow = 'Thank you for accepting the ESA terms and conditions. You can apply for your employees visas once your establishment card has been issued.';
        }else if (currentUser.Account.ec__c != null && currentUser.Account.vespe__c == 0) {
            messageToShow = 'Thank you for accepting the ESA terms and conditions. You can apply for your employees visas once your visa quota is activated.';
        }else{
            messageToShow = 'Thank you for accepting the ESA terms and conditions. You can apply for your employees visas once the visa quota is activated and the establishment card is issued.';
        }
        System.debug('message to show' + messageToShow);
    }

    //action to do
    public void AccountDetails() {
        //get id of the request from url
        accid = String.isBlank(accid) ? apexpages.currentpage().getparameters().get('id') : accid;
        // retrieve merge fields to be used on the pdf
        if (accid != null && String.isnotBlank(accid)) {
            try{
                Account acc = [SELECT Id, name, lc__c, PSA_Signed_Date__c, Prk__c
                               FROM Account
                               WHERE Id =: accid];

                park = acc.Prk__c;
                String  fullName='';
                List<Manager> m=new List<Manager>();
                accIDs ids = new accIDs();
                List < String > accLicNoLst = new List < String > ();
                accLicNoLst.add(acc.lc__c);
                ids.AccLicNos = accLicNoLst;
                String reqBody = JSON.serialize(ids);
                System.debug(reqBody);
                Http h = new Http();
                HttpRequest request = new HttpRequest();
                HttpResponse response = new HttpResponse();
                request.setHeader('Content-Type', 'application/json');
                request.setHeader('accept', 'application/json');
                request.setEndpoint('callout:DCCA_Auth/apexrest/fetchManagersInfo');
                request.setTimeout(90000);
                request.setMethod('POST');
                request.setBody(reqBody);
                response = h.send(request);
                if (response.getStatusCode() == 200) {
                    String respBody = '{"Managers":[]}';
                    if (response.getBody() != null) {
                        respBody = '{"Managers":' + response.getBody() + '}';
                    }
                    System.debug('<response.getBody()> : ' + respBody);
                    Records recs = (Records) JSON.deserialize(respBody, Records.class);
                    m= recs.Managers;
                    if (recs != null && !m.isEmpty() && m.size()>0) {
                        fullName=m[0].firstName != null?m[0].firstName:''+' '+m[0].lastName != null?m[0].lastName:'';
                        //Added by CB to validate that the loggedIn email is same as DDA email
                        managerDDAEmail = m[0].email;
                        showPSA = String.isNotBlank(managerDDAEmail) && (managerDDAEmail.equalsIgnoreCase(managerEmail)) ;/*&& isManagerInCharge; MR - Commented as Type__c is empty in axs*/
                    }

                }

                //merge fields to be used on the pdf - properties
                CompanyName = acc.Name ;
                LicenseNumber = acc.lc__c;
                //ManagerInCharge = mi[0].name__c;
                ManagerInCharge=fullName;
                AgreementDate = Date.today();
                TimeZone tz = UserInfo.getTimeZone();
                signedDate = acc.PSA_Signed_Date__c.addSeconds(tz.getOffset(acc.PSA_Signed_Date__c) / 1000);
            }
            catch (exception e) {
                system.debug('exception:'+e.getMessage());
            }
        }

    }

    public void updatePSASignFields() {

        Account currentAccount = [SELECT Id, PSA_Signed_Date__c, PSA_Signed_By__c, stapsa__c, PRM_Email__c, ec__c, vespe__c
                                  FROM Account
                                  WHERE Id = : accid ];

        currentAccount.PSA_Signed_Date__c = Datetime.now();
        currentAccount.PSA_Signed_By__c = managerInChargeId;
        currentAccount.stapsa__c  = 'Signed';

        try{
            if (Schema.sObjectType.Account.isUpdateable()) {
                update currentAccount;
            }
        }
        catch (Exception e) {

            System.debug('exception in updating account fields' + e);
        }
    }

    public class Records{public List<Manager> Managers;}
    public class accIDs {public List<String> AccLicNos;}
    public class Manager{
        public String accLicNo, salutation, firstName, lastName, mobile, email, passportNo, nationality, freelanceUsername, freelancePass;
        public Boolean dupCon, dupUsr, isfreelancerOb;
    }
}