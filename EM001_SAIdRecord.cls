/**
 * @author Wasim Khadaroo
 * @date 2025-09-02
 * @group Entity Manager
 * @description Shapes SAIdRecord__c SObject from decoded ID
 */
public with sharing class EM001_SAIdRecord {
    public static SAIdRecord__c buildFromDecoded(UT001_IdNumberUtil.DecodedId dec) {
        SAIdRecord__c r = new SAIdRecord__c();
        r.IdNumber__c   = dec.idNumber;
        r.DateOfBirth__c = dec.dateOfBirth;
        r.Gender__c     = dec.gender;
        r.IsCitizen__C  = dec.isCitizen;
        return r;
    }
}