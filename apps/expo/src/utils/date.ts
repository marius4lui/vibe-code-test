const LOCAL_DATE_PATTERN = /^(\d{4})-(\d{2})-(\d{2})$/;
const LOCAL_TIME_PATTERN = /^(\d{2}):(\d{2})$/;

const padTwo = (value: number): string => String(value).padStart(2, '0');

export function toLocalDateKey(date: Date): string {
  return `${date.getFullYear()}-${padTwo(date.getMonth() + 1)}-${padTwo(date.getDate())}`;
}

export function parseLocalDate(value: string): Date | null {
  const match = LOCAL_DATE_PATTERN.exec(value);

  if (!match) {
    return null;
  }

  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
  const parsed = new Date(0);

  parsed.setFullYear(year, month - 1, day);
  parsed.setHours(0, 0, 0, 0);

  if (
    parsed.getFullYear() !== year ||
    parsed.getMonth() !== month - 1 ||
    parsed.getDate() !== day
  ) {
    return null;
  }

  return parsed;
}

export function isValidLocalDate(value: string): boolean {
  return parseLocalDate(value) !== null;
}

export function isValidLocalTime(value: string): boolean {
  const match = LOCAL_TIME_PATTERN.exec(value);

  if (!match) {
    return false;
  }

  const hours = Number(match[1]);
  const minutes = Number(match[2]);

  return hours >= 0 && hours <= 23 && minutes >= 0 && minutes <= 59;
}

export function addLocalDays(date: Date, amount: number): Date {
  const result = new Date(date);
  result.setDate(result.getDate() + amount);
  return result;
}

export function addDaysToLocalDateKey(dateKey: string, amount: number): string {
  const parsed = parseLocalDate(dateKey);

  if (!parsed) {
    throw new Error(`Ungültiges lokales Datum: ${dateKey}`);
  }

  parsed.setDate(parsed.getDate() + amount);
  return toLocalDateKey(parsed);
}

export function localDateKeyFromIso(isoDate: string): string | null {
  const parsed = new Date(isoDate);
  return Number.isNaN(parsed.getTime()) ? null : toLocalDateKey(parsed);
}

export function compareLocalDateKeys(left: string, right: string): number {
  return left.localeCompare(right);
}
