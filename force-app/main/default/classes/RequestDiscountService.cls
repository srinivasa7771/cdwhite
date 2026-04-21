public class RequestDiscountService {

    public Static void updateChildstatus(Map<Id,Request_Discounti__c> newMap, Map<Id,Request_Discounti__c> oldMap){
        Map<Id,Request_Discounti__c> RequestappMap = new Map<Id,Request_Discounti__c>();
        Map<Id,Request_Discounti__c> RequestrejMap = new Map<Id,Request_Discounti__c>();
        List<Request_Discount__c> appchildStatusToUpdate = new List<Request_Discount__c>();
        List<Request_Discount__c> rejchildStatusToUpdate = new List<Request_Discount__c>();
        List<Request_Discount__c> appChildLst = new List<Request_Discount__c>();
        List<Request_Discount__c> rejChildLst = new List<Request_Discount__c>();

        for (Request_Discounti__c rd : newMap.values()){

            if (rd.Status__c == 'Approved'){

                RequestappMap.put(rd.Id,rd);


            }

            if (rd.Status__c == 'Rejected'){

                RequestrejMap.put(rd.Id,rd);


            }

        }
        system.debug('RequestappMap'+RequestappMap);
        system.debug('RequestrejMap'+RequestrejMap);

        if (!RequestappMap.isEmpty()){

            for (Id rids : RequestappMap.keySet()){

                FeedItem post = new FeedItem();
                post.ParentId = RequestappMap.get(rids).ownerId;
                post.Body = 'Request Discount'+' '+rids+' '+'Has been Approved';
                insert post;

            }

            appChildLst = [Select id from Request_Discount__c where MRequest_Discount__c In:RequestappMap.keySet()];
        }

        if (!RequestrejMap.isEmpty()){

            for (Id rids : RequestrejMap.keySet()){

                FeedItem post = new FeedItem();
                post.ParentId = RequestrejMap.get(rids).ownerId;
                post.Body = 'Request Discount'+' '+rids+' '+'Has been Rejected';
                insert post;

            }

            rejChildLst = [Select id from Request_Discount__c where MRequest_Discount__c In:RequestappMap.keySet()];
        }

        system.debug('rejChildLst'+rejChildLst);
        system.debug('appChildLst'+appChildLst);

        if (!appChildLst.isEmpty()){


            for (Request_Discount__c rd : appChildLst){


                rd.Status__c='Approved';

                appchildStatusToUpdate.add(rd);


            }

            system.debug('appchildStatusToUpdate'+appchildStatusToUpdate);
            if (!appchildStatusToUpdate.isEmpty()){

                SObjectAccessDecision secDec = Security.stripInaccessible(AccessType.UPDATABLE, appchildStatusToUpdate);
                update secDec.getRecords();


            }



        }

        if (!rejChildLst.isEmpty()){


            for (Request_Discount__c rd : rejChildLst){


                rd.Status__c='Rejected';

                rejchildStatusToUpdate.add(rd);


            }

            system.debug('rejchildStatusToUpdate'+rejchildStatusToUpdate);
            if (!rejchildStatusToUpdate.isEmpty()){

                SObjectAccessDecision secDec2 = Security.stripInaccessible(AccessType.UPDATABLE, rejchildStatusToUpdate);
                update secDec2.getRecords();


            }



        }


    }

}