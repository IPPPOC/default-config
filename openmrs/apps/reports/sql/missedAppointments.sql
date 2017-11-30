     SELECT
         pi.identifier AS 'Patient ID',
          CONCAT(pname.given_name, ' ', pname.family_name)  AS 'Patient Name',
          app_service.name                                                                                AS 'Appointment Service',
          app_service_type.name                                                                           AS 'Appointment Service Type',
          DATE_FORMAT(start_date_time, "%d/%m/%Y")                                                        AS 'Date of Appointment',
          CONCAT(DATE_FORMAT(start_date_time, "%l:%i %p"), " - ", DATE_FORMAT(end_date_time, "%l:%i %p")) AS 'Slot',
          CONCAT(pn.given_name, ' ', pn.family_name)                                                      AS 'Provider',
          pa.status                                                                                       AS 'Status',
          pa.comments																					 AS 'Notes'
     FROM
        patient_appointment pa
        JOIN person p ON p.person_id = pa.patient_id AND pa.voided IS FALSE
        JOIN person_name pname on pname.person_id = p.person_id
        JOIN patient_identifier pi on pi.patient_id = p.person_id
        JOIN appointment_service app_service
          ON app_service.appointment_service_id = pa.appointment_service_id AND app_service.voided IS FALSE
        LEFT JOIN provider prov ON prov.provider_id = pa.provider_id AND prov.retired IS FALSE
        LEFT JOIN person_name pn ON pn.person_id = prov.person_id AND pn.voided IS FALSE
        LEFT JOIN appointment_service_type app_service_type
          ON app_service_type.appointment_service_type_id = pa.appointment_service_type_id
      WHERE   DATE(start_date_time) BETWEEN CAST('#startDate#' AS DATE) AND (CASE WHEN CAST('#endDate#' AS DATE) <= CAST(CURRENT_DATE AS DATE)
      THEN CAST('#endDate#' AS DATE)
      ELSE CAST(CURRENT_DATE AS DATE)
END)  AND (app_service_type.voided IS FALSE OR app_service_type.voided IS NULL) AND pa.status != "Completed"
      ORDER BY start_date_time DESC
