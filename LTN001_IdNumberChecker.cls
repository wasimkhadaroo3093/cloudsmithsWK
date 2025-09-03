/**
 * @author Wasim Khadaroo
 * @date 2025-09-03
 * @group Lightning Controller
 * @description LWC entrypoints: 1) decode+save, 2) fetch holidays
 */
public inherited sharing class LTN001_IdNumberChecker {

    // Decode & Save (DML only)
    @AuraEnabled(cacheable=false)
    public static WRP_Types.IdResult decodeAndSave(String idNumber) {
        return SM001_IdCheckerService.decodeAndSave(idNumber);
    }

    // Fetch Holidays (Callout only)
    @AuraEnabled(cacheable=false)
    public static List<WRP_Types.Holiday> fetchHolidays(Integer year) {
        return SM001_IdCheckerService.fetchZAHolidaysByYear(year);
    }
}