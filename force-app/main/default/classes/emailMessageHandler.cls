public class emailMessageHandler {

    public static string SUPPORT_AXS = 'support@axs.ae';
    public static string CUST_CARE_TG = 'customercare@tecomgroup.ae';
    public static string CUST_CARE_DDD = 'customercare@dubaidesigndistrict.com';
    public static string INFO_TG = 'info@tecomgroup.ae';
    public static string LEASING_ENQUIRY = 'leasing.enquiry@dham.ae';
    public static string UPDATE_CONTACTS = 'updatecontacts@dham.ae';
    public static string ONLINE_DHAM = 'online@dham.ae';

    public static string UPDATE_CONTACT_TECOM='updatecontacts@tecom.ae';
    public static string INFO_TECOM = 'info@tecom.ae';
    public static string SUPPORT_DHAM = 'support@dham.ae';
    public static string SUPPORT_TECOM = 'axssupport@tecom.ae';
    public static string SUPPORT_TECOM_GRP = 'axssupport@tecomgroup.ae';
    public static string CUST_CARE_TECOM = 'customercare@tecom.ae';
    public static string LEASING_ENQUIRY_TECOM = 'leasingenquiry@tecom.ae';
    public static string LEASING_ENQ_TECOM = 'leasing.enquiry@tecom.ae';
    public static string LEASING_ENQUIRY_TECOM_GRP = 'leasing.enquiry@tecomgroup.ae';

    public static void updateCase(list < emailMessage > emList) {
        string toeml = '';
        string cceml = '';
        list <case> caseList = new list <case> ();
        set < id > emIDs = new set < id > ();
        for (emailMessage objEM: emList) {
            if (objEM.Incoming && objEM.ParentId != null) emIDs.add(objEM.id);
        }
        List < emailMessage > emessageList = new List < emailMessage > ([select id, ParentId,
            ToAddress, CCAddress, status, parent.status, incoming from emailMessage where id in: emIDs and parent.origin = 'Email']);
        for (emailMessage objEM: emessageList) {
            case objcs = new
            case ();
            objcs.id = objEM.ParentId;
            objcs.lemi__c = objEM.id;
            if (!string.isblank(objEM.ToAddress)) toeml = objEM.ToAddress;
            if (!string.isblank(objEM.ccAddress)) cceml = objEM.CCAddress;
            if (toeml.contains(SUPPORT_AXS)  ||toeml.contains(SUPPORT_TECOM) || toeml.contains(SUPPORT_TECOM_GRP) || toeml.contains(SUPPORT_DHAM)) { toeml = SUPPORT_AXS; }
            else if (toeml.contains(CUST_CARE_TG) || toeml.contains(CUST_CARE_TECOM)) {
                toeml = CUST_CARE_TG;
            }
            else if (toeml.contains(CUST_CARE_DDD)) {
                toeml = CUST_CARE_DDD;
            }
            else if (toeml.contains(INFO_TG) || toeml.contains(INFO_TECOM)) {
                toeml = INFO_TG;
            }
           else if (toeml.contains(LEASING_ENQUIRY) || toeml.contains(LEASING_ENQUIRY_TECOM) ||toeml.contains(LEASING_ENQ_TECOM) || toeml.contains(LEASING_ENQUIRY_TECOM_GRP)) {
               toeml = LEASING_ENQUIRY_TECOM_GRP;
           }
           else if (toeml.contains(UPDATE_CONTACTS) ||toeml.contains( UPDATE_CONTACT_TECOM)) {
               toeml = UPDATE_CONTACTS;
           }
           else if (toeml.contains(ONLINE_DHAM)) {
               toeml = ONLINE_DHAM;
           }
           else if (cceml.contains(SUPPORT_AXS) || cceml.contains(SUPPORT_TECOM) || cceml.contains(SUPPORT_TECOM_GRP) || cceml.contains(SUPPORT_DHAM)) {
               toeml = SUPPORT_AXS;
           }
           else if (cceml.contains(CUST_CARE_TG) || cceml.contains(CUST_CARE_TECOM)) {
               toeml = CUST_CARE_TG;
           }
           else if (cceml.contains(CUST_CARE_DDD)) {
               toeml = CUST_CARE_DDD;
           }
           else if (cceml.contains(INFO_TG) || cceml.contains(INFO_TECOM)) {
               toeml = INFO_TG;
           }
           else if (cceml.contains(LEASING_ENQUIRY)|| cceml.contains(LEASING_ENQUIRY_TECOM) || cceml.contains(LEASING_ENQ_TECOM) || cceml.contains(LEASING_ENQUIRY_TECOM_GRP)) {
               toeml = LEASING_ENQUIRY_TECOM_GRP;
           }
           else if (cceml.contains(UPDATE_CONTACTS) || toeml.contains( UPDATE_CONTACT_TECOM)) {
               toeml = UPDATE_CONTACTS;
           }
           else if (cceml.contains(ONLINE_DHAM)) {
               toeml = ONLINE_DHAM;
           }
           else if (!toeml.contains(SUPPORT_AXS) || !toeml.contains(CUST_CARE_TG) || !toeml.contains(CUST_CARE_DDD) || !toeml.contains(INFO_TG) ||  !toeml.contains(INFO_TECOM) || !toeml.contains(LEASING_ENQUIRY) ||!toeml.contains(UPDATE_CONTACTS) || !toeml.contains( UPDATE_CONTACT_TECOM) || !toeml.contains(ONLINE_DHAM) || !cceml.contains(SUPPORT_AXS) || !cceml.contains(CUST_CARE_TG) || !cceml.contains(CUST_CARE_DDD) || !cceml.contains(INFO_TG) || !cceml.contains(LEASING_ENQUIRY) ||!cceml.contains(UPDATE_CONTACTS) || !cceml.contains(ONLINE_DHAM)) {
               toeml = '';
           }
            objcs.Division__c = toeml == SUPPORT_AXS ? 'AXS' : 'Brand'; //support@axs.ae axs.suportt@gmail.com
            objcs.To_Email__c = toeml;
            if (objEM.parent.status == 'Waiting for Client') {
                objcs.status = 'Client Answered Back';
            }
            caseList.add(objcs);
        }
        if (Schema.sObjectType.Case.isUpdateable()) { if (caseList != null && !caseList.isEmpty() && caseList.size() > 0) update caseList; }
    }
    public static void appendCaseNumber(list < emailMessage > emList) {
        set < id > caseIds = new set < id > ();
        list <
            case > caseList = new list <
            case > ();
        for (emailMessage objEM: emList) {
            if (!string.isblank(objEM.ParentId)) caseIds.add(objEM.ParentId);
        }
        if (caseIds != null) {
            caseList = [select id, CaseNumber, origin from
                case where id in: caseIds limit 1
            ];
            for (emailMessage objEM: emList) {
                if (caseList != null && !caseList.isEmpty() && !objEM.Subject.contains(caseList[0].CaseNumber)) {
                    objEM.Subject = caseList[0].CaseNumber + ' ' + objEM.Subject;
                }
            }
        }
    }

}