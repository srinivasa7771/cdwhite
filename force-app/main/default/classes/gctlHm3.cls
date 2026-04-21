public with sharing class gctlHm3 {

    /* ============================================================
     *  Simple properties
     * ============================================================ */
    public String  licCopy        { get; set; }
    public String  parkingString  { get; set; }
    public String  days           { get; set; }
    public String  status         { get; set; }
    public User    U              { get; set; }
    public Account A              { get; set; }
    public g_Req__c rq            { get; set; }
    public Boolean pgHide         { get; set; }
    public Boolean ispu           { get; set; }

    public String lcl { get { return UserInfo.getLocale(); } }

    public Decimal minBG { get { return gU.csCurr('minBG'); } }
    public Decimal maxBG { get { return gU.csCurr('maxBG'); } }

    /* ------------------------------------------------------------
     *  Counters  (all default to 0)
     * ------------------------------------------------------------ */
    public Decimal VVU       { get; set; } { VVU       = 0; }
    public Decimal cD        { get; set; } { cD        = 0; } // Draft RQs
    public Decimal cO        { get; set; } { cO        = 0; } // Open RQs
    public Decimal cR        { get; set; } { cR        = 0; } // Under-Review RQs
    public Decimal cP        { get; set; } { cP        = 0; } // In-Process RQs
    public Decimal cH        { get; set; } { cH        = 0; } // On-Hold RQs
    public Decimal cC        { get; set; } { cC        = 0; } // Need-Correction RQs
    public Decimal cOD       { get; set; } { cOD       = 0; } // Contacts need update attribute
    public Decimal cRPExp    { get; set; } { cRPExp    = 0; } // Expired RPs
    public Decimal cPSExp    { get; set; } { cPSExp    = 0; } // Expired Passports
    public Decimal cPSExp30  { get; set; } { cPSExp30  = 0; } // Passports expiring next 30 days
    public Decimal cRPExp30  { get; set; } { cRPExp30  = 0; } // RPs expiring next 30 days

    public Date leaseDt { get; set; }

    /* ------------------------------------------------------------
     *  Collections
     * ------------------------------------------------------------ */
    public List<g_Req__c> notificationRqs   { get; set; }
    public List<g_Req__c> notificationRqs3  { get; set; }
    public List<g_Req__c> rcRqs             { get; set; }
    public List<g_Req__c> draftRqs          { get; set; }
    public List<g_Req__c> allDPRqs          { get; set; }
    public List<g_Req__c> pendingRqs        { get; set; }
    public List<g_Req__c> draftRq5          { get; set; }
    public List<g_Req__c> pendingRq5        { get; set; }
    public List<g_Req__c> allRqs            { get; set; }
    public List<g_Req__c> openNopmntRqs     { get; set; }

    public String  pageNo { get; set; }

    public Integer RecordsPerPageslist {
        get;
        set {
            if (value != null) {
                RecordsPerPageslist = value;
            }
        }
    }

    public Integer PageNumber {
        get {
            PageNumber = stdSetController.getPageNumber();
            return PageNumber;
        }
        set {
            stdSetController.setPageNumber(value);
        }
    }

    public Boolean isCI          { get; set; }
    public String  poBox         { get; set; }
    public String  orclId        { get; set; }
    public Integer mScSize       { get; set; }
    public Boolean mScHasVal     { get; set; }
    public String  prsn          { get; set; }
    public String  dat           { get; set; }
    public String  sta           { get; set; }
    public String  isPendingTab  { get; set; }
    public String  searchCriet   { get; set; }
    public String  accidonload   { get; set; }

    public List<Contact>                           contLst         { get; set; }
    public List<loc__c>                            locLst          { get; set; }
    public List<grqWsDccaGetService.Records>       tecomLeaseList  { get; set; }
    public Map<String, String>                     finalAgreeLoc   { get; set; }
    public List<g_Tran__c>                         tsLst           { get; set; }
    public List<myAccount>                         myAccountLst    { get; set; }
    public List<String>                            licList         { get; set; }
    public Map<String, User>                       uidUsrname      { get; set; }

    /* ============================================================
     *  Constructor
     * ============================================================ */
    public gctlHm3() {
        try {
            System.debug('In >> gctlHm3()');
            ispu   = gU.isPortalUser(UserInfo.getProfileId());
            pgHide = !ispu;
            System.debug('In >> Calling init()');
            init();
        } catch (Exception ex) {
            gU.AddErrorMsg(ex);
            System.debug('gctlHm3 >> Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            pgHide = true;
        }
        System.debug('Out >> gctlHm3()');
    }

    private void init() {
        System.debug('In >> init()');
        try {
            if (ispu) {
                loadData(false);
            }
            gU.checkNav();
        } catch (Exception ex) {
            gU.AddErrorMsg(ex);
            System.debug('init >> Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            pgHide = true;
        }
        System.debug('Out >> init()');
    }

    /* ============================================================
     *  obr  (on-board redirect)
     * ============================================================ */
    public PageReference obr() {
        String srvcUid = '216';

        U = [SELECT Id, AccountId,
                    Contact.Account.Id,
                    Contact.Account.os__c,
                    Contact.Account.Prk__c,
                    Contact.Account.Type
               FROM User
              WHERE Id = :UserInfo.getUserId()
              LIMIT 1];

        System.debug('usr >> ' + U);
        System.debug('srvcUid >> ' + srvcUid);

        if (U.Contact != null
                && U.Contact.Account != null
                && U.Contact.Account.os__c != null
                && U.Contact.Account.os__c != 'Completed') {

            List<g_Req__c> req1 = [SELECT Id, Name
                                     FROM g_Req__c
                                    WHERE Acc__c = :U.Contact.Account.Id
                                      AND srvc__r.uid__c = :srvcUid
                                      AND sta__c NOT IN ('Completed', 'Cancelled', 'Rejected')];
            System.debug('req1 >> ' + req1);

            if (!req1.isEmpty()) {
                PageReference pageRef = null;
                if (srvcUid == '216') {
                    pageRef = new PageReference('/grqob?id=' + req1[0].Id + '&m=e');
                    pageRef.setRedirect(true);
                }
                System.debug('pageRef >> ' + pageRef);
                return pageRef;
            }
        }
        return null;
    }

    /* ============================================================
     *  loadData
     * ============================================================ */
    private void loadData(Boolean isnw) {
        System.debug('In >> loadData()');

        licList = new List<String>{
            'License Under Renewal',
            'License Issued',
            'License Approved',
            'License Cancelled'
        };
        RecordsPerPageslist = 10;

        String url = ApexPages.currentPage().getURL();
        if (url.contains('pagepastrequests') || url.contains('pendingactions')) {
            String flg = ApexPages.currentPage().getParameters().get('flg');
            if (flg == 'pndg')      isPendingTab = 'pndg';
            else if (flg == 'drft') isPendingTab = 'drft';
        }

        U = [SELECT Id, FirstName, LastName, AccountId, LastPasswordChangeDate, LastLoginDate,
                    Contact.Photo_ID__c,
                    Contact.Account.Id, Contact.Account.on__c, Contact.Account.onar__c,
                    Contact.Account.Website, Contact.Account.vespe__c, Contact.Account.vespex__c,
                    Contact.Account.vetemp__c, Contact.Account.vbtemp__c, Contact.Account.vetst__c,
                    Contact.Account.vespst__c, Contact.Account.vespstx__c, Contact.Account.vbtst__c,
                    Contact.Account.vev__c, Contact.Account.mxPortalUsers__c, Contact.Account.Name,
                    Contact.Account.Email__c, Contact.Account.lPrk__c, Contact.Account.Building_Name__c,
                    Contact.Account.xcublg__c, Contact.Account.Location__c,
                    Contact.Account.Location_Cluster__c, Contact.Account.xcuzn__c,
                    Contact.Account.Phone, Contact.Account.Type, Contact.Account.Prk__c,
                    Contact.Account.adb__c, Contact.Account.info__c, Contact.Account.bgnr__c,
                    Contact.Account.bg__c, Contact.Account.bgc__c, Contact.Account.bgcabsc__c,
                    Contact.Account.bgb__c, Contact.Account.vctemp__c, Contact.Account.speabsc__c,
                    Contact.Account.vctst__c, Contact.Account.sncNt__c, Contact.Account.vbvv__c,
                    Contact.Account.lcidt1__c, Contact.Account.ec__c, Contact.Account.ecidt__c,
                    Contact.Account.lctp__c, Contact.Account.ecedt__c, Contact.Account.lcedt__c,
                    Contact.Account.lcsnc__c, Contact.Account.lcsncnt__c,
                    Contact.Account.Legal_Framework__c, Contact.Account.psasnc__c,
                    Contact.Account.psasncnt__c, Contact.Account.lcsta__c, Contact.Account.ecsnc__c,
                    Contact.Account.ecsncnt__c, Contact.Account.lcrndt__c, Contact.Account.cosnc__c,
                    Contact.Account.cosncnt__c, Contact.Account.licexdt__c, Contact.Account.licIdt__c,
                    Contact.Account.bgsnc__c, Contact.Account.bgsncnt__c, Contact.Account.snc__c,
                    Contact.Account.voep__c, Contact.Account.lc__c,
                    Contact.Account.ORACLE_PARTY_ID__c, Contact.Account.rpa__c,
                    Contact.Account.os__c, Contact.Account.adob__c, Contact.Account.adx__c,
                    Contact.Account.adc__c
               FROM User
              WHERE Id = :UserInfo.getUserId()
              LIMIT 1];

        A = U.Contact.Account;
        if (A.ORACLE_PARTY_ID__c != null) orclId = A.ORACLE_PARTY_ID__c;

        List<g_Req__c> rqLst = [SELECT Id, Name, STA__c, AP__c, xtpa__c, AOP__c, xadh__c,
                                       (SELECT Id FROM Attachments ORDER BY LastModifiedDate DESC LIMIT 1)
                                  FROM g_Req__c
                                 WHERE Acc__c = :A.Id
                                   AND STA__c IN ('Draft', 'Open', 'Under Review', 'In Process', 'Completed')
                                   AND srvc__r.uid__c = '208'
                                 ORDER BY LastModifiedDate DESC
                                 LIMIT 1];
        if (!rqLst.isEmpty()) rq = rqLst[0];

        /* Null-safe Type check -> avoids NPE if Type is null */
        String accType = (A.Type == null) ? '' : A.Type;
        if (!accType.equalsIgnoreCase('Customer - Incubation')
                && !accType.equalsIgnoreCase('Customer - Member')) {
            getRQs();
            getRCRQs();
            getdraftRQs();
            getpendingRQs();
            getnotificationRQs();
            getallDPRQs();
            getallDPRqs1();
        }
    }

    /* ============================================================
     *  Renewal links
     * ============================================================ */
    public Map<String, String> renewLinkMap { get; set; }
    public Boolean             showRenewal  { get; set; }

    public void setRenewalRequest() {
        renewLinkMap = new Map<String, String>();
        List<g_Req__c> rqRenLst = [SELECT Id, Acc__c, srvc__c, Service_Code__c, xadh__c
                                     FROM g_Req__c
                                    WHERE Acc__c = :U.Contact.Account.Id
                                      AND Service_Code__c = '223'
                                    LIMIT 499];
        for (g_Req__c rqren : rqRenLst) {
            renewLinkMap.put('Click Here for Renewal',
                             '/apex/ddfcRenewal?id=' + rqren.Id + '&m=v');
            showRenewal = true;
        }
        System.debug('renewLinkMap >> ' + renewLinkMap);
    }

    /* ============================================================
     *  Parking
     * ============================================================ */
    public List<ParkingM.ParkingDetails_m> lst_pdClone { get; set; }
    public List<ParkingM.ParkingDetails_m> lst_pd      { get; set; }

    public PageReference loadCards2(String oid) {
        lst_pd = new parkingM().loadCards(oid);
        if (lst_pd != null && !lst_pd.isEmpty()) {
            parkingString = JSON.serialize(lst_pd);
        }
        System.debug('parkingString >> ' + parkingString);
        return null;
    }

    public Map<String, Integer> el         { get; set; }
    public Boolean              isPRavail  { get; set; }

    public void getParkings(Account acc) {
        try {
            ParkingM p = new ParkingM();
            el = p.getEligibility(acc);
            System.debug('EL : ' + el);
        } catch (Exception ex) {
            System.debug('Exception : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }

        List<g_Req__c> renewlReq = [SELECT Id, Name
                                      FROM g_Req__c
                                     WHERE Acc__c = :U.AccountId
                                       AND STA__c = 'Draft'
                                       AND Service_Code__c = '156'
                                     LIMIT 1];
        isPRavail = !renewlReq.isEmpty();
    }

    /* ============================================================
     *  Contact-info
     * ============================================================ */
    public void getConInfo() {
        isCI = false;
        List<coninfo__c> lstCI = [SELECT Id, Name__c, Acc__c, Con__c, Email__c, rol__c, phone__c
                                    FROM coninfo__c
                                   WHERE Acc__c = :A.Id
                                   LIMIT 1];
        if (lstCI != null && !lstCI.isEmpty()) {
            isCI = true;
        }
    }

    public Map<String, coninfo__c> conMap { get; set; }

    public void getconinfoLst() {
        Map<String, coninfo__c> coninfoMap = new Map<String, coninfo__c>();
        conMap = new Map<String, coninfo__c>();

        for (coninfo__c con : [SELECT Id, Name__c, Acc__c, Con__c, Email__c, rol__c,
                                      phone__c, seml__c, sphn__c
                                 FROM coninfo__c
                                WHERE Acc__c = :A.Id
                                  AND Sta__c = 'Active']) {
            coninfoMap.put(con.rol__c, con);
        }

        if (!coninfoMap.isEmpty()) {
            for (String ci : coninfoMap.keySet()) {
                if (ci != null && ci.contains(';')) {
                    for (String s : ci.split(';')) {
                        conMap.put(s, coninfoMap.get(ci));
                    }
                } else {
                    conMap.put(ci, coninfoMap.get(ci));
                }
            }
            System.debug('conMap -----> ' + conMap);
        }
    }

    /* ============================================================
     *  Search by status (with day range)
     * ============================================================ */
    public PageReference searchByStatus1() {
        String qry = 'SELECT Id, Applicant_Name__c, prio__c, CurrentNationality__c, '
                   + 'xcnc__c, xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, '
                   + 'STA__c, damsgs__c, AOP__c '
                   + 'FROM g_Req__c '
                   + 'WHERE isDeleted = false AND Acc__c = \'' + String.escapeSingleQuotes(A.Id) + '\' ';

        if (ApexPages.currentPage().getParameters().get('flg') != null) {
            isPendingTab = ApexPages.currentPage().getParameters().get('flg');
        }
        System.debug('searchByStatus1 -> isPendingTab : ' + isPendingTab);

        if (isPendingTab == 'pndg') {
            qry += ' AND STA__c NOT IN (\'Completed\',\'Rejected\',\'Cancelled\') '
                +  ' AND ((AT__c = 0) OR (AT__c > 0 AND AOP__c > 0)) ';
        }

        if (String.isNotBlank(days)) {
            Integer d = Integer.valueOf(days) - 1;
            if (d == 0) {
                qry += ' AND LastModifiedDate = TODAY';
            } else {
                qry += ' AND LastModifiedDate = LAST_N_DAYS:' + d;
            }
            if (String.isNotBlank(status) && status != 'All') {
                qry += ' AND STA__c = \'' + String.escapeSingleQuotes(status) + '\'';
            }
        } else if (String.isNotBlank(status) && status != 'All') {
            qry += ' AND STA__c = \'' + String.escapeSingleQuotes(status) + '\'';
        }

        qry += ' LIMIT 100';
        System.debug('qry :: ' + qry);

        allDPRqs = Database.query(qry);

        if (isPendingTab == 'pndg') {
            List<g_Req__c> rqs = new List<g_Req__c>();
            for (g_Req__c r : allDPRqs) {
                if (r.damsgs__c != null && r.damsgs__c != '0') {
                    rqs.add(r);
                }
            }
            allDPRqs = rqs;
        }

        strAllDPRqs1   = JSON.serialize(allDPRqs);
        stdSetController = new ApexPages.StandardSetController(allDPRqs);
        return null;
    }

    /* ============================================================
     *  Test-only helper to reach private methods
     * ============================================================ */
    public void LoadPrivateMethods() {
        if (Test.isRunningTest()) {
            try { getSanctions();   } catch (Exception ex) {}
            try { getCs();          } catch (Exception ex) {}
            try { getSrvcs();       } catch (Exception ex) {}
            try { loadStats();      } catch (Exception ex) {}
            try { NotGCC('Pakistani'); } catch (Exception ex) {}
            try { getVisitors();    } catch (Exception ex) {}
            try { loadData(false);  } catch (Exception ex) {}
        }
    }

    /* ============================================================
     *  Request lists
     * ============================================================ */
    private void getRCRQs() {
        rcRqs = [SELECT Id, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, xcnc__c, xadh__c
                   FROM g_Req__c
                  WHERE i_STA__c LIKE '%Requires Correction%'
                    AND isDeleted = false
                    AND Acc__c = :A.Id
                  LIMIT 499];
    }

    public void getdraftRQs() {
        draftRq5 = new List<g_Req__c>();
        draftRqs = new List<g_Req__c>();

        allRqs = [SELECT Id, Applicant_Name__c, xfpdd__c, prio__c, CurrentNationality__c,
                         xcnc__c, AT__c, AP__c, xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c,
                         xcln__c, STA__c, bamsgs__c, damsgs__c, AOP__c, xadh__c
                    FROM g_Req__c
                   WHERE isDeleted = false
                     AND Acc__c = :A.Id
                   ORDER BY LastModifiedDate DESC
                   LIMIT 499];

        for (g_Req__c r : allRqs) {
            if (r.STA__c == 'Draft') draftRqs.add(r);
        }

        for (Integer i = 0; i < draftRqs.size() && i < 5; i++) {
            draftRq5.add(draftRqs.get(i));
        }
    }

    public void getnotificationRQs() {
        notificationRqs  = new List<g_Req__c>();
        notificationRqs3 = new List<g_Req__c>();

        System.debug('pendingRq5 --- ' + pendingRq5);

        /* Build notificationRqs from pendingRq5 (dedup: never add same rec twice). */
        if (pendingRq5 != null) {
            for (g_Req__c r : pendingRq5) {
                Boolean added = false;
                if (r.bamsgs__c != null) {
                    notificationRqs.add(r);
                    added = true;
                }
                if (!added && r.AP__c == 0) {
                    r.bamsgs__c = ',has been saved as a draft. Click here to resume the application.';
                    notificationRqs.add(r);
                }
            }
        }

        /* Top 3 into notificationRqs3 */
        for (Integer i = 0; i < notificationRqs.size() && i < 3; i++) {
            notificationRqs3.add(notificationRqs.get(i));
        }

        /* Tag draft rows with the "saved as draft" message (display-only). */
        if (draftRq5 != null) {
            for (g_Req__c dr : draftRq5) {
                dr.bamsgs__c = ',has been saved as a draft. Click here to resume the application.';
            }
        }
    }

    public void getpendingRQs() {
        pendingRq5 = new List<g_Req__c>();
        pendingRqs = [SELECT Id, Applicant_Name__c, prio__c, CurrentNationality__c, xcnc__c,
                             AT__c, AP__c, xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c,
                             STA__c, AOP__c, damsgs__c, bamsgs__c, LastModifiedDate, xadh__c
                        FROM g_Req__c
                       WHERE STA__c NOT IN ('Draft', 'Completed', 'Rejected', 'Cancelled')
                         AND isDeleted = false
                         AND Acc__c = :A.Id
                       ORDER BY LastModifiedDate DESC
                       LIMIT 40];

        if (pendingRqs != null) {
            for (Integer r = 0; r < pendingRqs.size() && pendingRq5.size() < 5; r++) {
                pendingRq5.add(pendingRqs.get(r));
            }
        }
    }

    public void getNopmntRQs() {
        openNopmntRqs = new List<g_Req__c>();
        if (allRqs == null) return;
        for (g_Req__c r : allRqs) {
            if (r.AT__c != r.AP__c && r.STA__c == 'Open') {
                openNopmntRqs.add(r);
            }
        }
    }

    public void searchPersons() {
        String p = '%' + prsn + '%';
        allDPRqs = [SELECT Id, Applicant_Name__c, prio__c, CurrentNationality__c, xcnc__c,
                           xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, STA__c,
                           damsgs__c, AOP__c, xadh__c
                      FROM g_Req__c
                     WHERE isDeleted = false
                       AND (Applicant_Name__c LIKE :p OR xcp__c LIKE :p)
                       AND Acc__c = :A.Id
                     LIMIT 499];
        stdSetController = new ApexPages.StandardSetController(allDPRqs);
    }

    public void getallDPRQs() {
        allDPRqs = new List<g_Req__c>();
        if (isPendingTab == 'pndg') {
            allDPRqs = pendingRqs;
        } else if (isPendingTab == 'drft') {
            allDPRqs = draftRqs;
        } else {
            allRqs = [SELECT Id, Applicant_Name__c, xfpdd__c, prio__c, CurrentNationality__c,
                             xcnc__c, AT__c, AP__c, xcp__c, Name, srvc__r.Name, xcfn__c,
                             xcmn__c, xcln__c, STA__c, damsgs__c, AOP__c, xadh__c
                        FROM g_Req__c
                       WHERE isDeleted = false
                         AND Acc__c = :A.Id
                       ORDER BY LastModifiedDate DESC
                       LIMIT 499];
            allDPRqs = allRqs;
        }
        System.debug('allDPRqs size --- ' + allDPRqs.size());
    }

    public void searchByStatus() {
        System.debug('sta ---> ' + sta);
        String s = sta;
        allDPRqs = [SELECT Id, Applicant_Name__c, prio__c, CurrentNationality__c, xcnc__c,
                           xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, STA__c,
                           damsgs__c, AOP__c, xadh__c
                      FROM g_Req__c
                     WHERE isDeleted = false
                       AND STA__c = :s
                       AND Acc__c = :A.Id
                     ORDER BY LastModifiedDate
                     LIMIT 499];
        stdSetController = new ApexPages.StandardSetController(allDPRqs);
    }

    public void searchByDate() {
        Integer d = Integer.valueOf(dat);
        if (d == 1) {
            allDPRqs = [SELECT Id, Applicant_Name__c, prio__c, CurrentNationality__c, xcnc__c,
                               xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, STA__c,
                               damsgs__c, AOP__c, xadh__c
                          FROM g_Req__c
                         WHERE isDeleted = false
                           AND Acc__c = :A.Id
                         ORDER BY LastModifiedDate
                         LIMIT 499];
        } else {
            Integer dd = d - 1;
            String qur = 'SELECT Id, Applicant_Name__c, prio__c, CurrentNationality__c, xcnc__c, '
                       + 'xcp__c, Name, srvc__r.Name, xcfn__c, xcmn__c, xcln__c, STA__c, '
                       + 'damsgs__c, xadh__c '
                       + 'FROM g_Req__c '
                       + 'WHERE isDeleted = false '
                       + 'AND LastModifiedDate = LAST_N_DAYS:' + dd + ' '
                       + 'AND Acc__c = \'' + String.escapeSingleQuotes(A.Id) + '\'';
            allDPRqs = Database.query(qur);
        }
        stdSetController = new ApexPages.StandardSetController(allDPRqs);
    }

    /* ============================================================
     *  Pagination helpers
     * ============================================================ */
    public Integer TotalPages {
        get {
            Integer resultSize = stdSetController.getResultSize();
            Integer pageSize   = stdSetController.getPageSize();

            if (resultSize == 0 || pageSize == 0) {
                TotalPages = 1;
            } else if (Math.mod(resultSize, pageSize) == 0) {
                TotalPages = resultSize / pageSize;
            } else {
                TotalPages = (resultSize / pageSize) + 1;
            }
            System.debug('TotalPages : ' + TotalPages);
            return TotalPages;
        }
        set;
    }

    public Integer MaxNumberOfRecords {
        get { return stdSetController.getRecords().size(); }
        set;
    }

    public void next() {
        stdSetController.next();
    }

    public ApexPages.StandardSetController stdSetController {
        get {
            if (stdSetController == null) {
                if (allDPRqs == null) allDPRqs = new List<g_Req__c>();

                allDPRqs = [SELECT Id, Applicant_Name__c, xfpdd__c, prio__c, CurrentNationality__c,
                                   xcnc__c, AT__c, AP__c, xcp__c, Name, srvc__r.Name, xcfn__c,
                                   xcmn__c, xcln__c, STA__c, damsgs__c, AOP__c, xadh__c
                              FROM g_Req__c
                             WHERE isDeleted = false
                               AND Acc__c = :A.Id
                               AND STA__c != 'Completed'
                             ORDER BY LastModifiedDate DESC
                             LIMIT 99];

                List<g_Req__c> rqs = new List<g_Req__c>();

                if (isPendingTab == 'pndg') {
                    for (g_Req__c r : allDPRqs) {
                        if (r.damsgs__c != null && r.damsgs__c != '0') {
                            rqs.add(r);
                            if (rqs.size() > 2) break;
                        }
                    }
                } else {
                    for (g_Req__c r : allDPRqs) {
                        rqs.add(r);
                        if (rqs.size() > 2) break;
                    }
                }
                allDPRqs = rqs;
                stdSetController = new ApexPages.StandardSetController(allDPRqs);
            }
            stdSetController.setPageSize(RecordsPerPageslist);
            return stdSetController;
        }
        set;
    }

    public PageReference getSelectedPageList() {
        stdSetController.setPageSize(RecordsPerPageslist);
        stdSetController.setPageNumber(Integer.valueOf(pageNo));
        return null;
    }

    public String strAllDPRqs1 { get; set; }

    public List<g_Req__c> getallDPRqs1() {
        List<g_Req__c> temp = (List<g_Req__c>) stdSetController.getRecords();
        strAllDPRqs1 = JSON.serialize(temp);
        System.debug('temp size : ' + temp.size() + ' ** strAllDPRqs1 ::: ' + strAllDPRqs1);
        return temp;
    }

    /* ============================================================
     *  Counters by status
     * ============================================================ */
    private void getRQs() {
        Map<String, Decimal> mSTA = new Map<String, Decimal>{
            'Draft'        => 0,
            'Open'         => 0,
            'Under Review' => 0,
            'In Process'   => 0,
            'On Hold'      => 0,
            'NC'           => 0
        };

        for (AggregateResult ar : [SELECT STA__c STA, COUNT(Id) C, SUM(nc__c) NC
                                     FROM g_Req__c
                                    WHERE isDeleted = false
                                      AND Acc__c = :A.Id
                                      AND (STA__c = 'Draft'
                                        OR STA__c = 'Open'
                                        OR STA__c = 'Under Review'
                                        OR STA__c = 'In Process'
                                        OR STA__c = 'On Hold')
                                    GROUP BY STA__c
                                    LIMIT 499]) {
            String sta    = (String)  ar.get('STA');
            Decimal count = (ar.get('C')  == null) ? 0 : (Decimal) ar.get('C');
            Decimal ncSum = (ar.get('NC') == null) ? 0 : (Decimal) ar.get('NC');

            mSTA.put(sta, mSTA.get(sta) + count);
            if (sta != 'On Hold') {
                mSTA.put('NC', mSTA.get('NC') + ncSum);
            }
        }
        cD = mSTA.get('Draft');
        cO = mSTA.get('Open');
        cR = mSTA.get('Under Review');
        cP = mSTA.get('In Process');
        cH = mSTA.get('On Hold');
        cC = mSTA.get('NC');
    }

    /* ============================================================
     *  Sanctions
     * ============================================================ */
    private void getSanctions() {
        mSnc = new Map<String, String>();
        mScSize   = 0;
        mScHasVal = false;

        if ((A.snc__c != null && A.snc__c != '')
                || A.lcsnc__c || A.psasnc__c || A.ecsnc__c) {

            if (A.lcsnc__c)  mSnc.put('LC',  A.lcsncnt__c);
            if (A.psasnc__c) mSnc.put('PSA', A.psasncnt__c);
            if (A.ecsnc__c)  mSnc.put('EC',  A.ecsncnt__c);

            if (String.isNotBlank(A.snc__c)) {
                for (String snc : A.snc__c.split(';')) {
                    mSnc.put(snc, '');
                }
            }

            mScSize   = mSnc.keySet().size();
            mScHasVal = mScSize > 0;

            if (mScHasVal) {
                for (Sanction_Detail__c sncDt : [SELECT Id, Name, Sanction_Notes__c
                                                   FROM Sanction_Detail__c
                                                  WHERE Name IN :mSnc.keySet()]) {
                    if (mSnc.containsKey(sncDt.Name)) {
                        mSnc.put(sncDt.Name, sncDt.Sanction_Notes__c);
                    }
                }
            }
        }
    }

    /* ============================================================
     *  PO-box
     * ============================================================ */
    public List<alocpob__c> poBoxLst { get; set; }

    public void getPOBox() {
        poBoxLst = [SELECT Id, Name, idt__c, edt__c, typ__c
                      FROM alocpob__c
                     WHERE isDeleted = false
                       AND acc__c = :A.Id
                       AND stts__c = 'Active'
                     LIMIT 10];
        if (poBoxLst != null && !poBoxLst.isEmpty()) poBox = poBoxLst[0].Name;
    }

    /* ============================================================
     *  Expiry aggregates (kept for reporting; no assignment today)
     * ============================================================ */
    private void getRPExpLst() {
        List<AggregateResult> rpExpLst = [SELECT COUNT(Id), CALENDAR_MONTH(rped__c)
                                            FROM Contact
                                           WHERE AccountId = :A.Id
                                             AND rped__c > TODAY
                                             AND rped__c <= NEXT_N_MONTHS:6
                                           GROUP BY CALENDAR_MONTH(rped__c)
                                           ORDER BY CALENDAR_MONTH(rped__c) DESC];
    }

    private void getPassportExpLst() {
        List<AggregateResult> pExpLst = [SELECT COUNT(Id), CALENDAR_MONTH(ped__c)
                                           FROM Contact
                                          WHERE AccountId = :A.Id
                                            AND ped__c > TODAY
                                            AND ped__c <= NEXT_N_MONTHS:6
                                          GROUP BY CALENDAR_MONTH(ped__c)
                                          ORDER BY CALENDAR_MONTH(ped__c) DESC];
    }

    private void getLeaseExpLst() {
        List<grqWsDccaGetService.Records> tecomd3Lst  = new List<grqWsDccaGetService.Records>();
        List<grqWsDccaGetService.Records> tecomLeaseLst =
                grqWsDccaGetService.loadTecomCRMLoc(A.ORACLE_PARTY_ID__c);
        List<grqWsDccaGetService.Records> d3lsLst =
                grqWsDccaGetService.loadD3Loc(A.ORACLE_PARTY_ID__c);
        tecomd3Lst.addAll(tecomLeaseLst);
        tecomd3Lst.addAll(d3lsLst);
    }

    /* ============================================================
     *  Contacts needing attribute update
     * ============================================================ */
    private void getCs() {
        for (AggregateResult ar : [SELECT COUNT(Id) C
                                     FROM Contact
                                    WHERE isDeleted = false
                                      AND AccountId = :A.Id
                                      AND STA__c = 'Active'
                                      AND rol__c = 'Employee'
                                      AND CreatedDate < LAST_N_DAYS:179
                                      AND (lua__c  = null
                                        OR lua__c  < LAST_N_DAYS:179
                                        OR luas__c = null
                                        OR luas__c < LAST_N_DAYS:179)]) {
            cOD += (ar.get('C') == null) ? 0 : (Decimal) ar.get('C');
        }
    }

    /* ============================================================
     *  Service menu
     * ============================================================ */
    private void getSrvcs() {
        Set<Id> sids;
        if (!gU.isPortalSuperUser(UserInfo.getProfileId()) && ispu) {
            sids = new Set<Id>();
            for (g_srvcAL__c al : [SELECT srvc__r.Id
                                     FROM g_srvcAL__c
                                    WHERE isDeleted = false
                                      AND usr__c = :UserInfo.getUserId()
                                      AND DE__c = true]) {
                sids.add(al.srvc__r.Id);
            }
        }

        Map<String, Map<String, List<g_Srvc__c>>> mH =
                new Map<String, Map<String, List<g_Srvc__c>>>();

        for (g_Srvc__c s : [SELECT Id, uid__c, Name, lbl__c, Menu_Category__c,
                                   Category__c, Sub_Category__c
                              FROM g_Srvc__c
                             WHERE isDeleted = false
                               AND actv__c = true
                               AND Category__c != null
                               AND Prk__c INCLUDES (:A.Prk__c)
                               AND AccTp__c INCLUDES (:A.Type)
                             ORDER BY sord__c]) {

            String sc = s.Sub_Category__c;
            if (String.isNotBlank(s.Menu_Category__c)) {
                for (String c : s.Menu_Category__c.split('\\;', 0)) {
                    if (!mH.containsKey(c)) {
                        mH.put(c, new Map<String, List<g_Srvc__c>>());
                    }
                    if (!mH.get(c).containsKey(sc)) {
                        mH.get(c).put(sc, new List<g_Srvc__c>());
                    }
                    mH.get(c).get(sc).add(s);
                }
            }
        }

        Srvcs = new List<GL1>();
        for (Schema.PicklistEntry c : g_Srvc__c.Menu_Category__c.getDescribe().getPicklistValues()) {
            if (mH.get(c.getLabel()) != null) {
                GL1 l1 = new GL1(c.getLabel());
                for (Schema.PicklistEntry sc : g_Srvc__c.Sub_Category__c.getDescribe().getPicklistValues()) {
                    if (mH.get(c.getLabel()).get(sc.getLabel()) != null) {
                        l1.lst.add(new GL2(sc.getLabel(), mH.get(c.getLabel()).get(sc.getLabel())));
                    }
                }
                Srvcs.add(l1);
            }
        }
        System.debug('Srvcs >> ' + Srvcs);
    }

    /* ============================================================
     *  Account-level loaders
     * ============================================================ */
    private void loadContact() {
        myAccountLst = new List<myAccount>();
        contLst      = new List<Contact>();
        uidUsrname   = new Map<String, User>();

        System.debug('loadContact >> ' + A.Id);
        contLst = [SELECT Id, Name, Personal_Photo__c, Photo_ID__c, Email, Job_Title_Formula__c,
                          rped__c, ped__c, nc__c, rol__c, STA__c, isDeleted
                     FROM Contact
                    WHERE AccountId = :A.Id];

        List<User> userLst = [SELECT Id, Name, ContactId, IsActive, Username, AccountId,
                                     Contact.Name, Contact.Personal_Photo__c, Contact.Photo_ID__c,
                                     Contact.Email, Contact.Job_Title_Formula__c, Contact.rped__c,
                                     Contact.ped__c, Contact.nc__c, Contact.rol__c, Contact.STA__c,
                                     Contact.isDeleted
                                FROM User
                               WHERE AccountId = :A.Id];

        for (User usr : userLst) {
            uidUsrname.put(usr.Id, usr);
        }

        for (User usr : userLst) {
            myAccount m = new myAccount();
            m.con      = usr.Contact;
            m.usr      = usr;
            m.usrPhoto = usr.Contact.Photo_ID__c;
            myAccountLst.add(m);
        }
        System.debug('myAccountLst >> ' + myAccountLst);
    }

    public class myAccount {
        public Contact con      { get; set; }
        public User    usr      { get; set; }
        public String  usrPhoto { get; set; }
    }

    private void loadAccountLocation() {
        try {
            tecomLeaseList = new List<grqWsDccaGetService.Records>();
            List<grqWsDccaGetService.Records> d3LeaseList = new List<grqWsDccaGetService.Records>();

            if (A != null && A.ORACLE_PARTY_ID__c != null) {
                // tecomLeaseList = grqWsDccaGetService.loadTecomCRMLoc(A.ORACLE_PARTY_ID__c);
                System.debug('tecomLeaseList : ' + tecomLeaseList);
            }

            if (d3LeaseList != null && !d3LeaseList.isEmpty()) {
                tecomLeaseList.addAll(d3LeaseList);
            }

            finalAgreeLoc = new Map<String, String>();
            for (grqWsDccaGetService.Records rec : tecomLeaseList) {
                if (rec.Products != null && !rec.Products.isEmpty()) {
                    finalAgreeLoc.put(rec.AgNo,
                        rec.Products[0].UnitNumber + ',' + rec.Products[0].ProductName);
                }
            }

            locLst = new List<loc__c>();
            if (A != null && A.Id != null) {
                for (loc__c lc : [SELECT Id, Name, acc__c, active__c, act__c, agrno__c, arBldg__c,
                                         arbu__c, arflr__c, aroffno__c, asf__c, Bldg__c, bu__c,
                                         cat__c, flr__c, IsActive__c, Is_frzn__c, IsMain__c,
                                         isregof__c, IsSub__c, ls_end__c, ls_std__c, lstyp__c,
                                         Loc__c, mu__c, offno__c, pyear__c, plt__c, pltarb__c,
                                         rpi__c, rqno__c, subcat__c, su__c
                                    FROM loc__c
                                   WHERE acc__c = :A.Id]) {
                    locLst.add(lc);
                }
            }
        } catch (Exception ex) {
            System.debug('loadAccountLocation Ex >> ' + ex);
        }
        System.debug('locLst >> ' + locLst);
    }

    private void loadTransaction() {
        tsLst = [SELECT Id, acc__c, Name, md__c, A__c, dt__c, STA__c
                   FROM g_Tran__c
                  WHERE acc__c = :A.Id
                  ORDER BY dt__c DESC
                  LIMIT 6];
        System.debug('tsLst >> ' + tsLst);
    }

    /* ============================================================
     *  User enable / disable
     * ============================================================ */
    private void enUser(Id uid, Boolean actv) {
        System.debug('enUser >> ' + uid + ' || ' + actv);
        if (uid == null) {
            gU.AddWarningMsg(Label.msgNoChange);
            return;
        }
        User usr = uidUsrname.get(uid);
        if (usr == null) {
            gU.AddWarningMsg(Label.msgNoChange);
            return;
        }
        usr.IsActive = actv;
        update usr;
        System.debug('updated User >> ' + usr);
        init();
        gU.AddSuccessMsg(Label.msgSuccess);
    }

    public void enUser() {
        try {
            enUser(ApexPages.currentPage().getParameters().get('uid'), true);
        } catch (Exception ex) {
            gU.AddErrorMsg(ex);
        }
    }

    public void dsbUser() {
        try {
            enUser(ApexPages.currentPage().getParameters().get('uid'), false);
        } catch (Exception ex) {
            gU.AddErrorMsg(ex);
        }
    }

    /* ============================================================
     *  Stats (expired passports/RPs etc.)
     * ============================================================ */
    private void loadStats() {
        Set<String> roles = new Set<String>{
            'Employee', 'Non Sponsored', 'Access Card', 'Student'
        };

        for (Contact c : [SELECT Id, rped__c, ped__c, nc__c, rol__c
                            FROM Contact
                           WHERE isDeleted = false
                             AND STA__c = 'Active'
                             AND AccountId = :A.Id
                           LIMIT 499]) {

            Boolean isEligible = NotGCC(c.nc__c) && roles.contains(c.rol__c);

            if (isEligible && c.rped__c != null && c.rped__c <= Date.today()) {
                cRPExp++;
            }

            if (isEligible && c.ped__c != null) {
                if (c.ped__c <= Date.today()) {
                    cPSExp++;
                } else if (Date.today().addDays(30) >= c.ped__c) {
                    cPSExp30++;
                }
            }
        }

        for (Contact ct : [SELECT Id, rped__c, ped__c, nc__c, rol__c
                             FROM Contact
                            WHERE isDeleted = false
                              AND STA__c = 'Active'
                              AND AccountId = :A.Id
                              AND rped__c = NEXT_N_DAYS:30]) {
            if (NotGCC(ct.nc__c) && roles.contains(ct.rol__c)) {
                cRPExp30++;
            }
        }
    }

    private Boolean NotGCC(String nationality) {
        if (nationality == null) return true;
        Set<String> gcc = new Set<String>{
            'Bahrain', 'Kuwait', 'Oman', 'Qatar', 'Saudi Arabia', 'United Arab Emirates'
        };
        return !gcc.contains(nationality);
    }

    /* ============================================================
     *  Licence / document retrieval (web-service calls)
     * ============================================================ */
    public PageReference getLicenseCopy() {
        String lc = ApexPages.currentPage().getParameters().get('lc');
        if (ispu) lc = A.lc__c;

        String jsonResp = grqWsDccaGetService.getLicenseCopy(lc);
        Map<String, Object> metadataMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResp);
        licCopy = (String) metadataMap.get('body');
        return null;
    }

    public PageReference getDocument() {
        String lc = ApexPages.currentPage().getParameters().get('lc');
        String dc = ApexPages.currentPage().getParameters().get('dc');
        System.debug('getDocument :: dc: ' + dc);

        if (String.isNotBlank(dc)) {
            Map<String, String> mapDocs = new Map<String, String>{
                'coi'  => 'Certificate of Incorporation',
                'aoa'  => 'Articles of Association',
                'cocn' => 'Certificate of Company Name Change',
                'fp'   => 'Freelancer Permit',
                'cobr' => 'Certificate of Branch Registration',
                'clc'  => 'Commercial Licence',
                'cxt'  => 'Company Extract',
                'brs'  => 'Board Resolution',
                'rod'  => 'Register Of Directors'
            };
            if (ispu) lc = A.lc__c;
            licCopy = grqWsDccaGetService.getDocument(lc, mapDocs.get(dc));
        }
        return null;
    }

    /* ============================================================
     *  Visitor counts
     * ============================================================ */
    private void getVisitors() {
        AggregateResult ar = [SELECT COUNT(Id) C
                                FROM g_Req__c
                               WHERE (isDeleted = false AND Acc__c = :A.Id)
                                 AND (srvc__r.uid__c = '058'
                                   OR srvc__r.uid__c = '074'
                                   OR srvc__r.uid__c = '096'
                                   OR srvc__r.uid__c = '097')
                                 AND ((STA__c != 'Rejected'
                                       AND STA__c != 'Cancelled'
                                       AND CreatedDate = THIS_MONTH)
                                    OR STA__c = 'Open'
                                    OR STA__c = 'Draft')];
        if (ar == null || ar.get('C') == null) return;
        VVU = (Decimal) ar.get('C');
    }

    /* ============================================================
     *  Menu wrappers
     * ============================================================ */
    public List<GL1> Srvcs        { get; set; }
    public List<GL1> SrvcCategory { get; set; }
    public Map<String, String> mSnc { get; set; }

    public class GL1 {
        public String    lbl { get; set; }
        public List<GL2> lst { get; set; }
        public GL1(String v) {
            lbl = v;
            lst = new List<GL2>();
        }
    }

    public class GL2 {
        public String         lbl { get; set; }
        public List<g_Srvc__c> lst { get; set; }
        public GL2(String v, List<g_Srvc__c> l) {
            lbl = v;
            lst = l;
        }
    }
}