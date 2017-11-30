Bahmni.Registration.AttributesConditions.rules = {
    'isAlreadyAnonymised': function(patient) {
        var returnValues = {
            hide: [],
            show: []
        };
        if (patient["isAlreadyAnonymised"]) {
            returnValues.hide.push("anonymisePatientData");
            returnValues.show.push("alreadyAnonymised");
        } else {
            returnValues.show.push("anonymisePatientData");
            returnValues.hide.push("alreadyAnonymised");
        }
        return returnValues
    }
};
