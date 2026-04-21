public class ClaimValidate {
 //public Map<string, g_TranItem__c> tranItmMap {set;get;}
 //public Map<string, reconcil__c> recMap {set;get;}
 public Map<string, PdfRec> recMap {set;get;}
 public String docId {set;get;}
 public String eVDocId {set;get;}
 public String ePDocId {set;get;}
 public String stmtDocId {set;get;}
 public String fileType {set;get;}
 public String fileLevel {set;get;}
 public transient string nameFile {get;set;}
 public  transient Blob contentFile {get;set;}
 public transient string eVFile {get;set;}
 public  transient Blob contentEVFile {get;set;}
 public transient string ePFile {get;set;}
 public  transient Blob contentEPFile {get;set;}
 public transient string nameStmtFile {get;set;}
 public  transient Blob contentStmtFile {get;set;}
// public Date fromDate {get; set;}
 public g_TranItem__c ti {set;get;}
  public boolean validate {set;get;}
 public boolean isErrorMsg {set;get;}
 public boolean isRefValidate {set;get;}
 public boolean isExport {set;get;}
 public List<TransInfo> trnLst {set;get;}
 public List<TransInfo> trnUnMatchLst {set;get;}
 public List<TransInfo> appUnMatchLst {set;get;}
 public Decimal ttlMAmount {set;get;}
 public Decimal ttlNMAmount {set;get;}
 public Decimal ttlappNMAmount {set;get;}
 public Decimal ttlDiffAmount {set;get;}
 public Decimal ttlMCnt {set;get;}
 public Decimal ttlNMCnt {set;get;}
  public Decimal ttlappNMCnt {set;get;}
 public ClaimValidate() {
   //  tranItmMap = new Map<string, g_TranItem__c>();
     if (recMap == null)
     recMap = new Map<string, PdfRec>();
     ti = new g_TranItem__c();
     trnLst = new List<TransInfo>(); trnUnMatchLst = new List<TransInfo>(); appUnMatchLst = new List<TransInfo>();
     contentFile = null;nameFile = null;validate=false;isExport=false;isRefValidate=false;fileType = '';fileLevel='';
     ttlMAmount = 0;ttlNMAmount=0;ttlMCnt = 0;ttlNMCnt=0;ttlDiffAmount=0;
  }

    public PageReference validate() {

        trnLst = new List<TransInfo>(); trnUnMatchLst = new List<TransInfo>();
        fileLevel = '2';
        //nameFile= EncodingUtil.base64Encode(contentFile);

        /*nameFile=contentFile.toString();
        Set<string> lst = new Set<string>();
       //nameFile= EncodingUtil.base64Encode(contentFile);
       //nameFile = EncodingUtil.urlEncode(nameFile, 'UTF-8');
       List<Id> idList =  new List<Id>();
       Map<String, string> map1 = new Map<string, string>();
       List<List<String>> parsedFields = parseCSV(nameFile, true);
       system.debug('size is '+parsedFields.size());

       for (List<String> e1: parsedFields) {
          double d = double.valueOf(e1[1]);
          Decimal d1 = Decimal.valueOf(d).setScale(2);
          lst.add(e1[0]+'_'+d1);
       } */
    ttlMAmount = 0;ttlNMAmount=0;ttlMCnt = 0;ttlNMCnt=0;ttlDiffAmount=0;
    Map<string, decimal> trnMap = new map<string, decimal>();
    String strApiKey = gu.csStr('parserAPIKey'); 
    String strParserId = gu.csStr('parserStmtDocId'); //'upjozesttuwx';//'qayxfmcvnwfh'; // 'yhbvgsksrofb';
    String strRsURL = 'https://api.docparser.com/v1/results/' + strParserId + '/'+stmtDocId ;

  // send out the request
  HttpRequest req = New HttpRequest();
  req.setHeader('Authorization', 'Basic ' + strApiKey);
  req.setMethod('GET');
        req.setEndpoint('callout:ClaimValidation_API');
  Http http = New Http();
  HTTPResponse res = http.send(req);
  //system.debug('res'+res.getBody());
  String resStr = res.getBody();
  isRefValidate = false;
  if (resStr != null && resStr.contains('"error"')) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'File not yet processed. Please validate again.'));
      isRefValidate = true;
       isExport = true;
      return null;
  }
  resStr = resStr.substring(1, resStr.length()-1);

  ClaimValidate.PdfInfo pdfinfo = (ClaimValidate.PdfInfo)Json.deserialize(resStr, ClaimValidate.PdfInfo.class);
  List<ClaimValidate.PdfRec> recLst = pdfinfo.table_data;
  for (ClaimValidate.PdfRec rec : recLst) {

      if (trnMap.containsKey(rec.key_1)) {
          Decimal amnt = trnMap.get(rec.key_1);
          amnt = amnt + decimal.valueOf(rec.key_5);
          trnMap.put(rec.key_1, amnt);
      }else if (!String.isBlank(rec.key_5)) {
           String  amt = rec.key_5.replace(', ', '');
           trnMap.put(rec.key_1, decimal.valueOf(amt));
      }
      //lst.add(rec.key_1);
  }

     Map<String, PdfRec> recRefMap = new  Map<String, PdfRec>();
        if (recMap != null && !recMap.isEmpty()) {
        for (PdfRec rc : recMap.values()) {
          String ref = '';
          if (fileType == 'EP-EDNRD')
           ref = rc.key_3;
          else
           ref = rc.key_6;
          if (trnMap.containskey(ref)) {

           TransInfo ti = new TransInfo();
           if (fileType == 'EP-EDNRD')
             ti.appNo = rc.key_1;
           else
           ti.appNo = rc.key_0;
           ti.refNo = ref;
           ti.amount = rc.key_4.substringBefore(' ');
           ti.amntDiff = string.valueOf(trnMap.get(ref) - decimal.valueOf(rc.key_4.substringBefore(' ')));
           ti.Matched = true;
           ttlMAmount =  ttlMAmount + decimal.valueOf(rc.key_4.substringBefore(' '));
           ttlDiffAmount = ttlDiffAmount  + (trnMap.get(ref) - decimal.valueOf(rc.key_4.substringBefore(' ')));
           ttlMCnt = ttlMCnt +1;
           trnLst.add(ti);
          }
          else{
           TransInfo ti = new TransInfo();
           if (fileType == 'EP-EDNRD')
             ti.appNo = rc.key_1;
           else
            ti.appNo = rc.key_0;
           ti.refNo = ref;
           ti.amount = rc.key_4.substringBefore(' ');
           ti.Matched = false;
           ttlNMAmount =  ttlNMAmount + decimal.valueOf(rc.key_4.substringBefore(' '));
           ttlNMCnt = ttlNMCnt +1;
           trnUnMatchLst.add(ti);
             }

           // recRefMap.put(rc.key_6, rc);
        }
        }
        isExport = true;
        return null;
    }

   public List<ClaimValidate.PdfRec> fetchJSONLst(String parserId, String documentId) {
       String strApiKey = gu.csStr('parserAPIKey'); 
       String strParserId = parserId; //gu.csStr('parserAppDocId'); //'ljyqedcmjgqy';//'vjngsoslebwk'; // 'yhbvgsksrofb';
       String strRsURL = 'https://api.docparser.com/v1/results/' + strParserId + '/'+documentId ;
      List<ClaimValidate.PdfRec> recLst = new List<ClaimValidate.PdfRec>();
       isErrorMsg = false;
      // send out the request
      HttpRequest req = New HttpRequest();
      req.setHeader('Authorization', 'Basic ' + strApiKey);
      req.setMethod('GET');
        req.setEndpoint('callout:ClaimValidation_API');
      Http http = New Http();
      HTTPResponse res = http.send(req);
      String resStr = res.getBody();
       system.debug('resStr::'+resStr);
      if (resStr != null && resStr.contains('"error"')) {
        validate = true;
         isErrorMsg = true;
         system.debug('isErrorMsg::'+isErrorMsg);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Validating File... Please wait.'));
        return null;
     }
    resStr = resStr.substring(1, resStr.length()-1);

    ClaimValidate.PdfInfo pdfinfo = (ClaimValidate.PdfInfo)Json.deserialize(resStr, ClaimValidate.PdfInfo.class);
    recLst = pdfinfo.table_data;
    return recLst;
   }

   public PageReference appValidate() {
    system.debug('test::');
    system.debug('docId::'+docId);
    Map<string, TransAmnt> tranItmMap = new Map<string, TransAmnt>();
       isErrorMsg = false;
    //Map<string, reconcil__c> tranItmMap = new Map<string, reconcil__c>();
    ttlMAmount = 0;ttlNMAmount=0;ttlappNMAmount=0;ttlMCnt = 0;ttlNMCnt=0;ttlappNMCnt=0;ttlDiffAmount=0;fileLevel = '1';
     isExport = false;
    if (fileType == 'ALL' || fileType == 'RP-EDNRD' || fileType == 'EP-EDNRD' || fileType == 'E-Vision' ) {
         Map<string, decimal> trnMap = new map<string, decimal>();
        List<ClaimValidate.PdfRec> rpLst  = new List<ClaimValidate.PdfRec>();
         List<ClaimValidate.PdfRec> epLst  = new List<ClaimValidate.PdfRec>();
         List<ClaimValidate.PdfRec> evLst  = new List<ClaimValidate.PdfRec>();
        if (fileType == 'ALL' || fileType == 'RP-EDNRD') {
          rpLst  = fetchJSONLst(gu.csStr('parserAppDocId'), docId);
            system.debug('validate::'+isErrorMsg);
          if ((rpLst == null || rpLst.isEmpty()) && isErrorMsg )
           return null;
        }
         if (fileType == 'ALL' || fileType == 'EP-EDNRD') {
          epLst  = fetchJSONLst(gu.csStr('parserVISAId'), ePDocId);
             system.debug('validate1::'+isErrorMsg);
         if ((epLst == null || epLst.isEmpty()) && isErrorMsg)
          return null;
         }
         if (fileType == 'ALL' || fileType == 'E-Vision') {
         evLst  = fetchJSONLst(gu.csStr('parserEVisionId'), eVDocId);
              system.debug('validate2::'+isErrorMsg);
         if ((evLst == null || evLst.isEmpty()) && isErrorMsg)
          return null;
         }
         List<ClaimValidate.PdfRec> stmtLst  = fetchJSONLst(gu.csStr('parserStmtDocId'), stmtDocId);
         system.debug('validate3::'+isErrorMsg);
         if ((stmtLst == null || stmtLst.isEmpty()) && isErrorMsg)
          return null;

        Map<string, PdfRec> stmtMap = new Map<string, PdfRec>();
        Map<string, String> stmtAppMap = new Map<string, String>();
        Map<string, string> appMap = new map<string, string>();
        if ((fileType == 'ALL' || fileType == 'RP-EDNRD') && (rpLst != null && !rpLst.isEmpty())) {
         for (PdfRec rc : rpLst) {
            PdfRec rc1 = new PdfRec(); rc1.key_4 = rc.key_4;rc1.key_0 =validateNum(rc.key_6);
            stmtMap.put(validateNum(rc.key_0), rc1);
            stmtAppMap.put(validateNum(rc.key_0), validateNum(rc.key_6));
            appMap.put(validateNum(rc.key_6), validateNum(rc.key_0));
           // trnIdLst.add(rc.key_6);
        }
        }
        if ((fileType == 'ALL' || fileType == 'EP-EDNRD') && (epLst != null && !epLst.isEmpty())) {
        for (PdfRec rc : epLst) {
           PdfRec rc1 = new PdfRec(); rc1.key_4 = rc.key_4;rc1.key_0 = validateNum(rc.key_3);
           stmtMap.put(validateNum(rc.key_1), rc1);
           stmtAppMap.put(validateNum(rc.key_1), validateNum(rc.key_3));
           appMap.put(validateNum(rc.key_3), validateNum(rc.key_1));
           //trnIdLst.add(rc.key_3);
        }
        }
         if ((fileType == 'ALL' || fileType == 'E-Vision') && (evLst != null && !evLst.isEmpty())) {
        for (PdfRec rc : evLst) {
            if (stmtMap.isEmpty() || !stmtMap.containsKey(validateNum(rc.key_3)) ) {
            PdfRec rc1 = new PdfRec(); rc1.key_4 = rc.key_4;rc1.key_0 = validateNum(rc.key_0);
            stmtMap.put(validateNum(rc.key_3), rc1);
            stmtAppMap.put(validateNum(rc.key_3), validateNum(rc.key_0));
            appMap.put(validateNum(rc.key_0), validateNum(rc.key_3));
             // trnIdLst.add(rc.key_0);
             }
        }
         }
       Set<string> refidLst = new Set<String>();

       Set<String> trnIdLst = reValidateTransactions(stmtMap, refidLst, stmtAppMap, false);
       Map<String, string> appNameMap = new Map<String, string>();
        for (ClaimValidate.PdfRec rec : stmtLst) {
          if (trnMap.containsKey(rec.key_1)) {
            Decimal amnt = trnMap.get(rec.key_1);
            amnt = amnt + decimal.valueOf(rec.key_5.replace(', ', ''));
            trnMap.put(validateNum(rec.key_1), amnt);
          }else if (!String.isBlank(rec.key_5)) {
             String  amt = rec.key_5.replace(', ', '');
             trnMap.put(validateNum(rec.key_1), decimal.valueOf(amt));
             appNameMap.put(validateNum(rec.key_1), rec.key_2);
          }
        }

        for (String str : trnMap.keySet()) {
           if (trnIdLst == null || trnIdLst.isEmpty() || !trnIdLst.contains(str)) {
              if (appMap != null && appMap.containskey(str))
              refidLst.add(appMap.get(str));
             /* TransInfo ti = new TransInfo();
              ti.appNo = str;
              ti.amount = String.valueOf(trnMap.get(str));
              ti.Matched = false;
              ttlappNMAmount = ttlappNMAmount + trnMap.get(str);
              appUnMatchLst.add(ti);*/
          }
       }
      //system.debug('refidLst::'+refidLst);
      Set<String> trnIdLst1 = reValidateTransactions(stmtMap, refidLst, stmtAppMap, true);
      system.debug('refidLst::'+refidLst);
      system.debug('trnIdLst1::'+trnIdLst1);
        for (String str : trnMap.keySet()) {
           if ((trnIdLst == null || trnIdLst.isEmpty() || !trnIdLst.contains(str)) && (trnIdLst1 == null || trnIdLst1.isEmpty() || !trnIdLst1.contains(str)) ) {
              TransInfo ti = new TransInfo();
              ti.appNo = str;
              if (appMap != null && appMap.containskey(str))
              ti.refNo = appMap.get(str);
              if (appNameMap != null && !appNameMap.isEmpty() && appNameMap.containsKey(str))
               ti.appName = appNameMap.get(str);
              ti.amount = String.valueOf(trnMap.get(str));
              ti.Matched = false;
              ttlappNMAmount = ttlappNMAmount + trnMap.get(str);
              appUnMatchLst.add(ti);
          }
       }
      ttlMCnt = trnLst.size(); ttlNMCnt = trnUnMatchLst.size(); ttlappNMCnt = appUnMatchLst.size();

    }
    else{
    if (fileType == 'EIDA') {
     //nameFile= EncodingUtil.base64Encode(contentFile);

        nameFile=contentFile.toString();
        Set<string> lst = new Set<string>();
       //nameFile= EncodingUtil.base64Encode(contentFile);
       //nameFile = EncodingUtil.urlEncode(nameFile, 'UTF-8');
       List<Id> idList =  new List<Id>();
       Map<String, string> map1 = new Map<string, string>();
       List<List<String>> parsedFields = parseCSV(nameFile, false);
       system.debug('size is '+parsedFields.size());

       for (List<String> prLst: parsedFields) {
          system.debug('csv lst::'+prLst);
          String str = prLst[0].replaceAll(', ', '').replaceAll(' ', ', ').replaceAll(', , , , ', ', ').replaceAll(', , ', ', ');
          List<string> e1 = str.split(', ');
          system.debug(e1);
          double d = double.valueOf(e1[6]);
          Decimal d1 = Decimal.valueOf(d).setScale(2);
          double dc = double.valueOf(e1[7]);
          Decimal dc1 = Decimal.valueOf(dc).setScale(2);
          lst.add(e1[0]+'_'+d1);
          PdfRec rec = new PdfRec();
          rec.key_0 = e1[0];
          rec.key_2 =e1[3];
          rec.key_4 =String.valueOf(d1+dc1);
           recMap.put(rec.key_0, rec);
       }
    }
    else{
       String strApiKey = gu.csStr('parserAPIKey'); 
    String strParserId = getParserId(); //gu.csStr('parserAppDocId'); //'ljyqedcmjgqy';//'vjngsoslebwk'; // 'yhbvgsksrofb';
    String strRsURL = 'https://api.docparser.com/v1/results/' + strParserId + '/'+docId ;

  // send out the request
  HttpRequest req = New HttpRequest();
  req.setHeader('Authorization', 'Basic ' + strApiKey);
  req.setMethod('GET');
        req.setEndpoint('callout:ClaimValidation_API');
  Http http = New Http();
  HTTPResponse res = http.send(req);
  system.debug('res:::'+res.getBody());
 String resStr = res.getBody();
  if (resStr != null && resStr.contains('"error"')) {
      validate = true;
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Validating File... Please wait.'));
      return null;
  }
  resStr = resStr.substring(1, resStr.length()-1);

  ClaimValidate.PdfInfo pdfinfo = (ClaimValidate.PdfInfo)Json.deserialize(resStr, ClaimValidate.PdfInfo.class);
  List<ClaimValidate.PdfRec> recLst = pdfinfo.table_data;

    for (PdfRec rc : recLst) {
        if (fileType == 'E-Vision') {
           if (recMap.containsKey(rc.key_3)) {
              Decimal amnt = decimal.valueOf(recMap.get(rc.key_3).key_4) + decimal.valueOf(rc.key_4);
              rc.key_4 = string.valueOf(amnt);
              recMap.put(rc.key_3, rc);
           }else if (!String.isBlank(rc.key_4)) {
              String  amt = rc.key_4.replace(', ', '');
              rc.key_4 = amt;
              recMap.put(rc.key_3, rc);
           }

        }
        else if (fileType == 'EP-EDNRD')
         recMap.put(rc.key_1, rc);
       else
         recMap.put(rc.key_0, rc);
     }
    }

     system.debug('recMap size::'+recMap.size());

    List<String> financeGrpLst = new List<String>();
      if (fileType == 'DNRD') {
           financeGrpLst.add('DNRD-Included');
           financeGrpLst.add('DNRD');
       }
       else {
           financeGrpLst.add(fileType);
       }
   Map<String, TransAmnt> inCMp = new Map<String, TransAmnt>();
   Map<String, TransAmnt> epMp = new Map<String, TransAmnt>();
   Set<string> refLst = new Set<String>();
   // for (g_TranItem__c itm : [select id, name, iRef__c, A__c, createdbyid, createdby.name from g_TranItem__c where Tp__c = 'Claim' and Finance_Group__c in ('DNRD-Included', 'DNRD') and DAY_ONLY(convertTimezone(createdDate)) = :fromDate])
    //for (reconcil__c itm : [select id, name, iRef__c, A__c, createdbyid,    usrName__c from reconcil__c where Tp__c = 'Claim' and Finance_Group__c in :financeGrpLst and DAY_ONLY(convertTimezone(cdt__c)) = :fromDate])
       for (g_TranItem__c itm : [select id, name, itm__r.RQ__r.Con__r.name, itm__r.RQ__r.Con__r.Department,
           T__r.name, iRef__c, A__c, createdbyid, createdby.name, T__r.Acc__r.name, T__r.Acc__r.lc__c,
           T__r.Acc__r.Prk__c, Request__c, itm__r.name, itm__r.itmCd__c,
               itm__r.xfid__c from g_TranItem__c where Tp__c = 'Claim' and Finance_Group__c in :financeGrpLst and DAY_ONLY(convertTimezone(createdDate)) = :ti.End_Date__c]) {
          TransAmnt t = new TransAmnt();
          t.ti = itm;
          t.amount = itm.A__c;
          if (!String.isBlank(itm.iRef__c))
            refLst.add(itm.iRef__c);
       // system.debug('itm.iRef__c::'+itm.iRef__c);
       if (itm.itm__r.itmCd__c == 'ep')
          epMp.put(itm.Request__c, t);
       else if (itm.itm__r.itmCd__c == 'ic')
          inCMp.put(itm.Request__c, t);
       else
         tranItmMap.put(itm.Request__c, t);
      /*  if (itm.iRef__c != null) {
            String str1 = itm.iRef__c.replace('x', '');
           tranItmMap.put(str1, itm);
        }*/

    }
   if (epMp != null && !epMp.isEmpty()) {
    for (String str : epMp.keySet()) {
       TransAmnt t =  epMp.get(str);
        if (inCMp != null && inCMp.containsKey(str)) {
            t.amount = t.amount + inCMp.get(str).amount;
        }
         tranItmMap.put(str, t);
   }
   }
  if (inCMp != null && !inCMp.isEmpty()) {
   for (String str : inCMp.keySet()) {
       TransAmnt t =  inCMp.get(str);
        if (epMp == null || epMp.isEmpty() || !epMp.containsKey(str)) {
             tranItmMap.put(str, t);
        }
   }
  }
      for (String str : tranItmMap.keySet()) {
          TransAmnt ta = tranItmMap.get(str);
          g_TranItem__c t = ta.ti;
           //reconcil__c t = tranItmMap.get(str);
           TransInfo ti = new TransInfo();
           ti.refNo =t.iRef__c;   //t.iRef__c.replace('x', '');
           ti.tranNo = t.T__r.name;
           ti.tItmId = t.id;
           ti.itmName = t.itm__r.name;
           ti.ownerName = t.createdby.name;
           ti.appName = t.itm__r.RQ__r.Con__r.name;
           ti.department = t.itm__r.RQ__r.Con__r.Department;
           ti.tranItmNo = t.name;
           ti.formIssuedate = t.itm__r.xfid__c;
           //ti.ownerName = t.usrName__c;  T__r.Acc__r.name, T__r.Acc__r.lc__c, T__r.Acc__r.Prk__c, Request__c
           ti.amount = String.valueOf(ta.amount);
           ti.reqNo = t.Request__c;
           ti.licence = t.T__r.Acc__r.lc__c;
           ti.accName = t.T__r.Acc__r.name;
           ti.brand = t.T__r.Acc__r.Prk__c;
          if (recMap != null && !String.isBlank(t.iRef__c) && recMap.containsKey(t.iRef__c)) {
              ti.amntDiff = recMap.get(t.iRef__c).key_4.substringBefore(' ');
              ti.Matched = true;
              ttlMAmount = ttlMAmount +  ta.amount;
              ttlDiffAmount = ttlDiffAmount + Decimal.valueOf(recMap.get(t.iRef__c).key_4.substringBefore(' '));
              trnLst.add(ti);
          }
           else{
               ti.Matched = false;
               ttlNMAmount = ttlNMAmount +  ta.amount;
               trnUnMatchLst.add(ti);
          }
       }
        for (String str : recMap.keySet()) {

          PdfRec t = recMap.get(str);
          if (refLst == null || refLst.isEmpty() || !refLst.contains(str)) {
              TransInfo ti = new TransInfo();
              ti.appNo = str;
              ti.amount = t.key_4.substringBefore(' ');
              if (fileType == 'EP-EDNRD')
                ti.refNo = t.key_3;
              else
                ti.refNo = t.key_6;
              ti.Matched = false;
               ttlappNMAmount = ttlappNMAmount + Decimal.valueOf(t.key_4.substringBefore(' '));
              appUnMatchLst.add(ti);
          }
       }
       ttlMCnt = trnLst.size(); ttlNMCnt = trnUnMatchLst.size(); ttlappNMCnt = appUnMatchLst.size();
       if (fileType != 'EIDA' && fileType != 'E-Vision')
       isRefValidate = true;
    }
       validate = false;
        isExport = true;
       return null;
   }

  public Set<String> reValidateTransactions(Map<string, PdfRec> stmtMap, Set<string> refidLst, Map<string, string> stmtAppMap, boolean revalidate) {
   Map<String, TransAmnt> inCMp = new Map<String, TransAmnt>();
   Map<String, TransAmnt> epMp = new Map<String, TransAmnt>();
   Map<string, TransAmnt> tranItmMap = new Map<string, TransAmnt>();
   Set<string> refLst = new Set<String>();
   Set<String> trnIdLst = new Set<String>();
   List<g_TranItem__c> trsnItmLst =  new List<g_TranItem__c>();
   if (revalidate)
     trsnItmLst = [select id, name, Item_Ref__c, itm__r.RQ__r.Full_Name__c, itm__r.RQ__r.Con__r.name,
         itm__r.RQ__r.Con__r.Department, T__r.name, iRef__c, A__c, createdbyid, createdby.name,
         T__r.Acc__r.name, T__r.Acc__r.lc__c, T__r.Acc__r.Prk__c, Request__c, itm__r.name,
         itm__r.itmCd__c, Finance_Group__c, itm__r.xfid__c from g_TranItem__c where Tp__c = 'Claim' and Finance_Group__c in ('RP-EDNRD',
         'EP-EDNRD', 'E-Vision') and createdDate >= LAST_N_DAYS:60 and Item_Ref__c = :refidLst];
   else
      trsnItmLst = [select id, name, Item_Ref__c, itm__r.RQ__r.Full_Name__c, itm__r.RQ__r.Con__r.name,
          itm__r.RQ__r.Con__r.Department, T__r.name, iRef__c, A__c, createdbyid, createdby.name,
          T__r.Acc__r.name, T__r.Acc__r.lc__c, T__r.Acc__r.Prk__c, Request__c, itm__r.name,
          itm__r.itmCd__c, Finance_Group__c, itm__r.xfid__c from g_TranItem__c where Tp__c = 'Claim' and Finance_Group__c in ('RP-EDNRD',
          'EP-EDNRD', 'E-Vision') and DAY_ONLY(convertTimezone(createdDate)) = :ti.End_Date__c];

   system.debug('revalidate::'+revalidate);
      // for (g_TranItem__c itm : [select id, name, iRef__c, A__c, createdbyid, createdby.name from g_TranItem__c where Tp__c = 'Claim' and Finance_Group__c in ('DNRD-Included', 'DNRD') and DAY_ONLY(convertTimezone(createdDate)) = :fromDate])
    //for (reconcil__c itm : [select id, name, iRef__c, A__c, createdbyid,    usrName__c from reconcil__c where Tp__c = 'Claim' and Finance_Group__c in :financeGrpLst and DAY_ONLY(convertTimezone(cdt__c)) = :fromDate])
      if (trsnItmLst != null && !trsnItmLst.isEmpty()) {
      for (g_TranItem__c itm : trsnItmLst ) {
          TransAmnt t = new TransAmnt();
          t.amount = itm.A__c;
          if (revalidate)
           itm.iRef__c = itm.Item_Ref__c;
           t.ti = itm;
          if (stmtMap != null && stmtMap.containsKey(itm.iRef__c) && !String.isBlank(itm.iRef__c)) {
              trnIdLst.add(validateNum(stmtMap.get(itm.iRef__c).key_0));
             /* if (itm.Finance_Group__c == 'RP-EDNRD')
               trnIdLst.add(stmtMap.get(itm.iRef__c).key_6);
              else if (itm.Finance_Group__c == 'EP-EDNRD')
               trnIdLst.add(stmtMap.get(itm.iRef__c).key_3);
              else
               trnIdLst.add(stmtMap.get(itm.iRef__c).key_0);  */
          }

       // system.debug('itm.iRef__c::'+itm.iRef__c);
       if (itm.itm__r.itmCd__c == 'ep')
          epMp.put(itm.Request__c, t);
       else if (itm.itm__r.itmCd__c == 'ic')
          inCMp.put(itm.Request__c, t);
       else
         tranItmMap.put(itm.id, t);
      /*  if (itm.iRef__c != null) {
            String str1 = itm.iRef__c.replace('x', '');
           tranItmMap.put(str1, itm);
        }*/

    }
     }
   if (epMp != null && !epMp.isEmpty()) {
    for (String str : epMp.keySet()) {
       TransAmnt t =  epMp.get(str);
        if (inCMp != null && inCMp.containsKey(str)) {
            t.amount = t.amount + inCMp.get(str).amount;
        }
         tranItmMap.put(str, t);
   }
   }
  if (inCMp != null && !inCMp.isEmpty()) {
   for (String str : inCMp.keySet()) {
       TransAmnt t =  inCMp.get(str);
        if (epMp == null || epMp.isEmpty() || !epMp.containsKey(str)) {
             tranItmMap.put(str, t);
        }
   }
  }
     for (String str : tranItmMap.keySet()) {
          TransAmnt ta = tranItmMap.get(str);
          g_TranItem__c t = ta.ti;
           //reconcil__c t = tranItmMap.get(str);
           TransInfo ti = new TransInfo();
           ti.refNo =t.iRef__c;   //t.iRef__c.replace('x', '');
           ti.tranNo = t.T__r.name;
           ti.tItmId = t.id;
           ti.itmName = t.itm__r.name;
           ti.ownerName = t.createdby.name;
           ti.appName = t.itm__r.RQ__r.Full_Name__c;
           ti.department = t.itm__r.RQ__r.Con__r.Department;
           ti.tranItmNo = t.name;
           ti.formIssuedate = t.itm__r.xfid__c;
           //ti.ownerName = t.usrName__c;  T__r.Acc__r.name, T__r.Acc__r.lc__c, T__r.Acc__r.Prk__c, Request__c
           ti.amount = String.valueOf(ta.amount);
           ti.reqNo = t.Request__c;
           ti.licence = t.T__r.Acc__r.lc__c;
           ti.accName = t.T__r.Acc__r.name;
           ti.brand = t.T__r.Acc__r.Prk__c;
           if (refLst != null && !refLst.isEmpty() && refLst.contains(t.iRef__c))
             ti.isDp = true;
           if (!String.isBlank(t.iRef__c))
            refLst.add(t.iRef__c);
          if (stmtMap != null && !String.isBlank(t.iRef__c) && stmtMap.containsKey(t.iRef__c)) {

              ti.amntDiff = stmtMap.get(t.iRef__c).key_4.substringBefore(' ').replace(', ', '');
              ti.Matched = true;
              if (stmtAppMap != null && !stmtAppMap.isEmpty() && stmtAppMap.containsKey(t.iRef__c))
              ti.appNo = stmtAppMap.get(t.iRef__c);
              ttlMAmount = ttlMAmount +  ta.amount;
              ttlDiffAmount = ttlDiffAmount + Decimal.valueOf(stmtMap.get(t.iRef__c).key_4.substringBefore(' ').replace(', ', ''));
              trnLst.add(ti);
          }
           else{
               ti.Matched = false;
               ttlNMAmount = ttlNMAmount +  ta.amount;
               trnUnMatchLst.add(ti);
          }
       }

    return trnIdLst;
  }
  public String docUpload(String nameFile, String parserId) {
       String strApiKey = gu.csStr('parserAPIKey'); 
    String strParserId =  parserId; //'vjngsoslebwk'; // 'vjngsoslebwk';
    String strTargetURL = 'https://api.docparser.com/v1/document/upload/' + strParserId + '?';
    String strSeparationKey = 'A_RANDOM_STRING';

   // assemble the body payload
    String strHeader = '--' + strSeparationKey + '\nContent-Disposition: form-data; name="file"; filename="TestClaim"\nContent-Type: application/octet-stream\n\n';
    String strBody = nameFile; // EncodingUtil.base64Encode(objPDF.Body);
    String strFooter = '\n--' + strSeparationKey + '--';

    String strHeaderEncoded = EncodingUtil.base64Encode(Blob.valueOf(strHeader+'\n'));
   while (strHeaderEncoded.endsWith('=')) {
    strHeader+=' ';
    strHeaderEncoded = EncodingUtil.base64Encode(Blob.valueOf(strHeader+'\n'));
   }
   String strBodyEncoded = strBody;
   String strFooterEncoded = EncodingUtil.base64Encode(Blob.valueOf(strFooter));

  Blob blobBody = null;
  String last4Bytes = strBodyEncoded.substring(strBodyEncoded.length()-4, strBodyEncoded.length());

  if (last4Bytes.endsWith('=')) {
    Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
    HttpRequest objHttpRequest = New HttpRequest();
    objHttpRequest.setBodyAsBlob(decoded4Bytes);
    String last4BytesFooter = objHttpRequest.getBody()+strFooter;
    blobBody = EncodingUtil.base64Decode(strHeaderEncoded+strBodyEncoded.substring(0, strBodyEncoded.length()-4)+EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
   } else {
     blobBody = EncodingUtil.base64Decode(strHeaderEncoded+strBodyEncoded+strFooterEncoded);
  }

  if (blobBody.size()>gu.csNum('parserFileSize')) { // 3000000
   // throw new CustomException('File size limit is 3 MBytes');
     system.debug('File size limit is 3 MBytes');
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'File size is too large. File size limit is 3MB .'));
      return null;
   }else{
     system.debug('blobBody.size()'+blobBody.size());
  }

   // send out the request
   HttpRequest req = New HttpRequest();
   req.setHeader('Content-Type', 'multipart/form-data; boundary=' + strSeparationKey);
   req.setHeader('Authorization', 'Basic ' + strApiKey);
   req.setMethod('POST');
        req.setEndpoint('callout:ClaimValidation_API');
   req.setBodyAsBlob(blobBody);
   req.setHeader('Content-Length', String.valueof(req.getBodyAsBlob().size()));
   Http http = New Http();
   HTTPResponse res = http.send(req);
   String resStr = res.getBody();
      system.debug('res'+resStr);
   string documentId = '';
   if (resStr != null && resStr != '') {
       ClaimValidate.DocParser obj = (ClaimValidate.DocParser) Json.deserialize(resStr, ClaimValidate.DocParser.class);
       documentId = obj.id;
    }
    return documentId;
  }

  public PageReference appNoUpload() {
     trnLst = new List<TransInfo>();
     trnUnMatchLst = new List<TransInfo>();
      if (string.isBlank(fileType)) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select fileType'));
        return null;
      }

      if (fileType == 'EIDA')
          appValidate();
      else if (fileType == 'All') {
          if (string.isBlank(nameFile) || string.isBlank(nameStmtFile) || string.isBlank(ePFile)) {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please upload File.'));
             return null;
           }
         nameFile= EncodingUtil.base64Encode(contentFile);
         docId = docUpload(nameFile, gu.csStr('parserAppDocId'));
         eVFile= EncodingUtil.base64Encode(contentStmtFile);
         eVDocId = docUpload(eVFile, gu.csStr('parserEVisionId'));
         ePFile= EncodingUtil.base64Encode(contentEPFile);
         ePDocId = docUpload(ePFile, gu.csStr('parserVISAId'));
         nameStmtFile= EncodingUtil.base64Encode(contentStmtFile);
         stmtDocId = docUpload(nameStmtFile, gu.csStr('parserStmtDocId'));
        validate = true;
      }
      else if (fileType == 'RP-EDNRD') {
          if (string.isBlank(nameFile) || string.isBlank(nameStmtFile) ) {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please upload File.'));
             return null;
           }
           nameFile= EncodingUtil.base64Encode(contentFile);
           docId = docUpload(nameFile, gu.csStr('parserAppDocId'));
           nameStmtFile= EncodingUtil.base64Encode(contentStmtFile);
           stmtDocId = docUpload(nameStmtFile, gu.csStr('parserStmtDocId'));
          validate = true;
      }
      else if (fileType == 'EP-EDNRD') {

           if (string.isBlank(ePFile) || string.isBlank(nameStmtFile) ) {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please upload File.'));
             return null;
           }
           ePFile= EncodingUtil.base64Encode(contentEPFile);
           ePDocId = docUpload(ePFile, gu.csStr('parserVISAId'));
           nameStmtFile= EncodingUtil.base64Encode(contentStmtFile);
           stmtDocId = docUpload(nameStmtFile, gu.csStr('parserStmtDocId'));
           validate = true;
      }
      else if (fileType == 'E-Vision') {
           if (string.isBlank(nameStmtFile) ) {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please upload File.'));
             return null;
           }
            eVFile= EncodingUtil.base64Encode(contentStmtFile);
            eVDocId = docUpload(eVFile, gu.csStr('parserEVisionId'));
           nameStmtFile= EncodingUtil.base64Encode(contentStmtFile);
           stmtDocId = docUpload(nameStmtFile, gu.csStr('parserStmtDocId'));
           validate = true;
      }
      else{
         nameFile= EncodingUtil.base64Encode(contentFile);
        docId = docUpload(nameFile, getParserId()); //'ljyqedcmjgqy' vjngsoslebwk
       system.debug('docId2::'+docId);
      if (fileType != 'E-Vision') {
         if (string.isBlank(nameStmtFile)) {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please upload File.'));
           return null;
         }
         nameStmtFile= EncodingUtil.base64Encode(contentStmtFile);
         stmtDocId = docUpload(nameStmtFile, gu.csStr('parserStmtDocId')); //'upjozesttuwx' qayxfmcvnwfh
         system.debug('stmtDocId::'+stmtDocId);
      }
       validate = true;

      }
      Pagereference ref = Page.ClaimValidate1;
      return ref;
  }
    Public string getParserId () {
        String parserId = '';
        if (fileType == 'EIDA')
            parserId = gu.csStr('parserEIDAId');
        else if (fileType == 'EP-EDNRD')
            parserId = gu.csStr('parserVISAId');
        else if (fileType == 'E-Vision')
            parserId = gu.csStr('parserEVisionId');
        else
            parserId = gu.csStr('parserAppDocId');
        return parserId;
    }
  public static List<List<String>> parseCSV(String contents, Boolean skipHeaders) {
     List<List<String>> allFields = new List<List<String>>();
    contents = contents.replaceAll(', """', ', "DBLQT').replaceall('""", ', 'DBLQT", ');
    contents = contents.replaceAll('""', 'DBLQT');

    List<String> lines = new List<String>();
    try {
        lines = contents.split('\n');
    } catch (System.ListException e) {
        System.debug('Limits exceeded?' + e.getMessage());
    }
    system.debug('Line num i s'+lines.size());
    Integer num = 0;
    for (String line : lines) {
        system.debug('line::'+line);
        line = line.replaceAll(', ', '').replaceAll('\'', '').replaceAll('"', '');

        if (line.replaceAll(', ', '').trim().length() == 0) break;

        List<String> fields = line.split(', ');
        system.debug('fields::'+fields);
        List<String> cleanFields = new List<String>();
        String compositeField;
        Boolean makeCompositeField = false;
        for (String field : fields) {
            if (field.startsWith('"') && field.endsWith('"')) {
                cleanFields.add(field.replaceAll('DBLQT', '"'));
            } else if (field.startsWith('"')) {
                makeCompositeField = true;
                compositeField = field;
            } else if (field.endsWith('"')) {
                compositeField += ', ' + field;
                cleanFields.add(compositeField.replaceAll('DBLQT', '"'));
                makeCompositeField = false;
            } else if (makeCompositeField) {
                compositeField +=  ', ' + field;
            } else {
                cleanFields.add(field.replaceAll('DBLQT', '"'));
            }
        }
        system.debug('cleanFields::'+cleanFields);
        allFields.add(cleanFields);
    }
    if (skipHeaders) allFields.remove(0);
    return allFields;
 }
  Public PageReference nextPage() {
        PageReference ref = null;
         trnLst = new List<TransInfo>();

        ref =Page.ClaimAppNoValidate; //new PageReference('/apex/ClaimAppNoValidate');
        //ref.setRedirect(true);
        return ref;

     }
    public String validateNum(String str) {
       /* String str1 = '';
       if (!String.isBlank(str))
        str1 = str.replaceAll('\\D', '');
      return  str1; */
         Pattern nonAlphanumeric = Pattern.compile('[^a-zA-Z0-9]');
        Matcher matcher = nonAlphanumeric.matcher(str);
         return matcher.replaceAll('');
    }

   /* public List<selectOption> getFGLst() {
        List<selectOption> lst = new List<selectOption>();
        lst.add(new selectOption('', '---Select---'));
        lst.add(new selectOption('DNRD', 'DNRD'));
        lst.add(new selectOption('EIDA', 'EIDA'));
        lst.add(new selectOption('Med', 'Medical'));
        return lst;

    }*/
   public Pagereference exportDetails() {
       Pagereference ref = Page.CliamInfoExport;
       return ref;
   }
    public class TransAmnt {
        public g_TranItem__c ti {set;get;}
        public decimal amount {set;get;}
    }
    public class TransInfo{
        public string tranNo {set;get;}
        public string refNo {set;get;}
        public string appNo {set;get;}
        public string amount {set;get;}
        public string amntDiff {set;get;}
        public string reqNo {set;get;}
        public string licence {set;get;}
        public string accName {set;get;}
        public string appName {set;get;}
        public string department {set;get;}
        public string tranItmNo {set;get;}
        public string itmName {set;get;}
        public string brand {set;get;}
        public id ownerid {set;get;}
        public id tItmId {set;get;}
        public string ownerName {set;get;}
        public Date formIssuedate {set;get;}
        public boolean Matched {set;get;}
        public boolean isDp {set;get;}
    }

    public class PdfInfo{
        public List<PdfRec> table_data {set;get;}
    }
    public class PdfRec {
        public string key_0 {set;get;}
        public string key_1 {set;get;}
        public string key_2 {set;get;}
        public string key_3 {set;get;}
        public string key_4 {set;get;}
        public string key_5 {set;get;}
        public string key_6 {set;get;}
    }
    public class DocParser {
        public string id {set;get;}
    }

}