global class dccaLicRenewalDocsSchld implements Schedulable{
    global void execute(SchedulableContext sc) {
        dccaLicRenewalDocs b = new dccaLicRenewalDocs();
        database.executebatch(b, 1);
    }
}