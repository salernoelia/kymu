export interface User {
  name: string;
  email: string;
  bio: string;
}

/*
const UserTypeOptions = [
  { label: 'Patient', value: 'patient' },
  { label: 'Caregiver', value: 'caregiver' },
  { label: 'Therapist', value: 'therapist' },
];
*/

export enum UserTypes {
  Patient = "patient",
  Caregiver = "caregiver",
  Therapist = "therapist",
}
