public class grqStaHisCnt {
    public g_Req__c rq {
        get;
        set;
    }
    public List < g_itmHistorySTA__c > lstrefHis {
        get;
        set;
    }
    public FusionRes objFusionRes {
        get;
        set;
    }
    public g_TranItem__c objTrItm {
        get;
        set;
    }
    public string approvedBy {
        get;
        set;
    }
    public g_reqitem__c objRfItm {
        get;
        set;
    }
    public Decimal approvedamt {
        get;
        set;
    }
    public grqStaHisCnt() {
        string rqid = 'a0EFf000000whUPMAY';
        try {
            rq = [Select xnaf__c, xoca__c, Account_Name__c, xvtyp__c, xtpa__c, xet__c, xst__c,
                xrsv__c, xuvdet__c, hpr__c, Reason__c, Con__c, xchn__c, xrap__c, prf__c, csp__c,
                i_STA__c, Id, xdcmt__c, xanum__c, Name, STA__c, AT__c, AP__c, AOP__c, rmob__c, xawb__c,
                xaloc__c, xbrnd__c, xbn__c, nt__c, xadh__c, xceml__c, xcemrt__c, xcfn__c, xcln__c,
                xcmob__c, xcof__c, xcot__c, xcp__c, xcped__c, xcpid__c, xcpic__c, xcpip__c, xcbp__c,
                xcnp__c, xcrlg__c, xcslt__c, xclng__c, xcstrt__c, xcmta__c, xdedc__c, xdedln__c,
                xosa__c, xphid__c, xcs__c, xcn__c, Zone__c, xrp__c, acc__r.bacnm__c, acc__r.banum__c,
                acc__r.iban__c, acc__r.bandb__r.Name, acc__r.basft__c, acc__r.bandb__r.ccode__c,
                acc__r.bfrc__c, acc__r.bfsc__c, acc__r.bifc__c, (select id, Name, xped__c, xst__c,
                xet__c, sta__c, sta__r.name, sta__r.cd__c From Items__r where itm__r.cd__c = 'apt' and IsDeleted = false order by itm__r.ord__c) From g_Req__c where id =: rqid];
        }
        catch (exception ex) {
        }
        getrefundHistory();
    }
    public grqStaHisCnt(ApexPages.StandardController c) {
        string rqid = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('id'));
        rq = [Select xnaf__c, xoca__c, Account_Name__c, xvtyp__c, xtpa__c, xet__c, xst__c,
            xrsv__c, xuvdet__c, hpr__c, Reason__c, Con__c, xchn__c, xrap__c, prf__c, csp__c,
            i_STA__c, Id, xdcmt__c, xanum__c, Name, STA__c, AT__c, AP__c, AOP__c, rmob__c, xawb__c,
            xaloc__c, xbrnd__c, xbn__c, nt__c, xadh__c, xceml__c, xcemrt__c, xcfn__c, xcln__c,
            xcmob__c, xcof__c, xcot__c, xcp__c, xcped__c, xcpid__c, xcpic__c, xcpip__c, xcbp__c,
            xcnp__c, xcrlg__c, xcslt__c, xclng__c, xcstrt__c, xcmta__c, xdedc__c, xdedln__c,
            xosa__c, xphid__c, xcs__c, xcn__c, Zone__c, xrp__c, acc__r.bacnm__c, acc__r.banum__c,
            acc__r.iban__c, acc__r.bandb__r.Name, acc__r.basft__c, acc__r.bandb__r.ccode__c,
            acc__r.bfrc__c, acc__r.bfsc__c, acc__r.bifc__c, (select id, Name, xped__c, xst__c,
            xet__c, sta__c, sta__r.name, sta__r.cd__c From Items__r where itm__r.cd__c = 'apt' and IsDeleted = false order by itm__r.ord__c) From g_Req__c where id =: rqid];
        getrefundHistory();
    }
    public void getrefundHistory() {
        list < g_reqitem__c > lstreqItem = [select id, name, itm__r.cd__c, xramt__c, xcnotes__c,
            (select id, T__r.name from Transactions__r) from g_reqitem__c where RQ__c =: rq.id and itm__r.cd__c = 'rf'];
        objRfItm = lstreqItem[0];
        approvedamt = lstreqItem[0].xramt__c == null ? rq.xtpa__c : lstreqItem[0].xramt__c;
        lstrefHis = [Select id, f__c, f__r.name, t__c, t__r.name, acts__c, actE__c, CreatedBy.name from g_itmHistorySTA__c where RQ__c =: rq.id];
        for (g_itmHistorySTA__c objSt: lstrefHis) {
            if (objSt.t__r.name == 'Approved') {
                approvedBy = objSt.CreatedBy.Name;
            }
        }
        objTrItm = lstreqItem[0].Transactions__r[0];
        list < ws_Call__c > lstws = [Select id, rq_jsn__c, res_jsn__c,
            mtd_nm__c, ws_typ__c from ws_call__c where rq_itm__c IN: lstreqItem and mtd_nm__c = 'CustomerRefund' and ws_typ__c = 'CreateCDBGREF' and intsts__c = 'Success' order by createddate desc limit 1 ];
        if (lstws != null && !lstws.isEmpty() && lstws[0].res_jsn__c != null) {
            /*String json=       '{"MESSAGE":"Number Receipts - 4 & Instance ID -488WDijItEfCBbFu_idhU9AHeader ID # 783", "STATUS":"Success", "REFUND_REFERENCES":[{"AP_INVOICE_DESCRIPTION":"Receipt Response =807", "AP_INVOICE_ID":3792285, "AP_INVOICE_AMOUNT":2263713.92, "AP_INVOICE_REFERENCE":4383269, "AP_INVOICE_STATUS":"APP"}, {"AP_INVOICE_DESCRIPTION":"Receipt Response =808", "AP_INVOICE_ID":3793287, "AP_INVOICE_AMOUNT":63639.29, "AP_INVOICE_REFERENCE":4384271, "AP_INVOICE_STATUS":"APP"}, {"AP_INVOICE_DESCRIPTION":"Receipt Response =809", "AP_INVOICE_ID":3793288, "AP_INVOICE_AMOUNT":172959.37, "AP_INVOICE_REFERENCE":4384272, "AP_INVOICE_STATUS":"APP"}, {"AP_INVOICE_DESCRIPTION":"Receipt Response =810", "AP_INVOICE_ID":3793289, "AP_INVOICE_AMOUNT":5000.0, "AP_INVOICE_REFERENCE":4384273, "AP_INVOICE_STATUS":"UNAPP"}], "REFUNDTYPE":"DEP", "REFUNDAMOUNT":2505312.58, "REFUNDREFERENCEID":"T2025053795190", "ACCOUNTNUMBER":"TDD-11313"}';
            */ String res = lstws[0].res_jsn__c;
            try {
                objFusionRes = (FusionRes) JSON.deserialize(res, FusionRes.class);
                system.debug('objFusionRes===' + objFusionRes);
            }
            catch (exception ex) {
                system.debug('Error===' + ex.getMessage());
            }
        }
    }
    class FusionRes {
        public String MESSAGE {
            get;
            set;
        }
        public String STATUS {
            get;
            set;
        }
        public list < REFUND_REFERENCES > REFUND_REFERENCES {
            get;
            set;
        }
        public String REFUNDTYPE {
            get;
            set;
        }
        public Double REFUNDAMOUNT {
            get;
            set;
        }
        public String REFUNDREFERENCEID {
            get;
            set;
        }
        public String ACCOUNTNUMBER {
            get;
            set;
        }
    }
    class REFUND_REFERENCES {
        public String AP_INVOICE_DESCRIPTION {
            get;
            set;
        }
        public Integer AP_INVOICE_ID {
            get;
            set;
        }
        public Double AP_INVOICE_AMOUNT {
            get;
            set;
        }
        public Integer AP_INVOICE_REFERENCE {
            get;
            set;
        }
        public String AP_INVOICE_STATUS {
            get;
            set;
        }
    }
}