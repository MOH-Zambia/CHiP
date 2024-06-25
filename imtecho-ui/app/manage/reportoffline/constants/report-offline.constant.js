angular.module('imtecho')
    .constant("OfflineReportStatus", {
        REQUESTED: "Requested",
        PROCESSING: "Processing",
        READY_FOR_DOWNLOAD: "Ready For Download",
        ERROR: "Error",
        ARCHIVED: "Archived"
    });