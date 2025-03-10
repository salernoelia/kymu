// export interface Family {
//     uid: number;
//     patient_first_name: string;
//     patient_last_name: string;
//     caregiver_first_name: string;
//     caregiver_last_name: string;
//     // patient_age: number;
//     condition: string;
// }

export interface Stat {
    id: number;
    title: string;
    value: string | number;
}

export interface StatsByPatient {
    [key: number]: Stat[];
}
