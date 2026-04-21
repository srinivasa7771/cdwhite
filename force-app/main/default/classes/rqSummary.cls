public class rqSummary {

    public g_Req__c req{get;set;}
    public REQWrapper adhoc4Data { set; get;}
    public  map<String, Decimal> mapLeaseInfo  {set; get;}
    public list<SegWrapper> adhoc2Data {set;get;}
    public rqSummary() {
        String rqid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));
        if (rqid != null)
            req = [Select Id, acc__r.name, xcfn__c, parCat__c, xcmn__c, xcln__c, xfb__c, xcpic__c,
                xadtx5__c, xadtx4__c, xadtx2__c, xuvdet__c, xvtyp__c, Acc__r.clt__c, xccn__c, rtacn__c,
                License_Authority__c from g_req__c where Id =: rqid];
        if (req != null) {
            adhoc4Data = (REQWrapper) JSON.deserialize(req.xadtx4__c, REQWrapper.class);
           // adhoc2Data = (SegWrapper) JSON.deserialize(req.xadtx2__c, SegWrapper.class);
           adhoc2Data =  (List<SegWrapper>)System.JSON.deserialize(req.xadtx2__c, List<SegWrapper>.class);
            system.debug('adhoc2==='+adhoc2Data);
        }
         mapLeaseInfo = new map<String, Decimal>();
        mapLeaseInfo.put('Size required', null);
        mapLeaseInfo.put('Connected Power Load Required', null);
        mapLeaseInfo.put('Anticipated amount of water for your industry', 0);
        mapLeaseInfo.put('Estimated BUA DM range (35-50%)', null);
        if (String.isNotBlank(req.xadtx5__c) && req.parCat__c != null && req.parCat__c == 'Land') {
            list < Object > lstLandInfo = (list < Object > ) JSON.deserializeUntyped(req.xadtx5__c);
            for (object landinfo: lstLandInfo) {
                map < String, object > maplandInfo = (map < String, object > ) landinfo;
                system.debug('strInfo===' + maplandInfo.get('type'));

                map < String, object > mapinfo = (map < String, object > ) maplandInfo.get('info');
                for (String strInfo: mapinfo.keySet()) {
                    system.debug('strInfo===' + strInfo + '=====val===' + mapinfo.get(strInfo));
                    if (strInfo == 'Size required') {
                        mapLeaseInfo.put('Size required', Decimal.valueOf(Integer.valueof(mapinfo.get(strInfo))));
                    } else if (strInfo == 'Connected Power Load Required') {
                        mapLeaseInfo.put('Connected Power Load Required', Decimal.valueOf(Integer.valueof(mapinfo.get(strInfo))));
                    } else if (strInfo == 'Anticipated amount of water for your industry') {
                        mapLeaseInfo.put('Anticipated amount of water for your industry',
                            (mapinfo.ContainsKey(strInfo) && mapinfo.get(strInfo) != null && mapinfo.get(strInfo) != '') ? Decimal.valueOf((String) mapinfo.get(strInfo)) : null);

                    } else if (strInfo == 'Estimated BUA DM range (35-50%)') {
                        mapLeaseInfo.put('Estimated BUA DM range (35-50%)', Integer.valueOf(mapinfo.get(strInfo)));
                    }
                }
            }
        }
        system.debug('mapLeaseInfo==='+mapLeaseInfo);
    }

public class REQWrapper{
    public String workorders {
        set;
        get;
    }
    public String usrName {
        set;
        get;
    }
    public String tdLcStdt {
        set;
        get;
    }
    public String tdLcEddt {
        set;
        get;
    }
    public String taxRgNo {
        set;
        get;
    }
    public String SubCategory {
        set;
        get;
    }
    public String StageName {
        set;
        get;
    }
    public String skipLeaseValidations{
        set;
        get;
    }
    public String shareHoldersType{
        set;
        get;
    }
    public cls_shareDetails shareDetails{
        set;
        get;
    }
    public string shareCapital{
        set;
        get;
    }
    public string secofceml{
        set;
        get;
    }
    public string secMobile{
        set;
        get;
    }
    public string seccode{
        set;
        get;
    }
    public string scWorkid{
        set;
        get;
    }
    public string respMsg{
        set;
        get;
    }
    public string requestid{
        set;
        get;
    }
    public string quotes{
        set;
        get;
    }
    public string proposedLegalForm{
        set;
        get;
    }
    public string profceml{
        set;
        get;
    }
    public string Products{
        set;
        get;
    }
    public string productName{
        set;
        get;
    }
    public string productCategory{
        set;
        get;
    }
    public string prmPhone{
        set;
        get;
    }
    public string prMobile{
        set;
        get;
    }
    public string prmMobile{
        set;
        get;
    }
    public string prmLastName{
        set;
        get;
    }
    public string prmFirstName{
        set;
        get;
    }
    public string prmEmail{
        set;
        get;
    }
    public string prmccode{
        set;
        get;
    }
    public string pcRegNo{
        set;
        get;
    }
    public string pcDOI{
        set;
        get;
    }
    public string paymentSchedules{
        set;
        get;
    }
    public string parentCompany{
        set;
        get;
    }
    public string oppId{
        set;
        get;
    }
    public string onbReqid{
        set;
        get;
    }
    public string ofcPhone{
        set;
        get;
    }
    public string ofcEmail{
        set;
        get;
    }
    public string ofcCountry{
        set;
        get;
    }
    public string ofcAddress{
        set;
        get;
    }
    public String iAuthority{
        set;
        get;
    }
    public String address{
        set;
        get;
    }
    public string noofShares{
        set;
        get;
    }
    public string nationality{
        set;
        get;
    }
    public string nameResWorkid{
        set;
        get;
    }
    public list<cls_members> members{
        set;
        get;
    }
    public string licenseType{
        set;
        get;
    }
    public string lcExpdate{
        set;
        get;
    }
    public string issuingAuthority{
        set;
        get;
    }
    public String isSuccess{
        set;
        get;
    }
    public String Invoices{
        set;
        get;
    }
    public String hseWorkid{
        set;
        get;
    }
    public String gvtRlsWorkId{
        set;
        get;
    }
    public String fullNameAr{
        set;
        get;
    }
    public String fullName{
        set;
        get;
    }
    public String documents{
        set;
        get;
    }
    public String dedLicense{
        set;
        get;
    }
    public String dedLeaseType{
        set;
        get;
    }
    public String dedCompanyName{
        set;
        get;
    }
    public String dedActivities{
        set;
        get;
    }
    public String DDAReqNo{
        set;
        get;
    }
    public String currentpgid{
        set;
        get;
    }
    public String crmOppId{
        set;
        get;
    }
    public String crmAccName{
        set;
        get;
    }
    public String crmAccId{
        set;
        get;
    }
    public String countryOfIncorp{
        set;
        get;
    }
    public String ContractStatusReason{
        set;
        get;
    }
    public String ContractStatus{
        set;
        get;
    }
    public String ContractStartDate{
        set;
        get;
    }
    public String ContractEndDate{
        set;
        get;
    }
    public String conEmail{
        set;
        get;
    }
    public String compName{
        set;
        get;
    }
    public String Category{
        set;
        get;
    }
    public String caseid{
        set;
        get;
    }
    public String BusinessPark{
        set;
        get;
    }
    public String businessName3{
        set;
        get;
    }
    public String businessName2{
        set;
        get;
    }
    public String businessName1{
        set;
        get;
    }
    public String brandWorkid{
        set;
        get;
    }
    public String AgNo{
        set;
        get;
    }
    public String addstreet{
        set;
        get;
    }
    public String addState{
        set;
        get;
    }
    public String addPO{
        set;
        get;
    }
    public String adcity{
        set;
        get;
    }
    public String actvities{
        set;
        get;
    }
    public String accStatus{
        set;
        get;
    }
    public String accDesc{
        set;
        get;
    }
}
public class cls_shareDetails {
    public Integer totalShares{
        set;
        get;
    }
    public Integer shareValue{
        set;
        get;
    }
}
public class cls_members {
    public String website{
        set;
        get;
    }
    public String visitedUAE{
        set;
        get;
    }
    public String uboType{
        set;
        get;
    }
    public String uboRelatedTo{
        set;
        get;
    }
    public String uboOwnedbyUAE{
        set;
        get;
    }
    public String uboDeclaration{
        set;
        get;
    }
    public String street{
        set;
        get;
    }
    public String stockExchangeListed{
        set;
        get;
    }
    public list<cls_sourceOfwealth> sourceOfwealth{
        set;
        get;
    }
    public String sh{
        set;
        get;
    }
    public String security{
        set;
        get;
    }
    public String salutation{
        set;
        get;
    }
    public String rRegNum{
        set;
        get;
    }
    public String rpNo{
        set;
        get;
    }
    public String rpExpDate{
        set;
        get;
    }
    public String role{
        set;
        get;
    }
    public String postalCode{
        set;
        get;
    }
    public String placeissued{
        set;
        get;
    }
    public String placeborn{
        set;
        get;
    }
    public String pIssuedDate{
        set;
        get;
    }
    public String phoneno{
        set;
        get;
    }
    public String pExpDate{
        set;
        get;
    }
    public String pepRelated{
        set;
        get;
    }
    public String pepCountry{
        set;
        get;
    }
    public String pepCloselyRelatedOthers{
        set;
        get;
    }
    public String pepCloselyAssociatedOthers{
        set;
        get;
    }
    public String pepAssociation{
        set;
        get;
    }
    public String passportNo{
        set;
        get;
    }
    public String passportId{
        set;
        get;
    }
    public String nationality{
        set;
        get;
    }
    public String mobile{
        set;
        get;
    }
    public String mname{
        set;
        get;
    }
    public String mailingStreet{
        set;
        get;
    }
    public String mailingPostalCode{
        set;
        get;
    }
    public String mailingCountry{
        set;
        get;
    }
    public String mailingCity{
        set;
        get;
    }
    public String lnameAr{
        set;
        get;
    }
    public String lname{
        set;
        get;
    }
    public String legals{
        set;
        get;
    }
    public String isParentComp{
        set;
        get;
    }
    public String inUAE{
        set;
        get;
    }
    public String gender{
        set;
        get;
    }
    public String fullName{
        set;
        get;
    }
    public String fnameAr{
        set;
        get;
    }
    public String fname{
        set;
        get;
    }
    public String fda{
        set;
        get;
    }
    public String emiratesIdIssueDate{
        set;
        get;
    }
    public String emirate{
        set;
        get;
    }
    public String email{
        set;
        get;
    }
    public String eidExp{
        set;
        get;
    }
    public String eid{
        set;
        get;
    }
    public String eExpDate{
        set;
        get;
    }
    public String dob{
        set;
        get;
    }
    public String ctgCode1{
        set;
        get;
    }
    public String ctgCode{
        set;
        get;
    }
    public String ctg{
        set;
        get;
    }
    public String cshType{
        set;
        get;
    }
    public String country{
        set;
        get;
    }
    public String corpORind{
        set;
        get;
    }
    public String contryCode{
        set;
        get;
    }
    public String conid{
        set;
        get;
    }
    public String cityIn{
        set;
        get;
    }
    public String city{
        set;
        get;
    }
    public String citizenOrResident{
        set;
        get;
    }
    public String birthplace{
        set;
        get;
    }
    public String birthCountry{
        set;
        get;
    }
    public String Area{
        set;
        get;
    }
    public String actingAsNomineeShareholder{
        set;
        get;
    }
    public String actingAsNomineeDirector{
        set;
        get;
    }
}
public class cls_sourceOfwealth {
    public String incomeSource{
        set;
        get;
    }
    public String incomeCountry{
        set;
        get;
    }
    public String detail{
        set;
        get;
    }
}
public class SegWrapper{
    public String name{
        set;
        get;
    }
    public String segId{
        set;
        get;
    }
    public String allowed{
        set;
        get;
    }
    public string price{
        set;
        get;
    }
    public List<SegActivities> SegActivities{
        set;
        get;
    }
}
public class SegActivities {
    public String name{
        set;
        get;
    }
    public String actId{
        set;
        get;
    }
    public String price{
        set;
        get;
    }
    public String channel{
        set;
        get;
    }
    public List<docs> docs{
        set;
        get;
    }
}
public class docs {
}

}