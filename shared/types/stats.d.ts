export interface Stat {
  id: number;
  title: string;
  value: string | number;
}

export interface StatsByPatient {
  [key: number]: Stat[];
}
