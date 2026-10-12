export const numbers = [
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
  'ten',
  'eleven',
  'twelve',
  'thirteen',
  'fourteen',
  'fifteen',
  'sixteen',
  'seventeen',
  'eighteen',
  'nineteen',
  'twenty',
];

export const numerals = [
  '2',
  '3',
  '5',
  '7',
  '11',
  '13',
  '17',
  '19',
  '23',
  '853',
];

export const digits = [0, 2, 3, 5, 7, 11, 13, 17, 19, 23, 853];

export const names = [
  'María',
  'Søren Larsen',
  'João',
  'Miguel',
  'Marta',
  'Lisa',
];

export interface SelectedCountryExtra {
  coolFlagIcon?: boolean;
  field?: 'code';
  passedAction?: () => void;
}

export type Country = {
  name: string;
  code: string;
  flagUrl: string;
  population: number;
  disabled?: boolean;
};

export const countries: Country[] = [
  {
    name: 'United States',
    code: 'US',
    flagUrl: '/flags/us.svg',
    population: 321853000,
  },
  { name: 'Spain', code: 'ES', flagUrl: '/flags/es.svg', population: 46439864 },
  {
    name: 'Portugal',
    code: 'PT',
    flagUrl: '/flags/pt.svg',
    population: 10374822,
  },
  {
    name: 'Russia',
    code: 'RU',
    flagUrl: '/flags/ru.svg',
    population: 146588880,
  },
  { name: 'Latvia', code: 'LV', flagUrl: '/flags/lv.svg', population: 1978300 },
  {
    name: 'Brazil',
    code: 'BR',
    flagUrl: '/flags/br.svg',
    population: 204921000,
  },
  {
    name: 'United Kingdom',
    code: 'GB',
    flagUrl: '/flags/gb.svg',
    population: 64596752,
  },
];

export const countriesWithDisabled: Country[] = [
  {
    name: 'United States',
    code: 'US',
    flagUrl: '/flags/us.svg',
    population: 321853000,
  },
  { name: 'Spain', code: 'ES', flagUrl: '/flags/es.svg', population: 46439864 },
  {
    name: 'Portugal',
    code: 'PT',
    flagUrl: '/flags/pt.svg',
    population: 10374822,
    disabled: true,
  },
  {
    name: 'Russia',
    code: 'RU',
    flagUrl: '/flags/ru.svg',
    population: 146588880,
    disabled: true,
  },
  { name: 'Latvia', code: 'LV', flagUrl: '/flags/lv.svg', population: 1978300 },
  {
    name: 'Brazil',
    code: 'BR',
    flagUrl: '/flags/br.svg',
    population: 204921000,
    disabled: true,
  },
  {
    name: 'United Kingdom',
    code: 'GB',
    flagUrl: '/flags/gb.svg',
    population: 64596752,
  },
];

export type GroupedNumber =
  | {
      groupName: string;
      options: (string | { groupName: string; options: string[] })[];
    }
  | string;

export const groupedNumbers: GroupedNumber[] = [
  { groupName: 'Smalls', options: ['one', 'two', 'three'] },
  { groupName: 'Mediums', options: ['four', 'five', 'six'] },
  {
    groupName: 'Bigs',
    options: [
      { groupName: 'Fairly big', options: ['seven', 'eight', 'nine'] },
      { groupName: 'Really big', options: ['ten', 'eleven', 'twelve'] },
      'thirteen',
    ],
  },
  'one hundred',
  'one thousand',
];

export type GroupedNumberWithDisabled =
  | {
      groupName: string;
      disabled?: boolean;
      options: (
        string | { groupName: string; disabled?: boolean; options: string[] }
      )[];
    }
  | string;

export const groupedNumbersWithDisabled: GroupedNumberWithDisabled[] = [
  { groupName: 'Smalls', disabled: true, options: ['one', 'two', 'three'] },
  { groupName: 'Mediums', options: ['four', 'five', 'six'] },
  {
    groupName: 'Bigs',
    options: [
      { groupName: 'Fairly big', options: ['seven', 'eight', 'nine'] },
      { groupName: 'Really big', options: ['ten', 'eleven', 'twelve'] },
      'thirteen',
    ],
  },
  'one hundred',
  'one thousand',
];

export type GroupedNumbersWithCustomProperty =
  | {
      groupName: string;
      variant: string;
      options: (
        string | { groupName: string; variant: string; options: string[] }
      )[];
    }
  | string;

export const groupedNumbersWithCustomProperty: GroupedNumbersWithCustomProperty[] =
  [
    {
      groupName: 'Smalls',
      variant: 'Primary',
      options: ['one', 'two', 'three'],
    },
    {
      groupName: 'Mediums',
      variant: 'Secondary',
      options: ['four', 'five', 'six'],
    },
    {
      groupName: 'Bigs',
      variant: 'Primary',
      options: [
        {
          groupName: 'Fairly big',
          variant: 'Secondary',
          options: ['seven', 'eight', 'nine'],
        },
        {
          groupName: 'Really big',
          variant: 'Primary',
          options: ['ten', 'eleven', 'twelve'],
        },
        'thirteen',
      ],
    },
    'one hundred',
    'one thousand',
  ];

export const namesStartingWithA = [
  'Abigail',
  'Abril',
  'Adriana',
  'Adrián',
  'Agustina',
  'Agustín',
  'Aitana',
  'Alan',
  'Alejandra',
  'Alejandro',
  'Alessandra',
  'Alex',
  'Alexa',
  'Alexander',
  'Allison',
  'Alma',
  'Alonso',
  'Álvaro',
  'Amanda',
  'Amelia',
  'Ana',
  'Andrea',
  'Andrés',
  // These two need to be in the middle.
  'Aaran', // Does not exist, don't look for it.
  'Aarón',
  'Ángel',
  'Anthony',
  'Antonella',
  'Antonia',
  'Antonio',
  'Ariadna',
  'Ariana',
  'Ashley',
  'Axel',
];
