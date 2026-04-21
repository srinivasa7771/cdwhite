public class grqWsDccaGetService {

    public static Map<String, String> actMap {get;set;}
    public static Map<String, String> priceMap {get;set;}

    public class argLocation {
        public Boolean isRegoff {get;set;}
        public string agreeNo {get;set;}
        public string floor ;
        public string arbfloor ;
        public string OffNo ;
        public string buildN ;
        public string arbBuildN ;
        public string bus ;
        public string arbBus ;
        public string status {get;set;}
        public string reason {get;set;}
        public string stDt {get;set;}
        public string edDt {get;set;}
        public string fullLoc {get;set;}
    }

    public class argLoc {
        public List<argLocation> argLocation;
    }

    public class Attachments {
        public String parentId;
        public String attachmentBody;
        public String Name;
        public String messagecode;
        public String message;

    }

    public class  Titles{
        public String name{set;get;}
        public String lang{set;get;}
        public String genere{set;get;}
        public String freq{set;get;}
    }

    public class  Channels{
        public String name{set;get;}
        public String lang{set;get;}
        public String genere{set;get;}
        public String freq{set;get;}
    }

    public class AttachList {
        public list<Attachments> AttachmentList {get;set;}
    }

    public class  Locations{
        public Boolean isRegoff {get;set;}
        public string AgreementNo {get;set;}
        public string ArabicBuildingName {get;set;}
        public string ArabicBusinessUnit {get;set;}
        public string ArabicFloor {get;set;}
        public string ArabicOfficeNo {get;set;}
        public string totalArea {get;set;}
        public string Category {get;set;}
        public string SubCategory {get;set;}
        public boolean regOff{get;set;}
        public string OfficeNo{get;set;}
        public string LicenseNo {get;set;}
        public string LocationId {get;set;}
        public string BusinessPark {get;set;}
        public string BuildingName {get;set;}
        public string Floor {get;set;}
        public String Status {get;set;}
        Public String ContractStatusReason {get;set;}
        Public date ContractStartDate {get;set;}
        Public date ContractEnddate {get;set;}
        Public boolean IsMainAdd {get;set;}
        Public String subleaseCompany {get;set;}
        Public boolean showOnLicen {get;set;}
        public string licenseType {get;set;}
        Public string IsSubLease {get;set;}
        public string error {get;set;}

        Public String IsDownsize {get;set;}
        Public String RenewalOpp {get;set;}

        public string Recordtype{get;set;}
        public string masterLocationLicense{get;set;}
        public List<products> prodList;

    }
    /**  public class products{
public string LineItemName {get;set;}
public string ProductName {get;set;}
public string UnitNumber {get;set;}
}**/
    public class Products {
        public String LineItemName{get;set;}
        public String ProductName{get;set;}
        public String UnitNumber{get;set;}
        public String OppArea{get;set;}
        public String buildingName{get;set;}
        public String floor{get;set;}
        public decimal UnitArea{get;set;}
        public string PlotNumer{get;set;}
        public boolean regOff{get;set;}
    }

    public class Activities{
        public string LicenseNo {get;set;}
        public string ActivityId {get;set;}
        public string Name {get;set;}
        Public string type {get;set;}
        public string segName {get;set;}
        public string accName {get;set;}
        public List<Titles> titleList {get;set;}
        public List<Channels> chanList {get;set;}
        public date StartDate {get;set;}
        public string error {get;set;}

    }
    public class  ActivityLocations{

        public List<Locations> locationList;
        public string LicnseNo {get;set;}
        public string MethodName {get;set;}
        public List<Activities> act;
        public string error {get;set;}
        public string errorCode {get;set;}
    }

    //Request creation
    public class DocumentD
    {
        public String name {get;set;}
        public String shareHolderName {get;set;}
        public boolean isRequired {get;set;}
    }
    public class LineItems
    {
        public string segment {get;set;}
        public string activity {get;set;}
        public string isActive {get;set;}
        public string lineName {get;set;}
        public Integer amount {get;set;}
    }
    public List<Data> Data;
    public string sme{get;set;}
    public String invno {set;get;}
    public class Data {
        public List<DocumentD> docs {get;set;}
        public List<LineItems> lines {get;set;}
        public Integer amount {get;set;}
        public string idRec {get;set;}
        public string licNo {get;set;}
        public string expDate {get;set;}
        public string name {get;set;}
        public string mangerName{get;set;}
        public string mangerNameA {get;set;}
        public string leaseType {get;set;}
        public string managerNation {get;set;}
        public string managerNationA {get;set;}
        public string errorCode {get;set;}
        public string errorMessage{get;set;}
        public string licType{get;set;}
        //public string dccaId{get;set;}
        public string sme{get;set;}
        public boolean buRecomendation{get;set;}
        public string shareHldType{get;set;}
        public List<sanctions> sancs;
        public string actspeNotes;
        public boolean isRenewalAllowed;
        public string status;
        public string legaleng;
        public string legalarabic;
        public string lincenseeeng ;
        public string lincenseearabic{get;set;}
        public string frameworkeng{get;set;}
        public string frameworkarabic{get;set;}
        public string businessPArk {get;set;}
        public boolean isUBOSubmitted {get;set;}
        public boolean isUBORequired {get;set;}
        public boolean isUniv {get;set;}
        public boolean locAmd {get;set;}
    }

    public Class sanctions
    {
        public string sanctionDept{get;set;}
        public string sancdescriprtion{get;set;}
    }

    public ResponseData ResponseData{get;set;}

    public class ResponseData {
        public String PartyId {get;set;}
        public Boolean Success{get;set;}
        public String Source {get;set;}
        public String Error {get;set;}
        public String ResponseCode{get;set;}
        public List<Records> Records{get;set;}
    }

    public class Records {
        public String StageName{get;set;}
        public String AgNo{get;set;}
        public String LeaseType{get;set;}
        public String Type{get;set;}
        public Boolean regOff{get;set;}
        public String BusinessPark{get;set;}
        public String OppArea{get;set;}
        public Decimal Area{get;set;}
        public String Building{get;set;}

        public String ContractStartDate{get;set;}
        public String ContractEndDate{get;set;}
        public String Category{get;set;}
        public String SubCategory{get;set;}
        public Boolean FreelancerLease {get;set;}
        public String ContractStatus{get;set;}
        public String ContractStatusReason{get;set;}
        public List<grqWsDccaGetService.Products> Products{get;set;}
        public List<Units> Units{get;set;}
        public String fullUnitAdd{get;set;}
        public List<PaymentSchedules> PaymentSchedules{get;set;}
        public List<Invoices> Invoices{get;set;}
        Public String IsDownsize {get;set;}
        Public String RenewalOpp {get;set;}
        public Boolean PushToDDA {get;set;}
        /* PMS Contract */
        Public String ContractNumber { get; set; } Public String Status { get; set; } public String BuildingName { get; set; } public decimal TotalSize { get; set; }
    }
    public class Invoices{
        public string InvoiceId {get;set;}
        public string InvoiceName {get;set;}
        public string InvoiceDueDate {get;set;}
        public string InvoiceType {get;set;}
        public string InvoiceAmount {get;set;}
    }

    public class PaymentSchedules{
        public string Id {get;set;}
        public string Name {get;set;}
        public string Type {get;set;}
        public string Amount {get;set;}
    }

    public class Units{
        //
        public string UnitNameArabic {get;set;}
        public string UnitNoArabic {get;set;}
        public string UnitNoEnglish {get;set;}
        public string FloorArabic {get;set;}
        public string FloorEnglish {get;set;}
        public string BuildingNameArabic {get;set;}
        public string Category {get;set;}
        public string SubCategory {get;set;}
        public string SendToDCCA {get;set;}
        //
        public string UnitName {get;set;}
        public string UnitNumber {get;set;}
        public string FloorName {get;set;}
        public string BuildingName {get;set;}
        //  public string BuildingNameArabic {get;set;}
        public string CommercialName {get;set;}
        public string BusinessPark {get;set;}
        public string UniqueKey {get;set;}
        public string AgNo {get;set;}
        public string ContractStartDate {get;set;}
        public string ContractEnddate {get;set;}
        public Decimal UnitArea {get;set;}
    }
    // DDA new Licence Request
    public static String getNewReqDetails(String Reqno) {

        String jsonBody;
        String jsonResp = '';
        Data renInfo = new Data();
        renInfo.idRec = Reqno;
        jsonBody = JSON.serialize(renInfo);
        System.debug('<getNewReqDetails> jsonBody: ' + jsonBody);
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:DCCA_Auth/apexrest/shareNewLicData');
        request.setMethod('POST');
        request.setBody(jsonBody);
        request.setTimeout(60000);
        try {
            response = h.send(request);
            System.debug('<getNewReqDetails> response: ' + response);
            if (response.getStatusCode() == 200) {
                jsonResp = response.getBody();
            }
        }catch (System.CalloutException e) {}
        return jsonResp;
    }
    public static String getReqDetails(String AccLic, string licExpDt, string dccaId) {
        return null;
    }
    public static String getReqDetails(String AccLic, string licExpDt, string dccaId, boolean amdFlg) { //

        String jsonBody;
        String jsonResp = '';
        Data renInfo = new Data();
        renInfo.licNo = AccLic;
        if (String.isNotBlank(dccaId))
            renInfo.idRec = dccaId;
        renInfo.expDate = licExpDt; /*'2020-02-26'*/
        if (amdFlg != null && amdFlg)renInfo.locAmd = amdFlg; else renInfo.locAmd = false;
        jsonBody = JSON.serialize(renInfo);
        system.debug('Req jsonBody::' + jsonBody);
        jsonBody = JSON.serialize(renInfo);
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:DCCA_Auth/apexrest/shareRenewalData');
        request.setMethod('POST');
        request.setBody(jsonBody);
        request.setTimeout(60000);
        try {
            response = h.send(request);
            if (response.getStatusCode() == 200) {
                jsonResp = response.getBody();
            }
        } catch (System.CalloutException e) {}
        return jsonResp;
    }

    public static String loadAllSeg(String AccLic) {
        //List<Activities>
        ActivityLocations  allAct = new ActivityLocations();
        String jsonBody;
        Activities actrec = new Activities();
        ActivityLocations actLoc = new ActivityLocations();
        List<Activities> dccaActList ;
        actLoc.LicnseNo =AccLic;
        actLoc.MethodName = 'getReqActivities';
        //'getActivities';
        jsonBody = JSON.serialize(actLoc);

        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:DCCA_Auth/apexrest/RnLIntegrationActLoc?licenseno='+AccLic+'&method='+ actLoc.MethodName);
        request.setTimeout(120000);
        request.setMethod('POST');
        request.setBody(jsonBody);
        response = h.send(request);
        if (response.getStatusCode() == 200) {
            allAct = ( ActivityLocations ) JSON.deserialize( response.getBody(), ActivityLocations.class);
            System.debug('allAct'+allAct);
            if (allAct.act != null) {dccaActList = allAct.act;}
            //return dccaActList;}
            //   else return dccaActList;
            // System.debug('JJ dccaActList'+dccaActList);

        }
        actMap = new Map<String, String>();
        priceMap = new Map<String, String>();
        if (dccaActList != null && dccaActList.size()>0) {
            for (Activities act : dccaActList) {
                if (actMap.containsKey(act.segName)) { actMap.put(act.segName, (String)actMap.get(act.segName)+'<li>'+act.Name+'</li>');
                                                   }else{actMap.put(act.segName, '<li>'+act.Name+'</li>');}
            }
        }
        if (response.getBody()!=null) {
            return  (response.getBody());}
        else{
            return null;
        }
    }

    public static string getNewLicDt(List < Records > tecomLeaseList, Date licEpy, String framework) { //

        Date dt;
        String licDt;
        try {
            if (framework != 'Freelancer') {
                List < Records > filtecomLeaseList = filterCategories(tecomLeaseList);
                system.debug('tecomLeaseList:::' + filtecomLeaseList);
                for (Records loc: filtecomLeaseList) {
                    String status;
                    Boolean PMStype = false;
                    if ((loc.LeaseType != null && loc.LeaseType.contains('PMS')) || String.isNotBlank(loc.ContractNumber)) {
                        PMStype = true;status = loc.Status;
                    }
                    //  system.debug('Inside PMStype'+PMStype);
                    if (loc.ContractStatusReason != null) status = loc.ContractStatusReason;
                    Boolean dtflg = false;
                    if (status != null && framework == 'Freelancer' && (status == 'Active' || status == 'Modification Activation' || status == 'Expansion Activation' || status == 'LA sent for Signoff' || status == 'Original Lease Activation' || status == 'Renewal Activation' || status == 'Customer sign' || status == 'Customer signed' || status == 'Tecom Sign' || status == 'Tecom Signed' || status == 'Ready for Activation' || status == 'Tecom Sign' || status == 'Tecom Signed' || status == 'Ready for Activation' || status == 'LA is signed off' || status == 'LA activated' || status == 'Signed LA received' || status.contains('Collected by BP') || status.contains('Signed by BP') || status.contains('Counter Signed') || status.contains('Ready for Activation') || status.contains('Modification In Progress') || status.contains('Renewal In Progress') || status.contains('Expansion In Progress') || status.contains('Termination in progress') || status.contains('Printed'))) {
                        dtflg = true;
                    }
                    else if (status != null && (status == 'Active' || status == 'Lease Signed' || status == 'Modification Activation' || status == 'Contraction Activation' || status == 'Contraction Activation' || status == 'LA sent for Signoff' || status == 'Expansion Activation' || status == 'Original Lease Activation' || status == 'Renewal Activation' || status == 'Customer sign' || status == 'Customer signed' ||
                                                  status == 'Tecom Sign' || status == 'Tecom Signed' || status == 'Ready for Activation' || status == 'Tecom Sign' || status == 'Tecom Signed' || status == 'Ready for Activation' || status.contains('Collected by BP') || status.contains('Signed by BP') || status == 'LA is signed off' || status == 'LA is ready to activated' || status == 'LA activated' || status == 'Signed LA received' || status.contains('Counter Signed') || status.contains('Ready for Activation') || status.contains('Modification In Progress') || status.contains('Renewal In Progress') || status.contains('Expansion In Progress') || status.contains('Termination in progress'))) {
                                                      dtflg = true;
                                                  }

                    if (PMStype && status != null && status != 'Terminated') {system.debug('Inside Pms');dtflg = true;}
                    /** && framework!='Freelancer'
else if (status != null && framework=='Freelancer' && (status=='Active' || status=='Customer sign' || status=='Customer signed'
|| status=='Tecom Sign' || status=='Tecom Signed' || status=='Ready for Activation' ||
status=='Tecom Sign' || status=='Tecom Signed' || status=='Ready for Activation' ||
status.contains('Collected by BP') || status.contains('Signed by BP') ||
status.contains('Counter Signed') || status.contains('Ready for Activation') || status=='LA is signed off' || status=='LA activated' || status=='Signed LA received'
|| status.contains('Modification In Progress') || status.contains('Renewal In Progress')
|| status.contains('Expansion In Progress') || status.contains('Termination in progress') || status.contains('Printed'))) {
dtflg=true;
}**/
                    if (loc.ContractEndDate != null && dtflg) {
                        String dxt = String.ValueOf(loc.ContractEndDate);
                        System.debug('Okd End Date JJJ' + loc.ContractEndDate);
                        String[] str = dxt.split('/');
                        // loc.ContractEndDate =
                        String ContractEndDate = str[2] + '-' + str[1] + '-' + str[0];
                        System.debug('New End Date JJJ' + ContractEndDate);
                        if (dt != null && dt < Date.valueOf(ContractEndDate)) {dt = Date.valueOf(ContractEndDate);}
                        if (dt == null) {dt = Date.valueOf(ContractEndDate);}
                    }
                }
                // system.debug('JJJ dt'+dt);

                Date tdy = Date.today();
                //Integer monthsBetween = tdy.monthsBetween(dt);
                Integer monthsBetween = licEpy.monthsBetween(dt);
                system.debug('JJJ monthsBetween' + monthsBetween);
                if (monthsBetween < 12) {
                    system.debug('JJJ 1');licDt = dt.format();
                } else {
                    licEpy = (licEpy.addYears(1));licDt = licEpy.format();
                    //licEpy=(licEpy.addDays(365)); licDt=licEpy.format();
                    // if (licEpy != null && licEpy.month()<9) {
                    //licDt =licEpy.day()+'/0'+licEpy.month()+'/'+(licEpy.year()+1);
                    //}else{licDt =licEpy.day()+'/'+licEpy.month()+'/'+(licEpy.year()+1);}
                }
            } else {
                licEpy = (licEpy.addYears(1));licDt = licEpy.format();
            }
            system.debug('JJJ licDt' + licDt);
        } catch (Exception e) {
            system.debug(e.getMessage());
        }

        return licDt;
    }

    public static String loaddccaLoc(String AccLic) {

        String jsonBody;
        Activities actrec = new Activities();
        ActivityLocations actLoc = new ActivityLocations();
        List < Locations > dccalocList;
        actLoc.LicnseNo = AccLic;
        actLoc.MethodName = 'getLocations';
        jsonBody = JSON.serialize(actLoc);

        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json'); //Acc.lc__c
        request.setEndpoint('callout:DCCA_Auth/apexrest/RnLIntegrationActLoc?licenseno=' + AccLic + '&method=getLocations');
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setBody(jsonBody);
        response = h.send(request);

        system.debug(response.getBody());
        if (response.getStatusCode() == 200) {
            ActivityLocations allAct = (ActivityLocations) JSON.deserialize(response.getBody(), ActivityLocations.class);
            //  System.debug('allAct locations'+allAct);
            /**  if (allAct.errorCode == '0') {
if (allAct.locationList != null) {dccalocList = allAct.locationList;}
if (dccalocList.size()<2)dccalocList[0].regOff=true;
}**/

        }
        if (response.getStatusCode() == 200 && response.getBody() != null) {
            return (response.getBody());
        } else {
            return null;
        }
    }

    public static List < Records > getAgreements(String agreNo) {
        List < Records > tecomRec = new List < Records > ();
        String jsonBody;
        ResponseData res = new ResponseData();
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();

        request.setEndpoint('callout:tecom_Courier/apexrest/licenserenewal/getPropertyDetails?AgNo=' + agreNo);
        //request.setEndpoint('callout:TECOM_QA/apexrest/licenserenewal/getPropertyDetails?AgNo='+agreNo);
        request.setMethod('GET');
        request.setTimeout(120000);
        response = h.send(request);
        system.debug('response.getBody()' + response.getBody());
        if (response.getStatusCode() == 200) {
            grqWsDccaGetService resLease = (grqWsDccaGetService) JSON.deserialize(response.getBody(), grqWsDccaGetService.class);
            //system.debug('JJ parse error '+(ResponseData) JSON.deserialize( response.getBody(), ResponseData.class));
            system.debug('JJJ resLease ' + resLease.ResponseData.Records);
            if (resLease.ResponseData.Records != null) {
                tecomRec = resLease.ResponseData.Records;
            }
        }
        system.debug('JJJ response  ' + tecomRec);

        return tecomRec;
    }

    public static List < Records > getD3Agreements(String agreNo) {
        List < Records > tecomRec = new List < Records > ();
        String jsonBody;
        ResponseData res = new ResponseData();
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndpoint('callout:D3_NC/apexrest/licenserenewal/getPropertyDetails?AgNo=' + agreNo);
        request.setMethod('GET');
        request.setTimeout(120000);
        response = h.send(request);
        if (response.getStatusCode() == 200) {
            grqWsDccaGetService resLease = (grqWsDccaGetService) JSON.deserialize(response.getBody(), grqWsDccaGetService.class);
            //system.debug('JJ parse error '+(ResponseData) JSON.deserialize( response.getBody(), ResponseData.class));
            //system.debug('JJJ resLease '+resLease.ResponseData.Records);
            if (resLease.ResponseData.Records != null) {
                tecomRec = resLease.ResponseData.Records;
            }
        }
        system.debug('JJJ response  ' + tecomRec);

        return tecomRec;
    }

    public static List < Records > loadTecomCRMLoc(String accParyId) {
        List < Records > tecomRec = new List < Records > ();
        String jsonBody;
        ResponseData res = new ResponseData();
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();

        request.setEndpoint('callout:tecom_Courier/apexrest/licenserenewal/getLeaseDetailsWithProducts?PartyId=' + accParyId);
        //request.setEndpoint('callout:TECOM_QA/apexrest/licenserenewal/getLeaseDetailsWithProducts?PartyId='+accParyId);
        request.setMethod('GET');
        request.setTimeout(120000);
        response = h.send(request);
        if (response.getStatusCode() == 200) {
            grqWsDccaGetService resLease = (grqWsDccaGetService) JSON.deserialize(response.getBody(), grqWsDccaGetService.class);
            //system.debug('JJ parse error '+(ResponseData) JSON.deserialize( response.getBody(), ResponseData.class));
            // system.debug('JJJ resLease '+response.getBody());
            // system.debug('JJJ resLease '+resLease.ResponseData.Records);
            if (resLease.ResponseData.Records != null) {tecomRec = resLease.ResponseData.Records;}
        }
        system.debug('JJJ response  ' + response.getBody());
        system.debug('JJJ response  ' + tecomRec);

        return tecomRec;
    }

    public static List < Records > loadD3Loc(String accParyId) {
        List < Records > d3Rec = new List < Records > ();
        String jsonBody;
        ResponseData res = new ResponseData();
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();

        request.setEndpoint('callout:D3_NC/apexrest/licenserenewal/getLeaseDetailsWithProducts?PartyId=' + accParyId);
        //request.setEndpoint('callout:CorpCRM/apexrest/licenserenewal/getLeaseDetailsWithProducts?PartyId='+accParyId);
        request.setMethod('GET');
        request.setTimeout(120000);
        response = h.send(request);
        if (response.getStatusCode() == 200) {
            grqWsDccaGetService resLease = (grqWsDccaGetService) JSON.deserialize(response.getBody(), grqWsDccaGetService.class);
            System.debug('####resLease::: ' + resLease);
            System.debug('####resLease.ResponseData::: ' + resLease.ResponseData);
            if (resLease != null && resLease.ResponseData != null && resLease.ResponseData.Records != null) {
                //d3Rec= resLease.ResponseData.Records;
                for (Records rc: resLease.ResponseData.Records) {
                    if (rc.ContractStatusReason != '' && rc.StageName != 'Cancelled' && rc.StageName != 'Renewed' && rc.StageName != 'Terminated' && rc.StageName != 'Modified')
                        d3Rec.add(rc);
                }
            }
        }
        system.debug('JJJ response.getBody()  ' + response.getBody());
        system.debug('JJJ response  ' + d3Rec);

        return d3Rec;
    }

    public static String getLicenseCopy(String AccLic) {

        String jsonBody;
        String jsonResp = '';

        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:DCCA_Auth/apexrest/getLicense?licenseNumber=' + AccLic);
        request.setMethod('GET');
        request.setTimeout(60000);
        try {
            response = h.send(request);
            if (response.getStatusCode() == 200) {
                jsonResp = response.getBody();
            }
        } catch (System.CalloutException e) {}
        return jsonResp;
    }

    public static void sendDccaLic(List < g_reqitem__c > rqItSet, map < Id, g_Req__c > reqMap, String wsTyp, String wsMd) {
        List < ws_call__c > wsList = new List < ws_call__c > ();
        List<g_Req__c>  reqDocList = new List<g_Req__c>();
        List<g_Req__c>  allreqList = new List<g_Req__c>();
        map<ID , List<g_reqDoc__c>> docListMap = new map<Id , List<g_reqDoc__c>>();
        map<ID , List<String>> docNameMap = new map<Id , List<String>>();
        //  system.debug('JJJ reqMap.keySet()'+reqMap.keySet());
        for (g_reqitem__c ri: rqItSet) {
            g_Req__c rq = reqMap.get(ri.Id);
            allreqList.add(rq);
        }
        List<g_reqDoc__c> reqDocNameList = [select Id, Name, RQ__c from g_reqDoc__c where RQ__c in:allreqList AND  Req__c=true and IsDeleted=false ];
        system.debug('JJJ reqDocNameList' +reqDocNameList);
        for (g_reqDoc__c rqDoc : reqDocNameList) {
            if (docNameMap.containsKey(rqDoc.RQ__c)) {

                List<String> strList = new  List<String> ();
                strList = docNameMap.get(rqDoc.RQ__c);
                strList.add(rqDoc.Name);
                docNameMap.put(rqDoc.RQ__c, strList);

            }else{
                docNameMap.put(rqDoc.RQ__c, new List<String> { rqDoc.Name });

            }
        }

        system.debug('JJJ docNameMap' +docNameMap);

        Integer j=1;
        for (g_reqitem__c ri: rqItSet) {

            g_Req__c rq = reqMap.get(ri.Id);
            List<String> docNameList= docNameMap.get(rq.Id);
            if (docNameList != null && docNameList.size()>0) {
                for (String Str: docNameList) {
                    grqWsDccaGetService.AttachList attList = new grqWsDccaGetService.AttachList();
                    List<grqWsDccaGetService.Attachments> attrecList = new List<grqWsDccaGetService.Attachments>();
                    grqWsDccaGetService.Attachments attrec = new grqWsDccaGetService.Attachments();
                    attrec.parentId =rq.xdei__c ;
                    attrec.Name =Str;
                    attrecList.add(attrec);
                    attList.AttachmentList = attrecList;
                    String jsonBody = JSON.serialize(attList);
                    ws_call__c ws = new ws_call__c();
                    ws.rq_jsn__c = jsonBody;
                    ws.ws_typ__c = wsTyp;
                    ws.mtd_nm__c = 'LicenseRenewalDoc';
                    ws.intsts__c = 'Ready for Integration';
                    ws.uid__c = rq.id + '' + ri.Id + '' + ri.sta__c + system.Today() +'Licdoc'+ j ;
                    j++;
                    ws.rq_itm__c = ri.id;
                    system.debug('****ri.status_type__c****'+ri.status_type__c);
                    if (ri.status_type__c=='Completed')
                        wsList.add(ws);

                }
            }
        }

        Integer i =1;
        List<g_Req__c> xrq = new List<g_Req__c>();
        for (g_reqitem__c ri: rqItSet) {
            grqWsDccaGetService.AttachList attList = new grqWsDccaGetService.AttachList();
            List<grqWsDccaGetService.Attachments> attrecList = new List<grqWsDccaGetService.Attachments>();
            grqWsDccaGetService.Attachments attrec = new grqWsDccaGetService.Attachments();
            //String jsonBody ;
            g_Req__c rq = reqMap.get(ri.Id);
            attrec.parentId =rq.xdei__c ;
            attrec.Name ='License Renewal Agreement_'+rq.Name;
            attrecList.add(attrec);
            attList.AttachmentList = attrecList;
            String jsonBody = JSON.serialize(attList);

            ws_call__c ws = new ws_call__c();
            ws.rq_jsn__c = jsonBody;
            ws.ws_typ__c = wsTyp;
            ws.mtd_nm__c = 'LicenseRenewalCopy';
            ws.intsts__c = 'Ready for Integration';
            ws.uid__c = rq.id + '' + ri.Id + '' + ri.sta__c + ''  + system.Today()+'Lic'  ;
            ws.rq_itm__c = ri.id;
            If((rq.xlicd__c == false ) ) {
                wsList.add(ws);
            }

        }

        system.debug('JJJ wsList'+wsList);

        try {
            Insert wsList;

        } catch (Exception e) { system.debug(e);}
    }

    public static string formatDt(String dt) {
        //Convert Date to DD/MM/YYYY

        String[] str = dt.split('-');
        String newDt = str[2] + '/' + str[1] + '/' + str[0];
        return newDt;
    }
    public static string formatEjariDt(String dt) {
        //Convert Date to DD/MM/YYYY
        String[] str = dt.split('/');
        String newDt = str[1] + '/' + str[0] + '/' + str[2];
        return newDt;
    }
    public static string formatDt2(String dt) {
        //Convert Date to DD-MM-YYYY
        //  if (dt != null) {
        String[] str = dt.split('/');
        String newDt = str[2] + '-' + str[1] + '-' + str[0];
        return newDt;
        //}else{
        //  return null;
        //  }

    }

    public static List < Records > filterCategories(List < Records > tecomLeaseList) {
        List < Records > tecomd3LeaseList = new List < Records > ();
        Map < String, String > hmap = new Map < String, String > ();
        hmap.put('Business Center - Executive Desk', 'Shared Desk-Type 2;Exclusive Desk;EO-Type-5;EO-Type-4;In5 Start-up Office;EO-Type-7;EO-Type-3;EO-Type-6;EO-Type-2;EO-Type-1;');
        hmap.put('Business Center - Executive Office', 'Shared Desk-Type 2;Exclusive Desk;EO-Type-5;EO-Type-4;In5 Start-up Office;EO-Type-7;EO-Type-3;EO-Type-6;EO-Type-2;EO-Type-1;');
        hmap.put('Business Center - Hot Desk', 'In5 Hot Desk;Shared Desk-Type 1;Freelancer Permit;');
        hmap.put('Shared Desk - Executive Desk', 'Share desk – Company;Share desk – Freelance;');
        hmap.put('Common Area', 'Foodcourt;Exclusive Food Court Seating Area;');
        hmap.put('Industrial', 'IMPZ-Showroom-Showroom;Showroom;Warehouse;');
        hmap.put('Office', 'Premium Fitted-out Office;Premium Furnished Office;Creative Office;Boutique Office;Boutique Studio;Lofts;Premium Office;Office;Standard Office;Courtyard Office;Office;Office-Makateb;Full Boutique C;Full Boutique B;Lofts;Boutique Office;Conference/Meeting;Premium Fitted-out Office;Office DBT in DSC;Full Boutique A;Boutique Studio;');
        hmap.put('Research and Development', 'Laboratory R&D;Laboratory;');
        hmap.put('Residential', 'Studio;');
        hmap.put('Category Name', 'Sub Category;');
        hmap.put('Retail', 'Foodcourt Outlet;Retail Outlet;Services;F&B;F&B Licensed;Bank;Entertainment-Licensed;;Speciality Retail;Retail Outlet;Restaurant/Cafe;Kiosk;Foodcourt Outlet;F&B-Hot;Food & Beverage;F&B-Licensed;ATM Machine;Bank;Entertainment-Licensed;F&B-Concept;Gym;Retail;Services;');
        hmap.put('Retail Support', 'ATM;Food Truck;Vending Machine;Foodcourt Outlet;Retail Outlet;Services;F&B;F&B Licensed;Bank;Entertainment-Licensed;;Speciality Retail;Retail Outlet;Restaurant/Cafe;Kiosk;Foodcourt Outlet;F&B-Hot;Food & Beverage;F&B-Licensed;ATM Machine;Bank;Entertainment-Licensed;F&B-Concept;Gym;Retail;Services;');
        hmap.put('Retail Outlet', 'ATM;Food Truck;Vending Machine;Foodcourt Outlet;Retail Outlet;Services;F&B;F&B Licensed;Bank;Entertainment-Licensed;;Speciality Retail;Retail Outlet;Restaurant/Cafe;Kiosk;Foodcourt Outlet;F&B-Hot;Food & Beverage;F&B-Licensed;ATM Machine;Bank;Entertainment-Licensed;F&B-Concept;Gym;Retail;Services;');
        hmap.put('Soundstages And Workshops', 'Production Office;Soundstage;Workshop;');
        hmap.put('Micro Studio - Executive Office', 'Micro Studio - Large;Micro Studio - Medium;Micro Studio - Small;');
        hmap.put('Micro Office - Executive Office', 'Micro Studio - Large;Micro Studio - Medium;Micro Studio - Small;');
        hmap.put('Micro Office - Executive Desk', 'Share desk – Company;');
        hmap.put('Private Office', 'Micro-Studio Large;Micro-Studio Medium;Micro Studio - Medium;Share desk – Company;Micro-Studio Small;In5 Office;PO-Type-2;PO-Type-3;PO-Type-4;PO-Type-5;PO-Type-6;PO-Type-7;');
        hmap.put('Executive Office', 'EO-Type-2;EO-Type-3;EO-Type-4;EO-Type-5;EO-Type-6;EO-Type-7;Micro-Studio Large;Micro-Studio Medium;Micro-Studio Small;In5 Office;');
        hmap.put('Desk', 'Shared Desk-Type 1;Shared Desk-Type 2;Exclusive Desk;In5 Desk;Hot Desk;Dedicated Desk;Virtual Desk;');
        hmap.put('In5 Incubator', 'Shared Desk-Type 1;Shared Desk-Type 2;Exclusive Desk;In5 Desk;In5 Office;');
        hmap.put('Soundstage', 'Workshop Soundstage;Production Office;Film Soundstage;');
        hmap.put('Workshop', 'Workshop;');
        hmap.put('Warehouse', 'Warehouse;High Power Warehouse;Light Industrial Unit;Standard Power Warehouse;Workshop;');
        hmap.put('Showroom', 'Showroom;Showroom-Showroom;Showroom-Warehouse;');
        hmap.put('Specialized Commercial', 'Laboratory;Premium Fitted-out Office;Premium Furnished Office;Creative Office;Boutique Office;Boutique Studio;Lofts;Premium Office;Office;Standard Office;Courtyard Office;Office;Office-Makateb;Full Boutique C;Full Boutique B;Lofts;Boutique Office;Conference/Meeting;Premium Fitted-out Office;Office DBT in DSC;Full Boutique A;Boutique Studio;');

        //hmap.put('Commercial Office', 'Office;');
        hmap.put('Commercial Office', 'Premium Fitted-out Office;Premium Furnished Office;Creative Office;Boutique Office;Boutique Studio;Lofts;Premium Office;Office;Standard Office;Courtyard Office;Office;Office-Makateb;Full Boutique C;Full Boutique B;Lofts;Boutique Office;Conference/Meeting;Premium Fitted-out Office;Office DBT in DSC;Full Boutique A;Boutique Studio;');

        for (Records r: tecomLeaseList) {
            /*if (r.PushToDDA != null && r.PushToDDA) {
tecomd3LeaseList.add(r);
}*/
            if ((hmap.get(r.Category) != null && hmap.get(r.Category).contains(r.SubCategory)) || (String.isNotBlank(r.LeaseType) && (r.LeaseType == 'Co-working' || r.LeaseType == 'Office')) || (String.isNotBlank(r.ContractNumber) && String.isNotBlank(r.LeaseType) && r.LeaseType == 'Ejari')) {
                tecomd3LeaseList.add(r);
            }
        }

        return tecomd3LeaseList;
        //   return tecomLeaseList;

    }

    public static List < Units > filterCategoriesForUnits(List < Units > unitList) {
        List < Units > newUnitList = new List < Units > ();
        Map < String, String > hmap = new Map < String, String > ();
        hmap.put('Business Center - Executive Desk', 'Shared Desk-Type 2;Exclusive Desk;EO-Type-5;EO-Type-4;In5 Start-up Office;EO-Type-7;EO-Type-3;EO-Type-6;EO-Type-2;EO-Type-1;');
        hmap.put('Business Center - Executive Office', 'Shared Desk-Type 2;Exclusive Desk;EO-Type-5;EO-Type-4;In5 Start-up Office;EO-Type-7;EO-Type-3;EO-Type-6;EO-Type-2;EO-Type-1;');
        hmap.put('Business Center - Hot Desk', 'In5 Hot Desk;Shared Desk-Type 1;Freelancer Permit;');
        hmap.put('Shared Desk - Executive Desk', 'Share desk – Company;Share desk – Freelance;');
        hmap.put('Common Area', 'Foodcourt;Exclusive Food Court Seating Area;');
        hmap.put('Industrial', 'IMPZ-Showroom-Showroom;Showroom;Warehouse;');
        hmap.put('Office', 'Premium Fitted-out Office;Premium Furnished Office;Creative Office;Boutique Office;Boutique Studio;Lofts;Premium Office;Office;Standard Office;Courtyard Office;Office;Office-Makateb;Full Boutique C;Full Boutique B;Lofts;Boutique Office;Conference/Meeting;Premium Fitted-out Office;Office DBT in DSC;Full Boutique A;Boutique Studio;');
        hmap.put('Research and Development', 'Laboratory R&D;Laboratory;');
        hmap.put('Residential', 'Studio;');
        hmap.put('Category Name', 'Sub Category;');
        hmap.put('Retail', 'Foodcourt Outlet;Retail Outlet;Services;F&B;F&B Licensed;Bank;Entertainment-Licensed;;Speciality Retail;Retail Outlet;Restaurant/Cafe;Kiosk;Foodcourt Outlet;F&B-Hot;Food & Beverage;F&B-Licensed;ATM Machine;Bank;Entertainment-Licensed;F&B-Concept;Gym;Retail;Services;');
        hmap.put('Retail Support', 'ATM;Food Truck;Vending Machine;Foodcourt Outlet;Retail Outlet;Services;F&B;F&B Licensed;Bank;Entertainment-Licensed;;Speciality Retail;Retail Outlet;Restaurant/Cafe;Kiosk;Foodcourt Outlet;F&B-Hot;Food & Beverage;F&B-Licensed;ATM Machine;Bank;Entertainment-Licensed;F&B-Concept;Gym;Retail;Services;');
        hmap.put('Retail Outlet', 'ATM;Food Truck;Vending Machine;Foodcourt Outlet;Retail Outlet;Services;F&B;F&B Licensed;Bank;Entertainment-Licensed;;Speciality Retail;Retail Outlet;Restaurant/Cafe;Kiosk;Foodcourt Outlet;F&B-Hot;Food & Beverage;F&B-Licensed;ATM Machine;Bank;Entertainment-Licensed;F&B-Concept;Gym;Retail;Services;');
        hmap.put('Soundstages And Workshops', 'Production Office;Soundstage;Workshop;');
        hmap.put('Micro Studio - Executive Office', 'Micro Studio - Large;Micro Studio - Medium;Micro Studio - Small;');
        hmap.put('Micro Office - Executive Office', 'Micro Studio - Large;Micro Studio - Medium;Micro Studio - Small;');
        hmap.put('Micro Office - Executive Desk', 'Share desk – Company;');
        hmap.put('Private Office', 'Micro-Studio Large;Share desk – Company;Micro-Studio Medium;Micro Studio - Medium;Micro-Studio Small;In5 Office;PO-Type-2;PO-Type-3;PO-Type-4;PO-Type-5;PO-Type-6;PO-Type-7;');
        hmap.put('Executive Office', 'EO-Type-2;EO-Type-3;EO-Type-4;EO-Type-5;EO-Type-6;EO-Type-7;Micro-Studio Large;Micro-Studio Medium;Micro-Studio Small;In5 Office;');
        hmap.put('Desk', 'Shared Desk-Type 1;Shared Desk-Type 2;Exclusive Desk;In5 Desk;Hot Desk;Dedicated Desk;Virtual Desk;');
        hmap.put('Soundstage', 'Workshop Soundstage;Production Office;Film Soundstage;');
        hmap.put('Workshop', 'Workshop;');
        hmap.put('Warehouse', 'Warehouse;High Power Warehouse;Light Industrial Unit;Standard Power Warehouse;Workshop;');
        hmap.put('Showroom', 'Showroom;Showroom-Showroom;Showroom-Warehouse;');
        hmap.put('Commercial Office', 'Premium Fitted-out Office;Premium Furnished Office;Creative Office;Boutique Office;Boutique Studio;Lofts;Premium Office;Office;Standard Office;Courtyard Office;Office;Office-Makateb;Full Boutique C;Full Boutique B;Lofts;Boutique Office;Conference/Meeting;Premium Fitted-out Office;Office DBT in DSC;Full Boutique A;Boutique Studio;');
        hmap.put('Specialized Commercial', 'Laboratory;Premium Fitted-out Office;Premium Furnished Office;Creative Office;Boutique Office;Boutique Studio;Lofts;Premium Office;Office;Standard Office;Courtyard Office;Office;Office-Makateb;Full Boutique C;Full Boutique B;Lofts;Boutique Office;Conference/Meeting;Premium Fitted-out Office;Office DBT in DSC;Full Boutique A;Boutique Studio;');
        hmap.put('In5 Incubator', 'Shared Desk-Type 1;Shared Desk-Type 2;Exclusive Desk;In5 Desk;In5 Office;');

        for (Units un: unitList) {
            if ((hmap.get(un.Category) != null && hmap.get(un.Category).contains(un.SubCategory)) || un.SendToDCCA == 'true') {
                newUnitList.add(un);
            }
        }

        return newUnitList;

    }

    //argUnitMap.put(rec.AgNo, new List<grqWsDccaGetService.Units>{un});
    //
    //

    public static Map < string, List < grqWsDccaGetService.Units >> remapUnitsAgr(Map < string, List < Units >> argUnitMap) {
        map < String, string > premiseEnglish = new map < String, string > ();
        map < String, string > premiseArab = new map < String, string > ();
        map < String, units > newArgUnit = new map < String, units > ();
        Map < string, List < Units >> NewargUnitMap = new Map < string, List < Units >> ();

        for (String arg: argUnitMap.keyset()) {
            List < Units > unList = new List < Units > ();
            unList = argUnitMap.get(arg);
            boolean flag = false;
            for (Units un: unList) {
                string Key = un.FloorEnglish + un.BuildingName + un.BusinessPark;
                if (premiseEnglish.containsKey(Key)) {
                    string premEg = premiseEnglish.get(Key);
                    string premArb = premiseArab.get(Key);
                    if (un.UnitNoEnglish != null && String.isNotBlank(un.UnitNoEnglish))
                        premEg = premEg + ', ' + un.UnitNoEnglish;
                    if (un.UnitNoArabic != null && String.isNotBlank(un.UnitNoArabic))
                        premArb = premArb + ', ' + un.UnitNoArabic;

                    premiseEnglish.put(Key, premEg);
                    premiseArab.put(Key, premArb);
                } else {

                    if (un != null && un.UnitNoEnglish != null) {
                        premiseEnglish.put(Key, un.UnitNoEnglish);
                    }
                    if (un != null && un.UnitNoArabic != null) {
                        premiseArab.put(Key, un.UnitNoArabic);
                    }
                }
            }
        }
        //system.debug('******premiseEnglish****'+premiseEnglish);
        // system.debug('******premiseArab****'+premiseArab);
        if (premiseEnglish != null) {
            for (String str: premiseEnglish.keyset()) {
                String newstr = premiseEnglish.get(str);
                String sortStr;
                if (String.isNotBlank(newstr)) {
                    sortStr = grqWsDccaGetService.sortPermises(newstr, ', ');
                    premiseEnglish.put(str, sortStr);
                }

            }

        }

        if (premiseArab != null) {
            for (String str: premiseArab.keyset()) {
                String newstr = premiseArab.get(str);
                String sortStr;
                if (String.isNotBlank(newstr)) {
                    sortStr = grqWsDccaGetService.sortPermises(newstr, ', ');
                    premiseArab.put(str, sortStr);
                }

            }

        }
        //system.debug('******premiseEnglish****'+premiseEnglish);
        //  system.debug('******premiseArab****'+premiseArab);

        map < String, String > argKey = new map < String, String > ();
        Set < String > uniKey = new Set < String > ();

        List < Units > unitsList = new List < Units > ();
        for (String arg: argUnitMap.keyset()) {
            List < Units > unList = new List < Units > ();
            unList = argUnitMap.get(arg);
            // system.debug('******unList****'+unList);
            for (Units un: unList) {
                string Key = un.FloorEnglish + un.BuildingName + un.BusinessPark;

                if (!(newArgUnit.containsKey(arg) && uniKey.contains(key))) {
                    newArgUnit.put(key, un);
                    argKey.put(key, arg);
                    uniKey.add(key);
                }

                // system.debug('******argKey.put(key, arg)****'+argKey);
            }

        }

        // system.debug('******argUnitMap from 1st helper****'+argUnitMap);
        // system.debug('**********newArgUnit.size()*******'+newArgUnit.size());
        Set < String > uniqKey = new Set < String > ();
        List < Units > finalList = new List < Units > ();

        for (String arg: argUnitMap.keyset()) {
            List < Units > unList = new List < Units > ();
            unList = argUnitMap.get(arg);
            for (Units un1: unList) {
                string Key = un1.FloorEnglish + un1.BuildingName + un1.BusinessPark;
                if (!uniqKey.contains(Key)) {
                    // system.debug('**********uniqKey*******'+uniqKey);
                    uniqKey.add(key);
                    Units un = new Units();
                    un = newArgUnit.get(Key);
                    if (un != null && premiseEnglish != null && premiseEnglish.containsKey(Key) && premiseEnglish.get(Key) != null) {
                        un.UnitNoEnglish = String.ValueOf(premiseEnglish.get(Key));
                        //   system.debug('premiseEnglish.get(Key)'+premiseEnglish.get(Key));
                    }
                    if (un != null && premiseArab != null && premiseArab.containsKey(Key) && premiseArab.get(Key) != null) {
                        un.UnitNoArabic = String.ValueOf(premiseArab.get(Key));
                        // system.debug('premiseArab.get(Key)'+premiseArab.get(Key));

                    }
                    finalList.add(un);
                }
            }
            // system.debug('**********finalList*******'+finalList);
            // system.debug('**********arg*******'+arg);
            NewargUnitMap.put(arg, finalList);
        }

        Set < Units > finalListSet = new Set < Units > ();

        system.debug('******NewargUnitMap from helper****' + NewargUnitMap);

        return NewargUnitMap;
    }

    public static string getEnglishBU( String bu) {
        String newBU ;

        if (bu.toUpperCase() == 'D3' ) {newBU ='Dubai Design District'; }
        else if (bu.toUpperCase() == 'DHC' ) {newBU='Dubai Healthcare City';}
        else if (bu.toUpperCase() == 'DIAC' ) {newBU='Dubai International Academic City';}
        else if (bu.toUpperCase() == 'DKP' ) {newBU='Dubai Knowledge Park';}
        else if (bu.toUpperCase() == 'DIC' ) {newBU='Dubai Internet City';}
        else if (bu.toUpperCase() == 'DOC' ) {newBU='Dubai Outsource City';}
        else if (bu.toUpperCase() == 'DMC' ) {newBU='Dubai Media City';}
        else if (bu.toUpperCase() == 'DSC' ) {newBU='Dubai Studio City';}
        else if (bu.toUpperCase() == 'DPC' ) {newBU='Dubai Production City';}
        else if (bu.toUpperCase() == 'DSP' ) {newBU='Dubai Science Park';}

        return newBU;
    }

    public static string getArabicBU( String bu) {
        String newBU ;

        if (bu.toUpperCase() == 'D3'  ) {newBU ='حي دبي للتصميم'; }
        else if (bu.toUpperCase() == 'DHC' ) {newBU='مدينة دبي الطبية';}
        else if (bu.toUpperCase() == 'DIAC' ) {newBU='مدينة دبي الأكاديمية العالمية';}
        else if (bu.toUpperCase() == 'DKP' ) {newBU='مجمع دبي للمعرفة';}
        else if (bu.toUpperCase() == 'DIC' ) {newBU='مدينة دبي للإنترنت';}
        else if (bu.toUpperCase() == 'DOC' ) {newBU='مدينة دبي للتعهيد';}
        else if (bu.toUpperCase() == 'DMC' ) {newBU='مدينة دبي للإعلام';}
        else if (bu.toUpperCase() == 'DSC' ) {newBU='مدينة دبي للإستديوهات';}
        else if (bu.toUpperCase() == 'DPC' ) {newBU='مدينة دبي للإنتاج';}
        else if (bu.toUpperCase() == 'DSP' ) {newBU='مجمع دبي للعلوم';}
        return newBU;
    }
    public static string convertNumToAr(String alphanum) {
        /**   alphanum=alphanum.replace('0', '?');
alphanum=alphanum.replace('1', '?');
alphanum=alphanum.replace('2', '?');
alphanum=alphanum.replace('3', '?');
alphanum=alphanum.replace('4', '?');
alphanum=alphanum.replace('5', '?');
alphanum=alphanum.replace('6', '?');
alphanum=alphanum.replace('7', '?');
alphanum=alphanum.replace('8', '?');
alphanum=alphanum.replace('9', '?');**/
        return alphanum;

    }

    public static string sortPermises(String perm, String splt) {
        string newpremVal;
        List < String > sortStr = perm.split(splt);
        sortStr.sort();
        for (string str: sortStr) {
            if (string.isBlank(newpremVal)) {
                newpremVal = str;
            } else {
                newpremVal = newpremVal + splt + str;
            }
        }

        return newpremVal;
    }

    public  static string convertDateArabic(date dt , string st) {
        //system.debug(grqWsDccaGetService.convertDateArabic(Date.ValueOf('12/03/2018'), '1'));
        //st = 1 to add 1 day to the Date
        //st = 2 to add 1 year to date
        //st = 0 to send date in arabic
        //Date dt ;
        string arbmonth;
        string arbyear;
        string arbday;
        String arbdt;
        if (dt != null) {
            //  dt=Date.parse(d);
            dt= dt.addDays(integer.ValueOf(st));

            switch on dt.month() {
                when 1 { arbmonth ='?????';}
                when 2 {arbmonth ='??????';}
                when 3 {arbmonth ='????';}
                when 4 {arbmonth ='?????';}
                when 5 {arbmonth ='????';}
                when 6 {arbmonth ='?????';}
                when 7 {arbmonth ='?????';}
                when 8 {arbmonth ='?????';}
                when 9 {arbmonth ='??????';}
                when 10 {arbmonth ='??????';}
                when 11 {arbmonth ='??????';}
                when 12 {arbmonth ='??????';}
            }
            //if (st=='1') {arbday =grqWsDccaGetService.convertNumToAr(String.ValueOf(dt.day()+1));}else{arbday = grqWsDccaGetService.convertNumToAr(String.ValueOf(dt.day()));}
            // if (st=='2') {arbyear = grqWsDccaGetService.convertNumToAr(String.ValueOf(dt.year()+1));}else{ arbyear = grqWsDccaGetService.convertNumToAr(String.ValueOf(dt.year()));}
            arbday =grqWsDccaGetService.convertNumToAr(String.ValueOf(dt.day()));
            arbyear = grqWsDccaGetService.convertNumToAr(String.ValueOf(dt.year()));
            arbdt = arbday+' '+arbmonth+' '+arbyear;
            //+' '++' '+;

        }
        return arbdt;
    }

    public  static void crtdoc(List<String> docName) {

        List<g_srvcitm_Doc__c> lstsrvDoc = new List<g_srvcitm_Doc__c>();

        List<g_srvcitm_Doc__c> newlstsrvDoc = new List<g_srvcitm_Doc__c>();
        map<String, String> newmap = new map<String, String>();

        List<g_srvcitm__c> lstsrvItm =[Select Id from g_srvcitm__c where cd__c=:'dr' and srvc__r.uid__c=:'208' limit 1];
        system.debug('lstsrvItm----'+lstsrvItm);

        lstsrvDoc = [select id, Name, lbl__c, Tp__c, itm__c, CurrencyIsoCode, Att_Type__c, reqAts__c, mnAts__c, mxAts__c from g_srvcitm_Doc__c where itm__r.id=: lstsrvItm[0].id];
        system.debug('lstsrvDoc---'+lstsrvDoc);

        for (g_srvcitm_Doc__c strdoc :lstsrvDoc) {
            newmap.put(strdoc.Name, strdoc.Name);
        }

        for (string str: docName) {
            if (!(newmap.containsKey(str))) {
                g_srvcitm_Doc__c srdoc = new g_srvcitm_Doc__c();
                srdoc.Name = str;
                srdoc.lbl__c = str;
                srdoc.Tp__c ='DDA License Docs' ;
                srdoc.itm__c = lstsrvItm[0].id;
                //srdoc.CurrencyIsoCode ='AED - UAE Dirham' ;
                srdoc.Att_Type__c ='JPEG' ;
                srdoc.reqAts__c = true ;
                srdoc.mnAts__c = 1;
                srdoc.mxAts__c = 1;
                newlstsrvDoc.add(srdoc);
            }
        }

        if (newlstsrvDoc != null && newlstsrvDoc.size()>0) {Insert newlstsrvDoc; system.debug('newlstsrvDoc'+newlstsrvDoc);}
    }

    public static String generateDDADoc(String rid, String dName) {
        String jsonBody;
        String jsonResp = '';
        String licCopy = '';
        String rgen = '';
        g_Req__c req = null;
        if (apexpages.currentpage() != null) rgen = apexpages.currentpage().getparameters().get('rg');
        //rgen = 'Y';
        DData dt = new DData();
        dt.documentName = dName.trim()=='AOADOC'?'AOA':dName.trim();
        Document dc = new Document();

        dc.Method = 'GetDocument';
        dc.data = dt;
        dc.pdf = true;
        system.debug(rid+'==dName=='+dName);
        if (dName == 'Freelancer Permit' || dName == 'Commercial License' || dName == 'License' || dName == 'COI'|| dName == 'COBR' || dName == 'ROD' || dName =='Register of Secretary'|| dName =='Register of Directors' || dName =='NameChangeCertificate') {
            dc.LicenseNumber = rid;
            if (dName == 'Freelancer Permit' || dName == 'Commercial License') {
                rgen = 'N';
            }
            else{
                List < g_Req__c > lst = [select id, xfpc__c, xfpdd__c, xlicd__c from g_Req__c where acc__r.lc__c =: rid and srvc__r.uid__c = '208'
                                         and xfpdd__c != null order by createddate desc limit 1
                                        ];
                if (lst != null && !lst.isEmpty()) {
                    req = lst[0];
                    date dt0 = date.newInstance(2021, 4, 3);
                    Datetime dt1 = Datetime.now();
                    Datetime dt2 = (req.xfpc__c).addMinutes(10);
                    if (string.isBlank(rgen) && req.xlicd__c == false && req.xfpdd__c > dt0 && dt2 < dt1) {
                        rgen = 'Y';
                    }
                }
            }
        }
        else if (dName == 'AOA'  || dName == 'Resolution') {
            dc.serviceRequestId = rid;
        }else if (dName == 'AOADOC' ) {
            dt.documentName='AOA';
            dc.serviceRequestId = rid;
            dc.pdf = false;
        }
        if (String.isNotBlank(rgen) && rgen == 'Y') /*doc.documentName=='Freelancer Permit' || doc.documentName=='Commercial License'*/ dc.Regenerate = 'false';
        if (String.isNotBlank(rgen) && rgen == 'N') dc.Regenerate = 'false';
        system.debug(rgen+'==Regenerate=='+dc.Regenerate);
        dc.Regenerate = 'false';
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setEndpoint('callout:DCCA_Auth/apexrest/LicenseService');
        system.debug('json body get doc::'+JSON.serialize(dc));
        request.setMethod('POST');
        request.setBody(JSON.serialize(dc));
        request.setTimeout(60000);
        try {
            response = h.send(request);
            if (response.getStatusCode() == 200) {
                jsonResp = response.getBody();
                System.debug('###<getDocument> jsonResp: ' + jsonResp);
                grqWsDccaGetService.Document data = (grqWsDccaGetService.Document) JSON.deserialize(jsonResp, grqWsDccaGetService.Document.class);
                if (data != null && data.Data != null) {
                    if (data.Data.body != null) {
                        licCopy = data.Data.body;
                    } /*MS 1.1*/ /*else if (String.isNotBlank(rgen) && rgen == 'Y') {
                        String enLic = gu.DED_Encrypt(rid);
                        system.debug('lc :::' + rid);
                        system.debug('enLic :::' + enLic);
                        PDFGeneratorWS.PDFGeneratorWSSoap pdfWS = new PDFGeneratorWS.PDFGeneratorWSSoap();
                        String GenPDFPath;
                        string pdfURL;

                        if (!Test.isRunningTest()) {
                            if (dName == 'AOA') {
                                GENPDFPATH = PDFWS.GenerateAOAPDF(data.Data.aoaParams, data.Data.docConfig);
                            }else if (dName == 'AOADOC') {
                                GENPDFPATH = PDFWS.GenerateAoADoc(data.Data.aoaParams, data.Data.docConfig);
                            }
                            else if (dName == 'Resolution') {
                                GENPDFPATH = PDFWS.GenerateResolutionPDF(data.Data.resolution, data.Data.docConfig);
                            }
                            else{
                                data.Data.pdfParams.QRCode = getDataUriFromUri(System.Label.AXSValidateURL + enLic);
                                GENPDFPATH = PDFWS.GenerateLicensePDF(data.Data.pdfParams, data.Data.docConfig);
                            }

                        }

                        System.debug('GENPDFPATH' + GenPDFPath);
                        pdfURL = System.Label.PDF_Web_Service_URL + GenPDFPath;
                        Integer count = 1;
                        Blob pdfblob = null;
                        do {
                            Http hpdf = new Http();
                            HttpRequest reqpdf = new HttpRequest();
                            reqpdf.setEndpoint('callout:DCCA_PDF_API');
                            reqpdf.setMethod('GET');
                            reqpdf.setHeader('Content-Type', 'image/jpeg');
                            reqpdf.setCompressed(true);
                            reqpdf.setTimeout(120000);
                            HttpResponse respdf = null;
                            respdf = hpdf.send(reqpdf);
                            pdfblob = respdf.getBodyAsBlob();
                            if (pdfblob != null) count++;
                        } List<SObject> bulkDml2 = new List<SObject>(); while (count < 12);
                        licCopy = EncodingUtil.base64Encode(pdfblob);
                        if (req != null) {
                            req.xlicd__c = true;
                            bulkDml2.add(req);
                        } if (!bulkDml2.isEmpty()) { update bulkDml2; }
                        if (dName == 'AOADOC') {licCopy=pdfURL;}
                        System.debug('licCopy' + licCopy);
                    }*/
                }
                /*if (String.isNotBlank(rgen) && rgen == 'Y') {
                    String rqid = apexpages.currentpage().getparameters().get('rid');
                    Attachment att = new Attachment();
                    att.name = rqid + '_' + dName + '.pdf';
                    att.Body = EncodingUtil.base64Decode(licCopy);
                    att.ParentId = rqid;
                    if (Schema.sObjectType.Attachment.isCreateable()) {
                        insert att;
                    }
                }
                */
            }
        } catch (System.CalloutException e) {
            System.debug('###<getDocument> Exception: ' + e.getMessage() + '  ###ExpStack: ' + e.getStackTraceString());
        }
        System.debug('###<getDocument> licCopy: ' + licCopy);
        return licCopy;
    }
    public static String getDocument(String rqNo, String dName) {
        String licCopy = '';
        licCopy = generateDDADoc(rqNo, dName);
        return licCopy;
    }

    public static List < Pending_Inv__c > getPMSInvList(String accId) {
        List < Pending_Inv__c > invLst = [select id, amt__c, invyr__c, inv_duedt__c, agno__c from Pending_Inv__c where acc__c =: accId and status__c = 'Unpaid'
                                          and act__c = true
                                         ];
        return invLst;
    }
    public static String getDataUriFromUri(String url) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:grqWsDccaGetService_API');
        req.setMethod('GET');
        Http binding = new Http();
        HttpResponse res = binding.send(req);
        Blob image = res.getBodyAsBlob();
        return EncodingUtil.base64Encode(image);
    }

    public class Document{
        public String LicenseNumber {get;set;}
        public String serviceRequestId {get;set;}
        public String Method {get;set;}
        public String Regenerate {get;set;}
        public DData Data {get;set;}
        public Boolean pdf {get;set;}
    }
    public class DData{
        public String documentName {get;set;}
        public String body {get;set;}
        public PDFGeneratorWS.LIC_Parameters pdfParams; /* PDFGeneratorWS.LIC_Parameters */
        public PDFGeneratorWS.DocumentConfig docConfig;
        public PDFGeneratorWS.AOA_PDF_Params aoaParams;
        public PDFGeneratorWS.Resoulution_PDF_Param resolution;
    }
    public class ContractInfo {
        public string contractNo {set;get;}
        public string buildingName {set;get;}
        public string businessPark {set;get;}
        public date contractStartdate {set;get;}
        public date contractEnddate {set;get;}
        public string unitNo {set;get;}
        public string floor {set;get;}
        public string status {set;get;}
        public String contractType {set;get;}
        public string businessUnit {set;get;}
        public string unitNoArb {set;get;}
        public string floorArb {set;get;}
        public string buildingnameArb {set;get;}
        public string businessUnitArb {set;get;}
        public decimal totalArea {set;get;}
    }

    public class PMSLeaseInfo {
        public List<ContractInfo> contracts {set;get;}

    }

}