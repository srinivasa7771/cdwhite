global class gctlMissingDocs {

    global g_req__c req {get;set;}
    global String xcdddocs {set;get;}
    global String reqNum {set;get;}
    global Boolean isAOAMissing{get;set;}

    global Set<String> setDocs {
        get{

            setDocs = new Set<String>();
            /*if (String.isNotBlank(xcdddocs)) {List<string> lstDocs = xcdddocs.split(';');System.debug('inside gctlMissingDocs: ' + xcdddocs);for (String d : lstDocs) {if (!d.equalsIgnoreCase('undefined'))setDocs.add(d.trim());}}*/

            if (String.isNotBlank(reqNum)) {

                isAOAMissing = false;
                req = [select id, name, xcddocs__c, sta__c, srvc__r.uid__c, xfb__c, (Select id, name,
                    lbl__c From rDocs__r where Req__c=true and upOk__c=false and IsDeleted=false) from g_req__c  where name=:reqNum ];

                if (req != null && req.rDocs__r != null && req.rDocs__r.size()>0) {

                    for (g_reqDoc__c doc: req.rDocs__r) {

                        String docFullName = String.isNotBlank(doc.lbl__c) ? doc.lbl__c : (String.isNotBlank(doc.name) ? doc.name : '');
                        if (String.isNotBlank(docFullName)) {
                           docFullName = docFullName.replace(' - dr', '').replace(' - sh1', '').replace(' - sh2',
                               '').replace(' - sh3', '').replace(' - sh4', '').replace(' - sh5', '').replace(' - sh6',
                               '').replace(' - sh7', '');
                            setDocs.add(docFullName);
                            String docname = docFullName.toLowerCase();

                            if (docname.contains('signed aoa') || docname.contains('signed resolution')) {
                                isAOAMissing = true;
                            }

                        }
                    }
                }
            }

            if (setDocs.size()>0) {return setDocs;}else{return null;}

        }

        set;
    }

    public gctlMissingDocs() {}

}