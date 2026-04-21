public class grqwsLookups {

    public static void upsertLookUpInfo(String lookupId, String lookupType) {

        try{
             HttpRequest req = New HttpRequest();
             req.setHeader('Content-Type', 'application/json');
             req.setHeader('Cache-Control', 'no-cache');
             req.setHeader('grant_type', 'password');
               //change  it to GSO settings  AS GDRF API KEY
             req.setHeader('Apikey', gU.csStr('GDRFAAPIKey')); //'uzXIQHrghLcve5A0Y3S19uRH6IKX9P0K'
            //change  it to GSO settings
             String authorizationHeader ='Basic '+ EncodingUtil.base64Encode(Blob.valueOf(gU.csStr('GDRFAUsr')+':'+gU.csStr('GDRFAPwd')));
             req.setHeader('Authorization', authorizationHeader);
             req.setTimeout(120000);
             req.setMethod('GET');
            // lable  URL
        req.setEndpoint('callout:GDRFA_Lookup_API/' + lookupId + '/items');
             Http http = New Http();
             system.debug('Grant type header set');
             HTTPResponse res = http.send(req);
            // system.debug('res'+res.getBody());
             String resStr = res.getBody();
             List<GDRFALOOKUP__mdt> lookupLst = new List<GDRFALOOKUP__mdt>();
             List<grqwsLookups> recList = (List<grqwsLookups>)Json.deserialize(resStr, List<grqwsLookups>.class);
            // system.debug('recList:'+recList);
            integer i=1;
           /* for (integer i=1000; i < 1280; i++ ) {
                grqwsLookups rec = recList[i];
                lookupLst.add(new GDRFALOOKUP__mdt(MasterLabel=lookupType+rec.loopkupId+rec.parentLookupId, DeveloperName=lookupType+
                    rec.loopkupId+rec.parentLookupId, type__c=lookupType, namear__c=rec.name.ar, nameen__c=rec.name.en, lookupid__c=rec.loopkupId, ParentLookupId__c=rec.parentLookupId));
               // lookupLst.add(new GDRFALOOKUP__mdt(MasterLabel=lookupType+i, DeveloperName=lookupType+i, type__c=lookupType, namear__c=rec.name.ar, nameen__c=rec.name.en, lookupid__c=rec.loopkupId, ParentLookupId__c=rec.parentLookupId));
               // i=i+1;
               if (i == 1279)
                   break;
            }*/
            for (grqwsLookups rec : recList) {
                lookupLst.add(new GDRFALOOKUP__mdt(MasterLabel=lookupType+i, DeveloperName=lookupType+
                    i, type__c=lookupType, namear__c=rec.name.ar, nameen__c=rec.name.en,
                    lookupid__c=rec.loopkupId, ParentLookupId__c=rec.parentLookupId));
                i=i+1;

            }
             gmdU.upsertMetadata(lookupLst);
            }catch (Exception e) { system.debug(e.getMessage());}

    }

    public string loopkupId {set;get;}
    public String parentLookupId {set;get;}
    public Name name {set;get;}
    public class Name {
        public string ar {set;get;}
        public string en {set;get;}
    }

}