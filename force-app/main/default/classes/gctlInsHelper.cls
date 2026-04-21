public class gctlInsHelper { 
    
    public static Map<String,String> calPremium(map<String,String> reqMap){
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndPoint(reqMap.get('Endpoint'));  request.setTimeout(90000);
        request.setHeader('Content-type', 'application/json;charset=utf-8');
        request.setHeader('Partner-Id',reqMap.get('PartnerID'));
        request.setHeader('Partner-Salt',reqMap.get('PartnerSalt'));
        request.setHeader('Partner-IV',reqMap.get('PartnerIV'));
        
        request.setBody(reqMap.get('reqBody'));          
        request.setMethod(reqMap.get('reqMethod'));
        
        System.debug('reqMap : ' + reqMap);
        try {
            Map<String,String> respMap = new Map<String,String>();
            response = h.send(request);
            if(response.getStatusCode()==200){ respMap.put('respBody', replaceKeys(String.ValueOf(response.getBody()))); 
                                             }else{ respMap.put('respBody', replaceKeys(String.ValueOf(response.getStatus())));}
            return respMap;
        }catch(System.CalloutException e) {System.debug('Callout error: '+ e);return null; } 
    }
    
    public static Map < String, String > genPolicy(map < String, String > reqMap) {
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndPoint(reqMap.get('Endpoint'));
        system.debug('JJ check' + reqMap.get('Endpoint'));
        request.setTimeout(90000);
        request.setHeader('Content-type', 'application/json;charset=utf-8');
        request.setHeader('Partner-Id', reqMap.get('PartnerID'));
        request.setHeader('Partner-Salt', reqMap.get('PartnerSalt'));
        request.setHeader('Partner-IV', reqMap.get('PartnerIV'));
        request.setBody(reqMap.get('reqBody'));
        request.setMethod(reqMap.get('reqMethod'));
        try {
            Map < String, String > respMap = new Map < String, String > ();
            system.debug('<genPolicy: Request Body>: ' + request);
            response = h.send(request);
            system.debug('<genPolicy: response>: ' + response);
            if (response.getStatusCode() == 200) {
                respMap.put('respBody', replaceKeys(String.ValueOf(response.getBody())));
            } else {
                respMap.put('respBody', replaceKeys(String.ValueOf(response.getStatus())));
            }
            return respMap;
        } catch (System.CalloutException e) {
            System.debug('Callout error: ' + e);
            return null;
        }
    }
    public static Map < String, String > eidaUpdate(map < String, String > reqMap) {
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndPoint(reqMap.get('Endpoint'));
        request.setTimeout(90000);
        request.setHeader('Content-type', 'application/json;charset=utf-8');
        request.setHeader('Partner-Id', reqMap.get('PartnerID'));
        request.setHeader('Partner-Salt', reqMap.get('PartnerSalt'));
        request.setHeader('Partner-IV', reqMap.get('PartnerIV'));
        request.setBody(reqMap.get('reqBody'));
        request.setMethod(reqMap.get('reqMethod'));
        try {
            Map < String, String > respMap = new Map < String, String > ();
            response = h.send(request);
            if (response.getStatusCode() == 200) {
                respMap.put('respBody', replaceKeys(String.ValueOf(response.getBody())));
            } else {
                respMap.put('respBody', replaceKeys(String.ValueOf(response.getStatus())));
            }
            return respMap;
        } catch (System.CalloutException e) {
            System.debug('Callout error: ' + e);
            return null;
        }
    }
    public static Map < String, String > uploadDoc(map < String, String > reqMap) {
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndPoint(reqMap.get('Endpoint'));
        request.setTimeout(90000);
        request.setHeader('Content-type', 'application/json;charset=utf-8');
        request.setHeader('Partner-Id', reqMap.get('PartnerID'));
        request.setHeader('Partner-Salt', reqMap.get('PartnerSalt'));
        request.setHeader('Partner-IV', reqMap.get('PartnerIV'));
        request.setBody(reqMap.get('reqBody'));
        request.setMethod(reqMap.get('reqMethod'));
        //request.setTimeout(120000);
        try {
            Map < String, String > respMap = new Map < String, String > ();
            response = h.send(request);
            if (response.getStatusCode() == 200) {
                respMap.put('respBody', replaceKeys(String.ValueOf(response.getBody())));
            } else {
                respMap.put('respBody', replaceKeys(String.ValueOf(response.getStatus())));
            }
            return respMap;
        } catch (System.CalloutException e) {
            System.debug('Callout error: ' + e);
            return null;
        }
    }
    
    public static String replaceKeys(String str) {
        if(String.isNotBlank(str)){
            if(str.contains('Partner-Salt'))    {str = str.replace('Partner-Salt', 'Partner_Salt');}
            if(str.contains('Partner-IV'))      {str = str.replace('Partner-IV', 'Partner_IV'); }
            if(str.contains('Encrypted-Text'))  {str = str.replace('Encrypted-Text', 'Encrypted_Text');}
            
            if(str.contains('"Decrypted-Text":"')){
                /* replace texts to remove JSON syntax errors while deserializing  */
                str = str.replace('"Decrypted-Text":"', '"Decrypted_Text":{"Insurance":');
                Integer lstInd = str.lastIndexOf('"');
                str = str.substring( 0,lstInd) + '' + str.substring(lstInd+1) +'}';
            }
        }
        
        return str;
    }
    
    /** 
* dt - DATE Format YYYY-MM-DD TT:TT:TT, 
* rplmnt - separator to replace '-'
**/
    public static String getFDt(String dt, String rplmnt){    
        if(dt.contains(' 00:00:00')){dt=dt.replace(' 00:00:00','');}
        if(dt.contains('-')){ String[] d=dt.split('-'); dt=''+d[2]+rplmnt+d[1]+rplmnt+d[0];}
        return dt;
    }
    
    public static String upperCase(String str){if(String.isNotBlank(str)){str = str.toUpperCase();} return str;}
    
    public static date dateFormat(String str){
        Date d ;
        if(String.isNotBlank(str) && str.contains('-')){
            String[] splStr = str.split('-');
            d = Date.newInstance(Integer.valueOf(splStr[2]),Integer.valueOf(splStr[1]),Integer.valueOf(splStr[0])); 
        }
        return d;
    }
    
    public static Map < String, String > crtReq(String callType, String PartnerSalt, String PartnerIV, String reqBody, String reqMethod) {
        map < String, String > createReq = new map < String, String > ();
        Map < String, adnicWS__c > adnicValues = adnicWS__c.getAll();
        createReq.put('CallType', callType);
        createReq.put('reqBody', reqBody);
        createReq.put('reqMethod', reqMethod);
        createReq.put('Endpoint', adnicValues.get(callType).Endpoint__c);
        createReq.put('PartnerID', adnicValues.get(callType).PartnerID__c);
        If(String.isNotBlank(PartnerSalt)) {
            createReq.put('PartnerSalt', PartnerSalt);
        }
        If(String.isNotBlank(PartnerIV)) {
            createReq.put('PartnerIV', PartnerIV);
        }
        if (createReq.size() > 0) {
            return createReq;
        } else {
            return null;
        }
    }
    
    public static contact updateCnt(String cnId,gctlInsHelper.Insurance decncryptParse){ contact c = new contact(); c.id = cnId; c.xpno__c = String.valueOf(decncryptParse.PolicyInfo.PolicyNo); c.xpsd__c = gctlInsHelper.dateFormat(decncryptParse.PolicyInfo.PolicyStartDate); c.xped__c = gctlInsHelper.dateFormat(decncryptParse.PolicyInfo.PolicyEndDate); c.xpdl__c = String.valueOf(decncryptParse.PolicyDocumentInfo.policyDoc); c.xpidl__c = String.valueOf(decncryptParse.PolicyDocumentInfo.invoiceDoc); c.xpcnl__c = String.valueOf(decncryptParse.PolicyDocumentInfo.creditNoteDoc); c.xpmi__c = String.valueOf(decncryptParse.InsuredInfo[0].MemberId);c.intp__c =(String.ValueOf(decncryptParse.QuoteInfo.PlanType));  return c; }
    
    public static g_reqitem__c updaterqItm(String reqId,String status,gctlInsHelper.Insurance decncryptParse){ g_reqitem__c ri = new g_reqitem__c(); ri.id = reqId; ri.sta__c = status; ri.xpno__c = String.valueOf(decncryptParse.PolicyInfo.PolicyNo); ri.xpsd__c = gctlInsHelper.dateFormat(decncryptParse.PolicyInfo.PolicyStartDate); ri.xped__c = gctlInsHelper.dateFormat(decncryptParse.PolicyInfo.PolicyEndDate); ri.xpdl__c = String.valueOf(decncryptParse.PolicyDocumentInfo.policyDoc); ri.xpidl__c = String.valueOf(decncryptParse.PolicyDocumentInfo.invoiceDoc); ri.xpcnl__c = String.valueOf(decncryptParse.PolicyDocumentInfo.creditNoteDoc); ri.xcnotes__c='';  return ri; }
    
    public static g_reqitem__c updaterqItmErrorMsg(String reqId,String errorMsg){ g_reqitem__c ri = new g_reqitem__c(); ri.id = reqId; ri.xcnotes__c = errorMsg;   return ri; }
    
    public static g_Req__c updaterq(String reqId, String status) { g_Req__c rq = new g_Req__c(); rq.id = reqId; rq.sta__c = status; return rq; }
    
    public static String encryptStr(String str, Integer i) {
        
        Map < String, String > En_D = getSnV(i);
        System.debug('<encryptStr> i' + i +'Map : '+ En_D);
        Blob bkey = EncodingUtil.base64Decode(En_D.get('apxSALT'));
        Blob IV = Blob.valueOf(En_D.get('apxIV'));
        Blob cipherText = Crypto.encrypt('AES128', bkey, IV, Blob.valueOf(str));
        String encodedCipherText = EncodingUtil.base64Encode(cipherText);
        return EncodingUtil.base64Encode(cipherText); 
    }
    
    public static String decryptStr(String eStr, Integer i){ 
        
        system.debug('eStr---->'+eStr+' '+'---->'+i);
        Map<String,String> En_D = getSnV(i); 
        System.debug('<decryptStr> i' + i +'Map : '+ En_D); 
        Blob bkey = EncodingUtil.base64Decode(En_D.get('apxSALT')); 
        Blob IV = Blob.valueOf(En_D.get('apxIV'));  
        System.debug('eStr  : ' + eStr);
        Blob cipherText = Crypto.decrypt('AES128',bkey,IV,EncodingUtil.base64Decode(eStr)); 
        system.debug('cipherText+++++'+cipherText);
        return cipherText.toString();
    } 
    //Added by Rena 
    public static String getJson(g_reqitem__c ri, Contact con) {
        system.debug('getJson:::');
        system.debug('ri::::'+ri);
        system.debug('con::::'+con.xean__c);
        system.debug('xceidid__c::::'+ri.xceidid__c);
        gctlInsHelper.Insurance ins = new gctlInsHelper.Insurance();
        List < gctlInsHelper.InsuredInfo > lstInsInfo = new List < gctlInsHelper.InsuredInfo > ();
        gctlInsHelper.InsuredInfo insInfo = new gctlInsHelper.InsuredInfo();
        gctlInsHelper.PartnerInfo pi = new gctlInsHelper.PartnerInfo();
        if (ri.RQ__r.xceidid__c != null && ri.RQ__r.xceidid__c.length() == 15) insInfo.EmiratesId = ri.RQ__r.xceidid__c.substring(0, 3) + '-' + ri.RQ__r.xceidid__c.substring(3, 7) + '-' + ri.RQ__r.xceidid__c.substring(7, 14) + '-' + ri.RQ__r.xceidid__c.substring(14, 15);
        else insInfo.EmiratesId = ri.RQ__r.xceidid__c;
        insInfo.EmiratesIdApplicationNo = (String.isNotBlank(con.xean__c)) ? '800' + con.xean__c : '';
        insInfo.MemberId = con.xpmi__c;
        system.debug('insInfo::::'+insInfo);
        lstInsInfo.add(insInfo);
        pi.PartnerId = 'TECOM';
        ins.InsuredInfo = lstInsInfo;
        ins.PartnerInfo = pi;
        String jReq = JSON.serialize(ins, true);
        return jReq;
    }    
    /* FOR PRODUCTION */
    public static Map<String,String> getSnV( integer i){ Map<Integer,Map<String,String>> mapSV = new Map<Integer,Map<String,String>>(); Map<String,String> map1 = new Map<String,String>();  /***map1.put('reqSALT','8A2BBAA0AC4FCA58225C086333B2FFD3'); map1.put('reqIV','30303030303030303030303030303030'); map1.put('apxSALT','X1IPJ0BbAF+fpIxkUtkgqA=='); map1.put('apxIV','0000000000000000'); mapSV.put(1,map1); //map1.clear();  map1 = new Map<String,String>(); map1.put('reqSALT','B94C6D2DAD2F3A1F8642D431F9238CA5'); map1.put('reqIV','31313131313131313131313131313131'); map1.put('apxSALT','Pi63RMfhQhvCzZqDxBXUxA=='); map1.put('apxIV','1111111111111111'); mapSV.put(2,map1); //map1.clear();  map1 = new Map<String,String>(); map1.put('reqSALT','301531D82CC570FE4BD7E50D1DDAFAB8'); map1.put('reqIV','32323232323232323232323232323232'); map1.put('apxSALT','V98Lj1beDsSgYUxbZkdkSA=='); map1.put('apxIV','2222222222222222'); mapSV.put(3,map1); //map1.clear();  map1 = new Map<String,String>(); map1.put('reqSALT','7DC3B21DD6A7FF5A66421E3C5D00C211'); map1.put('reqIV','33333333333333333333333333333333'); map1.put('apxSALT','9Dg5JC7cSIWiCkTUwkfHvA=='); map1.put('apxIV','3333333333333333'); mapSV.put(4,map1); //map1.clear();  map1 = new Map<String,String>(); map1.put('reqSALT','CAA26A3654052D6BB191A46E06041A67'); map1.put('reqIV','34343434343434343434343434343434'); map1.put('apxSALT','aArfQkaUdfB++N3qhkn4Yw=='); map1.put('apxIV','4444444444444444'); mapSV.put(5,map1); //map1.clear();  map1 = new Map<String,String>(); map1.put('reqSALT','6BF703794218FE857E6C27A7A31432DB'); map1.put('reqIV','35353535353535353535353535353535'); map1.put('apxSALT','WMJZUOujHEMMGjJO8pywpQ=='); map1.put('apxIV','5555555555555555'); mapSV.put(6,map1); //map1.clear(); ****/   map1.put('reqSALT','B94C6D2DAD2F3A1F8642D431F9238CA5'); map1.put('reqIV','31313131313131313131313131313131'); map1.put('apxSALT','0AFV5KkfhFV7yGdoRqM16A=='); map1.put('apxIV','1111111111111111'); mapSV.put(1,map1);   map1 = new Map<String,String>(); map1.put('reqSALT','301531D82CC570FE4BD7E50D1DDAFAB8'); map1.put('reqIV','32323232323232323232323232323232'); map1.put('apxSALT','qJ1dKddupStg3RjvonBiKA=='); map1.put('apxIV','2222222222222222'); mapSV.put(2,map1);  map1 = new Map<String,String>(); map1.put('reqSALT','7DC3B21DD6A7FF5A66421E3C5D00C211'); map1.put('reqIV','33333333333333333333333333333333'); map1.put('apxSALT','2/eiazz6NYIHbigCrrUP9A=='); map1.put('apxIV','3333333333333333'); mapSV.put(3,map1);  map1 = new Map<String,String>(); map1.put('reqSALT','CAA26A3654052D6BB191A46E06041A67'); map1.put('reqIV','34343434343434343434343434343434'); map1.put('apxSALT','ODt51ZTrR0eMTGPtyd4eeg=='); map1.put('apxIV','4444444444444444'); mapSV.put(4,map1);  map1 = new Map<String,String>(); map1.put('reqSALT','6BF703794218FE857E6C27A7A31432DB'); map1.put('reqIV','35353535353535353535353535353535'); map1.put('apxSALT','RWMEeFON+a/SuvDOcOv1KQ=='); map1.put('apxIV','5555555555555555'); mapSV.put(5,map1);  map1 = new Map<String,String>(); map1.put('reqSALT','8A2BBAA0AC4FCA58225C086333B2FFD3'); map1.put('reqIV','30303030303030303030303030303030'); map1.put('apxSALT','aLbsoMvoHfklx3j+4G9jtA=='); map1.put('apxIV','0000000000000000'); mapSV.put(6,map1);  System.debug('zzzzzzzzzzz vv ' + i +' mapSV: ' + mapSV); return mapSV.get(i); }
    
    /* FOR SANDBOXES */
    //public static Map < String, String > getSnV(integer i) { Map < Integer, Map < String, String >> mapSV = new Map < Integer, Map < String, String >> (); Map < String, String > map1 = new Map < String, String > ();  map1.put('reqSALT', '8A2BBAA0AC4FCA58225C086333B2FFD3'); map1.put('reqIV', '30303030303030303030303030303030'); map1.put('apxSALT', 'X1IPJ0BbAF+fpIxkUtkgqA=='); map1.put('apxIV', '0000000000000000'); mapSV.put(1, map1); map1 = new Map < String, String > (); map1.put('reqSALT', 'B94C6D2DAD2F3A1F8642D431F9238CA5'); map1.put('reqIV', '31313131313131313131313131313131'); map1.put('apxSALT', 'Pi63RMfhQhvCzZqDxBXUxA=='); map1.put('apxIV', '1111111111111111'); mapSV.put(2, map1); map1 = new Map < String, String > (); map1.put('reqSALT', '301531D82CC570FE4BD7E50D1DDAFAB8'); map1.put('reqIV', '32323232323232323232323232323232'); map1.put('apxSALT', 'V98Lj1beDsSgYUxbZkdkSA=='); map1.put('apxIV', '2222222222222222'); mapSV.put(3, map1); map1 = new Map < String, String > (); map1.put('reqSALT', '7DC3B21DD6A7FF5A66421E3C5D00C211'); map1.put('reqIV', '33333333333333333333333333333333'); map1.put('apxSALT', '9Dg5JC7cSIWiCkTUwkfHvA=='); map1.put('apxIV', '3333333333333333'); mapSV.put(4, map1); map1 = new Map < String, String > (); map1.put('reqSALT', 'CAA26A3654052D6BB191A46E06041A67'); map1.put('reqIV', '34343434343434343434343434343434'); map1.put('apxSALT', 'aArfQkaUdfB++N3qhkn4Yw=='); map1.put('apxIV', '4444444444444444'); mapSV.put(5, map1); map1 = new Map < String, String > (); map1.put('reqSALT', '6BF703794218FE857E6C27A7A31432DB'); map1.put('reqIV', '35353535353535353535353535353535'); map1.put('apxSALT', 'WMJZUOujHEMMGjJO8pywpQ=='); map1.put('apxIV', '5555555555555555'); mapSV.put(6, map1);   /***map1.put('reqSALT', 'B94C6D2DAD2F3A1F8642D431F9238CA5'); map1.put('reqIV', '31313131313131313131313131313131'); map1.put('apxSALT', '0AFV5KkfhFV7yGdoRqM16A=='); map1.put('apxIV', '1111111111111111'); mapSV.put(1, map1); map1 = new Map < String, String > (); map1.put('reqSALT', '301531D82CC570FE4BD7E50D1DDAFAB8'); map1.put('reqIV', '32323232323232323232323232323232'); map1.put('apxSALT', 'qJ1dKddupStg3RjvonBiKA=='); map1.put('apxIV', '2222222222222222'); mapSV.put(2, map1); map1 = new Map < String, String > (); map1.put('reqSALT', '7DC3B21DD6A7FF5A66421E3C5D00C211'); map1.put('reqIV', '33333333333333333333333333333333'); map1.put('apxSALT', '2/eiazz6NYIHbigCrrUP9A=='); map1.put('apxIV', '3333333333333333'); mapSV.put(3, map1); map1 = new Map < String, String > (); map1.put('reqSALT', 'CAA26A3654052D6BB191A46E06041A67'); map1.put('reqIV', '34343434343434343434343434343434'); map1.put('apxSALT', 'ODt51ZTrR0eMTGPtyd4eeg=='); map1.put('apxIV', '4444444444444444'); mapSV.put(4, map1); map1 = new Map < String, String > (); map1.put('reqSALT', '6BF703794218FE857E6C27A7A31432DB'); map1.put('reqIV', '35353535353535353535353535353535'); map1.put('apxSALT', 'RWMEeFON+a/SuvDOcOv1KQ=='); map1.put('apxIV', '5555555555555555'); mapSV.put(5, map1); map1 = new Map < String, String > (); map1.put('reqSALT', '8A2BBAA0AC4FCA58225C086333B2FFD3'); map1.put('reqIV', '30303030303030303030303030303030'); map1.put('apxSALT', 'aLbsoMvoHfklx3j+4G9jtA=='); map1.put('apxIV', '0000000000000000'); mapSV.put(6, map1);***/  System.debug('zzzzzzzzzzz vv ' + i + ' mapSV: ' + mapSV); return mapSV.get(i); } 
    
    //########################
    //### Wrapper Classes
    //########################
    public class Insurance {
        public      QuoteInfo           QuoteInfo;
        public      SponsorInfo         SponsorInfo;
        public      PremiumInfo         PremiumInfo;     
        public      List<InsuredInfo>   InsuredInfo;
        public      List<ErrorInfo>     errorInfo;
        public      PartnerInfo         PartnerInfo;
        public      PolicyInfo          PolicyInfo;
        public      PolicyDocumentInfo  PolicyDocumentInfo;
        public      List<DocumentInfo>  DocumentInfo;
    } 
    //updated by rena
    public class Insur {
        public QuoteInfo QuoteInfo;
        public SponsorInfo SponsorInfo;
        public List < InsuredInfo > InsuredInfo;
        public PolicyInfo PolicyInfo;
        public PartnerInfo PartnerInfo;
        
    }
    
    public class   QuoteInfo            { public String RefNo,QuotationNo,MemberId,VisaEmirate, SalaryBand, PolicyType, PlanType, NoOfPersonsToInsure, IncludingSponsor,disclaimer; }
    public class   InsuredInfo          { public String Name,DOB,Gender,PregnantStatus,MemberGrossPremiumAmt,Relationship,MaritalStatus,PreviouslyCovered,MemberId,EmiratesIdApplicationNo,Nationality,PassportNo,UIDNo,EmiratesId,OccupationalIndustry,WorkLocation,mobileNo,Commission,BirthCertficateId,EntryPermitNo,SalaryCap,ResidenceLocation,MemberCategory,emailId,placeOfBirth,currentAddress,placeOfWork,contactDetails,permanentResidency;
                                         public PersonalInfo PersonalInfo;}
    public class   SponsorInfo          { public String Name,MobileNo,TradeLicenseNo,EmailId,DOB,VATRegNo,Address,POBoxNo,City,PhoneNo,IsADNICMember,SponsorMedPolicyNo,SponsorPFNo;
                                         public PersonalInfo PersonalInfo;}
    public class   PolicyInfo           { public String PolicyStartDate,PolicyEndDate,FinalPremiumAmt,PaymentType,PaymentRefNo,PolicyNo,DebitNoteNo,CommissionAmtCreditNoteNo;}
    public class   PolicyDocumentInfo   { public String policyDoc,invoiceDoc,creditNoteDoc;}
    public class   PremiumInfo          { public String GrossPremiumAmt,VATAmt,FinalPremiumAmt,BasmahFund,DiscountAmt; }
    public class   ErrorInfo            { public String ErrorCode,ErrorMsg; }
    public class   PartnerInfo          { public String PartnerId; }
    public class   DocumentInfo         { public String MemberId,DocumentCategory,DocumentContent,DocumentName,DocuementStatus; }
    public class   Resp                 { public String Partner_Salt,Partner_IV,Encrypted_Text; public Decrypted_Text Decrypted_Text;}
    public class   Decrypted_Text       { public Insurance Insurance;}
    public class ApplicantInfo {
        public String ResidencyNo,Name,NameAr,SponsorName,SponsorNameAr,Profession,ProfessionAr,ProfessionId,Nationality,NationalityAr,NationalityId,PassportNum,Photo,Gender,DOB,ClientMobile,LandLine,SponsorAddress,SponsorAddressAr,Mail,SponsorMobile,EmiratesIDNo,UIDNo,SponsorTypes,VisaType,PersonType,UrgencyCategory,Centers,PackageType,FzSubEntity,FreeZoneOrganization;
    }
    public class PersonalInfo           { public String nationality,placeOfBirth,currentAddress,placeOfWork,passportNumber,eidNumber,contactDetails,birthCertificateNumber,permanentResidency;}
    
}