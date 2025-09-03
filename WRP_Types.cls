/**
 * @author Wasim Khadaroo
 * @date 2025-09-02
 * @group Wrappers
 * @description Wrapper types for exposing results to LWC
 */
public with sharing class WRP_Types {
    public class Holiday {
        @AuraEnabled public String name;
        @AuraEnabled public String description;
        @AuraEnabled public String dateIso;
        @AuraEnabled public List<String> type;
    }

    public class IdResult {
        @AuraEnabled public Boolean valid;
        @AuraEnabled public String message;
        @AuraEnabled public String idNumber;
        @AuraEnabled public Date dateOfBirth;
        @AuraEnabled public String gender;
        @AuraEnabled public Boolean isCitizen;
        @AuraEnabled public List<Holiday> holidays;
    }
}