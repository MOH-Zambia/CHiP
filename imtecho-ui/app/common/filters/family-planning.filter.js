(function () {
    let techoFilters = angular.module("imtecho.filters");
    techoFilters.filter('familyplanning', function (GeneralUtil) {
        return (input) => {
            if (input) {
                switch (input) {
                    case 'FMLSTR':
                        return 'FEMALE STERILIZATION';
                    case 'MLSTR':
                        return 'MALE STERILIZATION';
                    case 'IUCD5':
                        return 'IUCD- 5 YEARS';
                    case 'IUCD10':
                        return 'IUCD- 10 YEARS';
                    case 'CONDOM':
                        return 'CONDOM';
                    case 'ORALPILLS':
                        return 'ORAL PILLS';
                    case 'CHHAYA':
                        return 'CHHAYA';
                    case 'ANTARA':
                        return 'ANTARA';
                    case 'CONTRA':
                        return 'EMERGENCY CONTRACEPTIVE PILLS';
                    case 'PPIUCD':
                        return 'PPIUCD';
                    case 'PAIUCD':
                        return 'PAIUCD';
                    case 'PPTL':
                        return 'Post Parterm TL';
                    case 'PATL':
                        return 'Post Abortion TL';
                    case 'LAPAROSCOPIC_TL':
                        return 'Laparoscopic TL';
                    case 'ABDOMINAL_TL':
                        return 'Abdominal TL';
                    case 'VASECTOMY_FOR_HUSBAND':
                        return 'Vasectomy (for Husband)';
                    case 'MALE_CONDOM':
                        return 'ស្រោមអនាម័យបុរស (Male Condom)';
                    case 'COC':
                        return 'ស៊ីអូស៊ី (COC)';
                    case 'POP':
                        return 'ថ្នាំគ្រាប់ពន្យារកំណើត (POP)';
                    case 'CONTRACEPTION':
                        return 'ថ្នាំពន្យារកំណើតបន្ទាន់ (Emergency Contraception)';
                    case 'INJECTION':
                        return 'ការចាក់ថ្នាំពន្យារកំណើត (Contraceptive Injection)';
                    case 'IMPLANT':
                        return 'ការដាក់កងពន្យារកំណើត (Contraceptive Implant)';
                    case 'IUD':
                        return 'ឧបករណ៍ខាងក្នុងស្បូន (Intrauterine Device (IUD))';
                    case 'OTHER':
                        return 'ផ្សេងៗ (Others)';
                    default:
                        if(GeneralUtil.getEnv() === 'imomcare'){
                            return 'ផ្សេងទៀត Other ('+input+')';
                        }else{
                            return 'N.A';
                        }
                        
                }
            } else {
                return 'N.A';
            }
        };
    });
})();
